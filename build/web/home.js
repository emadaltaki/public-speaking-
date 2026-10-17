// Speak Up Fearless home page: language, theme, account link, menu, photo
// viewer and the booking form. Plain JavaScript so the page stays light.
(function () {
  'use strict';

  var LANG_KEY = 'speakupfearless.language';
  var THEME_KEY = 'speakupfearless.theme';
  var AUTH_KEY = 'firebase:authUser:AIzaSyD61GC3xaetEqOwPYhYltxMp-FAsFLX6Ow:[DEFAULT]';
  var BOOKING_ENDPOINT = 'https://formsubmit.co/ajax/speakupunshaken@gmail.com';
  // Our own backend keeps a copy of each request; the email above stays the
  // way requests reach the inbox.
  var API_BASE = 'https://public-speaking-backend.vercel.app';
  var CONTACT_EMAIL = 'speakupfearless@gmail.com';
  var root = document.documentElement;
  var $ = function (id) { return document.getElementById(id); };
  var all = function (sel) { return Array.prototype.slice.call(document.querySelectorAll(sel)); };

  function store(key, value) {
    try {
      if (value === undefined) return localStorage.getItem(key);
      localStorage.setItem(key, value);
    } catch (_) { return null; }
  }

  // ---------------------------------------------------------------- copy
  var EXTRA_EN = {
    langLong: 'العربية', langShort: 'ع', signIn: 'Sign in', account: 'Your account',
    themeDark: 'Dark theme', themeLight: 'Light theme', openMenu: 'Open menu', closeMenu: 'Close menu',
    close: 'Close', prev: 'Previous photo', next: 'Next photo',
    morningFull: 'Morning (9am–12pm)', afternoonFull: 'Afternoon (12–5pm)', eveningFull: 'Evening (5–9pm)',
    sending: 'Sending…', subject: 'Free intro call request',
    planSingle: "I'm interested in a single session.",
    planFour: "I'm interested in the 4-session package.",
    planEight: "I'm interested in the 8-session package.",
    weekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    privacyBody: 'Speak Up Fearless respects your privacy.\n\n' +
      'What we collect: this website does not store anything you type. When you request a time through the booking form, your name, email or phone, reason and preferred time are sent to us by email through FormSubmit (formsubmit.co), a form-forwarding service. If you email or call us, we receive your name, contact details, and whatever you choose to share.\n\n' +
      'How we use it: only to reply to you, arrange sessions, and keep in touch about sessions you have asked about. We never sell or rent your information.\n\n' +
      'Website statistics: we may use privacy-friendly, cookie-free analytics that count visits without identifying you.\n\n' +
      'Your choices: you can ask us at any time to see, correct, or delete the information we hold about you by emailing speakupfearless@gmail.com.\n\n' +
      "We follow Canada's Personal Information Protection and Electronic Documents Act (PIPEDA)."
  };

  var AR = {
    skip: 'انتقل إلى المحتوى', navWhy: 'لماذا نفعل هذا', navSessions: 'الجلسات', navCommunity: 'مجتمعنا',
    navGames: 'الألعاب', navFaq: 'الأسئلة الشائعة', navContact: 'تواصل معنا', navHome: 'الرئيسية',
    langLong: 'English', langShort: 'EN', signIn: 'تسجيل الدخول', account: 'حسابك',
    themeDark: 'المظهر الداكن', themeLight: 'المظهر الفاتح', openMenu: 'افتح القائمة', closeMenu: 'أغلق القائمة',
    joinUs: 'احجز مكالمة', ctaBook: 'احجز جلسة تعريفية مجانية', ctaLearn: 'تعرّف على جلساتنا',
    heroLocation: 'نلتقي الآن في ميسيساغا، أونتاريو',
    heroHeadline: 'لست بحاجة لأن تكون بلا خوف لكي تتحدث.',
    heroSupport: 'القلق من التحدث أمام الناس أمر طبيعي. تدرّب مع مجموعة داعمة في ميسيساغا وابنِ ثقة حقيقية، خطوة بخطوة.',
    heroTrust: 'مساحة داعمة للتدرّب. بلا أحكام. بلا ضغط. تقدّم فقط.',
    heroImageAlt: 'مضيف يقود ورشة Speak Up Fearless أمام مجموعة صغيرة',
    badgeTitle: 'الجميع يشارك', badgeBody: 'الأخطاء جزء من التعلّم.',
    eyebrowWhy: 'لست وحدك', anxietyHeadline: 'إن كان التحدث يوترك، فأنت لست وحدك.',
    feel1: '«قلبي يبدأ بالخفقان بسرعة.»', feel2: '«أفكّر كثيرًا في كل ما أريد قوله.»',
    feel3: '«أخاف أن يحكم عليّ الناس.»', feel4: '«أعرف ما أريد قوله، لكنني أتجمّد.»',
    anxietyHuman: 'هذه المشاعر لا تعني أنك سيئ في التحدث، بل تعني أنك إنسان.',
    eyebrowSessions: 'ماذا نتدرّب', sessionsHeadline: 'تدرّب بلا ضغط.',
    sessionsIntro: 'مكان منتظم للتدرّب على التحدث. مجتمع ومهارات، وليس علاجًا سريريًا.',
    how1: 'احضر', how2: 'تحدّث', how3: 'تأمّل', how4: 'انمُ',
    p1t: 'التدرّب على التحدث', p1b: 'تدرّب على التعبير عن أفكارك بوضوح وثقة.',
    p2t: 'الحديث الارتجالي', p2b: 'تعلّم كيف تفكر وتجيب عندما تُفاجأ بسؤال.',
    p3t: 'سرد القصص', p3b: 'تعلّم كيف تحوّل تجاربك وأفكارك إلى قصص مشوّقة.',
    p4t: 'الملاحظات والتطوّر', p4b: 'احصل على ملاحظات بنّاءة في بيئة داعمة.',
    p5t: 'تحدّيات الثقة', p5b: 'تحدّيات صغيرة مصمّمة لتوسيع منطقة راحتك تدريجيًا.',
    eyebrowCommunity: 'من داخل القاعة', galleryHeadline: 'مجتمعنا',
    galleryIntro: 'جلسات حقيقية وأشخاص حقيقيون، يجدون صوتهم معًا.',
    g1: 'نتدرّب معًا', g2: 'نجد صوتنا', g3: 'نتعلّم من الملاحظات', g4: 'نتعلّم بالممارسة',
    g5: 'ورش عمل إنسانية', g6: 'خلف الكواليس',
    gAlt1: 'أعضاء جالسون حول طاولة طويلة يشاهدون الميسّر وهو يقدّم تمرين تحدّث',
    gAlt2: 'عضو يتحدث أمام القاعة بجانب شريحة لعبة البودكاست',
    gAlt3: 'ميسّر يشير إلى تمرين Triple Step على الشاشة بينما يتابع المشاركون',
    gAlt4: 'مضيف يعرض قواعد "لنتعلّم بالممارسة" على المجموعة',
    gAlt5: 'ثلاثة أشخاص في مقدمة القاعة خلال لعبة تحدّث والمجموعة تشاهد',
    gAlt6: 'لحظة عفوية بعد لعبة تحدّث والمجموعة ما زالت تضحك',
    eyebrowHosts: 'تعرّف على المضيفين', hostsHeadline: 'الأشخاص وراء الجلسات.',
    emadQuote: 'أعرف شعور أن يكون لديك ما يستحق القول ثم تتجمّد رغم ذلك. Speak Up Fearless هو المكان الذي تمنّيته حينها — تتدرّب أولًا، ثم تأتي الثقة.',
    eliasQuote: 'لا أحد هنا ينتظر حتى يشعر بالاستعداد. نحضر، ونتحدث، ونقدّم لبعضنا ملاحظات صادقة ولطيفة، ويغادر الجميع وهم يعرفون ما يعملون عليه بعد ذلك.',
    hostRole: 'شريك مؤسس ومضيف', emadAlt: 'صورة عماد، المؤسس والمضيف', eliasAlt: 'صورة إلياس، الشريك المؤسس والمضيف',
    eyebrowPricing: 'الأسعار', pricingHeadline: 'ابدأ من حيث أنت. وانمُ من هناك.',
    pricingSupport: 'ابدأ بمكالمة مجانية، وتابع فقط عندما تكون مستعدًا.', pricingCurrency: 'الأسعار بالدولار الكندي ($).',
    free: 'مجاني', freeTitle: 'جلسة تعريفية مجانية عبر الإنترنت',
    freeDesc: 'قابل أحد المضيفين وتعرّف على طريقة الجلسات. لا يُطلب منك التحدث، ولا ضغط للانضمام.',
    freeF1: 'قابل أحد المضيفين', freeF2: 'افهم كيف تعمل الجلسات', freeF3: 'تأكد إن كانت مناسبة لك — دون أي التزام',
    freeMeta: '15–20 دقيقة · مكالمة فيديو عبر الإنترنت',
    singleTitle: 'جلسة واحدة', singleMeta: 'جلسة تحدّث واحدة', singleCta: 'ابدأ بجلسة واحدة',
    popular: 'الأكثر طلبًا', fourTitle: 'باقة 4 جلسات', fourSave: 'وفّر 20$ · خصم 10%', fourPer: '45$ للجلسة', fourCta: 'ابنِ الاستمرارية',
    bestValue: 'أفضل قيمة', eightTitle: 'باقة 8 جلسات', eightSave: 'وفّر 80$ · خصم 20%', eightPer: '40$ للجلسة', eightCta: 'اكتسب الزخم',
    includes: 'كل جلسة تشمل تدريبًا موجّهًا على التحدث، وملاحظات بنّاءة، وتمارين لبناء الثقة ضمن مجموعة داعمة.',
    eyebrowFaq: 'أسئلة وأجوبة', faqHeadline: 'الأسئلة الشائعة',
    q1: 'هل أحتاج إلى خبرة في التحدث أمام الناس؟', a1: 'لا. نرحّب بمن يبدأ للتو. لا تحتاج أن تشعر بالثقة قبل الانضمام — فالمجتمع هو ما ينمّي الثقة.',
    q2: 'ماذا لو كنت متوترًا جدًا؟', a2: 'إذًا أنت في المكان الصحيح. التوتر أمر شائع هنا. نتقبّله ونفهمه ونتدرّب على التحدث رغمه — معًا.',
    q3: 'هل عليّ التحدث في جلستي الأولى؟', a3: 'سنشرح لك كيف تبدو الجلسة المعتادة عندما تتواصل معنا، ويمكنك البدء بالسرعة التي تناسبك. لا ضغط عليك للأداء.',
    q8: 'كم التكلفة؟', a8: 'الأسعار بالدولار الكندي: 50$ للجلسة الواحدة، و180$ لأربع جلسات، و320$ لثماني جلسات. مكالمتك الأولى مجانية.',
    q9: 'هل يمكنني التحدث معكم قبل الانضمام إلى جلسة؟', a9: 'نعم. نقدّم جلسة تعريفية مجانية عبر الإنترنت لتتحدث مع أحد المضيفين وتفهم ما نفعله وتطرح أسئلتك. لا يُطلب منك التحدث ولا ضغط للانضمام.',
    eyebrowContact: 'تواصل معنا', bookHeadline: 'احجز مكالمتك التعريفية المجانية',
    bookIntro: 'اختر اليوم والوقت المناسبين لك، وسنرد عليك للتأكيد.', bookFormTitle: 'اختر وقتًا لمكالمتك المجانية',
    pickDay: 'اختر يومًا', pickTime: 'اختر وقتًا', morning: 'صباحًا', afternoon: 'ظهرًا', evening: 'مساءً',
    morningFull: 'صباحًا (من 9 إلى 12)', afternoonFull: 'ظهرًا (من 12 إلى 5)', eveningFull: 'مساءً (من 5 إلى 9)',
    choiceRequired: 'يرجى اختيار يوم ووقت.', yourDetails: 'بياناتك',
    name: 'الاسم', contact: 'البريد أو الهاتف', reason: 'ما سبب الحجز؟', desc: 'هل تريد إضافة شيء آخر؟ (اختياري)',
    nameRequired: 'يرجى إدخال اسمك.', contactRequired: 'يرجى إضافة بريد إلكتروني أو رقم هاتف.', reasonRequired: 'يرجى إخبارنا بسبب الحجز.',
    send: 'أرسل الطلب', sending: 'جارٍ الإرسال…', sendFailed: 'لم نتمكن من الإرسال من هنا، لذلك فتحنا رسالة بريد تحتوي على طلبك.',
    bookNote: 'يصلنا طلبك مباشرة، وسنرد عليك لتأكيد الموعد.',
    sentTitle: 'تم إرسال الطلب!', sentBody: 'شكرًا لك! سنتواصل معك قريبًا لتأكيد الموعد.', again: 'اطلب موعدًا آخر',
    preferTalk: 'تفضّل التحدث أولًا؟', emailUs: 'راسلنا', callUs: 'اتصل بنا',
    footerBlurb: 'مجتمع داعم يساعد الناس ليصبحوا متحدثين أكثر راحة وثقة وشجاعة.',
    explore: 'استكشف', mission: 'رسالتنا', community: 'المجتمع', privacy: 'سياسة الخصوصية', contactLabel: 'تواصل',
    copyright: '© 2026 Speak Up Fearless. جميع الحقوق محفوظة.', close: 'إغلاق',
    stickyCta: 'احجز مكالمتك التعريفية المجانية', prev: 'الصورة السابقة', next: 'الصورة التالية',
    subject: 'طلب مكالمة تعريفية مجانية',
    planSingle: 'أنا مهتم بجلسة واحدة.', planFour: 'أنا مهتم بباقة 4 جلسات.', planEight: 'أنا مهتم بباقة 8 جلسات.',
    weekdays: ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'],
    months: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
    privacyBody: 'تحترم Speak Up Fearless خصوصيتك.\n\nما نجمعه: لا يحفظ هذا الموقع أي شيء تكتبه. عندما تطلب موعدًا عبر نموذج الحجز، يُرسل إلينا اسمك وبريدك أو هاتفك وسبب الحجز والوقت المفضّل عبر البريد من خلال خدمة FormSubmit (formsubmit.co) لإعادة توجيه النماذج. وإذا راسلتنا أو اتصلت بنا، نتلقى اسمك وبيانات التواصل وما تختار مشاركته.\n\nكيف نستخدمها: فقط للرد عليك وترتيب الجلسات والتواصل بخصوص الجلسات التي سألت عنها. لا نبيع معلوماتك ولا نؤجّرها أبدًا.\n\nإحصاءات الموقع: قد نستخدم أدوات تحليل تحترم الخصوصية ولا تستخدم ملفات تعريف الارتباط، تحسب الزيارات دون التعرف عليك.\n\nخياراتك: يمكنك في أي وقت أن تطلب الاطلاع على معلوماتك لدينا أو تصحيحها أو حذفها بمراسلة speakupfearless@gmail.com.\n\nنلتزم بقانون حماية المعلومات الشخصية والوثائق الإلكترونية الكندي (PIPEDA).'
  };

  // English comes from the page itself, so the HTML stays the source of truth.
  var EN = {};
  all('[data-t]').forEach(function (el) { if (!(el.dataset.t in EN)) EN[el.dataset.t] = el.textContent; });
  all('[data-t-ph]').forEach(function (el) { EN[el.dataset.tPh] = el.getAttribute('placeholder'); });
  all('[data-t-alt]').forEach(function (el) { EN[el.dataset.tAlt] = el.getAttribute('alt'); });
  Object.keys(EXTRA_EN).forEach(function (k) { if (!EN[k]) EN[k] = EXTRA_EN[k]; });

  var lang = store(LANG_KEY) === 'ar' ? 'ar' : 'en';
  function t(key) { var d = lang === 'ar' ? AR : EN; return key in d ? d[key] : EN[key]; }

  function applyLanguage() {
    root.lang = lang === 'ar' ? 'ar' : 'en-CA';
    root.dir = lang === 'ar' ? 'rtl' : 'ltr';
    all('[data-t]').forEach(function (el) { var v = t(el.dataset.t); if (v != null) el.textContent = v; });
    all('[data-t-ph]').forEach(function (el) { el.setAttribute('placeholder', t(el.dataset.tPh)); el.setAttribute('aria-label', t(el.dataset.tPh)); });
    all('[data-t-alt]').forEach(function (el) { el.setAttribute('alt', t(el.dataset.tAlt)); });
    $('langBtn').setAttribute('aria-label', t('langLong'));
    $('lbPrev').setAttribute('aria-label', t('prev'));
    $('lbNext').setAttribute('aria-label', t('next'));
    $('lbClose').setAttribute('aria-label', t('close'));
    document.title = lang === 'ar' ? 'دروس الخطابة في ميسيساغا | Speak Up Fearless' : 'Public Speaking Classes in Mississauga | Speak Up Fearless';
    renderMenuLabel();
    renderTheme();
    renderAccount();
    renderDays();
    root.classList.remove('ar-pending');
  }

  $('langBtn').addEventListener('click', function () {
    lang = lang === 'ar' ? 'en' : 'ar';
    store(LANG_KEY, lang);
    applyLanguage();
  });

  // ---------------------------------------------------------------- theme
  function isDark() { return root.dataset.theme === 'dark'; }
  function renderTheme() {
    var icon = isDark() ? '#i-sun' : '#i-moon';
    var label = isDark() ? t('themeLight') : t('themeDark');
    $('themeBtn').querySelector('use').setAttribute('href', icon);
    $('themeBtn').setAttribute('aria-label', label);
    $('themeBtn').title = label;
    $('themeBtn2').querySelector('use').setAttribute('href', icon);
    $('themeBtn2').querySelector('span').textContent = label;
    document.querySelector('meta[name="theme-color"]').content = isDark() ? '#241C16' : '#F1DDBC';
  }
  function toggleTheme() {
    if (isDark()) delete root.dataset.theme; else root.dataset.theme = 'dark';
    store(THEME_KEY, isDark() ? 'dark' : 'light');
    renderTheme();
  }
  $('themeBtn').addEventListener('click', toggleTheme);
  $('themeBtn2').addEventListener('click', toggleTheme);

  // ---------------------------------------------------------------- account
  function signedInUser() {
    try { var raw = localStorage.getItem(AUTH_KEY); return raw ? JSON.parse(raw) : null; } catch (_) { return null; }
  }
  function renderAccount() {
    var user = signedInUser();
    var link = $('acct');
    var label = link.querySelector('.acct-label');
    if (user) {
      var name = (user.displayName || user.email || '').split(' ')[0].split('@')[0];
      link.href = '/account';
      label.textContent = name || t('account');
      link.setAttribute('aria-label', t('account'));
    } else {
      link.href = '/login?next=%2F';
      label.textContent = t('signIn');
      link.setAttribute('aria-label', t('signIn'));
    }
  }

  // ---------------------------------------------------------------- menu
  var menu = $('mobileMenu');
  var menuBtn = $('menuBtn');
  function renderMenuLabel() {
    var open = menu.classList.contains('open');
    menuBtn.setAttribute('aria-label', open ? t('closeMenu') : t('openMenu'));
    menuBtn.querySelector('use').setAttribute('href', open ? '#i-close' : '#i-menu');
  }
  function setMenu(open) {
    menu.classList.toggle('open', open);
    menuBtn.setAttribute('aria-expanded', String(open));
    renderMenuLabel();
  }
  menuBtn.addEventListener('click', function () { setMenu(!menu.classList.contains('open')); });
  all('#mobileMenu a').forEach(function (a) { a.addEventListener('click', function () { setMenu(false); }); });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    setMenu(false);
    closeLightbox();
    closePrivacy();
  });

  // ---------------------------------------------------------------- photos
  var photos = all('[data-photo]').map(function (btn) {
    var img = btn.querySelector('img');
    var cap = btn.querySelector('figcaption');
    return { img: img, cap: cap };
  });
  var lb = $('lightbox');
  var lbIndex = 0;
  function showPhoto(i) {
    lbIndex = (i + photos.length) % photos.length;
    var p = photos[lbIndex];
    $('lbImg').src = p.img.currentSrc || p.img.src;
    $('lbImg').alt = p.img.alt;
    $('lbCap').textContent = p.cap ? p.cap.textContent : '';
  }
  function openLightbox(i) { showPhoto(i); lb.classList.add('open'); document.body.style.overflow = 'hidden'; $('lbClose').focus(); }
  function closeLightbox() { if (!lb.classList.contains('open')) return; lb.classList.remove('open'); document.body.style.overflow = ''; }
  all('[data-photo]').forEach(function (btn, i) {
    btn.setAttribute('aria-label', (btn.querySelector('img') || {}).alt || '');
    btn.addEventListener('click', function () { openLightbox(i); });
  });
  $('lbClose').addEventListener('click', closeLightbox);
  $('lbPrev').addEventListener('click', function () { showPhoto(lbIndex - (root.dir === 'rtl' ? -1 : 1)); });
  $('lbNext').addEventListener('click', function () { showPhoto(lbIndex + (root.dir === 'rtl' ? -1 : 1)); });
  lb.addEventListener('click', function (e) { if (e.target === lb) closeLightbox(); });
  var touchX = null;
  lb.addEventListener('touchstart', function (e) { touchX = e.touches.length === 1 ? e.touches[0].clientX : null; }, { passive: true });
  lb.addEventListener('touchend', function (e) {
    if (touchX == null) return;
    var dx = e.changedTouches[0].clientX - touchX;
    if (Math.abs(dx) > 50) showPhoto(lbIndex + (dx < 0 ? 1 : -1));
    touchX = null;
  });

  // ---------------------------------------------------------------- privacy
  var privacy = $('privacy');
  function closePrivacy() { privacy.classList.remove('open'); document.body.style.overflow = ''; }
  $('privacyBtn').addEventListener('click', function () {
    privacy.querySelector('[data-t="privacyBody"]').textContent = t('privacyBody');
    privacy.classList.add('open');
    document.body.style.overflow = 'hidden';
    $('privacyClose').focus();
  });
  $('privacyClose').addEventListener('click', closePrivacy);
  privacy.addEventListener('click', function (e) { if (e.target === privacy) closePrivacy(); });

  // ---------------------------------------------------------------- booking
  var days = [];
  (function () {
    var today = new Date();
    today.setHours(12, 0, 0, 0);
    for (var i = 1; i <= 14; i++) { var d = new Date(today); d.setDate(today.getDate() + i); days.push(d); }
  })();
  var pickedDay = -1;
  var pickedTime = -1;
  var timeKeys = ['morningFull', 'afternoonFull', 'eveningFull'];

  function weekday(d) { return t('weekdays')[(d.getDay() + 6) % 7]; }
  function renderDays() {
    var box = $('days');
    box.innerHTML = '';
    days.forEach(function (d, i) {
      var b = document.createElement('button');
      b.type = 'button';
      b.className = 'day';
      b.setAttribute('aria-pressed', String(i === pickedDay));
      var wd = weekday(d);
      var short = lang === 'ar' ? wd : wd.toUpperCase();
      b.innerHTML = '<small></small><b></b><span></span>';
      b.children[0].textContent = short;
      b.children[1].textContent = d.getDate();
      b.children[2].textContent = t('months')[d.getMonth()];
      b.setAttribute('aria-label', wd + ' ' + t('months')[d.getMonth()] + ' ' + d.getDate());
      b.addEventListener('click', function () { pickedDay = i; renderDays(); checkChoice(); });
      box.appendChild(b);
    });
  }
  all('.time').forEach(function (b) {
    b.addEventListener('click', function () {
      pickedTime = +b.dataset.time;
      all('.time').forEach(function (o) { o.setAttribute('aria-pressed', String(o === b)); });
      checkChoice();
    });
  });
  function checkChoice() { if (pickedDay >= 0 && pickedTime >= 0) $('choiceErr').classList.remove('show'); }

  function preferredTime() {
    var d = days[pickedDay];
    // Always English for the inbox, matching the app.
    var wd = EXTRA_EN.weekdays[(d.getDay() + 6) % 7];
    return wd + ', ' + EXTRA_EN.months[d.getMonth()] + ' ' + d.getDate() + ', ' + EXTRA_EN[timeKeys[pickedTime]];
  }

  function fieldOk(id) {
    var input = $(id);
    var ok = input.value.trim().length > 0;
    input.parentNode.classList.toggle('bad', !ok);
    return ok;
  }
  ['fName', 'fContact', 'fReason'].forEach(function (id) {
    $(id).addEventListener('input', function () { if ($(id).parentNode.classList.contains('bad')) fieldOk(id); });
  });

  // Package buttons prefill the reason so the request says what they want.
  all('[data-plan]').forEach(function (a) {
    a.addEventListener('click', function () {
      var key = { single: 'planSingle', four: 'planFour', eight: 'planEight' }[a.dataset.plan];
      var reason = $('fReason');
      if (!reason.value.trim() || /package|session|باقة|جلسة/i.test(reason.value)) reason.value = t(key);
    });
  });

  $('bookForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var choiceOk = pickedDay >= 0 && pickedTime >= 0;
    $('choiceErr').classList.toggle('show', !choiceOk);
    var ok = [fieldOk('fName'), fieldOk('fContact'), fieldOk('fReason')].every(Boolean) && choiceOk;
    if (!ok) {
      var first = !choiceOk ? $('days') : document.querySelector('.field.bad input');
      if (first) { first.scrollIntoView({ block: 'center', behavior: 'smooth' }); if (first.focus) first.focus({ preventScroll: true }); }
      return;
    }
    var req = {
      name: $('fName').value.trim(),
      contact: $('fContact').value.trim(),
      reason: $('fReason').value.trim(),
      description: $('fDesc').value.trim(),
      preferredTime: preferredTime()
    };
    var subject = EXTRA_EN.subject + ' — ' + req.preferredTime;
    var payload = {
      _subject: subject, _template: 'table', _captcha: 'false',
      'Preferred time': req.preferredTime, 'Name': req.name, 'Email or phone': req.contact, 'Reason': req.reason
    };
    if (req.description) payload['More details'] = req.description;
    var btn = $('sendBtn');
    btn.disabled = true;
    btn.textContent = t('sending');
    $('sendErr').classList.remove('show');

    saveToBackend(req);
    var controller = 'AbortController' in window ? new AbortController() : null;
    var timer = setTimeout(function () { if (controller) controller.abort(); }, 15000);
    fetch(BOOKING_ENDPOINT, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', 'Accept': 'application/json' },
      body: JSON.stringify(payload),
      signal: controller ? controller.signal : undefined
    }).then(function (r) { return r.ok ? r.json() : null; })
      .then(function (data) { return !!data && String(data.success) === 'true'; })
      .catch(function () { return false; })
      .then(function (sent) {
        clearTimeout(timer);
        btn.disabled = false;
        btn.textContent = t('send');
        if (sent) {
          $('bookForm').hidden = true;
          $('sent').hidden = false;
          $('bookCard').scrollIntoView({ block: 'center', behavior: 'smooth' });
          return;
        }
        // Fall back to an email draft so the request isn't lost.
        var body = 'Hi! I would like to book a free intro call.\n\n' +
          'Preferred time: ' + req.preferredTime + '\nName: ' + req.name + '\nEmail or phone: ' + req.contact +
          '\nReason: ' + req.reason + '\n' + (req.description ? '\nMore details:\n' + req.description + '\n' : '');
        $('sendErr').classList.add('show');
        location.href = 'mailto:' + CONTACT_EMAIL + '?subject=' + encodeURIComponent(subject) + '&body=' + encodeURIComponent(body);
      });
  });

  function saveToBackend(req) {
    var body = { name: req.name, contact: req.contact, preferredTime: req.preferredTime, reason: req.reason };
    if (req.description) body.description = req.description;
    try {
      fetch(API_BASE + '/v1/bookings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(body),
        keepalive: true
      }).catch(function () {});
    } catch (_) {}
  }

  $('again').addEventListener('click', function () {
    $('bookForm').reset();
    pickedDay = -1;
    pickedTime = -1;
    all('.time').forEach(function (o) { o.setAttribute('aria-pressed', 'false'); });
    renderDays();
    $('sent').hidden = true;
    $('bookForm').hidden = false;
  });

  // ---------------------------------------------------------------- sticky CTA
  // Shown on phones once the hero is out of view, hidden near the form.
  var sticky = $('stickyCta');
  if ('IntersectionObserver' in window) {
    var heroOut = false;
    var bookIn = false;
    var footIn = false;
    var update = function () { sticky.classList.toggle('show', heroOut && !bookIn && !footIn); };
    new IntersectionObserver(function (es) { heroOut = !es[0].isIntersecting; update(); }).observe($('top'));
    new IntersectionObserver(function (es) { bookIn = es[0].isIntersecting; update(); }, { rootMargin: '0px 0px -20% 0px' }).observe($('book'));
    new IntersectionObserver(function (es) { footIn = es[0].isIntersecting; update(); }).observe(document.querySelector('footer'));
    document.body.classList.add('has-sticky');
  }

  applyLanguage();
})();
