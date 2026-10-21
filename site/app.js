// Shared code for the plain-HTML account and games pages: language, theme,
// who is signed in, the backend, the header, game info and "How to play".
// Exposes window.SUF for the page scripts.
(function () {
  'use strict';

  // The dev site (dev.speakunshaken.com, speakup-dev-fbb4b.web.app) has its
  // own Firebase project and backend, so test accounts never touch real ones.
  var IS_DEV = /^dev\.|^speakup-dev-fbb4b\./.test(location.hostname);
  var PROD_API = 'https://public-speaking-backend.vercel.app';
  var DEV_API = 'https://public-speaking-backend-git-dev-emad-altakis-projects.vercel.app';
  var API = IS_DEV ? DEV_API : PROD_API;

  // Dev site: a small badge so nobody mistakes it for the real site.
  if (IS_DEV) {
    var devTag = document.createElement('div');
    devTag.textContent = 'DEV';
    devTag.setAttribute('aria-hidden', 'true');
    devTag.style.cssText = 'position:fixed;z-index:9999;bottom:10px;left:10px;padding:3px 9px;border-radius:999px;background:#7A4E9A;color:#fff;font:800 11px/1.4 system-ui,sans-serif;letter-spacing:.08em;pointer-events:none;opacity:.9';
    (document.body || document.documentElement).appendChild(devTag);
  }
  var API_KEY = IS_DEV ? 'AIzaSyAb3AF_ECZ84HSQd0gdta9U93UF62K9Fdk' : 'AIzaSyD61GC3xaetEqOwPYhYltxMp-FAsFLX6Ow';
  var AUTH_KEY = 'firebase:authUser:' + API_KEY + ':[DEFAULT]';
  var root = document.documentElement;

  function store(key, value) {
    try {
      if (value === undefined) return localStorage.getItem(key);
      if (value === null) localStorage.removeItem(key); else localStorage.setItem(key, value);
    } catch (_) { return null; }
  }

  // ------------------------------------------------------------ language
  var lang = store('speakupfearless.language') === 'ar' ? 'ar' : 'en';
  root.lang = lang === 'ar' ? 'ar' : 'en-CA';
  root.dir = lang === 'ar' ? 'rtl' : 'ltr';
  var STRINGS = {
    en: {
      home: 'Back to the site', signIn: 'Sign in', account: 'Your account', light: 'Light theme', dark: 'Dark theme', langName: 'العربية', langShort: 'ع',
      howTo: 'How to play', next: 'Next', back: 'Back', letsPlay: "Let's play!", close: 'Close', stepOf: 'Step {n} of {t}', play: 'Play',
      gateTitle: 'Sign up to play', gateBody: 'Create a free account to unlock all our speaking games and keep track of your practice.',
      gateSignUp: 'Create free account', gateSignIn: 'I already have an account',
      dailyName: 'Daily Challenge', dailyTag: 'A new one-minute topic every day. Keep your streak going.',
      dailyCardTitle: "Today's 1-minute challenge", dailyCardDone: 'Done today. Come back tomorrow!', dailyCardGo: 'Take the challenge',
      joinKicker: 'Free to play', joinTitle: "You're one step away from playing", joinAll: 'Speaking games',
      joinBody: 'Make a free account to start {game}. It only takes a moment, and you can play right away.',
      joinBodyAll: 'Make a free account to play all our speaking games. It only takes a moment.',
      joinB1: 'All 4 speaking games, free forever', joinB2: 'Watch your progress and streaks grow', joinB3: 'Practice alone first, no audience needed',
      joinCta: 'Create my free account', joinHave: 'Already have an account?', joinSignIn: 'Sign in', joinFine: 'Takes 30 seconds. No card, no spam.',
      verifyTitle: 'Confirm your email to play', verifyBody: "We'll send a 6-digit code to {e}. It only takes a moment.", verifyCta: 'Send my code',
      minutes: '{n} min', round1: '1 round', rounds: '{n} rounds', seconds: '{n}s',
      guestBar: "Today's challenge is always free, and you can try each game once without an account. Make a free account to play them all as often as you like.", guestBarCta: 'Create free account',
      freeTry: '1 free try', endTryDone: 'That was your free try. Make a free account to keep playing all the games, and keep this round.', lockUsed: "That was your free try of {game}. Make a free account to keep playing, and keep the rounds you've played.",
      lockBadge: 'Free with an account', unlock: 'Unlock free', freeNow: 'Free, no sign-up',
      lockTitle: 'Unlock {game} for free', lockAll: 'One free account unlocks all of these',
      lockB1: 'Every game, free forever', lockB2: 'Your streak and progress saved on every device', lockB3: 'Takes 30 seconds, no card needed',
      freeNowTitle: "Try today's 1-minute challenge first", freeNowGo: 'Start', freeNowBody: 'Speak for one minute on a new topic and start your streak. No account needed.',
      moreTitle: '{n} more games are waiting for you', moreBody: 'Each one trains a different speaking skill. Make a free account to play them all.',
      moreLine: 'Your free account also unlocks {n} more speaking games',
      savedToast1: 'Welcome! Your guest round is now saved to your account.', savedToastN: 'Welcome! Your {n} guest rounds are now saved to your account.', savedToast2: 'Welcome! Your 2 guest rounds are now saved to your account.'
    },
    ar: {
      home: 'العودة إلى الموقع', signIn: 'تسجيل الدخول', account: 'حسابك', light: 'المظهر الفاتح', dark: 'المظهر الداكن', langName: 'English', langShort: 'EN',
      howTo: 'طريقة اللعب', next: 'التالي', back: 'رجوع', letsPlay: 'هيا نلعب!', close: 'إغلاق', stepOf: 'الخطوة {n} من {t}', play: 'العب',
      gateTitle: 'سجّل لتلعب', gateBody: 'أنشئ حسابًا مجانيًا لتفتح جميع ألعاب التحدث وتتابع تدريبك.',
      gateSignUp: 'أنشئ حسابًا مجانيًا', gateSignIn: 'لدي حساب بالفعل',
      dailyName: 'التحدي اليومي', dailyTag: 'موضوع جديد لدقيقة واحدة كل يوم. حافظ على سلسلتك.',
      dailyCardTitle: 'تحدي الدقيقة لليوم', dailyCardDone: 'أنجزته اليوم. عد غدًا!', dailyCardGo: 'خُض التحدي',
      joinKicker: 'مجانية', joinTitle: 'خطوة واحدة وتبدأ اللعب', joinAll: 'ألعاب التحدث',
      joinBody: 'أنشئ حسابًا مجانيًا لتبدأ {game}. يستغرق الأمر لحظة، وتلعب فورًا.',
      joinBodyAll: 'أنشئ حسابًا مجانيًا لتلعب جميع ألعاب التحدث. يستغرق الأمر لحظة.',
      joinB1: 'ألعاب التحدث الأربع، مجانًا للأبد', joinB2: 'شاهد تقدّمك وسلسلة أيامك تكبر', joinB3: 'تدرّب وحدك أولًا، بلا جمهور',
      joinCta: 'أنشئ حسابي المجاني', joinHave: 'لديك حساب؟', joinSignIn: 'سجّل الدخول', joinFine: 'يستغرق 30 ثانية. بلا بطاقة وبلا رسائل مزعجة.',
      verifyTitle: 'أكّد بريدك لتلعب', verifyBody: 'سنرسل رمزًا من 6 أرقام إلى {e}. لن يستغرق الأمر سوى لحظة.', verifyCta: 'أرسل الرمز',
      minutes: '{n} د', round1: 'جولة واحدة', rounds: '{n} جولات', seconds: '{n} ث',
      guestBar: 'تحدي اليوم مجاني دائمًا، ويمكنك تجربة كل لعبة مرة واحدة بلا حساب. أنشئ حسابًا مجانيًا لتلعبها كلها متى شئت.', guestBarCta: 'أنشئ حسابًا مجانيًا',
      freeTry: 'تجربة مجانية واحدة', endTryDone: 'كانت هذه تجربتك المجانية. أنشئ حسابًا مجانيًا لتواصل لعب كل الألعاب وتحتفظ بهذه الجولة.', lockUsed: 'كانت هذه تجربتك المجانية لـ {game}. أنشئ حسابًا مجانيًا لتواصل اللعب وتحتفظ بجولاتك.',
      lockBadge: 'مجانًا مع حساب', unlock: 'افتحها مجانًا', freeNow: 'مجاني، بلا تسجيل',
      lockTitle: 'افتح {game} مجانًا', lockAll: 'حساب مجاني واحد يفتح كل هذه الألعاب',
      lockB1: 'كل الألعاب، مجانًا للأبد', lockB2: 'سلسلتك وتقدّمك محفوظان على كل أجهزتك', lockB3: 'يستغرق 30 ثانية، بلا بطاقة',
      freeNowTitle: 'جرّب تحدي الدقيقة لليوم أولًا', freeNowGo: 'ابدأ', freeNowBody: 'تحدّث دقيقة عن موضوع جديد وابدأ سلسلتك. بلا حساب.',
      moreTitle: '{n} ألعاب أخرى بانتظارك', moreBody: 'كل لعبة تدرّب مهارة مختلفة في التحدث. أنشئ حسابًا مجانيًا لتلعبها كلها.',
      moreLine: 'حسابك المجاني يفتح لك أيضًا {n} ألعاب تحدّث أخرى',
      savedToast1: 'أهلًا بك! جولتك كضيف محفوظة الآن في حسابك.', savedToastN: 'أهلًا بك! جولاتك الـ{n} كضيف محفوظة الآن في حسابك.', savedToast2: 'أهلًا بك! جولتاك كضيف محفوظتان الآن في حسابك.'
    }
  };
  function t(key, vars) {
    var s = (STRINGS[lang] && STRINGS[lang][key]) || STRINGS.en[key] || key;
    if (vars) Object.keys(vars).forEach(function (k) { s = s.replace('{' + k + '}', vars[k]); });
    return s;
  }
  function addStrings(en, ar) {
    Object.assign(STRINGS.en, en);
    Object.assign(STRINGS.ar, ar);
  }
  function setLang(l) {
    store('speakupfearless.language', l);
    location.reload();
  }

  // ------------------------------------------------------------ theme
  function isDark() { return root.dataset.theme === 'dark'; }
  if (store('speakupfearless.theme') === 'dark') root.dataset.theme = 'dark';
  function toggleTheme() {
    if (isDark()) delete root.dataset.theme; else root.dataset.theme = 'dark';
    store('speakupfearless.theme', isDark() ? 'dark' : 'light');
    renderHeader();
  }

  // ------------------------------------------------------------ account
  function rawUser() {
    try { var r = store(AUTH_KEY); return r ? JSON.parse(r) : null; } catch (_) { return null; }
  }
  function user() {
    var u = rawUser();
    if (!u || !u.uid) return null;
    var name = (u.displayName || '').trim();
    var short = name ? name.split(' ')[0] : (u.email || '').split('@')[0];
    return {
      uid: u.uid, email: u.email || '', displayName: name, photoURL: u.photoURL || '',
      emailVerified: !!u.emailVerified,
      shortName: short ? short[0].toUpperCase() + short.slice(1) : '',
      initial: short ? short[0].toUpperCase() : '?'
    };
  }
  function signIn(returnTo, signUp) {
    location.href = '/login?next=' + encodeURIComponent(returnTo || location.pathname) + (signUp ? '&mode=signup' : '');
  }
  function signOut() {
    store(AUTH_KEY, null);
    try { sessionStorage.setItem('speakupfearless.signedOut', '1'); } catch (_) {}
    location.href = '/';
  }

  // A valid Firebase ID token (refreshed when needed), or null.
  function idToken() {
    var u = rawUser();
    var m = u && u.stsTokenManager;
    if (!m) return Promise.resolve(null);
    if (m.accessToken && (m.expirationTime || 0) - Date.now() > 60000) return Promise.resolve(m.accessToken);
    if (!m.refreshToken) return Promise.resolve(null);
    return fetch('https://securetoken.googleapis.com/v1/token?key=' + API_KEY, {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'grant_type=refresh_token&refresh_token=' + encodeURIComponent(m.refreshToken)
    }).then(function (r) { return r.ok ? r.json() : null; }).then(function (b) {
      if (!b || !b.id_token) return null;
      m.accessToken = b.id_token;
      m.refreshToken = b.refresh_token || m.refreshToken;
      m.expirationTime = Date.now() + (parseInt(b.expires_in, 10) || 3600) * 1000;
      store(AUTH_KEY, JSON.stringify(u));
      return b.id_token;
    }).catch(function () { return null; });
  }

  // Calls the backend; resolves {status, body} or null when it can't be reached.
  function api(path, opts) {
    opts = opts || {};
    return idToken().then(function (token) {
      if (!token) return null;
      var ctl = 'AbortController' in window ? new AbortController() : null;
      var timer = setTimeout(function () { if (ctl) ctl.abort(); }, opts.timeout || 10000);
      return fetch(API + path, {
        method: opts.method || 'GET',
        headers: { Authorization: 'Bearer ' + token, 'Content-Type': 'application/json' },
        body: opts.body ? JSON.stringify(opts.body) : undefined,
        signal: ctl ? ctl.signal : undefined
      }).then(function (r) {
        clearTimeout(timer);
        return r.json().catch(function () { return {}; }).then(function (b) { return { status: r.status, body: b }; });
      }).catch(function () { clearTimeout(timer); return null; });
    });
  }

  // Sends a FormData (a recording) to the backend; same result shape as api().
  // asGuest: without a sign-in, send this device's guest id instead (the
  // backend gives guests one free Speech Coach try).
  function upload(path, form, timeout, asGuest) {
    return idToken().then(function (token) {
      if (!token && !asGuest) return null;
      var ctl = 'AbortController' in window ? new AbortController() : null;
      var timer = setTimeout(function () { if (ctl) ctl.abort(); }, timeout || 90000);
      var headers = token ? { Authorization: 'Bearer ' + token } : { 'X-Guest-Id': guestId() };
      return fetch(API + path, { method: 'POST', headers: headers, body: form, signal: ctl ? ctl.signal : undefined })
        .then(function (r) {
          clearTimeout(timer);
          return r.json().catch(function () { return {}; }).then(function (b) { return { status: r.status, body: b }; });
        }).catch(function () { clearTimeout(timer); return null; });
    });
  }

  // ------------------------------------------------------------ profile photo
  function avatarKey() { var u = user(); return u ? 'speakupfearless.avatar.' + u.uid : null; }
  function cachedAvatar() { var k = avatarKey(); var v = k && store(k); return v || null; }
  var avatarListeners = [];
  function setAvatar(v) {
    var k = avatarKey();
    if (k) store(k, v || '');
    avatarListeners.forEach(function (f) { f(v); });
  }
  function onAvatar(f) { avatarListeners.push(f); }
  function refreshAvatar() {
    return api('/v1/me').then(function (r) {
      if (r && r.status === 200 && 'avatar' in r.body) setAvatar(r.body.avatar || null);
      return r;
    });
  }
  function saveAvatar(dataUrl) {
    setAvatar(dataUrl);
    return api('/v1/me', { method: 'PATCH', body: { avatar: dataUrl || '' }, timeout: 15000 })
      .then(function (r) { return !!r && r.status < 300; });
  }
  function avatarStyle(el, u, photo) {
    var src = photo || (u && u.photoURL) || '';
    el.textContent = src ? '' : (u ? u.initial : '?');
    el.style.backgroundImage = src ? 'url("' + src.replace(/"/g, '%22') + '")' : '';
  }

  // Lets the visitor pick a photo, crops it to a square and shrinks it on the
  // device. The file input stays on the page while picking (iPhone needs it).
  function pickPhoto(size) {
    size = size || 256;
    return new Promise(function (resolve) {
      var input = document.createElement('input');
      input.type = 'file';
      input.accept = 'image/*';
      input.style.display = 'none';
      document.body.appendChild(input);
      var done = function (v) { input.remove(); resolve(v); };
      input.addEventListener('cancel', function () { done(null); });
      input.addEventListener('change', function () {
        var file = input.files && input.files[0];
        if (!file) return done(null);
        var url = URL.createObjectURL(file);
        var img = new Image();
        img.onload = function () {
          var side = Math.min(img.naturalWidth, img.naturalHeight);
          var c = document.createElement('canvas');
          c.width = c.height = size;
          c.getContext('2d').drawImage(img, (img.naturalWidth - side) / 2, (img.naturalHeight - side) / 2, side, side, 0, 0, size, size);
          URL.revokeObjectURL(url);
          done(c.toDataURL('image/jpeg', 0.85));
        };
        img.onerror = function () { URL.revokeObjectURL(url); done(null); };
        img.src = url;
      });
      input.click();
    });
  }

  // ------------------------------------------------------------ email confirmed?
  // true / false; lets people through when it can't be checked.
  function checkVerified() {
    var u = user();
    if (!u) return Promise.resolve(false);
    if (u.emailVerified || store('speakupfearless.verifySkip.' + u.uid) === '1') return Promise.resolve(true);
    return api('/v1/me').then(function (r) {
      if (r && r.status === 200 && 'avatar' in r.body) setAvatar(r.body.avatar || null);
      return !(r && r.status === 200 && r.body.emailVerified === false);
    });
  }

  // ------------------------------------------------------------ game history
  var GUEST_HISTORY = 'speakupfearless.history.guest';
  function historyKey() { var u = user(); return u ? 'speakupfearless.history.' + u.uid : GUEST_HISTORY; }
  function readList(key) { try { return JSON.parse(store(key) || '[]') || []; } catch (_) { return []; } }
  function localHistory() {
    try { return JSON.parse(store(historyKey()) || '[]'); } catch (_) { return []; }
  }
  function recordRound(round, localOnly) {
    // round: {gameId, spokenSeconds, topic}. localOnly when the backend saves it itself.
    var entry = { gameId: round.gameId, playedAt: new Date().toISOString(), spokenSeconds: Math.round(round.spokenSeconds || 0) };
    if (round.topic) entry.topic = round.topic;
    var all = [entry].concat(localHistory()).slice(0, 200);
    store(historyKey(), JSON.stringify(all));
    if (localOnly) return Promise.resolve(null);
    var body = { gameId: entry.gameId, durationSeconds: entry.spokenSeconds };
    if (entry.topic) body.details = { topic: entry.topic };
    return api('/v1/games/sessions', { method: 'POST', body: body });
  }
  // This device's rounds merged with the ones saved on the backend.
  function history() {
    var local = localHistory();
    return api('/v1/games/sessions?limit=200').then(function (r) {
      var remote = (r && r.status === 200 && r.body.sessions) || [];
      var same = function (a, b) {
        return a.gameId === b.gameId && Math.abs(a.spokenSeconds - b.spokenSeconds) <= 1 &&
          Math.abs(new Date(a.playedAt) - new Date(b.playedAt)) <= 120000;
      };
      remote.forEach(function (s) {
        // Rounds played as a guest keep the time they were really played.
        var item = { gameId: s.gameId, playedAt: (s.details && s.details.playedAt) || s.playedAt, spokenSeconds: s.durationSeconds, topic: s.details && s.details.topic };
        if (!local.some(function (l) { return same(l, item); })) local.push(item);
      });
      return local.sort(function (a, b) { return new Date(b.playedAt) - new Date(a.playedAt); });
    });
  }

  // ------------------------------------------------------------ games
  var GAMES = null;
  var ORDER = ['speech-coach', 'triple-step', 'conductor', 'podcast', 'autocomplete'];
  var ICONS = {
    'triple-step': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><rect x="9" y="3" width="6" height="11" rx="3"/><path d="M5 11a7 7 0 0 0 14 0M12 18v3"/></svg>',
    conductor: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M3 12h1M7 8v8M11 4v16M15 7v10M19 10v4"/></svg>',
    podcast: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="11" r="2.5"/><path d="M12 13.5V21M7.8 15.2a6 6 0 1 1 8.4 0M5 18a10 10 0 1 1 14 0"/></svg>',
    autocomplete: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M13 2 4.5 13.5H11L10 22l8.5-11.5H12z"/></svg>',
    daily: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12.5 2s1 3.3-1.5 6C9.1 10 7 11.6 7 14.8A5 5 0 0 0 12 20a5 5 0 0 0 5-5c0-1.8-.7-3.2-1.5-4.2 0 0-.1 1.9-1.8 2.4 0 0 1-4.8-1.2-11.2z"/></svg>',
    'speech-coach': '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="5" y="2.5" width="6" height="10" rx="3"/><path d="M2.5 9.5a5.5 5.5 0 0 0 11 0M8 15v3.5"/><path d="M15 14l2 2 4.5-4.5"/><path d="M16.5 5.5h4M16.5 9h3"/></svg>'
  };
  // Pictures for each "How to play" step.
  var STEP_ICONS = {
    topic: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M4 4h12v9H8l-4 3z"/><path d="M8 17h8l4 3V9"/></svg>',
    tune: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M4 6h10M18 6h2M4 12h4M12 12h8M4 18h12M20 18h0"/><circle cx="16" cy="6" r="2"/><circle cx="10" cy="12" r="2"/><circle cx="18" cy="18" r="2"/></svg>',
    bolt: ICONS.autocomplete,
    flag: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 21V4M5 4h11l-2 4 2 4H5"/></svg>',
    group: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 12.75c1.63 0 3.07.39 4.24.9A3 3 0 0 1 18 16.4V18H6v-1.6c0-1.2.7-2.25 1.76-2.73 1.17-.52 2.61-.92 4.24-.92zM12 6a3 3 0 1 1 0 6 3 3 0 0 1 0-6z"/></svg>',
    mic: ICONS['triple-step'],
    shuffle: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M16 3h5v5M4 20 21 3M21 16v5h-5M15 15l6 6M4 4l5 5"/></svg>',
    text: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M4 8h16M4 12h10M4 16h6"/></svg>',
    timer: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="13" r="8"/><path d="M12 9v4l2 2M9 2h6"/></svg>',
    next: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M6 6v12l8.5-6zM16 6h2v12h-2z"/></svg>'
  };
  var STEP_PICS = {
    'triple-step': ['tune', 'topic', 'bolt', 'flag'],
    conductor: ['topic', 'demo', 'demo', 'demo'],
    podcast: ['group', 'topic', 'mic', 'shuffle'],
    autocomplete: ['text', 'mic', 'timer', 'next'],
    daily: ['topic', 'timer', 'mic', 'flag'],
    'speech-coach': ['topic', 'mic', 'tune', 'flag']
  };
  // Speech Coach isn't one of the app's games, so its wording lives here.
  var COACH = {
    en: { title: 'Speech Coach', tagline: 'Talk for up to a minute and get scored on how you sound.',
      description: 'Record yourself on a topic. AI listens back and scores your pace, pauses, filler words, clarity and flow from 1 to 10, then shows the exact moments to work on.',
      skills: ['AI feedback', 'Pace', 'Filler words', 'Flow'],
      steps: ['Pick a topic, or bring your own, and talk for 30 seconds to a minute.', 'Allow the microphone, then talk until the time is up or you tap Finish.',
        'AI listens back and scores your pace, pauses, filler words, clarity and flow from 1 to 10.', 'See the exact moments you slipped, with a fix for each, and try again.'],
      tip: 'Your recording is only used to score you. We keep the scores and the transcript, not the audio.' },
    ar: { title: 'مدرب الإلقاء', tagline: 'تحدث حتى دقيقة واحصل على تقييم لطريقة كلامك.',
      description: 'سجّل نفسك وأنت تتحدث عن موضوع. يستمع الذكاء الاصطناعي ويقيّم سرعتك ووقفاتك وكلمات الحشو والوضوح وترابط الأفكار من 1 إلى 10، ثم يريك اللحظات التي تحتاج إلى تحسين.',
      skills: ['تقييم بالذكاء الاصطناعي', 'السرعة', 'كلمات الحشو', 'الترابط'],
      steps: ['اختر موضوعًا أو موضوعك الخاص، وتحدث من 30 ثانية إلى دقيقة.', 'اسمح باستخدام الميكروفون، ثم تحدث حتى ينتهي الوقت أو تضغط إنهاء.',
        'يستمع الذكاء الاصطناعي ويقيّم سرعتك ووقفاتك وكلمات الحشو والوضوح والترابط من 1 إلى 10.', 'شاهد اللحظات التي تعثرت فيها مع طريقة لتحسين كل منها، ثم حاول مرة أخرى.'],
      tip: 'نستخدم تسجيلك لتقييمك فقط. نحتفظ بالدرجات والنص المكتوب، وليس بالصوت.' }
  };
  // What each members' game helps with, for people who haven't joined yet.
  var PITCH = {
    en: {
      'speech-coach': 'AI shows you exactly where you said "um", rushed or lost the thread, and how to fix it.',
      'triple-step': 'Stay calm and keep talking when something throws you off mid-sentence.',
      conductor: 'Find a voice with energy that makes people want to listen.',
      podcast: 'Answer any question on the spot, without freezing up.',
      autocomplete: 'Think on your feet so you never run out of words.'
    },
    ar: {
      'speech-coach': 'يريك الذكاء الاصطناعي أين قلت «اممم» أو أسرعت أو فقدت الفكرة، وكيف تصلح ذلك.',
      'triple-step': 'ابقَ هادئًا وتابع الكلام عندما يشتّتك شيء في منتصف الجملة.',
      conductor: 'اكتشف صوتًا مليئًا بالحيوية يجعل الناس يرغبون في الاستماع.',
      podcast: 'أجب عن أي سؤال فورًا، دون أن تتجمد.',
      autocomplete: 'فكّر بسرعة حتى لا تنفد كلماتك أبدًا.'
    }
  };
  function pitch(id) { return (PITCH[lang] || PITCH.en)[id] || ''; }
  // Without an account the daily challenge is always open, and every other
  // game can be played once on this device; after that it asks them to sign
  // up. Speech Coach waits for the backend to score guests (GUEST_TRY).
  var FREE_GAME = 'daily';
  // Guest scoring is on the dev backend first; main follows once it's live there.
  var GUEST_TRY = { 'speech-coach': IS_DEV };
  function triedAsGuest(id) { return readList(GUEST_HISTORY).some(function (r) { return r.gameId === id; }); }
  function locked(id) {
    if (user() || !id || id === FREE_GAME) return false;
    return GUEST_TRY[id] === false || triedAsGuest(id);
  }
  // A guest who still has their one free try of this game.
  function freeTry(id) { return !user() && !!id && id !== FREE_GAME && !locked(id); }

  function loadGames() {
    if (GAMES) return Promise.resolve(GAMES);
    return fetch('/data/games.json').then(function (r) { return r.json(); }).then(function (d) {
      GAMES = d[lang] || d.en;
      GAMES['speech-coach'] = COACH[lang] || COACH.en;
      // Game wording shared with the app ("9999" and "@@" mark where values go).
      var fix = function (o) {
        var out = {};
        Object.keys(o).forEach(function (k) { out[k] = typeof o[k] === 'string' ? o[k].replace('9999', '{n}').replace('@@', '{n}') : o[k]; });
        return out;
      };
      if (d.strings) addStrings(fix(d.strings.en), fix(d.strings.ar));
      return GAMES;
    });
  }

  // ------------------------------------------------------------ How to play
  function esc(s) { var d = document.createElement('div'); d.textContent = s == null ? '' : s; return d.innerHTML; }
  var howOpen = false;
  // lastLabel: the last button's wording ("Let's play!" by default).
  function howToPlay(id, onPlay, lastLabel) {
    // Seen once, from anywhere: the game page won't open it again by itself.
    store('speakupfearless.howto.' + id, '1');
    if (howOpen) return Promise.resolve();
    howOpen = true;
    return loadGames().then(function (games) {
      var g = games[id];
      var pics = STEP_PICS[id] || [];
      var n = g.steps.length;
      var wrap = document.createElement('div');
      wrap.className = 'modal';
      wrap.innerHTML = '<div class="howto" role="dialog" aria-modal="true" aria-label="' + esc(t('howTo')) + '">' +
        '<div class="howto-head"><div><small>' + esc(t('howTo')) + '</small><h3>' + esc(g.title) + '</h3></div>' +
        '<button class="x" type="button" aria-label="' + esc(t('close')) + '"><svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round"><path d="M6 6l12 12M18 6 6 18"/></svg></button></div>' +
        '<div class="slides">' + g.steps.map(function (s, i) {
          var pic = pics[i] === 'demo'
            ? '<div class="demo"><b>2</b><span class="bars">' + Array.apply(null, Array(10)).map(function (_, k) { return '<i style="height:' + (14 + k * 6) + 'px"></i>'; }).join('') + '</span></div>'
            : '<span class="bubble">' + (STEP_ICONS[pics[i]] || ICONS[id]) + '</span>';
          return '<div class="slide"><div class="pic"><span class="badge">' + esc(t('stepOf', { n: i + 1, t: n })) + '</span>' + pic + '</div><p>' + esc(s) + '</p></div>';
        }).join('') + '</div>' +
        (g.tip ? '<div class="tip" hidden>💡 ' + esc(g.tip) + '</div>' : '') +
        '<div class="howto-foot"><span class="dots">' + g.steps.map(function () { return '<i></i>'; }).join('') + '</span>' +
        '<button class="back" type="button" hidden>' + esc(t('back')) + '</button>' +
        '<button class="btn btn-primary go" type="button">' + esc(t('next')) + '</button></div></div>';
      document.body.appendChild(wrap);
      document.body.style.overflow = 'hidden';
      var slides = wrap.querySelector('.slides');
      var page = 0;
      var close = function () { clearInterval(demoTimer); wrap.remove(); document.body.style.overflow = ''; howOpen = false; };
      var go = function (i) { slides.scrollTo({ left: slides.clientWidth * i * (root.dir === 'rtl' ? -1 : 1), behavior: 'smooth' }); };
      var render = function () {
        wrap.querySelectorAll('.dots i').forEach(function (d, i) { d.classList.toggle('on', i === page); });
        wrap.querySelector('.back').hidden = page === 0;
        var last = page === n - 1;
        wrap.querySelector('.go').textContent = last ? (lastLabel || t('letsPlay')) : t('next');
        var tip = wrap.querySelector('.tip');
        if (tip) tip.hidden = !last;
      };
      slides.addEventListener('scroll', function () {
        var p = Math.round(Math.abs(slides.scrollLeft) / slides.clientWidth);
        if (p !== page) { page = p; render(); }
      }, { passive: true });
      wrap.querySelector('.go').addEventListener('click', function () {
        if (page === n - 1) { close(); if (onPlay) onPlay(); } else { page++; go(page); render(); }
      });
      wrap.querySelector('.back').addEventListener('click', function () { page--; go(page); render(); });
      wrap.querySelector('.x').addEventListener('click', close);
      wrap.addEventListener('click', function (e) { if (e.target === wrap) close(); });
      document.addEventListener('keydown', function esc(e) { if (e.key === 'Escape') { close(); document.removeEventListener('keydown', esc); } });
      // The Conductor's pitch demo: the number changes and the bars follow.
      var levels = [2, 8, 5, 10, 1, 7], li = 0;
      var demoTimer = setInterval(function () {
        li = (li + 1) % levels.length;
        wrap.querySelectorAll('.demo').forEach(function (d) {
          d.querySelector('b').textContent = levels[li];
          d.querySelectorAll('.bars i').forEach(function (bar, k) { bar.classList.toggle('on', k < levels[li]); });
        });
      }, 1300);
      wrap.querySelectorAll('.demo .bars i').forEach(function (bar, k) { bar.classList.toggle('on', k < 2); });
      render();
    });
  }
  // Opens "How to play" by itself the first time someone opens a game.
  function howToPlayFirstTime(id, onPlay) {
    var key = 'speakupfearless.howto.' + id;
    if (store(key)) return;
    store(key, '1');
    howToPlay(id, onPlay);
  }

  // ------------------------------------------------------------ header
  var LOGO = '<svg viewBox="0 0 100 100" aria-hidden="true"><rect x="8" y="8" width="84" height="64" rx="22" fill="#B4583A"/><path d="M28 68 L22 92 L48 68 Z" fill="#B4583A"/><path d="M38 48 L50 28 L62 48 M50 28 L50 56" fill="none" stroke="#FFF8F1" stroke-width="10" stroke-linecap="round" stroke-linejoin="round"/></svg>';
  var SVG = {
    user: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="10"/><circle cx="12" cy="10" r="3.2"/><path d="M6.2 18.4c1.4-1.9 3.4-2.9 5.8-2.9s4.4 1 5.8 2.9"/></svg>',
    moon: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 14.5A8 8 0 1 1 9.5 4a6.5 6.5 0 0 0 10.5 10.5z"/></svg>',
    sun: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round"><circle cx="12" cy="12" r="4.5"/><path d="M12 2v2M12 20v2M4.9 4.9l1.4 1.4M17.7 17.7l1.4 1.4M2 12h2M20 12h2M4.9 19.1l1.4-1.4M17.7 6.3l1.4-1.4"/></svg>',
    home: '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M3 10.5 12 3l9 7.5"/><path d="M5 9.5V20a1 1 0 0 0 1 1h4v-6h4v6h4a1 1 0 0 0 1-1V9.5"/></svg>',
    lang: '<svg viewBox="0 0 24 24" fill="currentColor"><path d="m12.87 15.07-2.54-2.51.03-.03A17.5 17.5 0 0 0 14.07 6H17V4h-7V2H8v2H1v2h11.17C11.5 7.92 10.44 9.75 9 11.35 8.07 10.32 7.3 9.19 6.69 8h-2c.73 1.63 1.73 3.17 2.98 4.56l-5.09 5.02L4 19l5-5 3.11 3.11zM18.5 10h-2L12 22h2l1.12-3h4.75L21 22h2zm-2.62 7 1.62-4.33L19.12 17z"/></svg>'
  };
  function renderHeader() {
    var h = document.querySelector('.app-header');
    if (!h) {
      h = document.createElement('header');
      h.className = 'app-header';
      document.body.insertBefore(h, document.body.firstChild);
    }
    var u = user();
    var here = location.pathname.replace(/\/$/, '');
    h.innerHTML = '<div class="bar"><a class="brand" href="/" aria-label="speakUnshaken">' + LOGO + '<span dir="ltr">speakUnshaken</span></a>' +
      (u ? '<a class="hbtn acct" href="/account" aria-label="' + esc(t('account')) + '"' + (here === '/account' ? ' aria-current="page"' : '') + '><span class="av"></span></a>'
         : '<a class="hbtn acct" href="/login?next=' + encodeURIComponent(location.pathname) + '">' + SVG.user + '<span class="label">' + esc(t('signIn')) + '</span></a>') +
      '<button class="hbtn lang" type="button" aria-label="' + esc(t('langName')) + '">' + SVG.lang + '<span>' + esc(t('langShort')) + '</span></button>' +
      '<button class="hbtn theme" type="button" aria-label="' + esc(isDark() ? t('light') : t('dark')) + '">' + (isDark() ? SVG.sun : SVG.moon) + '</button>' +
      '<a class="hbtn" href="/" aria-label="' + esc(t('home')) + '" title="' + esc(t('home')) + '">' + SVG.home + '</a></div>';
    var av = h.querySelector('.av');
    if (av) avatarStyle(av, u, cachedAvatar());
    h.querySelector('.theme').addEventListener('click', toggleTheme);
    h.querySelector('.lang').addEventListener('click', function () { setLang(lang === 'ar' ? 'en' : 'ar'); });
    // Tapping the page you're already on does nothing.
    var acct = h.querySelector('.acct');
    if (here === '/account' && u) acct.addEventListener('click', function (e) { e.preventDefault(); });
  }
  onAvatar(function (v) {
    var av = document.querySelector('.app-header .av');
    if (av) avatarStyle(av, user(), v);
  });

  // ------------------------------------------------------------ toast
  function toast(msg) {
    var el = document.querySelector('.toast');
    if (!el) { el = document.createElement('div'); el.className = 'toast'; el.setAttribute('role', 'status'); document.body.appendChild(el); }
    el.textContent = msg;
    requestAnimationFrame(function () { el.classList.add('show'); });
    clearTimeout(el._t);
    el._t = setTimeout(function () { el.classList.remove('show'); }, 3200);
  }

  // ------------------------------------------------------------ members only
  var LOCK = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="11" width="16" height="10" rx="3"/><path d="M8 11V8a4 4 0 0 1 7.8-1.3"/><circle cx="12" cy="16" r="1.2" fill="currentColor"/></svg>';
  var MAIL = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="5" width="18" height="14" rx="3"/><path d="m4 7 8 6 8-6"/></svg>';
  var TROPHY = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M8 21h8M12 17v4M7 4h10v5a5 5 0 0 1-10 0z"/><path d="M17 5h3v2a3 3 0 0 1-3 3M7 5H4v2a3 3 0 0 0 3 3"/></svg>';
  var HEART = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20s-7-4.4-7-10a4 4 0 0 1 7-2.6A4 4 0 0 1 19 10c0 5.6-7 10-7 10z"/></svg>';
  // ------------------------------------------------------------ guests
  // People can play before they have an account. Their rounds stay on this
  // device under "guest" and move into the account when they sign up or in.
  function guestId() {
    var g = store('speakupfearless.guestId');
    if (!g) { g = 'guest-' + Math.random().toString(36).slice(2, 10) + Date.now().toString(36); store('speakupfearless.guestId', g); }
    return g;
  }
  function signUpHref() { return '/login?mode=signup&next=' + encodeURIComponent(location.pathname); }
  // Moves this device's guest rounds into the signed-in account, then sends
  // them to the backend (kept in a queue until each one is saved).
  function adoptGuest() {
    var u = user();
    if (!u) return;
    var pendingKey = 'speakupfearless.guestPending.' + u.uid;
    var guest = readList(GUEST_HISTORY);
    if (guest.length) {
      var mine = guest.concat(localHistory()).sort(function (a, b) { return new Date(b.playedAt) - new Date(a.playedAt); });
      store(historyKey(), JSON.stringify(mine.slice(0, 200)));
      var send = guest.filter(function (r) { return r.gameId !== 'speech-coach'; });
      store(pendingKey, JSON.stringify(readList(pendingKey).concat(send).slice(0, 200)));
      store(GUEST_HISTORY, null);
      // Today's daily topic stays the same after signing up.
      var gid = store('speakupfearless.guestId');
      var topic = gid && store('speakupfearless.dailyTopic.' + gid);
      if (topic && !store('speakupfearless.dailyTopic.' + u.uid)) store('speakupfearless.dailyTopic.' + u.uid, topic);
      var n = guest.length;
      var say = function () { setTimeout(function () { toast(n === 1 ? t('savedToast1') : n === 2 ? t('savedToast2') : t('savedToastN', { n: n })); }, 400); };
      if (document.readyState === 'loading') document.addEventListener('DOMContentLoaded', say); else say();
    }
    var queue = readList(pendingKey);
    var next = function () {
      var r = queue[0];
      if (!r) return;
      var details = { playedAt: r.playedAt, guest: true };
      if (r.topic) details.topic = r.topic;
      api('/v1/games/sessions', { method: 'POST', body: { gameId: r.gameId, durationSeconds: r.spokenSeconds || 0, details: details } }).then(function (res) {
        // Try again next visit if the backend can't be reached; drop rounds it refuses.
        if (!res || res.status >= 500) return;
        queue.shift();
        store(pendingKey, queue.length ? JSON.stringify(queue) : null);
        next();
      });
    };
    next();
  }
  // A slim strip for pages guests browse (the games list).
  function guestBar() {
    if (user()) return '';
    return '<div class="guest-bar"><span>' + esc(t('guestBar', { n: ORDER.length })) + '</span><a class="btn btn-primary" href="' + signUpHref() + '">' + esc(t('guestBarCta')) + '</a></div>';
  }

  // The members' games as rows (icon, name, what it helps with), each one
  // opening its game page. except: a game id to leave out.
  function lockedList(games, except) {
    return '<ul class="lock-list">' + ORDER.filter(function (id) { return id !== except; }).map(function (id) {
      return '<li><a href="/games/' + id + '"><span class="lock-ic g-' + id + '">' + ICONS[id] + '</span>' +
        '<span class="lock-txt"><b>' + esc(games[id].title) + '</b><small>' + esc(pitch(id)) + '</small></span>' +
        (freeTry(id) ? '<span class="try-pad">' + esc(t('freeTry')) + '</span>' : '<span class="lock-pad" aria-label="' + esc(t('lockBadge')) + '">' + LOCK + '</span>') + '</a></li>';
    }).join('') + '</ul>';
  }
  // A guest on a members' game: what this game does for them, every other
  // game they'd unlock, and today's free challenge as the way to try first.
  // o.extra: HTML under the main button.
  function lockedCard(el, o) {
    o = o || {};
    var here = location.pathname;
    var id = (here.match(/^\/games\/([\w-]+)/) || [])[1];
    return loadGames().then(function (games) {
      var g = games[id];
      var tick = function (icon, key) { return '<li><span class="tick">' + icon + '</span><span>' + esc(t(key)) + '</span></li>'; };
      // The game they came for comes first; the free daily challenge (no
      // account needed) is offered at the end.
      el.innerHTML = '<div class="locked">' +
        '<div class="join join-inline">' +
        '<div class="join-top g-' + id + '"><span class="join-badge">' + LOCK + esc(t('lockBadge')) + '</span>' +
        '<div class="join-game"><span class="join-ic">' + ICONS[id] + '</span><span><b>' + esc(g.title) + '</b><small>' + esc(g.tagline || '') + '</small></span></div>' +
        '<p class="join-pitch">' + esc(pitch(id)) + '</p>' +
        (g.skills ? '<ul class="join-skills">' + g.skills.map(function (k) { return '<li>' + esc(k) + '</li>'; }).join('') + '</ul>' : '') + '</div>' +
        '<div class="join-body">' + (triedAsGuest(id) ? '<p class="lock-used">' + esc(t('lockUsed', { game: g.title })) + '</p>' : '') +
        '<h3>' + esc(t('lockTitle', { game: g.title })) + '</h3>' +
        '<ul class="join-list">' + tick(ICONS['triple-step'], 'lockB1') + tick(TROPHY, 'lockB2') + tick(HEART, 'lockB3') + '</ul>' +
        '<a class="btn btn-primary join-cta" href="' + signUpHref() + '">' + esc(t('joinCta')) + '</a>' + (o.extra || '') +
        '<p class="join-alt">' + esc(t('joinHave')) + ' <a href="/login?next=' + encodeURIComponent(here) + '">' + esc(t('joinSignIn')) + '</a></p></div></div>' +
        '<section class="card lock-more"><h3>' + esc(t('lockAll')) + '</h3>' + lockedList(games, id) + '</section>' +
        '<a class="free-now g-daily" href="/games/daily"><span class="g-ic">' + ICONS.daily + '</span><span class="txt"><small>' + esc(t('freeNow')) + '</small>' +
        '<b>' + esc(t('freeNowTitle')) + '</b><span>' + esc(t('freeNowBody')) + '</span></span><span class="go">' + esc(t('freeNowGo')) + ' →</span></a>' +
        '</div>';
      return games;
    });
  }
  // Guests play the free game straight away and see what a members' game
  // offers on the others (opts.onLocked runs after that card, opts.extra goes
  // in it). A signed-in player whose email isn't confirmed yet sees a
  // "confirm your email" card instead.
  function gate(el, onAllowed, opts) {
    opts = opts || {};
    var u = user();
    var here = location.pathname;
    if (!u) {
      if (!locked((here.match(/^\/games\/([\w-]+)/) || [])[1])) return Promise.resolve(onAllowed());
      return lockedCard(el, opts).then(function (games) { if (opts.onLocked) opts.onLocked(games); });
    }
    return checkVerified().then(function (ok) {
      if (ok) return onAllowed();
      el.innerHTML = '<div class="card center"><div class="ic round">' + MAIL + '</div>' +
        '<h2>' + esc(t('verifyTitle')) + '</h2><p class="lead" style="margin:8px auto 0">' + esc(t('verifyBody', { e: u.email })) + '</p>' +
        '<div class="btn-row" style="margin-top:20px"><a class="btn btn-primary" href="/login?verify=1&next=' + encodeURIComponent(here) + '">' + esc(t('verifyCta')) + '</a></div></div>';
    });
  }

  // Once per visit, tell the account which time zone this device is in, so
  // streak reminders arrive in the player's own evening.
  (function () {
    if (!user()) return;
    try { if (sessionStorage.getItem('speakupfearless.tzSent')) return; sessionStorage.setItem('speakupfearless.tzSent', '1'); } catch (_) {}
    var tz = '';
    try { tz = Intl.DateTimeFormat().resolvedOptions().timeZone || ''; } catch (_) {}
    if (tz) api('/v1/me', { method: 'PATCH', body: { timeZone: tz } });
  })();

  adoptGuest();

  window.SUF = {
    gate: gate, freeTry: freeTry, guestId: guestId, guestBar: guestBar, signUpHref: signUpHref, locked: locked, lockedList: lockedList, pitch: pitch, LOCK: LOCK,
    lang: lang, t: t, addStrings: addStrings, esc: esc, store: store,
    user: user, signIn: signIn, signOut: signOut, api: api, upload: upload, idToken: idToken,
    cachedAvatar: cachedAvatar, refreshAvatar: refreshAvatar, saveAvatar: saveAvatar, onAvatar: onAvatar, avatarStyle: avatarStyle, pickPhoto: pickPhoto,
    setLang: setLang, checkVerified: checkVerified, recordRound: recordRound, history: history,
    loadGames: loadGames, ORDER: ORDER, ICONS: ICONS, howToPlay: howToPlay, howToPlayFirstTime: howToPlayFirstTime,
    renderHeader: renderHeader, toast: toast, localHistory: localHistory
  };
  document.addEventListener('DOMContentLoaded', renderHeader);
})();
