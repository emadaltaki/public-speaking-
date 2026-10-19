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
    scNoAudio: 'The recording isn\'t kept, so playback only works right after you record.',
    scV10: 'Outstanding!', scV8: 'Great talk!', scV6: 'Solid work, keep going', scV4: 'A good start', scV1: 'Every talk makes the next one easier',
    scBest: 'Your strongest: {c}', scFocus: 'Focus next: {c}',
    scStory: 'Your story', scOutline: 'Your main points', scOpening: 'Opening', scMiddle: 'Middle', scEnding: 'Ending',
    scRate: { strong: 'Strong', ok: 'Okay', weak: 'Needs work' }, scConnect: 'How your ideas connect',
    scPace: 'Your pace', scPaceAvg: 'Average {n} words a minute', scPaceZone: 'Comfortable zone: 130 to 160',
    scPaceFast: 'You sped up around {t} ({n} a minute).', scPaceSlow: 'You slowed right down around {t} ({n} a minute).', scPaceSteady: 'Nice and steady the whole way through.', scFillerList: 'Your filler words'
  }, {
    scOverall: 'الإجمالي', scOutOf: 'من 10', scTopicOwn: 'موضوعك الخاص',
    scCats: { pace: 'السرعة', pauses: 'الوقفات', fillers: 'كلمات الحشو', clarity: 'الوضوح', flow: 'ترابط الأفكار' },
    scWpm: '{n} كلمة في الدقيقة', scFillers0: 'لا توجد كلمات حشو', scFillers1: 'كلمة حشو واحدة', scFillersN: '{n} كلمات حشو',
    scPauses0: 'لا توجد وقفات طويلة', scPauses1: 'وقفة طويلة واحدة', scPausesN: '{n} وقفات طويلة',
    scMoments: 'لحظات تحتاج إلى تحسين', scTry: 'جرّب هذا', scPlayHere: 'شغّل من {t}', scAt: 'عند {t}',
    scStrengths: 'ما أحسنت فيه', scNext: 'تدرّب على هذا لاحقًا', scTranscript: 'ما قلته', scPause: 'وقفة {n} ث',
    scLegend: 'كلمات الحشو مظللة، والوقفات الطويلة معلّمة.', scShowAll: 'اعرض النص كاملًا',
    scNoAudio: 'لا نحتفظ بالتسجيل، لذا يعمل التشغيل بعد التسجيل مباشرة فقط.',
    scV10: 'رائع جدًا!', scV8: 'حديث رائع!', scV6: 'عمل جيد، استمر', scV4: 'بداية جيدة', scV1: 'كل حديث يجعل التالي أسهل',
    scBest: 'أقوى نقطة: {c}', scFocus: 'ركّز على: {c}',
    scStory: 'قصتك', scOutline: 'نقاطك الرئيسية', scOpening: 'البداية', scMiddle: 'الوسط', scEnding: 'النهاية',
    scRate: { strong: 'قوية', ok: 'مقبولة', weak: 'تحتاج تحسينًا' }, scConnect: 'كيف ترتبط أفكارك',
    scPace: 'سرعتك', scPaceAvg: 'المتوسط {n} كلمة في الدقيقة', scPaceZone: 'المنطقة المريحة: من 130 إلى 160',
    scPaceFast: 'أسرعت عند {t} ({n} كلمة في الدقيقة).', scPaceSlow: 'أبطأت كثيرًا عند {t} ({n} كلمة في الدقيقة).', scPaceSteady: 'سرعة ثابتة ومريحة طوال الحديث.', scFillerList: 'كلمات الحشو لديك'
  });

  var CATS = ['pace', 'pauses', 'fillers', 'clarity', 'flow'];
  var PLAY = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5.5v13a1 1 0 0 0 1.5.86l10.5-6.5a1 1 0 0 0 0-1.72L9.5 4.64A1 1 0 0 0 8 5.5z"/></svg>';

  function mmss(sec) {
    sec = Math.max(0, Math.floor(sec || 0));
    return Math.floor(sec / 60) + ':' + String(sec % 60).padStart(2, '0');
  }
  function clamp(n) { n = Math.round(+n || 0); return Math.max(1, Math.min(10, n)); }
  function band(n) { return n >= 8 ? 'hi' : n >= 5 ? 'mid' : 'lo'; }
  function verdict(n) { n = clamp(n); return t(n >= 9 ? 'scV10' : n >= 8 ? 'scV8' : n >= 6 ? 'scV6' : n >= 4 ? 'scV4' : 'scV1'); }
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

  // The highest and lowest scoring areas, as two small badges.
  function bestAndFocus(sc) {
    var ranked = CATS.filter(function (k) { return sc[k]; }).sort(function (a, b) { return clamp(sc[b].score) - clamp(sc[a].score); });
    if (ranked.length < 2) return '';
    var best = ranked[0], low = ranked[ranked.length - 1];
    if (clamp(sc[best].score) === clamp(sc[low].score)) return '';
    return '<div class="sc-bf"><span class="up">▲ ' + esc(t('scBest', { c: t('scCats')[best] })) + '</span><span class="dn">● ' + esc(t('scFocus', { c: t('scCats')[low] })) + '</span></div>';
  }

  // How the talk hangs together: main points, opening/middle/ending, links.
  function storyCard(st) {
    if (!st || !(st.outline || st.opening)) return '';
    var part = function (key, p) {
      p = p || {};
      var rate = p.rating === 'strong' || p.rating === 'weak' ? p.rating : 'ok';
      return '<li class="st-' + rate + '"><span class="st-dot"></span><div><b>' + esc(t(key)) + ' <em>' + esc(t('scRate')[rate]) + '</em></b>' +
        (p.note ? '<p dir="auto">' + esc(p.note) + '</p>' : '') + '</div></li>';
    };
    return '<div class="card sc-story"><h2>' + esc(t('scStory')) + '</h2>' +
      (st.outline && st.outline.length ? '<p class="sc-sub">' + esc(t('scOutline')) + '</p><ol class="sc-outline">' +
        st.outline.map(function (o) { return '<li dir="auto">' + esc(o) + '</li>'; }).join('') + '</ol>' : '') +
      '<ul class="sc-arc">' + part('scOpening', st.opening) + part('scMiddle', st.middle) + part('scEnding', st.ending) + '</ul>' +
      (st.connection ? '<div class="sc-connect"><b>' + esc(t('scConnect')) + '</b><p dir="auto">' + esc(st.connection) + '</p></div>' : '') +
      '</div>';
  }

  // Words per minute every 15 seconds, against the comfortable zone.
  function paceCard(m) {
    var p = m.paceTimeline || [];
    if (p.length < 2) return '';
    var top = Math.max(200, Math.max.apply(null, p) + 10);
    var y = function (v) { return (100 - v / top * 100).toFixed(1); };
    var bars = p.map(function (v, i) {
      var zone = v > 170 ? 'fast' : v < 115 ? 'slow' : 'ok';
      return '<div class="pc-col"><div class="pc-bar ' + zone + '" style="height:' + Math.max(4, v / top * 100).toFixed(1) + '%"><span>' + v + '</span></div>' +
        '<small dir="ltr">' + mmss(i * 15) + '</small></div>';
    }).join('');
    return '<div class="card sc-pace"><h2>' + esc(t('scPace')) + '</h2><p class="sc-sub">' + esc(t('scPaceAvg', { n: m.wordsPerMinute || 0 })) + '</p>' +
      '<div class="pc-chart"><div class="pc-zone" style="top:' + y(160) + '%;bottom:' + (100 - y(130)) + '%"></div>' + bars + '</div>' +
      '<p class="pc-legend"><span class="z"></span>' + esc(t('scPaceZone')) + '</p>' + paceNote(p) + '</div>';
  }

  // One line on where they rushed or dragged, if anywhere.
  function paceNote(p) {
    var hi = 0, lo = 0;
    p.forEach(function (v, i) { if (v > p[hi]) hi = i; if (v < p[lo]) lo = i; });
    var bits = [];
    if (p[hi] > 170) bits.push(t('scPaceFast', { t: mmss(hi * 15), n: p[hi] }));
    if (p[lo] < 115) bits.push(t('scPaceSlow', { t: mmss(lo * 15), n: p[lo] }));
    if (!bits.length) bits.push(t('scPaceSteady'));
    return '<p class="pc-note">' + esc(bits.join(' ')) + '</p>';
  }

  // Each filler word and how many times it came up.
  function fillerCard(m) {
    var f = m.fillers || {};
    var keys = Object.keys(f).sort(function (a, b) { return f[b] - f[a]; });
    if (!keys.length) return '';
    return '<div class="card sc-fill"><h2>' + esc(t('scFillerList')) + '</h2><ul class="fl-list">' +
      keys.map(function (k) { return '<li><b dir="auto">' + esc(k) + '</b><span>×' + f[k] + '</span></li>'; }).join('') + '</ul></div>';
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
      '<div class="sc-head"><small>' + esc(t('scOverall')) + '</small><p class="sc-verdict">' + esc(verdict(r.overall)) + '</p><h2>' + esc(r.topic || t('scTopicOwn')) + '</h2>' +
      bestAndFocus(sc) +
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
      }).join('') + '</div>' + storyCard(r.story) + paceCard(m) + fillerCard(m);
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

    if (opts.celebrate) reveal(el, clamp(r.overall));

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

  // Fresh results: the ring fills, the number counts up, the bars grow, and a
  // great score gets a little burst of confetti.
  function reveal(el, n) {
    if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    var bar = el.querySelector('.sc-ring .bar'), num = el.querySelector('.sc-big .n b');
    var full = bar ? bar.getAttribute('stroke-dashoffset') : null;
    if (bar) { bar.style.transition = 'none'; bar.setAttribute('stroke-dashoffset', bar.getAttribute('stroke-dasharray')); }
    var fills = el.querySelectorAll('.sc-bar i');
    fills.forEach(function (i) { i.dataset.w = i.style.width; i.style.width = '0%'; });
    if (num) num.textContent = '0';
    requestAnimationFrame(function () {
      requestAnimationFrame(function () {
        if (bar) { bar.style.transition = 'stroke-dashoffset 1.2s cubic-bezier(.2,.8,.2,1)'; bar.setAttribute('stroke-dashoffset', full); }
        fills.forEach(function (i, k) { i.style.transition = 'width .9s cubic-bezier(.2,.8,.2,1) ' + (0.3 + k * 0.12) + 's'; i.style.width = i.dataset.w; });
      });
    });
    var k = 0, tick = setInterval(function () { k++; if (num) num.textContent = String(Math.min(n, k)); if (k >= n) clearInterval(tick); }, 1100 / Math.max(n, 1));
    if (n >= 8) {
      var box = document.createElement('div');
      box.className = 'sc-confetti';
      var colors = ['#E0703E', '#D49A4E', '#3E8E7A', '#7A4E9A', '#3F6F8E'];
      for (var c = 0; c < 36; c++) {
        var p = document.createElement('i');
        p.style.left = (Math.random() * 100) + '%';
        p.style.background = colors[c % colors.length];
        p.style.animationDelay = (Math.random() * 0.5) + 's';
        p.style.animationDuration = (1.6 + Math.random() * 1.2) + 's';
        p.style.transform = 'rotate(' + Math.round(Math.random() * 360) + 'deg)';
        box.appendChild(p);
      }
      document.body.appendChild(box);
      setTimeout(function () { box.remove(); }, 3500);
    }
  }

  window.Coach = { render: render, mmss: mmss, clamp: clamp, band: band, CATS: CATS };
})();
