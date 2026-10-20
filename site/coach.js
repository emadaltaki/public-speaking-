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
    scPaceUnit: 'words a minute on average', scPaceFeel: { ok: 'comfortable', fast: 'too fast', slow: 'too slow' }, scSec: 's', scPaceHow: 'Each bar is how fast you spoke during that part of your talk, in words a minute.', scAllFast: 'Your whole talk was fast ({n} words a minute). Slow down and aim for 130 to 160 so people can keep up.', scAllSlow: 'Your whole talk was slow ({n} words a minute). Aim for 130 to 160 to keep people engaged.', scPartFast: 'You were fastest {w} ({n} words a minute).', scPartSlow: 'You slowed right down {w} ({n} words a minute).', scAtStart: 'at the start', scAtEnd: 'near the end', scInPart: 'between {r}', scPaceSteady: 'Nice and steady the whole way through.', scFillerList: 'Your filler words',
    scPractice: 'Practice this next', scPlayGame: 'Play {g}', scComeBack: 'Play it a few times, then come back to Speech Coach and record again to see how much you improve.',
    scG: { autocomplete: 'Autocomplete', 'triple-step': 'Triple Step', conductor: 'The Conductor', podcast: 'The Podcast Game', daily: 'Daily Challenge' },
    scStyles: { serious: '🎯 Serious', funny: '😄 Funny', inspiring: '✨ Inspiring', persuasive: '📣 Persuasive', story: '📖 Story' },
    scStatWpm: 'words / min', scStatFillers: 'filler words', scStatPauses: 'long pauses', scStatTime: 'length', scListen: 'Listen back',
    scTabOverview: 'Overview', scTabStory: 'Story', scTabPace: 'Pace & fillers', scTabMoments: 'Moments', scTabWords: 'Transcript',
    scLegendF: 'filler word', scLegendP: 'long pause',
    scUp: '▲ Up {n} from your last talk', scDown: '▼ {n} lower than last time. Keep practicing!', scSame: 'Same score as last time. Keep going!'
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
    scPaceUnit: 'كلمة في الدقيقة في المتوسط', scPaceFeel: { ok: 'مريحة', fast: 'سريعة جدًا', slow: 'بطيئة جدًا' }, scSec: ' ث', scPaceHow: 'كل عمود يبيّن سرعة كلامك في ذلك الجزء من حديثك، بالكلمات في الدقيقة.', scAllFast: 'كان حديثك كله سريعًا ({n} كلمة في الدقيقة). أبطئ واستهدف من 130 إلى 160 ليتمكن الناس من المتابعة.', scAllSlow: 'كان حديثك كله بطيئًا ({n} كلمة في الدقيقة). استهدف من 130 إلى 160 لتحافظ على انتباه الناس.', scPartFast: 'كنت أسرع {w} ({n} كلمة في الدقيقة).', scPartSlow: 'أبطأت كثيرًا {w} ({n} كلمة في الدقيقة).', scAtStart: 'في البداية', scAtEnd: 'قرب النهاية', scInPart: 'بين {r}', scPaceSteady: 'سرعة ثابتة ومريحة طوال الحديث.', scFillerList: 'كلمات الحشو لديك',
    scPractice: 'تدرّب على هذه اللعبة', scPlayGame: 'العب {g}', scComeBack: 'العبها بضع مرات، ثم عد إلى مدرب الإلقاء وسجّل مجددًا لترى كم تحسّنت.',
    scG: { autocomplete: 'الإكمال التلقائي', 'triple-step': 'الخطوة الثلاثية', conductor: 'قائد الأوركسترا', podcast: 'لعبة البودكاست', daily: 'التحدي اليومي' },
    scStyles: { serious: '🎯 جاد', funny: '😄 مضحك', inspiring: '✨ ملهم', persuasive: '📣 مقنع', story: '📖 قصة' },
    scStatWpm: 'كلمة / دقيقة', scStatFillers: 'كلمات حشو', scStatPauses: 'وقفات طويلة', scStatTime: 'المدة', scListen: 'استمع لتسجيلك',
    scTabOverview: 'نظرة عامة', scTabStory: 'القصة', scTabPace: 'السرعة والحشو', scTabMoments: 'اللحظات', scTabWords: 'النص',
    scLegendF: 'كلمة حشو', scLegendP: 'وقفة طويلة',
    scUp: '▲ أعلى بـ {n} من حديثك السابق', scDown: '▼ أقل بـ {n} من المرة السابقة. واصل التدرّب!', scSame: 'الدرجة نفسها مثل المرة السابقة. استمر!'
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
    if (!p.length) return '';
    var dur = +m.durationSeconds || 0;
    var top = Math.max(200, Math.max.apply(null, p) + 20);
    var y = function (v) { return (100 - v / top * 100).toFixed(1); };
    var range = function (i) { return (i * 30) + '–' + (i === p.length - 1 && dur ? Math.round(dur) : (i + 1) * 30) + t('scSec'); };
    var bars = p.map(function (v, i) {
      var zone = v > 170 ? 'fast' : v < 115 ? 'slow' : 'ok';
      return '<div class="pc-col"><div class="pc-bar ' + zone + '" style="height:' + Math.max(4, v / top * 100).toFixed(1) + '%"><span>' + v + '</span></div>' +
        '<small dir="ltr">' + range(i) + '</small></div>';
    }).join('');
    var avg = m.wordsPerMinute || 0;
    var feel = avg > 170 ? 'fast' : avg < 115 ? 'slow' : 'ok';
    return '<div class="card sc-pace"><h2>' + esc(t('scPace')) + '</h2>' +
      '<div class="pc-avg ' + feel + '"><b>' + avg + '</b><span>' + esc(t('scPaceUnit')) + '<em>' + esc(t('scPaceFeel')[feel]) + '</em></span></div>' +
      '<p class="pc-how">' + esc(t('scPaceHow')) + '</p>' +
      '<div class="pc-chart"><div class="pc-zone" style="top:' + y(160) + '%;bottom:' + (100 - y(130)) + '%"></div>' + bars + '</div>' +
      '<div class="pc-legend"><span><i class="z"></i>' + esc(t('scPaceZone')) + '</span><span><i class="k ok"></i>' + esc(t('scPaceFeel').ok) + '</span>' +
        '<span><i class="k fast"></i>' + esc(t('scPaceFeel').fast) + '</span><span><i class="k slow"></i>' + esc(t('scPaceFeel').slow) + '</span></div>' +
      (p.length > 1 ? paceNote(p, avg, range) : paceNote([avg], avg, range)) + '</div>';
  }

  // Plain words on what the chart shows: the whole talk first, then any part that stood out.
  function paceNote(p, avg, range) {
    var hi = 0, lo = 0;
    p.forEach(function (v, i) { if (v > p[hi]) hi = i; if (v < p[lo]) lo = i; });
    var where = function (i) { return i === 0 ? t('scAtStart') : i === p.length - 1 ? t('scAtEnd') : t('scInPart', { r: range(i) }); };
    var bits = [];
    if (avg > 170) bits.push(t('scAllFast', { n: avg }));
    else if (avg < 115) bits.push(t('scAllSlow', { n: avg }));
    if (p[hi] > 170 && !(avg > 170 && p[hi] - avg < 25)) bits.push(t('scPartFast', { w: where(hi), n: p[hi] }));
    if (p[lo] < 115 && !(avg < 115 && avg - p[lo] < 25)) bits.push(t('scPartSlow', { w: where(lo), n: p[lo] }));
    if (!bits.length) bits.push(t('scPaceSteady'));
    return '<p class="pc-note">' + esc(bits.join(' ')) + '</p>';
  }

  // The game to practise next, then come back and compare.
  function practiceCard(p) {
    if (!p || !p.game || !t('scG')[p.game]) return '';
    var name = t('scG')[p.game];
    return '<div class="card sc-practice g-' + p.game + '"><div class="sp-top"><span class="g-ic">' + (S.ICONS[p.game] || '') + '</span>' +
      '<span><small>' + esc(t('scPractice')) + '</small><b>' + esc(name) + '</b></span></div>' +
      (p.reason ? '<p dir="auto">' + esc(p.reason) + '</p>' : '') +
      '<a class="sp-go" href="/games/' + encodeURIComponent(p.game) + '">' + esc(t('scPlayGame', { g: name })) + ' →</a>' +
      '<p class="sp-back">🔁 ' + esc(t('scComeBack')) + '</p></div>';
  }

  // A small badge comparing this talk with the one before.
  function progress(el, now, before) {
    var head = el && el.querySelector('.sc-head');
    if (!head || before == null) return;
    var d = clamp(now) - clamp(before);
    var b = document.createElement('p');
    b.className = 'sc-prog ' + (d > 0 ? 'up' : d < 0 ? 'down' : 'same');
    b.textContent = d > 0 ? t('scUp', { n: d }) : d < 0 ? t('scDown', { n: -d }) : t('scSame');
    head.insertBefore(b, head.querySelector('h2'));
  }

  // Each filler word and how many times it came up.
  function fillerCard(m) {
    var f = m.fillers || {};
    var keys = Object.keys(f).sort(function (a, b) { return f[b] - f[a]; });
    if (!keys.length) return '';
    return '<div class="card sc-fill"><h2>' + esc(t('scFillerList')) + '</h2><ul class="fl-list">' +
      keys.map(function (k) { return '<li><b dir="auto">' + esc(k) + '</b><span>×' + f[k] + '</span></li>'; }).join('') + '</ul></div>';
  }

  // Draws a report into el: a summary card on top, then tabs for the details,
  // so nothing is scattered down a long page. opts.audio: an object URL for
  // playback (fresh recordings only); opts.celebrate: animate the reveal.
  function render(el, r, opts) {
    opts = opts || {};
    var m = r.metrics || {};
    var sc = r.scores || {};
    var moments = (r.moments || []).slice().sort(function (a, b) { return (a.at || 0) - (b.at || 0); });
    var words = r.transcript || [];
    var stat = function (big, label) { return '<div class="sc-stat"><b dir="ltr">' + esc(String(big)) + '</b><span>' + esc(label) + '</span></div>'; };

    // Summary: the score, the verdict, four numbers and the listen-back player.
    var html = '<div class="sc">' +
      '<section class="card sc-hero"><div class="sc-top">' +
        '<div class="sc-big">' + ring(r.overall) + '<div class="n"><b>' + clamp(r.overall) + '</b><small>' + esc(t('scOutOf')) + '</small></div></div>' +
        '<div class="sc-head"><p class="sc-verdict">' + esc(verdict(r.overall)) + '</p><h2 dir="auto">' + esc(r.topic || t('scTopicOwn')) + '</h2>' +
          (r.style && t('scStyles')[r.style] ? '<span class="sc-style">' + esc(t('scStyles')[r.style]) + '</span>' : '') + bestAndFocus(sc) + '</div>' +
      '</div>' +
      '<div class="sc-stats">' +
        stat(m.wordsPerMinute ? Math.round(m.wordsPerMinute) : '–', t('scStatWpm')) +
        stat(m.fillerCount || 0, t('scStatFillers')) +
        stat(m.longPauses || 0, t('scStatPauses')) +
        stat(r.durationSeconds ? mmss(r.durationSeconds) : '–', t('scStatTime')) +
      '</div>' +
      (opts.audio ? '<div class="sc-player"><button type="button" class="pl-btn" aria-label="' + esc(t('scListen')) + '">' + PLAY + '</button>' +
        '<div class="pl-main"><span class="pl-label">' + esc(t('scListen')) + '</span><div class="pl-track" role="slider" tabindex="0" aria-label="' + esc(t('scListen')) + '"><i></i><span class="pl-knob"></span></div></div>' +
        '<span class="pl-time" dir="ltr">0:00</span><audio preload="auto" src="' + esc(opts.audio) + '"></audio></div>' : '') +
      '</section>';

    // Tabs
    var tabs = [
      ['overview', t('scTabOverview'), ''],
      ['story', t('scTabStory'), ''],
      ['pace', t('scTabPace'), ''],
      ['moments', t('scTabMoments'), moments.length ? String(moments.length) : ''],
      ['words', t('scTabWords'), '']
    ].filter(function (x) { return x[0] !== 'story' || r.story; }).filter(function (x) { return x[0] !== 'moments' || moments.length; }).filter(function (x) { return x[0] !== 'words' || words.length; });
    html += '<nav class="sc-tabs" role="tablist">' + tabs.map(function (x, i) {
      return '<button type="button" role="tab" data-tab="' + x[0] + '" aria-selected="' + (i === 0) + '">' + esc(x[1]) + (x[2] ? '<em>' + x[2] + '</em>' : '') + '</button>';
    }).join('') + '</nav>';

    // Overview: the five scores, the game to practise, what went well and what next.
    html += '<section class="sc-panel" data-panel="overview">' +
      '<div class="card sc-scores">' + CATS.map(function (k) {
        var s = sc[k] || {};
        var n = clamp(s.score);
        return '<div class="sc-row"><div class="sc-row-h"><b>' + esc(t('scCats')[k]) + '</b><span class="sc-n ' + band(n) + '">' + n + '<small>/10</small></span></div>' +
          '<div class="sc-bar"><i class="' + band(n) + '" style="width:' + (n * 10) + '%"></i></div>' +
          (s.summary ? '<p dir="auto">' + esc(s.summary) + '</p>' : '') + '</div>';
      }).join('') + '</div>' +
      practiceCard(r.practice) +
      ((r.strengths && r.strengths.length) || r.nextStep ? '<div class="sc-two">' +
        (r.strengths && r.strengths.length ? '<div class="card sc-good"><h3>' + esc(t('scStrengths')) + '</h3><ul class="sc-list">' + r.strengths.map(function (s) { return '<li dir="auto">' + esc(s) + '</li>'; }).join('') + '</ul></div>' : '') +
        (r.nextStep ? '<div class="card sc-nextstep"><h3>' + esc(t('scNext')) + '</h3><p dir="auto">' + esc(r.nextStep) + '</p></div>' : '') + '</div>' : '') +
      '</section>';

    if (r.story) html += '<section class="sc-panel" data-panel="story" hidden>' + storyCard(r.story) + '</section>';

    html += '<section class="sc-panel" data-panel="pace" hidden>' + (paceCard(Object.assign({ durationSeconds: r.durationSeconds }, m)) || '<div class="card"><p>' + esc(t('scWpm', { n: Math.round(m.wordsPerMinute || 0) })) + '</p></div>') + fillerCard(m) + '</section>';

    if (moments.length) {
      html += '<section class="sc-panel" data-panel="moments" hidden><ol class="sc-mlist">' + moments.map(function (mo, i) {
        var cat = t('scCats')[mo.category] || '';
        return '<li class="card" data-m="' + i + '"><div class="sc-m-h">' +
          '<button type="button" class="sc-time" data-at="' + (+mo.at || 0) + '" aria-label="' + esc(t(opts.audio ? 'scPlayHere' : 'scAt', { t: mmss(mo.at) })) + '">' + (opts.audio ? PLAY : '') + '<span dir="ltr">' + mmss(mo.at) + '</span></button>' +
          (cat ? '<span class="sc-tag sc-tag-' + esc(mo.category) + '">' + esc(cat) + '</span>' : '') + '</div>' +
          (mo.quote ? '<blockquote dir="auto">“' + esc(mo.quote) + '”</blockquote>' : '') +
          (mo.issue ? '<p dir="auto">' + esc(mo.issue) + '</p>' : '') +
          (mo.fix ? '<p class="sc-fix" dir="auto"><b>' + esc(t('scTry')) + '</b> ' + esc(mo.fix) + '</p>' : '') + '</li>';
      }).join('') + '</ol></section>';
    }

    if (words.length) {
      html += '<section class="sc-panel" data-panel="words" hidden><div class="card sc-tr"><p class="sc-legend"><span class="lg-f">um</span> ' + esc(t('scLegendF')) +
        ' <span class="lg-p">' + esc(t('scPause', { n: '2.0' })) + '</span> ' + esc(t('scLegendP')) + '</p>' +
        '<div class="sc-text" dir="auto">' + transcript(words) + '</div></div></section>';
    }
    html += '</div>';
    el.innerHTML = html;

    // Tabs
    var nav = el.querySelector('.sc-tabs');
    function show(name) {
      nav.querySelectorAll('button').forEach(function (b) { b.setAttribute('aria-selected', String(b.dataset.tab === name)); });
      el.querySelectorAll('.sc-panel').forEach(function (p) { p.hidden = p.dataset.panel !== name; });
    }
    nav.addEventListener('click', function (e) {
      var b = e.target.closest('button');
      if (!b) return;
      show(b.dataset.tab);
      try { b.scrollIntoView({ inline: 'center', block: 'nearest', behavior: 'smooth' }); } catch (_) {}
      // Bring the tabs up so the chosen section is in view.
      var top = nav.getBoundingClientRect().top + window.scrollY - 86;
      if (Math.abs(window.scrollY - top) > 40) window.scrollTo({ top: top, behavior: 'smooth' });
    });

    if (opts.celebrate) reveal(el, clamp(r.overall));

    // Listen-back player
    var audio = el.querySelector('.sc-player audio');
    if (audio) {
      var player = el.querySelector('.sc-player'), btn = el.querySelector('.pl-btn'), fill = el.querySelector('.pl-track i');
      var knob = el.querySelector('.pl-knob'), time = el.querySelector('.pl-time'), track = el.querySelector('.pl-track');
      var PAUSE = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M7 5h3.5v14H7zM13.5 5H17v14h-3.5z"/></svg>';
      var dragging = false, raf = 0;
      var total = function () { return isFinite(audio.duration) && audio.duration > 0 ? audio.duration : (r.durationSeconds || 0); };
      var draw = function (at) {
        var d = total(), f = d ? Math.max(0, Math.min(1, at / d)) : 0;
        fill.style.width = (f * 100) + '%';
        knob.style.insetInlineStart = (f * 100) + '%';
        time.textContent = mmss(at) + ' / ' + mmss(d);
      };
      // Phone recordings come out without a proper length (Chrome's WebM says
      // "Infinity", Safari's MP4 is stitched from pieces), and they then play
      // silently until something seeks. So once the file loads we find its real
      // length by jumping to the end, and every first play starts with a seek.
      var primed = false, want = null;
      function prime() {
        if (primed) return;
        var done = function () {
          primed = true;
          var to = want == null ? 0 : want;
          want = null;
          try { audio.currentTime = Math.max(0.01, to); } catch (_) {}
          draw(audio.currentTime);
        };
        if (isFinite(audio.duration) && audio.duration > 0) return done();
        var onLen = function () {
          if (!isFinite(audio.duration) || !(audio.duration > 0)) return;
          audio.removeEventListener('durationchange', onLen);
          done();
        };
        audio.addEventListener('durationchange', onLen);
        try { audio.currentTime = 1e101; } catch (_) { audio.removeEventListener('durationchange', onLen); done(); }
      }
      // Play (from a time, or from where it is). play() stays inside the tap so
      // iPhone allows it; the seek happens now or as soon as the file is ready.
      function playAt(to) {
        if (primed) { if (to != null) { try { audio.currentTime = Math.max(0.01, to); } catch (_) {} } }
        else want = to == null ? (want == null ? 0 : want) : to;
        var p = audio.play();
        if (p && p.catch) p.catch(function () {});
      }
      // Redraw every frame while playing, so the bar moves smoothly.
      var loop = function () { if (!dragging) draw(audio.currentTime); if (!audio.paused) raf = requestAnimationFrame(loop); };
      btn.addEventListener('click', function () { if (audio.paused) playAt(null); else audio.pause(); });
      audio.addEventListener('play', function () { btn.innerHTML = PAUSE; player.classList.add('on'); cancelAnimationFrame(raf); raf = requestAnimationFrame(loop); });
      audio.addEventListener('pause', function () { btn.innerHTML = PLAY; player.classList.remove('on'); draw(audio.currentTime); });
      audio.addEventListener('ended', function () { draw(total()); });
      audio.addEventListener('loadedmetadata', function () { draw(audio.currentTime); prime(); });
      if (audio.readyState >= 1) prime();
      audio.addEventListener('seeked', function () { if (!dragging) draw(audio.currentTime); });
      // Tap or drag anywhere on the bar.
      var at = function (e) {
        var rc = track.getBoundingClientRect();
        var x = (e.clientX - rc.left) / rc.width;
        if (getComputedStyle(track).direction === 'rtl') x = 1 - x;
        return Math.max(0, Math.min(1, x)) * total();
      };
      track.addEventListener('pointerdown', function (e) {
        dragging = true;
        try { track.setPointerCapture(e.pointerId); } catch (_) {}
        player.classList.add('drag');
        draw(at(e));
      });
      track.addEventListener('pointermove', function (e) { if (dragging) draw(at(e)); });
      var drop = function (e) {
        if (!dragging) return;
        dragging = false;
        player.classList.remove('drag');
        var to = at(e);
        if (primed) { try { audio.currentTime = to; } catch (_) {} } else want = to;
        draw(to);
      };
      track.addEventListener('pointerup', drop);
      track.addEventListener('pointercancel', function () { dragging = false; player.classList.remove('drag'); });
      // Arrow keys move 5 seconds.
      track.addEventListener('keydown', function (e) {
        var step = e.key === 'ArrowRight' ? 5 : e.key === 'ArrowLeft' ? -5 : 0;
        if (!step) return;
        e.preventDefault();
        try { audio.currentTime = Math.max(0, Math.min(total(), audio.currentTime + step)); } catch (_) {}
      });
      audio.playAt = playAt;
      draw(0);
    }
    var text = el.querySelector('.sc-text');
    // A moment's time plays from there, and lights up those words in the transcript.
    function jump(at) {
      if (text) {
        text.querySelectorAll('.sc-w.hl').forEach(function (w) { w.classList.remove('hl'); });
        text.querySelectorAll('.sc-w').forEach(function (w) {
          var s = +w.dataset.s;
          if (s >= at - 0.4 && s <= at + 2.5) w.classList.add('hl');
        });
      }
      if (audio && audio.playAt) audio.playAt(Math.max(0, at - 1));
    }
    el.querySelectorAll('.sc-time').forEach(function (b) { b.addEventListener('click', function () { jump(+b.dataset.at); }); });
    if (text && audio) {
      text.addEventListener('click', function (e) {
        var w = e.target.closest('.sc-w');
        if (w && audio.playAt) audio.playAt(Math.max(0, +w.dataset.s - 0.2));
      });
      // Follow along: the word being spoken is underlined.
      var ws = text.querySelectorAll('.sc-w');
      audio.addEventListener('timeupdate', function () {
        var now = audio.currentTime;
        ws.forEach(function (w) { w.classList.toggle('now', !audio.paused && +w.dataset.s <= now && now < +w.dataset.s + 0.6); });
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
    if (n >= 8) confetti();
  }

  // A short burst of confetti over the page.
  function confetti() {
    if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
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

  window.Coach = { render: render, progress: progress, confetti: confetti, transcriptHtml: transcript, mmss: mmss, clamp: clamp, band: band, CATS: CATS };
})();
