// Building blocks for the game pages (window.G). Needs app.js (window.SUF).
(function () {
  'use strict';
  var S = window.SUF;
  var esc = S.esc;
  var t = S.t;

  var ICON = {
    close: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 6l12 12M18 6 6 18"/></svg>',
    back: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.4" stroke-linecap="round" stroke-linejoin="round"><path d="m15 5-7 7 7 7"/></svg>',
    bulb: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M9 18h6M10 21h4M12 3a6 6 0 0 0-4 10.5c.7.7 1 1.5 1 2.5h6c0-1 .3-1.8 1-2.5A6 6 0 0 0 12 3z"/></svg>',
    play: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5.5v13a1 1 0 0 0 1.5.86l10.5-6.5a1 1 0 0 0 0-1.72L9.5 4.64A1 1 0 0 0 8 5.5z"/></svg>',
    pause: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M7 5h3.5v14H7zM13.5 5H17v14h-3.5z"/></svg>',
    next: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M6 6v12l8.5-6zM16 6h2v12h-2z"/></svg>',
    flag: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 21V4M5 4h11l-2 4 2 4H5"/></svg>',
    person: '<svg viewBox="0 0 24 24" fill="currentColor"><circle cx="12" cy="8" r="4"/><path d="M4 20c0-4 3.6-6.5 8-6.5s8 2.5 8 6.5z"/></svg>',
    group: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12.75c1.63 0 3.07.39 4.24.9A3 3 0 0 1 18 16.4V18H6v-1.6c0-1.2.7-2.25 1.76-2.73 1.17-.52 2.61-.92 4.24-.92zM4 13a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm-.13 1.1A7 7 0 0 0 0 16.43V18h4.5v-1.61c0-.83.23-1.61.63-2.29A7 7 0 0 0 3.87 14.1zM20 13a2 2 0 1 0 0-4 2 2 0 0 0 0 4zm4 3.43a2 2 0 0 0-1.22-1.85A7 7 0 0 0 20 14c-.39 0-.76.04-1.13.1.4.68.63 1.46.63 2.29V18H24zM12 6a3 3 0 1 1 0 6 3 3 0 0 1 0-6z"/></svg>',
    clock: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="9"/><path d="M12 7v5l3 2"/></svg>',
    repeat: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 2l4 4-4 4M3 11V9a3 3 0 0 1 3-3h15M7 22l-4-4 4-4M21 13v2a3 3 0 0 1-3 3H3"/></svg>',
    list: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M9 6h11M9 12h11M9 18h11M4 6h.01M4 12h.01M4 18h.01"/></svg>',
    speed: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><path d="M4 18a8 8 0 1 1 16 0M12 18l4-6"/></svg>',
    arrow: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"><path d="M5 12h14M13 6l6 6-6 6"/></svg>'
  };

  // ---------------------------------------------------------------- words
  var WORDS = null;
  function loadWords() {
    if (WORDS) return Promise.resolve(WORDS);
    return fetch('/data/words.json').then(function (r) { return r.json(); }).then(function (d) {
      WORDS = d[S.lang] || d.en;
      return WORDS;
    });
  }
  function shuffle(a) {
    for (var i = a.length - 1; i > 0; i--) { var j = Math.floor(Math.random() * (i + 1)); var x = a[i]; a[i] = a[j]; a[j] = x; }
    return a;
  }
  // Topics come out in a random order without repeats until all are used.
  var deck = [];
  function drawTopic() {
    if (!deck.length) deck = shuffle(WORDS.topics.slice());
    return deck.pop();
  }
  // Same rules as before: General draws a topic, other sets turn a word into one.
  function pickTopic(suggest, wordSet) {
    if (!suggest) return t('yourOwnTopic');
    var words = WORDS.wordSets[wordSet];
    if (wordSet === 'General' || !words) return drawTopic();
    var w = words[Math.floor(Math.random() * words.length)];
    return w[0].toUpperCase() + w.slice(1);
  }
  function setName(n) { var m = t('wordSetNames'); return (m && m[n]) || n; }

  // ---------------------------------------------------------------- formats
  function clock(ms) {
    var s = Math.max(0, Math.ceil(ms / 1000));
    return String(Math.floor(s / 60)).padStart(2, '0') + ':' + String(s % 60).padStart(2, '0');
  }
  function timerLabel(sec) {
    var m = Math.floor(sec / 60), s = sec % 60;
    if (s) return S.lang === 'ar' ? m + ':' + String(s).padStart(2, '0') + ' د' : m + ':' + String(s).padStart(2, '0') + ' min';
    if (S.lang === 'ar') return m === 1 ? 'دقيقة واحدة' : (m === 2 ? 'دقيقتان' : m + ' دقائق');
    return m === 1 ? '1 minute' : m + ' minutes';
  }
  function playerName(n) { return t('playerName', { n: n }); }

  // ---------------------------------------------------------------- setup page
  // Renders the setup card. fields: [{type, ...}] ; returns {values()}.
  function setup(opts) {
    var main = document.getElementById('main');
    var games = opts.games;
    var g = games[opts.id];
    main.innerHTML = '<div class="setup card"><div class="g-head"><span class="gi g-' + opts.id + '">' + S.ICONS[opts.id] + '</span>' +
      '<div><h1>' + esc(g.title) + '</h1><p>' + esc(opts.subtitle || g.tagline) + '</p></div>' +
      '<a class="x" href="/games" aria-label="' + esc(t('tripleStepBackToGames')) + '">' + ICON.close + '</a></div>' +
      '<button class="howbtn" type="button">' + ICON.bulb + esc(t('howTo')) + '</button>' +
      '<div class="rows" id="rows"></div>' +
      '<button class="btn btn-primary start" type="button" id="startBtn">' + (opts.startIcon || ICON.play) + esc(opts.startLabel || t('tripleStepStart')) + '</button></div>';
    // "Let's play" at the end of How to play starts the game.
    // (A game whose first page is only settings keeps people on it instead.)
    var play = opts.playFromHow === false ? null : function () { var b = main.querySelector('#startBtn'); if (b) b.click(); };
    main.querySelector('.howbtn').addEventListener('click', function () { S.howToPlay(opts.id, play); });
    S.howToPlayFirstTime(opts.id, play);
    var rows = main.querySelector('#rows');
    opts.render(rows);
    main.querySelector('#startBtn').addEventListener('click', opts.onStart);
    return main;
  }
  function row(html) { var d = document.createElement('div'); d.innerHTML = html; return d; }
  function slider(o) {
    // o: {icon, label, help, min, max, step, value, format, onChange}
    var r = row('<div class="row-head">' + (o.icon || '') + '<span>' + esc(o.label) + '</span><span class="val"></span></div>' +
      (o.help ? '<p class="help">' + esc(o.help) + '</p>' : '') +
      '<input type="range" min="' + o.min + '" max="' + o.max + '" step="' + (o.step || 1) + '" value="' + o.value + '" aria-label="' + esc(o.label) + '">');
    var input = r.querySelector('input'), val = r.querySelector('.val');
    var show = function () { val.textContent = o.format(+input.value); };
    input.addEventListener('input', function () { show(); o.onChange(+input.value); });
    show();
    return r;
  }
  function toggle(o) {
    var r = row('<label class="toggle"><div><b>' + esc(o.label) + '</b><p class="help">' + esc(o.help || '') + '</p></div>' +
      '<span class="switch"><input type="checkbox"' + (o.value ? ' checked' : '') + '><span></span></span></label>');
    r.querySelector('input').addEventListener('change', function (e) { o.onChange(e.target.checked); });
    return r;
  }
  function select(o) {
    var r = row('<label><span class="row-head"><span>' + esc(o.label) + '</span></span><select class="sel">' +
      o.options.map(function (v) { return '<option value="' + esc(v) + '"' + (v === o.value ? ' selected' : '') + '>' + esc(setName(v)) + '</option>'; }).join('') +
      '</select></label>');
    r.querySelector('select').addEventListener('change', function (e) { o.onChange(e.target.value); });
    return r;
  }
  function modeTabs(o) {
    var r = row('<div class="tabs2" role="group"><button type="button" data-m="0">' + ICON.person + esc(t('tripleStepSingle')) + '</button>' +
      '<button type="button" data-m="1">' + ICON.group + esc(t('tripleStepMulti')) + '</button></div>');
    var paint = function () { r.querySelectorAll('button').forEach(function (b) { b.setAttribute('aria-pressed', String(+b.dataset.m === (o.value ? 1 : 0))); }); };
    r.querySelectorAll('button').forEach(function (b) {
      b.addEventListener('click', function () { o.value = b.dataset.m === '1'; paint(); o.onChange(o.value); });
    });
    paint();
    return r;
  }
  // Editable list of player names.
  function players(o) {
    // o: {names, min, max, label, fixed}
    var r = row('<div class="row-head">' + ICON.group + '<span>' + esc(o.label || t('tripleStepPlayers')) + '</span></div><div class="players"></div>' +
      (o.fixed ? '' : '<button class="add-player" type="button">+ ' + esc(t('tripleStepAddPlayer')) + '</button>'));
    var box = r.querySelector('.players');
    var paint = function () {
      box.innerHTML = '';
      o.names.forEach(function (n, i) {
        var d = document.createElement('div');
        d.innerHTML = '<input maxlength="24" autocapitalize="words" aria-label="' + esc(playerName(i + 1)) + '">' +
          (o.fixed || o.names.length <= o.min ? '' : '<button type="button" aria-label="' + esc(t('tripleStepRemovePlayer')) + '">' + ICON.close + '</button>');
        var inp = d.querySelector('input');
        inp.value = n;
        inp.addEventListener('input', function () { o.names[i] = inp.value; });
        var rm = d.querySelector('button');
        if (rm) rm.addEventListener('click', function () { o.names.splice(i, 1); paint(); });
        box.appendChild(d);
      });
      var add = r.querySelector('.add-player');
      if (add) add.hidden = o.names.length >= o.max;
    };
    var add = r.querySelector('.add-player');
    if (add) add.addEventListener('click', function () { o.names.push(playerName(o.names.length + 1)); paint(); });
    paint();
    r.names = function () { return o.names.map(function (n, i) { return (n || '').trim() || playerName(i + 1); }); };
    return r;
  }

  // ---------------------------------------------------------------- play stage
  var wakeLock = null;
  function keepAwake(on) {
    try {
      if (on && 'wakeLock' in navigator && !wakeLock) navigator.wakeLock.request('screen').then(function (w) { wakeLock = w; }).catch(function () {});
      if (!on && wakeLock) { wakeLock.release(); wakeLock = null; }
    } catch (_) {}
  }
  // A full-screen stage with a top bar (back to settings, leave the game).
  function stage(o) {
    var el = document.createElement('div');
    el.className = 'stage' + (o.dark ? ' dark' : '');
    el.innerHTML = '<div class="topbar"><button type="button" class="b-back">' + ICON.back + '<span>' + esc(t('tripleStepBackToSettings')) + '</span></button>' +
      '<button type="button" class="b-exit" aria-label="' + esc(t('tripleStepBackToGames')) + '">' + ICON.close + '</button></div><div class="body center-col"></div>';
    document.body.appendChild(el);
    document.body.style.overflow = 'hidden';
    keepAwake(true);
    var api = {
      el: el,
      body: el.querySelector('.body'),
      close: function () { loopStop(); keepAwake(false); el.remove(); document.body.style.overflow = ''; var e = document.querySelector('.end'); if (e) e.remove(); },
      dark: function (on) { el.classList.toggle('dark', on); }
    };
    el.querySelector('.b-back').addEventListener('click', function () { if (o.onLeave) o.onLeave(); api.close(); });
    el.querySelector('.b-exit').addEventListener('click', function () { if (o.onLeave) o.onLeave(); location.href = '/games'; });
    return api;
  }

  // One animation loop at a time; calls fn(deltaMs).
  var raf = 0, last = 0, gen = 0;
  function loop(fn) {
    loopStop();
    var mine = ++gen;
    last = performance.now();
    var step = function (now) {
      var d = Math.min(now - last, 250);
      last = now;
      fn(d);
      // fn may have stopped this loop (or started another one).
      if (mine === gen) raf = requestAnimationFrame(step);
    };
    raf = requestAnimationFrame(step);
  }
  function loopStop() { gen++; cancelAnimationFrame(raf); raf = 0; }
  // Don't let a background tab eat the clock.
  document.addEventListener('visibilitychange', function () { last = performance.now(); });

  // "Ready?" screen with the topic, then Ready? Set. Go! (3 seconds).
  function ready(body, o, onGo) {
    body.innerHTML = '<div class="cue">' + esc(t('gamesCueReady')) + '</div>' +
      (o.topic != null ? '<div style="margin-top:22px"><div class="topic-label">' + esc(o.topicLabel || t('conductorTopic')) + '</div><div class="topic">' + esc(o.topic) + '</div></div>' : '') +
      (o.extra || '') +
      (o.hint ? '<p class="hint">' + esc(o.hint) + '</p>' : '') +
      '<button class="btn btn-primary ready-btn" type="button">' + esc(t('gamesImReady')) + '</button>';
    body.querySelector('.ready-btn').addEventListener('click', function () {
      var cue = body.querySelector('.cue');
      body.querySelector('.ready-btn').remove();
      var h = body.querySelector('.hint'); if (h) h.remove();
      var cues = [t('gamesCueReady'), t('gamesCueSet'), t('gamesCueGo')];
      var i = 0;
      cue.textContent = cues[0];
      var id = setInterval(function () {
        i++;
        if (i < 3) { cue.textContent = cues[i]; return; }
        clearInterval(id);
        onGo();
      }, 1000);
    });
  }

  function pie(fraction) {
    var c = 2 * Math.PI * 70;
    return '<div class="pie"><svg viewBox="0 0 160 160"><circle class="track" cx="80" cy="80" r="70"/><circle class="bar" cx="80" cy="80" r="70" stroke-dasharray="' + c.toFixed(1) +
      '" stroke-dashoffset="' + (c * (1 - Math.max(0, Math.min(1, fraction)))).toFixed(1) + '"/></svg></div>';
  }
  function setPie(el, fraction) {
    var bar = el.querySelector('.pie .bar');
    if (!bar) return;
    var c = 2 * Math.PI * 70;
    bar.setAttribute('stroke-dashoffset', (c * (1 - Math.max(0, Math.min(1, fraction)))).toFixed(1));
  }

  // Results card over the stage.
  function end(o) {
    var el = document.createElement('div');
    el.className = 'end';
    el.innerHTML = '<div class="card"><div class="party">🎉</div><h2>' + esc(o.title) + '</h2>' + (o.message ? '<p>' + esc(o.message) + '</p>' : '') + (o.extra || '') +
      '<button class="btn btn-primary" type="button">' + esc(o.primary) + '</button>' +
      '<div class="more">' + (o.onRetry ? '<button type="button" class="r">' + esc(o.retryLabel || t('tripleStepRetry')) + '</button>' : '') +
      '<button type="button" class="s">' + esc(t('tripleStepSettings')) + '</button></div></div>';
    document.body.appendChild(el);
    var close = function () { el.remove(); };
    el.querySelector('.btn-primary').addEventListener('click', function () { close(); o.onPrimary(); });
    var r = el.querySelector('.r'); if (r) r.addEventListener('click', function () { close(); o.onRetry(); });
    el.querySelector('.s').addEventListener('click', function () { close(); o.onSettings(); });
    return el;
  }

  // Loads what every game page needs, then checks sign-in.
  // lockedOpts go to S.gate for guests on a members' game.
  function boot(id, start, lockedOpts) {
    var main = document.getElementById('main');
    Promise.all([S.loadGames(), loadWords()]).then(function (res) {
      document.title = res[0][id].title + ' | Speak Up Fearless';
      S.gate(main, function () { start(res[0], res[1]); }, lockedOpts);
    });
  }

  window.G = {
    ICON: ICON, boot: boot, setup: setup, slider: slider, toggle: toggle, select: select, modeTabs: modeTabs, players: players,
    stage: stage, loop: loop, loopStop: loopStop, ready: ready, pie: pie, setPie: setPie, end: end,
    loadWords: loadWords, pickTopic: pickTopic, shuffle: shuffle, setName: setName, clock: clock, timerLabel: timerLabel, playerName: playerName
  };
})();
