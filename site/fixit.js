// Speech Coach "Fix-it mode": a level for each slip in a report. The player
// hears what happened, learns the fix, says that part again, and earns up to
// 3 stars when the retry is better. Needs app.js, game.js and coach.js.
// Exposes window.Fixit.
(function () {
  'use strict';
  var S = window.SUF, G = window.G, esc = S.esc, t = S.t;

  S.addStrings({
    fxTitle: 'Fix-it mode', fxCta: 'Fix your slips', fxCtaBody: '{n} moments to fix. Say each one again and earn stars.',
    fxCtaDone: '{s} of {m} stars earned. Go for a perfect run!', fxGo: 'Play Fix-it', fxPlayAgain: 'Play again',
    fxIntro: 'For each slip, hear what happened, learn the fix, then say that part again. Better retries earn up to 3 stars.',
    fxStart: "Let's fix them", fxLevel: 'Slip {n} of {t}', fxYouSaid: 'You said', fxHear: 'Hear it', fxWhat: 'What happened', fxFix: 'The fix',
    fxAsk: 'Now say that part again, using the fix.', fxSay: 'Say it again', fxSkip: 'Skip', fxDone: 'Done',
    fxListening: 'Say it again', fxShort: 'Keep going a little longer.', fxChecking: 'Checking your retry',
    fxPassed: ['Getting better!', 'Fixed it!', 'Nailed it!'], fxNotYet: 'Almost there', fxEarned: '+{n} stars', fxEarned1: '+1 star',
    fxNext: 'Next slip', fxFinish: 'See my stars', fxRetry: 'Try again', fxFor3: 'Go for 3 stars', fxHeard: 'We heard',
    fxSelf: "We can't check this one automatically right now. How did it go?", fxSelfYes: 'I nailed it', fxSelfNo: 'Try again',
    fxErr: "We couldn't check that. Try again.", fxNoSpeech: "We didn't hear that. Move closer to the microphone and try again.",
    fxLimit: "You've used today's retries. Come back tomorrow.",
    fxEndTitle: 'Slips fixed!', fxEndBody: 'You earned {s} of {m} stars.', fxBadges: ['Getting there', 'Fixer', 'Smooth talker', 'Perfect run'],
    fxBack: 'Back to my report', fxNoMic: "We couldn't use your microphone. Allow it in your browser settings, then try again."
  }, {
    fxTitle: 'وضع التصحيح', fxCta: 'صحّح تعثّراتك', fxCtaBody: '{n} لحظات للتصحيح. قل كل واحدة من جديد واجمع النجوم.',
    fxCtaDone: 'جمعت {s} من {m} نجوم. حاول الوصول إلى العلامة الكاملة!', fxGo: 'العب التصحيح', fxPlayAgain: 'العب مجددًا',
    fxIntro: 'في كل تعثّر، استمع لما حدث، وتعرّف على طريقة التحسين، ثم قل ذلك الجزء من جديد. كلما كانت إعادتك أفضل جمعت حتى 3 نجوم.',
    fxStart: 'لنصحّحها', fxLevel: 'التعثّر {n} من {t}', fxYouSaid: 'قلت', fxHear: 'استمع', fxWhat: 'ما الذي حدث', fxFix: 'طريقة التحسين',
    fxAsk: 'الآن قل ذلك الجزء من جديد باستخدام طريقة التحسين.', fxSay: 'قلها من جديد', fxSkip: 'تخطَّ', fxDone: 'تم',
    fxListening: 'قلها من جديد', fxShort: 'استمر قليلًا بعد.', fxChecking: 'نتحقق من إعادتك',
    fxPassed: ['أفضل من قبل!', 'صحّحتها!', 'أتقنتها!'], fxNotYet: 'اقتربت', fxEarned: '+{n} نجوم', fxEarned1: '+نجمة',
    fxNext: 'التعثّر التالي', fxFinish: 'شاهد نجومي', fxRetry: 'حاول مجددًا', fxFor3: 'حاول للحصول على 3 نجوم', fxHeard: 'سمعنا',
    fxSelf: 'لا نستطيع التحقق من هذه تلقائيًا الآن. كيف كانت؟', fxSelfYes: 'أتقنتها', fxSelfNo: 'حاول مجددًا',
    fxErr: 'لم نتمكن من التحقق. حاول مجددًا.', fxNoSpeech: 'لم نسمعك. اقترب من الميكروفون وحاول مجددًا.',
    fxLimit: 'استخدمت إعادات اليوم. عد غدًا.',
    fxEndTitle: 'صحّحت تعثّراتك!', fxEndBody: 'جمعت {s} من {m} نجوم.', fxBadges: ['في الطريق', 'مصحّح', 'متحدث سلس', 'أداء كامل'],
    fxBack: 'عُد إلى تقريري', fxNoMic: 'لم نتمكن من استخدام الميكروفون. اسمح به في إعدادات المتصفح، ثم حاول مجددًا.'
  });

  var MAX_SECONDS = 25, MIN_SECONDS = 2;
  var STAR = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="m12 2.8 2.8 5.7 6.3.9-4.6 4.4 1.1 6.3L12 17.1l-5.6 3 1.1-6.3L2.9 9.4l6.3-.9z"/></svg>';
  var MIC = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>';

  function sorted(report) { return (report.moments || []).slice().sort(function (a, b) { return (a.at || 0) - (b.at || 0); }); }
  function key(report) { return 'speakupfearless.fixit.' + (report.id || 'x'); }
  // Best stars per slip: this device's, plus any the account saved ("fixes").
  function saved(report) {
    var best = {};
    try { best = JSON.parse(S.store(key(report)) || '{}') || {}; } catch (_) {}
    var f = report.fixes || {};
    Object.keys(f).forEach(function (k) { best[k] = Math.max(best[k] || 0, +f[k] || 0); });
    return best;
  }
  function save(report, best) { S.store(key(report), JSON.stringify(best)); }
  function total(best) { return Object.keys(best).reduce(function (s, k) { return s + (best[k] || 0); }, 0); }
  function stars(n, max, cls) {
    var h = '';
    for (var i = 0; i < (max || 3); i++) h += '<i class="' + (i < n ? 'on' : '') + '" style="animation-delay:' + (i * 0.18) + 's">' + STAR + '</i>';
    return '<span class="fx-stars ' + (cls || '') + '">' + h + '</span>';
  }
  function pickType() {
    if (!window.MediaRecorder) return null;
    var types = ['audio/webm;codecs=opus', 'audio/mp4', 'audio/webm', 'audio/ogg;codecs=opus'];
    for (var i = 0; i < types.length; i++) { try { if (MediaRecorder.isTypeSupported(types[i])) return types[i]; } catch (_) {} }
    return '';
  }

  // The card on the report that starts the game (and shows stars so far).
  function cta(report, onPlay) {
    var ms = sorted(report);
    if (!ms.length) return null;
    var best = saved(report), got = total(best), max = ms.length * 3;
    var el = document.createElement('section');
    el.className = 'card fx-cta';
    el.innerHTML = '<div class="fx-cta-top"><span class="fx-ic">' + STAR + '</span><div><small>' + esc(t('fxTitle')) + '</small><h2>' + esc(t('fxCta')) + '</h2>' +
      '<p>' + esc(got ? t('fxCtaDone', { s: got, m: max }) : t('fxCtaBody', { n: ms.length })) + '</p></div></div>' +
      '<div class="fx-dots">' + ms.map(function (_, i) { return stars(best[i] || 0, 3, 'sm'); }).join('') + '</div>' +
      '<button class="btn btn-primary btn-block" type="button">' + G.ICON.play + esc(got ? t('fxPlayAgain') : t('fxGo')) + '</button>';
    el.querySelector('button').addEventListener('click', onPlay);
    return el;
  }

  // Runs the game. opts: {report, audio (object URL of the original, optional), onClose}
  function start(opts) {
    var report = opts.report, ms = sorted(report), best = saved(report);
    var st = G.stage({ onLeave: cleanup });
    st.el.classList.add('fx-stage');
    var original = opts.audio ? new Audio(opts.audio) : null, stopAt = 0;
    if (original) original.addEventListener('timeupdate', function () { if (stopAt && original.currentTime >= stopAt) { original.pause(); stopAt = 0; } });
    var stream = null, rec = null, ctx = null, type = pickType(), level = 0, timer = 0;

    function cleanup() {
      clearInterval(timer);
      G.loopStop();
      try { if (rec && rec.state !== 'inactive') { rec.onstop = null; rec.stop(); } } catch (_) {}
      if (stream) stream.getTracks().forEach(function (tr) { tr.stop(); });
      if (ctx) { try { ctx.close(); } catch (_) {} }
      stream = null; ctx = null;
      if (original) original.pause();
    }
    function close() { cleanup(); st.close(); if (opts.onClose) opts.onClose(); }
    function header() {
      return '<div class="fx-head"><span class="fx-prog">' + ms.map(function (_, i) {
        return '<b class="' + (i === level ? 'now' : best[i] ? 'won' : '') + '"></b>';
      }).join('') + '</span><span class="fx-total">' + STAR + '<span dir="ltr">' + total(best) + '</span></span></div>';
    }

    function intro() {
      st.body.innerHTML = '<div class="fx-badge-ic">' + STAR + '</div><div class="cue" style="font-size:clamp(34px,9vw,56px)">' + esc(t('fxTitle')) + '</div>' +
        '<p class="hint">' + esc(t('fxIntro')) + '</p>' +
        '<div class="controls"><button class="btn btn-primary" type="button" id="fxs">' + G.ICON.arrow + esc(t('fxStart')) + '</button></div>';
      st.body.querySelector('#fxs').addEventListener('click', function () { level = 0; showLevel(); });
    }

    function showLevel(msg) {
      var mo = ms[level], cat = t('scCats')[mo.category] || '';
      st.body.innerHTML = header() +
        '<div class="fx-card"><div class="fx-meta"><span>' + esc(t('fxLevel', { n: level + 1, t: ms.length })) + '</span>' +
          (cat ? '<span class="sc-tag sc-tag-' + esc(mo.category) + '">' + esc(cat) + '</span>' : '') + '</div>' +
        (mo.quote ? '<div class="fx-sec"><small>' + esc(t('fxYouSaid')) + '</small><blockquote dir="auto">“' + esc(mo.quote) + '”</blockquote>' +
          (original ? '<button type="button" class="fx-hear">' + G.ICON.play + esc(t('fxHear')) + ' <span dir="ltr">' + window.Coach.mmss(mo.at) + '</span></button>' : '') + '</div>' : '') +
        (mo.issue ? '<div class="fx-sec"><small>' + esc(t('fxWhat')) + '</small><p dir="auto">' + esc(mo.issue) + '</p></div>' : '') +
        (mo.fix ? '<div class="fx-sec fx-fixbox"><small>' + esc(t('fxFix')) + '</small><p dir="auto">' + esc(mo.fix) + '</p></div>' : '') +
        '</div>' +
        '<p class="fx-ask">' + esc(msg || t('fxAsk')) + '</p>' +
        '<div class="controls"><button class="btn btn-ghost" type="button" id="fxk">' + esc(t('fxSkip')) + '</button>' +
        '<button class="btn btn-primary" type="button" id="fxr">' + MIC + esc(t('fxSay')) + '</button></div>';
      var h = st.body.querySelector('.fx-hear');
      if (h) h.addEventListener('click', function () {
        try { original.currentTime = Math.max(0.01, (mo.at || 0) - 1); stopAt = (mo.at || 0) + 5; var p = original.play(); if (p && p.catch) p.catch(function () {}); } catch (_) {}
      });
      st.body.querySelector('#fxk').addEventListener('click', next);
      st.body.querySelector('#fxr').addEventListener('click', askMic);
    }

    function askMic() {
      if (original) original.pause();
      if (type === null || !navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) return showLevel(t('cNoRecorder'));
      try { ctx = new (window.AudioContext || window.webkitAudioContext)(); } catch (_) { ctx = null; }
      navigator.mediaDevices.getUserMedia({ audio: { echoCancellation: true, noiseSuppression: true, autoGainControl: true } })
        .then(function (s) { stream = s; record(); })
        .catch(function () { cleanup(); showLevel(t('fxNoMic')); });
    }

    function record() {
      var chunks = [], began = Date.now();
      try { rec = type ? new MediaRecorder(stream, { mimeType: type, audioBitsPerSecond: 48000 }) : new MediaRecorder(stream); }
      catch (_) { cleanup(); return showLevel(t('cNoRecorder')); }
      rec.ondataavailable = function (e) { if (e.data && e.data.size) chunks.push(e.data); };
      rec.onstop = function () {
        var secs = (Date.now() - began) / 1000;
        if (stream) stream.getTracks().forEach(function (tr) { tr.stop(); });
        if (ctx) { try { ctx.close(); } catch (_) {} }
        stream = null; ctx = null;
        check(new Blob(chunks, { type: rec.mimeType || type || 'audio/webm' }), secs);
      };
      rec.start();
      var mo = ms[level];
      st.body.innerHTML = header() + '<div class="mic fx-mic" id="fxm">' + MIC + '</div><div class="rec">' + esc(t('fxListening')) + '</div>' +
        (mo.fix ? '<p class="fx-remind" dir="auto">' + esc(mo.fix) + '</p>' : '') +
        '<div class="clock" id="fxc">0:00</div><p class="note" id="fxmsg"></p>' +
        '<div class="controls"><button class="btn btn-primary" type="button" id="fxd">' + G.ICON.flag + esc(t('fxDone')) + '</button></div>';
      var mic = st.body.querySelector('#fxm'), clock = st.body.querySelector('#fxc');
      var analyser = null, buf = null;
      if (ctx) {
        try { if (ctx.state === 'suspended') ctx.resume(); analyser = ctx.createAnalyser(); analyser.fftSize = 512; ctx.createMediaStreamSource(stream).connect(analyser); buf = new Uint8Array(analyser.fftSize); }
        catch (_) { analyser = null; }
      }
      var stop = function () { G.loopStop(); if (rec && rec.state !== 'inactive') rec.stop(); };
      st.body.querySelector('#fxd').addEventListener('click', function () {
        if ((Date.now() - began) / 1000 < MIN_SECONDS) { st.body.querySelector('#fxmsg').textContent = t('fxShort'); return; }
        stop();
      });
      G.loop(function () {
        var s = (Date.now() - began) / 1000;
        if (s >= MAX_SECONDS) return stop();
        clock.textContent = window.Coach.mmss(s);
        if (analyser) {
          analyser.getByteTimeDomainData(buf);
          var peak = 0;
          for (var k = 0; k < buf.length; k++) peak = Math.max(peak, Math.abs(buf[k] - 128));
          mic.style.boxShadow = '0 0 0 ' + (12 + Math.min(1, peak / 70) * 18).toFixed(0) + 'px color-mix(in srgb, #3E8E7A 24%, transparent)';
        }
      });
    }

    function check(blob, secs) {
      st.body.innerHTML = header() + '<div class="fx-spin" aria-hidden="true"></div><div class="cue" style="font-size:clamp(26px,7vw,40px)">' + esc(t('fxChecking')) + '</div>';
      var ext = /mp4/.test(blob.type) ? 'm4a' : /ogg/.test(blob.type) ? 'ogg' : 'webm';
      var form = new FormData();
      form.append('audio', blob, 'retry.' + ext);
      form.append('lang', S.lang);
      form.append('reportId', String(report.id || ''));
      form.append('moment', String(level));
      form.append('durationSeconds', secs.toFixed(1));
      S.upload('/v1/speech/retry', form, 60000).then(function (r) {
        if (r && r.status === 200 && r.body && 'stars' in r.body) return result(r.body, blob);
        var code = r && r.body && r.body.code;
        if (r && code === 'no_speech') return showLevel(t('fxNoSpeech'));
        if (r && r.status === 429) return showLevel(t('fxLimit'));
        // Checking isn't available (yet): let them judge it, so the game still works.
        if (!r || r.status === 404 && !code || r.status === 503 || r.status === 501 || r.status === 405) return selfCheck(blob);
        showLevel(t('fxErr'));
      });
    }

    function award(n) {
      n = Math.max(0, Math.min(3, Math.round(n || 0)));
      if (n > (best[level] || 0)) { best[level] = n; save(report, best); }
      return n;
    }

    function playback(blob) {
      return '<audio class="fx-audio" controls preload="auto" src="' + esc(URL.createObjectURL(blob)) + '"></audio>';
    }

    function result(r, blob) {
      // 1 star means better but not fixed yet; it still counts.
      var n = award(r.stars);
      var last = level === ms.length - 1;
      var heard = r.transcript && r.transcript.length ? window.Coach.transcriptHtml(r.transcript) : esc(r.heard || '');
      st.body.innerHTML = header() +
        '<div class="fx-result ' + (n ? 'win' : 'try') + '">' + stars(n, 3, 'big') +
        '<div class="cue" style="font-size:clamp(32px,9vw,54px)">' + esc(n ? t('fxPassed')[n - 1] : t('fxNotYet')) + '</div>' +
        (n ? '<span class="fx-plus">' + esc(n === 1 ? t('fxEarned1') : t('fxEarned', { n: n })) + '</span>' : '') +
        (r.feedback ? '<p class="fx-fb" dir="auto">' + esc(r.feedback) + '</p>' : '') +
        (heard ? '<div class="fx-heard"><small>' + esc(t('fxHeard')) + '</small><div class="sc-text" dir="auto">' + heard + '</div></div>' : '') +
        playback(blob) + '</div>' +
        '<div class="controls">' +
          (n < 3 ? '<button class="btn btn-ghost" type="button" id="fxa">' + G.ICON.repeat + esc(n ? t('fxFor3') : t('fxRetry')) + '</button>' : '') +
          '<button class="btn ' + (n ? 'btn-primary' : 'btn-ghost') + '" type="button" id="fxn">' + G.ICON.arrow + esc(last ? t('fxFinish') : n ? t('fxNext') : t('fxSkip')) + '</button>' +
        '</div>';
      if (n >= 2) window.Coach.confetti();
      if (navigator.vibrate && n) navigator.vibrate([40, 60, 40]);
      var a = st.body.querySelector('#fxa');
      if (a) a.addEventListener('click', function () { showLevel(); });
      st.body.querySelector('#fxn').addEventListener('click', next);
    }

    function selfCheck(blob) {
      st.body.innerHTML = header() + '<div class="fx-result">' + '<p class="fx-fb">' + esc(t('fxSelf')) + '</p>' + playback(blob) + '</div>' +
        '<div class="controls"><button class="btn btn-ghost" type="button" id="fxno">' + G.ICON.repeat + esc(t('fxSelfNo')) + '</button>' +
        '<button class="btn btn-primary" type="button" id="fxyes">' + STAR + esc(t('fxSelfYes')) + '</button></div>';
      st.body.querySelector('#fxno').addEventListener('click', function () { showLevel(); });
      st.body.querySelector('#fxyes').addEventListener('click', function () { result({ passed: true, stars: 2 }, blob); });
    }

    function next() {
      if (level < ms.length - 1) { level++; showLevel(); } else finish();
    }

    function finish() {
      var got = total(best), max = ms.length * 3, f = max ? got / max : 0;
      var badge = t('fxBadges')[f >= 1 ? 3 : f >= 0.66 ? 2 : f >= 0.33 ? 1 : 0];
      st.body.innerHTML = '<div class="fx-trophy">🏆</div><div class="cue" style="font-size:clamp(34px,9vw,56px)">' + esc(t('fxEndTitle')) + '</div>' +
        '<span class="fx-badge">' + esc(badge) + '</span>' +
        '<p class="hint">' + esc(t('fxEndBody', { s: got, m: max })) + '</p>' +
        '<div class="fx-dots big">' + ms.map(function (_, i) { return stars(best[i] || 0, 3, 'sm'); }).join('') + '</div>' +
        '<div class="controls"><button class="btn btn-ghost" type="button" id="fxagain">' + G.ICON.repeat + esc(t('fxPlayAgain')) + '</button>' +
        '<button class="btn btn-primary" type="button" id="fxback">' + esc(t('fxBack')) + '</button></div>';
      if (got) window.Coach.confetti();
      st.body.querySelector('#fxagain').addEventListener('click', function () { level = 0; showLevel(); });
      st.body.querySelector('#fxback').addEventListener('click', close);
    }

    if (!ms.length) return close();
    intro();
  }

  window.Fixit = { cta: cta, start: start };
})();
