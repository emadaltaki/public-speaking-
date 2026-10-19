// Speech Coach report: the scores, the moments to work on and the transcript.
// Used by the game page (right after a recording) and the account page (past
// reports). Needs app.js (window.SUF). Exposes window.Coach.
(function () {
  'use strict';
  var S = window.SUF, esc = S.esc, t = S.t;

  S.addStrings({
    scOverall: 'Overall', scOutOf: 'out of 10', scTopicOwn: 'Your own topic',
    scCats: { pace: 'Pace', pauses: 'Pauses', fillers: 'Filler words', clarity: 'Clarity', flow: 'Flow of ideas' },
    scWpm: '{n} words a minute', scFillers0: 'No filler words', scFillers1: '1 filler word', scFillersN: '{n} filler words',
    scPauses0: 'No long pauses', scPauses1: '1 long pause', scPausesN: '{n} long pauses',
    scMoments: 'Moments to work on', scTry: 'Try this', scPlayHere: 'Play from {t}', scAt: 'At {t}',
    scStrengths: 'What went well', scNext: 'Practice next', scTranscript: 'What you said', scPause: 'pause {n}s',
    scLegend: 'Filler words are highlighted. Long pauses are marked.', scShowAll: 'Show the full transcript',
    scNoAudio: 'The recording isn\'t kept, so playback only works right after you record.'
  }, {
    scOverall: 'الإجمالي', scOutOf: 'من 10', scTopicOwn: 'موضوعك الخاص',
    scCats: { pace: 'السرعة', pauses: 'الوقفات', fillers: 'كلمات الحشو', clarity: 'الوضوح', flow: 'ترابط الأفكار' },
    scWpm: '{n} كلمة في الدقيقة', scFillers0: 'لا توجد كلمات حشو', scFillers1: 'كلمة حشو واحدة', scFillersN: '{n} كلمات حشو',
    scPauses0: 'لا توجد وقفات طويلة', scPauses1: 'وقفة طويلة واحدة', scPausesN: '{n} وقفات طويلة',
    scMoments: 'لحظات تحتاج إلى تحسين', scTry: 'جرّب هذا', scPlayHere: 'شغّل من {t}', scAt: 'عند {t}',
    scStrengths: 'ما أحسنت فيه', scNext: 'تدرّب على هذا لاحقًا', scTranscript: 'ما قلته', scPause: 'وقفة {n} ث',
    scLegend: 'كلمات الحشو مظللة، والوقفات الطويلة معلّمة.', scShowAll: 'اعرض النص كاملًا',
    scNoAudio: 'لا نحتفظ بالتسجيل، لذا يعمل التشغيل بعد التسجيل مباشرة فقط.'
  });

  var CATS = ['pace', 'pauses', 'fillers', 'clarity', 'flow'];
  var PLAY = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5.5v13a1 1 0 0 0 1.5.86l10.5-6.5a1 1 0 0 0 0-1.72L9.5 4.64A1 1 0 0 0 8 5.5z"/></svg>';

  function mmss(sec) {
    sec = Math.max(0, Math.floor(sec || 0));
    return Math.floor(sec / 60) + ':' + String(sec % 60).padStart(2, '0');
  }
  function clamp(n) { n = Math.round(+n || 0); return Math.max(1, Math.min(10, n)); }
  function band(n) { return n >= 8 ? 'hi' : n >= 5 ? 'mid' : 'lo'; }
  function plural(n, zero, one, many) { return n === 0 ? t(zero) : n === 1 ? t(one) : t(many, { n: n }); }

  function ring(score) {
    var c = 2 * Math.PI * 52, f = clamp(score) / 10;
    return '<svg class="sc-ring ' + band(score) + '" viewBox="0 0 120 120" aria-hidden="true"><circle class="track" cx="60" cy="60" r="52"/>' +
      '<circle class="bar" cx="60" cy="60" r="52" stroke-dasharray="' + c.toFixed(1) + '" stroke-dashoffset="' + (c * (1 - f)).toFixed(1) + '"/></svg>';
  }

  // Transcript words with fillers highlighted and long pauses marked.
  function transcript(words) {
    var out = [], prevEnd = null;
    words.forEach(function (w, i) {
      if (prevEnd != null && w.s - prevEnd >= 1.5) out.push('<span class="sc-gap">' + esc(t('scPause', { n: (w.s - prevEnd).toFixed(1) })) + '</span> ');
      out.push('<span class="sc-w' + (w.f ? ' f' : '') + '" data-i="' + i + '" data-s="' + (+w.s || 0) + '">' + esc(w.w) + '</span> ');
      prevEnd = +w.e || +w.s || prevEnd;
    });
    return out.join('');
  }

  // Draws a report into el. opts.audio: an object URL for playback (fresh recordings only).
  function render(el, r, opts) {
    opts = opts || {};
    var m = r.metrics || {};
    var sc = r.scores || {};
    var moments = (r.moments || []).slice().sort(function (a, b) { return (a.at || 0) - (b.at || 0); });
    var words = r.transcript || [];
    var html = '<div class="sc">' +
      '<div class="card sc-top"><div class="sc-big">' + ring(r.overall) + '<div class="n"><b>' + clamp(r.overall) + '</b><small>' + esc(t('scOutOf')) + '</small></div></div>' +
      '<div class="sc-head"><small>' + esc(t('scOverall')) + '</small><h2>' + esc(r.topic || t('scTopicOwn')) + '</h2>' +
      '<ul class="chips sc-chips">' +
        (m.wordsPerMinute ? '<li>' + esc(t('scWpm', { n: Math.round(m.wordsPerMinute) })) + '</li>' : '') +
        '<li>' + esc(plural(m.fillerCount || 0, 'scFillers0', 'scFillers1', 'scFillersN')) + '</li>' +
        '<li>' + esc(plural(m.longPauses || 0, 'scPauses0', 'scPauses1', 'scPausesN')) + '</li>' +
        (r.durationSeconds ? '<li dir="ltr">' + mmss(r.durationSeconds) + '</li>' : '') +
      '</ul></div></div>' +
      '<div class="card sc-scores">' + CATS.map(function (k) {
        var s = sc[k] || {};
        var n = clamp(s.score);
        return '<div class="sc-row"><div class="sc-row-h"><b>' + esc(t('scCats')[k]) + '</b><span class="sc-n ' + band(n) + '">' + n + '/10</span></div>' +
          '<div class="sc-bar"><i class="' + band(n) + '" style="width:' + (n * 10) + '%"></i></div>' +
          (s.summary ? '<p dir="auto">' + esc(s.summary) + '</p>' : '') + '</div>';
      }).join('') + '</div>';
    if (moments.length) {
      html += '<div class="card sc-moments"><h2>' + esc(t('scMoments')) + '</h2><ol>' + moments.map(function (mo, i) {
        var cat = t('scCats')[mo.category] || '';
        return '<li data-m="' + i + '"><div class="sc-m-h">' +
          (opts.audio ? '<button type="button" class="sc-time" data-at="' + (+mo.at || 0) + '" aria-label="' + esc(t('scPlayHere', { t: mmss(mo.at) })) + '">' + PLAY + '<span dir="ltr">' + mmss(mo.at) + '</span></button>'
                      : '<button type="button" class="sc-time" data-at="' + (+mo.at || 0) + '" aria-label="' + esc(t('scAt', { t: mmss(mo.at) })) + '"><span dir="ltr">' + mmss(mo.at) + '</span></button>') +
          (cat ? '<span class="sc-tag">' + esc(cat) + '</span>' : '') + '</div>' +
          (mo.quote ? '<blockquote dir="auto">“' + esc(mo.quote) + '”</blockquote>' : '') +
          (mo.issue ? '<p dir="auto">' + esc(mo.issue) + '</p>' : '') +
          (mo.fix ? '<p class="sc-fix"><b>' + esc(t('scTry')) + ':</b> ' + esc(mo.fix) + '</p>' : '') + '</li>';
      }).join('') + '</ol></div>';
    }
    if ((r.strengths && r.strengths.length) || r.nextStep) {
      html += '<div class="sc-two">' +
        (r.strengths && r.strengths.length ? '<div class="card"><h2>' + esc(t('scStrengths')) + '</h2><ul class="sc-list">' + r.strengths.map(function (s) { return '<li>' + esc(s) + '</li>'; }).join('') + '</ul></div>' : '') +
        (r.nextStep ? '<div class="card sc-nextstep"><h2>' + esc(t('scNext')) + '</h2><p>' + esc(r.nextStep) + '</p></div>' : '') + '</div>';
    }
    if (words.length) {
      html += '<div class="card sc-tr"><h2>' + esc(t('scTranscript')) + '</h2><p class="help">' + esc(t('scLegend')) + '</p>' +
        (opts.audio ? '<audio controls preload="metadata" src="' + esc(opts.audio) + '"></audio>' : '') +
        '<div class="sc-text" dir="auto">' + transcript(words) + '</div></div>';
    }
    html += '</div>';
    el.innerHTML = html;

    var audio = el.querySelector('audio');
    var text = el.querySelector('.sc-text');
    // Light up the words around a moment, and play from there when we can.
    function jump(at) {
      if (text) {
        text.querySelectorAll('.sc-w.hl').forEach(function (w) { w.classList.remove('hl'); });
        var hit = null;
        text.querySelectorAll('.sc-w').forEach(function (w) {
          var s = +w.dataset.s;
          if (s >= at - 0.4 && s <= at + 2.5) { w.classList.add('hl'); if (!hit) hit = w; }
        });
        if (hit) hit.scrollIntoView({ behavior: 'smooth', block: 'center' });
      }
      if (audio) { try { audio.currentTime = Math.max(0, at - 1); audio.play(); } catch (_) {} }
    }
    el.querySelectorAll('.sc-time').forEach(function (b) { b.addEventListener('click', function () { jump(+b.dataset.at); }); });
    if (text && audio) {
      text.addEventListener('click', function (e) {
        var w = e.target.closest('.sc-w');
        if (w) { try { audio.currentTime = Math.max(0, +w.dataset.s - 0.2); audio.play(); } catch (_) {} }
      });
    }
  }

  window.Coach = { render: render, mmss: mmss, clamp: clamp, band: band, CATS: CATS };
})();
