// speakUnshaken home page: language, theme, account link, menu, photo
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

  // Dev site (dev.speakunshaken.com or speakunshaken-dev.web.app): a small badge
  // so nobody mistakes it for the real site.
  if (/^dev\.|-dev\.web\.app$|-dev\.firebaseapp\.com$/.test(location.hostname)) {
    var devTag = document.createElement('div');
    devTag.textContent = 'DEV';
    devTag.setAttribute('aria-hidden', 'true');
    devTag.style.cssText = 'position:fixed;z-index:9999;bottom:10px;left:10px;padding:3px 9px;border-radius:999px;background:#7A4E9A;color:#fff;font:800 11px/1.4 system-ui,sans-serif;letter-spacing:.08em;pointer-events:none;opacity:.9';
    (document.body || document.documentElement).appendChild(devTag);
  }
  var CONTACT_EMAIL = 'speakupunshaken@gmail.com';
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
    langLong: 'العربية', langShort: 'ع', signIn: 'Sign in', signOut: 'Sign out', signedOut: "You're signed out. See you soon!", account: 'Your account',
    themeDark: 'Dark theme', themeLight: 'Light theme', openMenu: 'Open menu', closeMenu: 'Close menu',
    close: 'Close', prev: 'Previous photo', next: 'Next photo',
    morningFull: 'Morning (9am to 12pm)', afternoonFull: 'Afternoon (12 to 5pm)', eveningFull: 'Evening (5 to 9pm)',
    joinBody: 'Make a free account to start {game}. It only takes a moment, and you can play right away.',
    lbT0: 'Everyone gets a turn',
    lbD0: 'A host guides every session. You start small, everyone takes part, and mistakes are welcome.',
    lbD1: 'You sit with a small, friendly group and warm up together before anyone stands up.',
    lbD2: "You speak in short, playful rounds like the Podcast Game, so it feels like a chat, not a speech.",
    lbD3: 'After each round you get kind, specific tips: what worked, and one thing to try next.',
    lbD4: 'Simple ground rules keep it safe: everyone takes part, nobody judges, mistakes are part of learning.',
    lbD5: 'Games like Triple Step get you talking on your feet while the group cheers you on.',
    lbD6: 'Expect lots of laughs. Most people leave feeling lighter than when they walked in.',
    sending: 'Sending…', subject: 'Free intro call request',
    pickSession: 'Choose your session',
    mLead: 'Just', mDay: 'pick a day', mTime: 'pick a time', mName: 'add your name',
    mContact: 'add your email', mPhone: 'add a phone number', badEmail: 'That email doesn\'t look right. Please check it.', badPhone: 'Please enter a 10-digit phone number, like (416) 555-0123.', mReason: 'tell us what you want help with',
    sIntro: 'Free intro call', sIntroMeta: '20 min video chat about your goals',
    sSingle: 'One session', sSingleMeta: '1 hour, a good way to try it',
    sFour: '4 sessions', sFourMeta: '1 hour each, $45 a session, save $20',
    sEight: '8 sessions', sEightMeta: '1 hour each, $40 a session, save $80',
    sFree: 'Free', popular: 'MOST POPULAR', bestValue: 'BEST VALUE',
    weekdays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
    months: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
    privacyBody: 'speakUnshaken respects your privacy.\n\n' +
      'What we collect: this website does not store anything you type. When you request a time through the booking form, your name, email or phone, reason and preferred time are sent to us by email through FormSubmit (formsubmit.co), a form-forwarding service. If you email or call us, we receive your name, contact details, and whatever you choose to share.\n\n' +
      'How we use it: only to reply to you, arrange sessions, and keep in touch about sessions you have asked about. We never sell or rent your information.\n\n' +
      'Website statistics: we may use privacy-friendly, cookie-free analytics that count visits without identifying you.\n\n' +
      'Your choices: you can ask us at any time to see, correct, or delete the information we hold about you by emailing speakupunshaken@gmail.com.\n\n' +
      "We follow Canada's Personal Information Protection and Electronic Documents Act (PIPEDA)."
  };

  var AR = {
    dailyPill: 'جديد: تحدي تحدّث لدقيقة واحدة كل يوم',
    freeTag: 'مجاني، بلا تسجيل', freeTagLong: 'مجاني للعب، بلا تسجيل', dailyTitle: 'تحدي التحدّث لدقيقة واحدة لليوم',
    dailyBody: 'موضوع جديد كل يوم. تحدّث دقيقة واحدة وابدأ سلسلتك.', dailyGo: 'ابدأ الآن', lockChip: 'حساب مجاني', prevPhotos: 'الصور السابقة', morePhotos: 'المزيد من الصور', unlockFree: 'افتحها مجانًا',
    gamesIntroGuest: 'ابدأ بتحدي الدقيقة لليوم، مجانًا وبلا تسجيل. الحساب المجاني يفتح لك بقية الألعاب.',
    skInSession: 'في الجلسة', skTip: 'اضغط على أي مهارة لترى كيف تبدو في الجلسة.',
    skD1: 'جولات قصيرة وسهلة تتحدث فيها من 30 إلى 60 ثانية، وبالسرعة التي تناسبك.',
    skD2: 'أسئلة وكلمات مفاجئة، كما في Triple Step، لتتعلّم الرد دون أن تتجمّد.',
    skD3: 'تصوغ قصة واحدة من حياتك وترويها أمام مجموعة ودودة.',
    skD4: 'يسمع الجميع شيئًا نجح وشيئًا يجرّبونه بعدها. دون قسوة أبدًا.',
    skD5: 'خطوة صغيرة في كل مرة، مثل وقفة مقصودة أو رفع نظرك عن أوراقك.',
    howWeHelp: 'كيف نساعدك', feelTip: 'اضغط على أي بطاقة لترى كيف نساعدك.',
    help1: 'نبدأ بجولات صغيرة بلا ضغط، فيتعلّم جسمك أن الكلام آمن.',
    help2: 'ألعاب سريعة تدرّبك على أن تتكلم أولًا وتحسّن لاحقًا.',
    help3: 'الجميع هنا يتوترون مثلك، وكل الملاحظات لطيفة ومفيدة.',
    help4: 'نتدرّب على تجاوز التوقف، فلا يعود الصمت يبدو كارثة.',
    joinKicker: 'مجانية', joinTitle: 'خطوة واحدة وتبدأ اللعب',
    joinBody: 'أنشئ حسابًا مجانيًا لتبدأ {game}. يستغرق الأمر لحظة، وتلعب فورًا.',
    joinB1: 'ألعاب التحدث الأربع، مجانًا للأبد', joinB2: 'شاهد تقدّمك وسلسلة أيامك تكبر', joinB3: 'تدرّب وحدك أولًا، بلا جمهور',
    joinCta: 'أنشئ حسابي المجاني', joinHave: 'لديك حساب؟', joinSignIn: 'سجّل الدخول', joinFine: 'يستغرق 30 ثانية. بلا بطاقة وبلا رسائل مزعجة.',
    lbKicker: 'ما الذي ستحصل عليه', lbT0: 'الجميع يأخذ دوره',
    lbD0: 'يقود كل جلسة مضيف. تبدأ بخطوات صغيرة، ويشارك الجميع، والأخطاء مرحّب بها.',
    lbD1: 'تجلس مع مجموعة صغيرة وودودة وتتحمّسون معًا قبل أن يقف أحد.',
    lbD2: 'تتحدث في جولات قصيرة ومرحة مثل لعبة البودكاست، فتشعر أنها دردشة لا خطبة.',
    lbD3: 'بعد كل جولة تحصل على نصائح لطيفة ومحددة: ما نجح، وشيء واحد تجرّبه بعدها.',
    lbD4: 'قواعد بسيطة تحافظ على الأمان: الجميع يشارك، لا أحد يحكم، والأخطاء جزء من التعلّم.',
    lbD5: 'ألعاب مثل Triple Step تجعلك تتحدث واقفًا والمجموعة تشجّعك.',
    lbD6: 'توقّع الكثير من الضحك. معظم الناس يغادرون أخفّ مما دخلوا.',
    skip: 'انتقل إلى المحتوى', navWhy: 'لماذا نفعل هذا', navSessions: 'الجلسات', navCommunity: 'مجتمعنا',
    navGames: 'الألعاب', newBadge: 'جديد', playNow: 'العب', navCoach: 'المدرب الذكي', heroCoach: 'مدرب إلقاء مجاني بالذكاء الاصطناعي',
    coachNew: 'جديد · مدرب إلقاء مجاني بالذكاء الاصطناعي', coachTitleA: 'تحدّث', coachTitleHl: 'لدقيقة واحدة.', coachTitleB: 'واحصل على تقرير مدرب خلال ثوانٍ.',
    coachS1: 'تحدّث لدقيقة', coachS2: 'الذكاء الاصطناعي يستمع', coachS3: 'استلم تقريرك', coachDemoWpmShort: 'كلمة/د', coachDemoGood: 'بداية قوية', coachDemoLabel: 'مثال على تقرير',
    coachLead: 'سجّل نفسك عن أي موضوع من متصفحك مباشرة. يستمع مدرب الذكاء الاصطناعي ويبيّن لك بالضبط ما تعمل عليه بعد ذلك.',
    coachF1t: 'سرعتك', coachF1b: 'اعرف أين أسرعت وأين أبطأت.', coachF2t: 'كل «اممم» و«آآ»', coachF2b: 'كلمات الحشو، معدودة وظاهرة في كلامك.',
    coachF3t: 'قصتك', coachF3b: 'مدى ترابط بدايتك ووسطك ونهايتك.', coachF4t: 'ماذا تتمرّن', coachF4b: 'لعبة مختارة لك، ثم جرّب مجددًا وشاهد تقدّمك.',
    coachCta: 'جرّب المدرب الذكي مجانًا', coachNote: 'حساب مجاني · يعمل على هاتفك · بالعربية أو الإنجليزية', coachDemoAria: 'مثال على تقرير مدرب الإلقاء',
    coachDemoVerdict: 'حديث رائع!', coachDemoTopic: 'وظيفتي الأولى', coachDemoStyle: '📖 قصة', coachDemoWpm: 'كلمة / دقيقة', coachDemoFill: 'كلمات حشو',
    coachDemoPause: 'وقفة طويلة', coachDemoPace: 'السرعة', coachDemoNextL: 'تمرّن بعد ذلك', coachDemoNext: 'الخطوة الثلاثية، لانتقالات أسلس',
    gamesEyebrow: 'ألعاب تحدّث مجانية', gamesHeadline: 'جهّز صوتك للحديث في دقيقتين.',
    gamesIntro: 'ألعاب سريعة تلعبها وحدك أو مع أصدقائك. كل ما تحتاجه حساب مجاني.', gamesCta: 'العب الآن',
    gTriple: 'الخطوة الثلاثية', gTripleTag: 'تحدّث عن موضوع وأدخل الكلمات المفاجئة في كلامك.',
    gConductor: 'قائد الأوركسترا', gConductorTag: 'غيّر طبقة صوتك من 1 (منخفض) إلى 10 (مرتفع) وأنت تتكلم.',
    gPodcast: 'لعبة البودكاست', gPodcastTag: 'موضوع واحد وبعض الأصدقاء، والميكروفون يتنقّل بينكم.',
    gAuto: 'الإكمال التلقائي', gAutoTag: 'أكمل كل جملة بصوت عالٍ قبل أن ينتهي الوقت.',
    moreDetails: 'أضف ملاحظة', navFaq: 'الأسئلة الشائعة', navContact: 'تواصل معنا', navHome: 'الرئيسية',
    langLong: 'English', langShort: 'EN', signIn: 'تسجيل الدخول', signOut: 'تسجيل الخروج', signedOut: 'تم تسجيل خروجك. نراك قريبًا!', account: 'حسابك',
    themeDark: 'المظهر الداكن', themeLight: 'المظهر الفاتح', openMenu: 'افتح القائمة', closeMenu: 'أغلق القائمة',
    joinUs: 'احجز مكالمة', getStarted: 'ابدأ معنا', getStartedFree: 'ابدأ مجانًا', ctaBookShort: 'احجز مكالمتي المجانية', ctaBook: 'احجز مكالمة تعريفية مجانية', ctaLearn: 'اطّلع على ما نتدرّب عليه',
    heroLocation: 'تدريب على التحدث أمام الناس، عبر الإنترنت أو حضوريًا في منطقة تورونتو',
    talkLocation: 'عبر الإنترنت، أو حضوريًا في منطقة تورونتو',
    how1: 'تعال', how2: 'تحدّث قليلًا', how3: 'ودع الخوف يتلاشى',
    ctaNote: 'ابدأ بمكالمة فيديو مجانية مدتها 20 دقيقة مع أحد المضيفين عن أهدافك. لن يُطلب منك إلقاء كلمة.',
    qWhere: 'هل الجلسات عبر الإنترنت أم حضورية؟', aWhere: 'الاثنان. انضم عبر الإنترنت من أي مكان، أو تعال حضوريًا في مكان ما في منطقة تورونتو الكبرى. نتفق على ما يناسبك في مكالمتك المجانية.',
    heroHeadline: 'ابدأ بالكلام، ودع التوتر يرحل.',
    heroSupport: 'نساعد من يتوترون عند التحدث أمام الآخرين. مجموعات صغيرة وودودة وتمارين كلام ممتعة، خطوة صغيرة في كل مرة، حتى يخف القلق.',
    heroTrust: 'مكان ودود لا يحكم عليك فيه أحد، وتتقدّم فيه على راحتك.',
    heroImageAlt: 'مضيف يقود ورشة speakUnshaken أمام مجموعة صغيرة',
    badgeTitle: 'الكل يأخذ دوره', badgeBody: 'الأخطاء مرحّب بها هنا.',
    eyebrowWhy: 'لست وحدك', anxietyHeadline: 'يوترك التحدث؟ معظمنا يشعر بالشيء نفسه.',
    feel1: '«قلبي يبدأ بالخفقان بسرعة.»', feel2: '«أفكّر كثيرًا في كل ما أريد قوله.»',
    feel3: '«أخاف أن يحكم عليّ الناس.»', feel4: '«أعرف ما أريد قوله، لكنني أتجمّد.»',
    anxietyHuman: 'هذا الشعور لا يعني أنك سيئ في التحدث، بل يعني أنك تهتم.',
    eyebrowSessions: 'ماذا نتدرّب', sessionsHeadline: 'ما نعمل عليه معًا',
    sessionsIntro: 'مكان هادئ ومنتظم للتدرّب. إنه مجتمع وليس علاجًا.',
    how1: 'احضر', how2: 'تحدّث', how3: 'تأمّل', how4: 'انمُ',
    p1t: 'التدرّب على الكلام', p1b: 'قل ما تريد بوضوح وهدوء.',
    p2t: 'الارتجال', p2b: 'أجب جيدًا عندما يفاجئك أحد بسؤال.',
    p3t: 'سرد القصص', p3b: 'حوّل تجاربك إلى قصص يتذكرها الناس.',
    p4t: 'ملاحظات لطيفة', p4b: 'اعرف ما نجح وما تجرّبه في المرة القادمة.',
    p5t: 'تحديات صغيرة', p5b: 'خطوات صغيرة توسّع منطقة راحتك.',
    eyebrowCommunity: 'من داخل القاعة', galleryHeadline: 'مجتمعنا',
    galleryIntro: 'أشخاص حقيقيون في جلساتنا الحقيقية.',
    g1: 'نتدرّب معًا', g2: 'نجد صوتنا', g3: 'نتعلّم من الملاحظات', g4: 'نتعلّم بالممارسة',
    g5: 'ورش عمل إنسانية', g6: 'خلف الكواليس',
    gAlt1: 'أعضاء جالسون حول طاولة طويلة يشاهدون الميسّر وهو يقدّم تمرين تحدّث',
    gAlt2: 'عضو يتحدث أمام القاعة بجانب شريحة لعبة البودكاست',
    gAlt3: 'ميسّر يشير إلى تمرين Triple Step على الشاشة بينما يتابع المشاركون',
    gAlt4: 'مضيف يعرض قواعد "لنتعلّم بالممارسة" على المجموعة',
    gAlt5: 'ثلاثة أشخاص في مقدمة القاعة خلال لعبة تحدّث والمجموعة تشاهد',
    gAlt6: 'لحظة عفوية بعد لعبة تحدّث والمجموعة ما زالت تضحك',
    eyebrowHosts: 'تعرّف على المضيفين', hostsHeadline: 'تعرّف على المضيفين',
    emadQuote: '«أعرف شعور أن تتجمّد ولديك ما يستحق القول. هذا هو المكان الذي تمنّيته حينها.»',
    eliasQuote: '«لا أحد هنا ينتظر حتى يشعر بالاستعداد. نحضر ونتكلم ونساعد بعضنا لنتحسّن.»',
    hostRole: 'شريك مؤسس ومضيف', emadAlt: 'صورة عماد، المؤسس والمضيف', eliasAlt: 'صورة إلياس، الشريك المؤسس والمضيف',
    eyebrowPricing: 'الأسعار', pricingHeadline: 'أسعار بسيطة وواضحة',
    pricingSupport: 'ابدأ بمكالمة تعريفية مجانية نتحدث فيها عن أهدافك، ثم انضم إلى جلسات التدريب فقط إن شعرت أنها تناسبك.', pricingCurrency: 'الأسعار بالدولار الكندي.',
    free: 'مجاني', freeTitle: 'مكالمة تعريفية مجانية: اعرف إن كانت تناسبك',
    freeDesc: 'مكالمة فيديو قصيرة مع أحد المضيفين. أخبرنا بما يصعّب عليك التحدث، واعرف كيف تسير جلسات التدريب، واسأل ما تشاء. إنها ليست جلسة، فلن يُطلب منك إلقاء كلمة، ولا ضغط للتسجيل.',
    freeF1: 'قابل أحد المضيفين', freeF2: 'افهم كيف تعمل الجلسات', freeF3: 'تأكد إن كانت مناسبة لك دون أي التزام',
    freeMeta: 'مكالمة فيديو مدتها 20 دقيقة',
    singleTitle: 'جلسة واحدة', singleMeta: 'ساعة واحدة، طريقة جيدة للتجربة', singleCta: 'ابدأ بجلسة واحدة',
    popular: 'الأكثر طلبًا', fourTitle: '4 جلسات', fourSave: 'وفّر 20$ · خصم 10%', fourPer: 'ساعة لكل جلسة، 45$ للجلسة', fourCta: 'ابنِ الاستمرارية',
    bestValue: 'أفضل قيمة', eightTitle: '8 جلسات', eightSave: 'وفّر 80$ · خصم 20%', eightPer: 'ساعة لكل جلسة، 40$ للجلسة', eightCta: 'اكتسب الزخم',
    includes: 'كل جلسة مدتها ساعة فيها تدريب موجّه وملاحظات ودودة وتمارين تساعدك على الشعور بثقة أكبر.',
    eyebrowFaq: 'معلومات تهمّك', faqHeadline: 'أسئلة يطرحها الناس',
    q1: 'هل أحتاج إلى خبرة في التحدث أمام الناس؟', a1: 'لا. نرحّب بمن يبدأ للتو. لا تحتاج أن تشعر بالثقة قبل الانضمام، فالمجتمع هو ما ينمّي الثقة.',
    q2: 'ماذا لو كنت متوترًا جدًا؟', a2: 'إذًا أنت بين أناس يفهمونك. معظم من هنا شعروا بالشيء نفسه في البداية. نتدرّب معًا وعلى مهل.',
    q3: 'هل عليّ التحدث في جلستي الأولى؟', a3: 'ليس إن كنت لا تريد. سنشرح لك كيف تسير الجلسة قبل أن تأتي، ويمكنك أن تبدأ بخطوة صغيرة. لن يضغط عليك أحد.',
    q8: 'كم التكلفة؟', a8: 'الجلسة الواحدة بـ50$. ويمكنك أيضًا أخذ 4 جلسات بـ180$ أو 8 جلسات بـ320$. مكالمتك الأولى مجانية.',
    q9: 'هل يمكنني التحدث معكم قبل الانضمام إلى جلسة؟', a9: 'نعم. نقدّم جلسة تعريفية مجانية عبر الإنترنت لتتحدث مع أحد المضيفين وتفهم ما نفعله وتطرح أسئلتك. لا يُطلب منك التحدث ولا ضغط للانضمام.',
    eyebrowContact: 'تواصل معنا', bookHeadline: 'احجز مكالمتك التعريفية المجانية',
    bookIntro: 'مكالمة فيديو مجانية مدتها 20 دقيقة عن أهدافك في التحدث. اختر الوقت المناسب لك وسنرد عليك للتأكيد.',
    pickDay: 'اختر يومًا', pickTime: 'اختر وقتًا', morning: 'صباحًا', afternoon: 'ظهرًا', evening: 'مساءً',
    morningFull: 'صباحًا (من 9 إلى 12)', afternoonFull: 'ظهرًا (من 12 إلى 5)', eveningFull: 'مساءً (من 5 إلى 9)',
    choiceRequired: 'يرجى اختيار يوم ووقت.', yourDetails: 'عنك',
    name: 'اسمك', contact: 'البريد الإلكتروني', phone: 'رقم الهاتف', phoneRequired: 'يرجى إضافة رقم هاتف.',
    badEmail: 'يبدو أن البريد غير صحيح. يرجى التحقق منه.', badPhone: 'أدخل رقم هاتف من 10 أرقام، مثل 0123-555 (416).', reason: 'بماذا تريد أن نساعدك؟', desc: 'هل هناك شيء آخر تود أن نعرفه؟',
    nameRequired: 'يرجى كتابة اسمك.', contactRequired: 'يرجى إضافة بريدك الإلكتروني.', reasonRequired: 'أخبرنا قليلًا بما تريد المساعدة فيه.',
    send: 'أرسل الطلب', sending: 'جارٍ الإرسال…', sendFailed: 'لم نتمكن من الإرسال من هنا، لذلك فتحنا رسالة بريد تحتوي على طلبك.',
    bookNote: 'يصل طلبك مباشرة إلى بريدنا. بلا رسائل مزعجة، ولا شيء للدفع.',
    ns1t: 'ترسل هذا الطلب', ns1b: 'دقيقة تقريبًا، بلا دفع',
    ns2t: 'نرد عليك خلال 24 ساعة', ns2b: 'عبر البريد أو رسالة نصية، من شخص حقيقي',
    ns3t: 'مكالمتك المجانية لمدة 20 دقيقة', ns3b: 'في الوقت الذي اخترته',
    promiseTitle: 'سيرد عليك عماد أو إلياس شخصيًا', promiseSub: 'عادةً في اليوم نفسه، ودائمًا خلال 24 ساعة.',
    quickAlt: 'لا تفضّل ملء النموذج؟', textUs: 'راسلنا نصيًا',
    sentTitle: 'وصلنا طلبك، شكرًا لك!', sentBody: 'سنتواصل معك قريبًا لتأكيد الموعد.', again: 'أرسل طلبًا آخر',
    preferTalk: 'تفضّل أن نتحدث مباشرة؟', emailUs: 'راسلنا', callUs: 'اتصل بنا',
    footerBlurb: 'مجموعة ودودة في ميسيساغا يتدرّب فيها الناس على التحدث ويرتاحون له أكثر فأكثر.',
    explore: 'استكشف', mission: 'لماذا نفعل هذا', community: 'المجتمع', privacy: 'سياسة الخصوصية', contactLabel: 'تواصل',
    copyright: '© 2026 speakUnshaken. جميع الحقوق محفوظة.', close: 'إغلاق',
    stickyCta: 'احجز الآن', almostThere: 'اقتربت!', mLead: 'بقي فقط:', mDay: 'اختيار يوم', mTime: 'اختيار وقت',
    mName: 'كتابة اسمك', mContact: 'إضافة بريدك', mPhone: 'إضافة رقم هاتف', mReason: 'إخبارنا بما تريد المساعدة فيه',
    dayMissing: 'اختر اليوم الأنسب لك.', timeMissing: 'صباحًا أم ظهرًا أم مساءً؟', tryGame: 'لست مستعدًا للكلام بعد؟ جرّب تحدي الدقيقة لليوم',
    sentMail: 'أرسلنا نسخة إلى بريدك أيضًا.', afterTitle: 'وأنت تنتظر، جهّز صوتك بلعبة',
    afterSub: 'تحدي اليوم يستغرق دقيقة واحدة وهو مجاني.',
    cancelPolicy: 'الظروف تتغير، ونحن نتفهم ذلك. أخبرنا قبل الجلسة بـ24 ساعة على الأقل وسننقلها إلى يوم آخر مجانًا. لديك سؤال عن الاسترداد؟ اسألنا فقط.', stickyTitle: 'مكالمة تعريفية مجانية', stickySub: 'مكالمة 20 دقيقة عن أهدافك', prev: 'الصورة السابقة', next: 'الصورة التالية',
    subject: 'طلب مكالمة تعريفية مجانية',
    pickSession: 'ماذا تريد؟', sIntro: 'مكالمة تعريفية مجانية', sIntroMeta: 'مكالمة فيديو 20 دقيقة عن أهدافك',
    sSingle: 'جلسة واحدة', sSingleMeta: 'ساعة واحدة، طريقة جيدة للتجربة', sFour: '4 جلسات', sFourMeta: 'ساعة لكل جلسة، 45$ للجلسة، وفّر 20$',
    sEight: '8 جلسات', sEightMeta: 'ساعة لكل جلسة، 40$ للجلسة، وفّر 80$', sFree: 'مجاني',
    bookFormTitle: 'اطلب جلسة', bookFormSub: 'لن يستغرق الأمر سوى دقيقة.',
    weekdays: ['الإثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة', 'السبت', 'الأحد'],
    months: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
    privacyBody: 'تحترم speakUnshaken خصوصيتك.\n\nما نجمعه: لا يحفظ هذا الموقع أي شيء تكتبه. عندما تطلب موعدًا عبر نموذج الحجز، يُرسل إلينا اسمك وبريدك أو هاتفك وسبب الحجز والوقت المفضّل عبر البريد من خلال خدمة FormSubmit (formsubmit.co) لإعادة توجيه النماذج. وإذا راسلتنا أو اتصلت بنا، نتلقى اسمك وبيانات التواصل وما تختار مشاركته.\n\nكيف نستخدمها: فقط للرد عليك وترتيب الجلسات والتواصل بخصوص الجلسات التي سألت عنها. لا نبيع معلوماتك ولا نؤجّرها أبدًا.\n\nإحصاءات الموقع: قد نستخدم أدوات تحليل تحترم الخصوصية ولا تستخدم ملفات تعريف الارتباط، تحسب الزيارات دون التعرف عليك.\n\nخياراتك: يمكنك في أي وقت أن تطلب الاطلاع على معلوماتك لدينا أو تصحيحها أو حذفها بمراسلة speakupunshaken@gmail.com.\n\nنلتزم بقانون حماية المعلومات الشخصية والوثائق الإلكترونية الكندي (PIPEDA).'
  };

  // English comes from the page itself, so the HTML stays the source of truth.
  var EN = {};
  all('[data-t]').forEach(function (el) { if (!(el.dataset.t in EN)) EN[el.dataset.t] = el.textContent; });
  all('[data-t-ph]').forEach(function (el) { EN[el.dataset.tPh] = el.getAttribute('placeholder'); });
  all('[data-t-alt]').forEach(function (el) { EN[el.dataset.tAlt] = el.getAttribute('alt'); });
  all('[data-t-aria]').forEach(function (el) { EN[el.dataset.tAria] = el.getAttribute('aria-label'); });
  Object.keys(EXTRA_EN).forEach(function (k) { if (!EN[k]) EN[k] = EXTRA_EN[k]; });

  var lang = store(LANG_KEY) === 'ar' ? 'ar' : 'en';
  function t(key) { var d = lang === 'ar' ? AR : EN; return key in d ? d[key] : EN[key]; }

  function applyLanguage() {
    root.lang = lang === 'ar' ? 'ar' : 'en-CA';
    root.dir = lang === 'ar' ? 'rtl' : 'ltr';
    all('[data-t]').forEach(function (el) { var v = t(el.dataset.t); if (v != null) el.textContent = v; });
    all('[data-t-ph]').forEach(function (el) { el.setAttribute('placeholder', t(el.dataset.tPh)); el.setAttribute('aria-label', t(el.dataset.tPh)); });
    all('[data-t-alt]').forEach(function (el) { el.setAttribute('alt', t(el.dataset.tAlt)); });
    all('[data-t-aria]').forEach(function (el) { el.setAttribute('aria-label', t(el.dataset.tAria)); });
    $('langBtn').setAttribute('aria-label', t('langLong'));
    $('lbPrev').setAttribute('aria-label', t('prev'));
    $('lbNext').setAttribute('aria-label', t('next'));
    $('lbClose').setAttribute('aria-label', t('close'));
    document.title = lang === 'ar' ? 'دروس الخطابة في ميسيساغا | speakUnshaken' : 'Public Speaking Classes in Mississauga | speakUnshaken';
    renderMenuLabel();
    renderTheme();
    renderAccount();
    renderDays();
    if (typeof renderSession === 'function' && SESSIONS) renderSession();
    root.classList.remove('ar-pending');
  }

  function toggleLanguage() {
    lang = lang === 'ar' ? 'en' : 'ar';
    store(LANG_KEY, lang);
    applyLanguage();
  }
  $('langBtn').addEventListener('click', toggleLanguage);
  $('langBtn2').addEventListener('click', function () { toggleLanguage(); setMenu(false); });

  // ---------------------------------------------------------------- theme
  function isDark() { return root.dataset.theme === 'dark'; }
  function renderTheme() {
    var icon = isDark() ? '#i-sun' : '#i-moon';
    var label = isDark() ? t('themeLight') : t('themeDark');
    $('themeBtn').querySelector('use').setAttribute('href', icon);
    $('themeBtn').setAttribute('aria-label', label);
    $('themeBtn').title = label;
    document.querySelector('meta[name="theme-color"]').content = isDark() ? '#141010' : '#F1DDBC';
  }
  function toggleTheme() {
    if (isDark()) delete root.dataset.theme; else root.dataset.theme = 'dark';
    store(THEME_KEY, isDark() ? 'dark' : 'light');
    renderTheme();
  }
  $('themeBtn').addEventListener('click', toggleTheme);


  // ---------------------------------------------------------------- account
  function signedInUser() {
    try { var raw = localStorage.getItem(AUTH_KEY); return raw ? JSON.parse(raw) : null; } catch (_) { return null; }
  }
  // Signed-in visitors get their name and email filled in on the booking form.
  function prefillBooking() {
    var user = signedInUser();
    if (!user) return;
    if (!$('fName').value && user.displayName) $('fName').value = user.displayName;
    if (!$('fContact').value && user.email) $('fContact').value = user.email;
  }

  $('signOutBtn').addEventListener('click', function () {
    try { localStorage.removeItem(AUTH_KEY); } catch (_) {}
    setMenu(false);
    renderAccount();
    window.scrollTo(0, 0);
    notice(t('signedOut'));
  });

  // A short message under the header that fades away on its own.
  function notice(msg) {
    var el = $('notice');
    el.querySelector('span').textContent = msg;
    el.hidden = false;
    requestAnimationFrame(function () { el.classList.add('show'); });
    clearTimeout(el._t);
    el._t = setTimeout(function () {
      el.classList.remove('show');
      setTimeout(function () { el.hidden = true; }, 300);
    }, 3500);
  }
  // Signed out from another page: say so once we're back home.
  try {
    if (sessionStorage.getItem('speakupfearless.signedOut')) {
      sessionStorage.removeItem('speakupfearless.signedOut');
      setTimeout(function () { notice(t('signedOut')); }, 300);
    }
  } catch (_) {}

  function renderAccount() {
    var user = signedInUser();
    // Guests see what's free (the daily challenge) and what needs an account.
    document.documentElement.classList.toggle('signed-in', !!user);
    prefillBooking();
    $('signOutBtn').hidden = !user;
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
  var menuOpenedAt = 0;
  function setMenu(open) {
    if (open) menuOpenedAt = window.scrollY;
    menu.classList.toggle('open', open);
    menuBtn.setAttribute('aria-expanded', String(open));
    renderMenuLabel();
  }
  menuBtn.addEventListener('click', function () { setMenu(!menu.classList.contains('open')); });
  all('#mobileMenu a').forEach(function (a) { a.addEventListener('click', function () { setMenu(false); }); });
  // Tapping anywhere outside the open menu just closes it (without also
  // pressing whatever was underneath).
  document.addEventListener('click', function (e) {
    if (!menu.classList.contains('open')) return;
    if (menu.contains(e.target) || menuBtn.contains(e.target)) return;
    e.preventDefault();
    e.stopPropagation();
    setMenu(false);
  }, true);
  window.addEventListener('scroll', function () {
    if (menu.classList.contains('open') && window.scrollY > menuOpenedAt + 60) setMenu(false);
  }, { passive: true });
  document.addEventListener('keydown', function (e) {
    if (e.key !== 'Escape') return;
    setMenu(false);
    closeLightbox();
    closePrivacy();
  });

  // ---------------------------------------------------------------- page edges
  // iPhones bounce past the ends of the page and show what's behind it.
  // Colour that area like the nearest edge: the hero at the top, the dark
  // footer at the bottom, so no white gap shows up.
  var edgeColour = '';
  function paintEdges() {
    var nearBottom = window.scrollY > (root.scrollHeight - window.innerHeight) / 2;
    var colour = nearBottom ? 'var(--footer)' : 'var(--band)';
    if (colour !== edgeColour) { root.style.backgroundColor = colour; edgeColour = colour; }
  }
  window.addEventListener('scroll', paintEdges, { passive: true });
  paintEdges();

  // ---------------------------------------------------------------- feelings
  // Cards slide in once, and flip to show how the sessions help. The sample
  // coach report fills its score ring and pace bars the same way.
  var feelCards = all('.feelings li').concat(all('.coach-demo'));
  if ('IntersectionObserver' in window) {
    var feelIo = new IntersectionObserver(function (es) {
      es.forEach(function (e) { if (e.isIntersecting) { e.target.classList.add('in'); feelIo.unobserve(e.target); } });
    }, { threshold: .2 });
    feelCards.forEach(function (li) { feelIo.observe(li); });
  } else feelCards.forEach(function (li) { li.classList.add('in'); });
  function flipFeel(li) {
    var on = !li.classList.contains('flip');
    li.classList.toggle('flip', on);
    li.setAttribute('aria-pressed', String(on));
    if (!on) { li.classList.remove('wiggle'); void li.offsetWidth; li.classList.add('wiggle'); }
    track('feeling_flip', { which: li.querySelector('[data-t^="feel"]').dataset.t });
  }
  feelCards.forEach(function (li) {
    li.addEventListener('click', function () { flipFeel(li); });
    li.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); flipFeel(li); } });
  });

  // ---------------------------------------------------------------- skills
  // Skills slide in once, and open to show what they look like in a session.
  var skillCards = all('.skills li');
  if ('IntersectionObserver' in window) {
    var skillIo = new IntersectionObserver(function (es) {
      es.forEach(function (e) {
        if (!e.isIntersecting) return;
        // Staggered once on the way in, then no delay on later taps.
        var li = e.target;
        li.style.transitionDelay = (skillCards.indexOf(li) * 60) + 'ms';
        li.classList.add('in');
        setTimeout(function () { li.style.transitionDelay = ''; }, 900);
        skillIo.unobserve(li);
      });
    }, { threshold: .2 });
    skillCards.forEach(function (li) { skillIo.observe(li); });
  } else skillCards.forEach(function (li) { li.classList.add('in'); });
  // Glide each card from its old height to its new one.
  function glide(change) {
    var before = skillCards.map(function (c) { return c.offsetHeight; });
    change();
    if (matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    skillCards.forEach(function (c, i) {
      var after = c.offsetHeight;
      if (after === before[i]) return;
      c.style.height = before[i] + 'px';
      c.style.overflow = 'hidden';
      void c.offsetHeight;
      c.style.transition = 'height .38s cubic-bezier(.2,.8,.2,1), border-color .2s, box-shadow .2s';
      c.style.height = after + 'px';
      var done = function (e) {
        if (e && e.propertyName !== 'height') return;
        c.style.height = c.style.overflow = c.style.transition = '';
        c.removeEventListener('transitionend', done);
      };
      c.addEventListener('transitionend', done);
      setTimeout(done, 500);
    });
  }
  function toggleSkill(li) {
    var open = !li.classList.contains('open');
    glide(function () {
      skillCards.forEach(function (o) { if (o !== li) { o.classList.remove('open'); o.setAttribute('aria-expanded', 'false'); } });
      li.classList.toggle('open', open);
    });
    li.setAttribute('aria-expanded', String(open));
    if (open) track('skill_open', { which: li.querySelector('b').dataset.t });
  }
  skillCards.forEach(function (li) {
    li.addEventListener('click', function () { toggleSkill(li); });
    li.addEventListener('keydown', function (e) { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); toggleSkill(li); } });
  });

  // ---------------------------------------------------------------- photos
  // ---------------------------------------------------------------- drag to scroll
  // Sideways rows (community photos, games) scroll with a mouse drag too,
  // not only with a trackpad or a finger. A drag never counts as a tap.
  function dragScroll(row) {
    var down = false, moved = false, startX = 0, startLeft = 0;
    row.addEventListener('pointerdown', function (e) {
      if (e.pointerType !== 'mouse' || e.button !== 0) return;
      down = true; moved = false; startX = e.clientX; startLeft = row.scrollLeft;
    });
    window.addEventListener('pointermove', function (e) {
      if (!down) return;
      var dx = e.clientX - startX;
      if (!moved && Math.abs(dx) > 5) { moved = true; row.classList.add('dragging'); }
      if (moved) { row.scrollLeft = startLeft - dx; e.preventDefault(); }
    });
    window.addEventListener('pointerup', function () {
      if (!down) return;
      down = false;
      if (!moved) return;
      // Let the row settle on the nearest photo again.
      var left = row.scrollLeft;
      row.classList.remove('dragging');
      row.scrollLeft = left;
    });
    row.addEventListener('click', function (e) { if (moved) { e.preventDefault(); e.stopPropagation(); moved = false; } }, true);
    row.addEventListener('dragstart', function (e) { e.preventDefault(); });
  }
  all('.strip, .game-row').forEach(dragScroll);
  // Arrow buttons beside the community photos (mouse users).
  (function () {
    var strip = document.querySelector('.strip');
    if (!strip) return;
    var prev = document.querySelector('.strip-nav.prev'), next = document.querySelector('.strip-nav.next');
    var rtl = function () { return document.documentElement.dir === 'rtl'; };
    var step = function (dir) {
      var card = strip.querySelector('button');
      var w = card ? card.getBoundingClientRect().width + 12 : 300;
      strip.scrollBy({ left: dir * (rtl() ? -1 : 1) * w * Math.max(1, Math.floor(strip.clientWidth / w) - 1), behavior: 'smooth' });
    };
    var paint = function () {
      var max = strip.scrollWidth - strip.clientWidth, at = Math.abs(strip.scrollLeft);
      prev.disabled = at < 4;
      next.disabled = at > max - 4;
    };
    prev.addEventListener('click', function () { step(-1); });
    next.addEventListener('click', function () { step(1); });
    strip.addEventListener('scroll', paint, { passive: true });
    window.addEventListener('resize', paint);
    paint();
  })();

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
    $('lbCap').textContent = p.cap ? p.cap.textContent : t('lbT0');
    $('lbDesc').textContent = t('lbD' + lbIndex);
    $('lbCount').textContent = (lbIndex + 1) + ' / ' + photos.length;
    var img = $('lbImg');
    img.style.animation = 'none'; void img.offsetWidth; img.style.animation = '';
  }
  function openLightbox(i) { showPhoto(i); lb.classList.add('open'); document.body.style.overflow = 'hidden'; $('lbClose').focus(); }
  function closeLightbox() { if (!lb.classList.contains('open')) return; lb.classList.remove('open'); document.body.style.overflow = ''; }
  all('[data-photo]').forEach(function (btn, i) {
    btn.setAttribute('aria-label', (btn.querySelector('img') || {}).alt || '');
    btn.addEventListener('click', function () { openLightbox(i); });
  });
  $('lbClose').addEventListener('click', closeLightbox);
  $('lbCta').addEventListener('click', closeLightbox);
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

  // A little bounce, shine and ripple when a game is tapped, then carry on.
  function gameTap(card, e, then) {
    var r = card.getBoundingClientRect();
    var dot = document.createElement('span');
    dot.className = 'g-ripple';
    dot.style.left = ((e.clientX || r.left + r.width / 2) - r.left) + 'px';
    dot.style.top = ((e.clientY || r.top + r.height / 2) - r.top) + 'px';
    card.appendChild(dot);
    setTimeout(function () { dot.remove(); }, 650);
    card.classList.remove('tapped'); void card.offsetWidth; card.classList.add('tapped');
    var calm = matchMedia('(prefers-reduced-motion: reduce)').matches;
    setTimeout(then, calm ? 0 : 280);
  }
  document.addEventListener('click', function (e) {
    var a = e.target.closest && e.target.closest('a.game');
    if (!a || e.metaKey || e.ctrlKey || e.shiftKey) return;
    e.preventDefault();
    // Everyone plays straight away; guests are asked to sign up after a round.
    gameTap(a, e, function () {
      location.href = a.getAttribute('href');
    });
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
  // Marks finished steps with a tick and clears hints as things get filled in.
  function checkChoice() {
    $('stepDay').classList.toggle('done', pickedDay >= 0);
    $('stepTime').classList.toggle('done', pickedTime >= 0);
    if (pickedDay >= 0) { $('dayHint').hidden = true; $('stepDay').classList.remove('need'); $('days').classList.remove('need-box'); }
    if (pickedTime >= 0) { $('timeHint').hidden = true; $('stepTime').classList.remove('need'); document.querySelector('.times').classList.remove('need-box'); }
    var detailsOk = ['fName', 'fContact', 'fPhone', 'fReason'].every(function (id) { return $(id).value.trim(); });
    $('stepDetails').classList.toggle('done', detailsOk);
    if (detailsOk) $('stepDetails').classList.remove('need');
    if (!$('missing').hidden) updateMissing();
  }

  // Lists what is still needed in plain words, e.g. "Just pick a day and add your name."
  function missingItems() {
    var items = [];
    if (pickedDay < 0) items.push(t('mDay'));
    if (pickedTime < 0) items.push(t('mTime'));
    if (!$('fName').value.trim()) items.push(t('mName'));
    if (!emailOk($('fContact').value)) items.push(t('mContact'));
    if (!phoneOk($('fPhone').value)) items.push(t('mPhone'));
    if (!$('fReason').value.trim()) items.push(t('mReason'));
    return items;
  }
  function joinList(items) {
    if (items.length < 2) return items.join('');
    var and = lang === 'ar' ? ' و' : ' and ';
    return items.slice(0, -1).join(lang === 'ar' ? '، ' : ', ') + and + items[items.length - 1];
  }
  function updateMissing() {
    var items = missingItems();
    $('missing').hidden = items.length === 0;
    $('missingText').textContent = items.length ? t('mLead') + ' ' + joinList(items) + (lang === 'ar' ? '.' : '.') : '';
  }

  function preferredTime() {
    var d = days[pickedDay];
    // Always English for the inbox, matching the app.
    var wd = EXTRA_EN.weekdays[(d.getDay() + 6) % 7];
    return wd + ', ' + EXTRA_EN.months[d.getMonth()] + ' ' + d.getDate() + ', ' + EXTRA_EN[timeKeys[pickedTime]];
  }

  function emailOk(v) { return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v.trim()); }
  // Phone numbers use one standard: (416) 555-0123 for Canada and the US
  // (a leading 1 is fine). Numbers starting with + are kept as international.
  function phoneDigits(v) {
    var d = v.replace(/\D/g, '');
    return d.length === 11 && d[0] === '1' ? d.slice(1) : d;
  }
  function phoneOk(v) {
    v = v.trim();
    if (v[0] === '+' && !/^\+1/.test(v)) return v.replace(/\D/g, '').length >= 8 && v.replace(/\D/g, '').length <= 15;
    return phoneDigits(v).length === 10;
  }

  // Where a phone number was registered (area code or country code). People
  // keep numbers when they move, so it's a hint for the inbox, not proof.
  var AREAS = {
    'Toronto, ON': [416, 647, 437], 'GTA (Mississauga, Brampton, Hamilton…), ON': [905, 289, 365, 742],
    'Southwestern Ontario': [519, 226, 548, 382], 'Ottawa & Eastern Ontario': [613, 343, 753],
    'Central & Northern Ontario': [705, 249, 683], 'Northwestern Ontario': [807],
    'Montreal, QC': [514, 438, 263], 'Montreal area, QC': [450, 579, 354], 'Quebec City & Eastern Quebec': [418, 581, 367],
    'Western Quebec': [819, 873, 468], 'Vancouver area, BC': [604, 778, 236, 672], 'British Columbia': [250],
    'Calgary & Southern Alberta': [403, 587, 825, 368], 'Edmonton & Northern Alberta': [780],
    'Saskatchewan': [306, 639, 474], 'Manitoba': [204, 431, 584], 'Nova Scotia / PEI': [902, 782],
    'New Brunswick': [506, 428], 'Newfoundland & Labrador': [709, 879], 'Northern Canada': [867]
  };
  var COUNTRIES = {
    44: 'United Kingdom', 971: 'UAE', 966: 'Saudi Arabia', 20: 'Egypt', 962: 'Jordan', 961: 'Lebanon', 963: 'Syria',
    964: 'Iraq', 965: 'Kuwait', 974: 'Qatar', 973: 'Bahrain', 968: 'Oman', 970: 'Palestine', 212: 'Morocco', 213: 'Algeria',
    216: 'Tunisia', 218: 'Libya', 249: 'Sudan', 967: 'Yemen', 90: 'Turkey', 91: 'India', 92: 'Pakistan', 63: 'Philippines',
    86: 'China', 33: 'France', 49: 'Germany', 39: 'Italy', 34: 'Spain', 31: 'Netherlands', 61: 'Australia', 52: 'Mexico', 55: 'Brazil'
  };
  function phoneArea(raw) {
    var v = raw.trim();
    var d = v.replace(/\D/g, '');
    if (v[0] === '+' && d[0] !== '1') {
      for (var len = 3; len >= 1; len--) { var c = COUNTRIES[d.slice(0, len)]; if (c) return c + ' (+' + d.slice(0, len) + ')'; }
      return 'Outside North America (+' + d.slice(0, 3) + '…)';
    }
    if (d.length === 11 && d[0] === '1') d = d.slice(1);
    if (d.length !== 10) return '';
    var code = +d.slice(0, 3);
    for (var name in AREAS) if (AREAS[name].indexOf(code) >= 0) return name + ' (' + code + ')';
    return 'United States or elsewhere in North America (' + code + ')';
  }

  function formatPhone(v) {
    if (v.trim()[0] === '+' && !/^\s*\+1/.test(v)) return v;
    var d = phoneDigits(v).slice(0, 10);
    if (d.length < 4) return d.length ? '(' + d : '';
    if (d.length < 7) return '(' + d.slice(0, 3) + ') ' + d.slice(3);
    return '(' + d.slice(0, 3) + ') ' + d.slice(3, 6) + '-' + d.slice(6);
  }
  // Formats the number as it's typed, e.g. 4165550123 -> (416) 555-0123.
  $('fPhone').addEventListener('input', function (e) {
    if (e.inputType && e.inputType.indexOf('delete') === 0) return;
    var el = $('fPhone');
    var f = formatPhone(el.value);
    if (f !== el.value) el.value = f;
  });
  // Shows where the number is from as soon as the area code is typed.
  function showArea() {
    var v = $('fPhone').value, d = v.replace(/\D/g, '');
    if (d.length === 11 && d[0] === '1') d = d.slice(1);
    var area = '';
    if (v.trim()[0] === '+' && d[0] !== '1') area = d.length >= 2 ? phoneArea(v) : '';
    else if (d.length >= 3) area = phoneArea((d.slice(0, 3) + '0000000').slice(0, 10));
    $('phoneArea').hidden = !area;
    $('phoneArea').textContent = area;
  }
  $('fPhone').addEventListener('input', showArea);
  $('fPhone').addEventListener('blur', function () { var el = $('fPhone'); if (phoneOk(el.value)) el.value = formatPhone(el.value); });
  function fieldOk(id) {
    var input = $(id);
    var v = input.value.trim();
    var ok = id === 'fContact' ? emailOk(v) : id === 'fPhone' ? phoneOk(v) : v.length > 0;
    var err = input.parentNode.querySelector('.err');
    if (id === 'fContact') err.textContent = v ? t('badEmail') : t('contactRequired');
    if (id === 'fPhone') err.textContent = v ? t('badPhone') : t('phoneRequired');
    input.parentNode.classList.toggle('bad', !ok);
    return ok;
  }
  ['fName', 'fContact', 'fPhone', 'fReason'].forEach(function (id) {
    $(id).addEventListener('input', function () { if ($(id).parentNode.classList.contains('bad')) fieldOk(id); checkChoice(); });
  });

  // ---------------------------------------------------------------- sessions
  var SESSIONS = [
    { id: 'intro', title: 'sIntro', meta: 'sIntroMeta', price: null, icon: '#i-chat' },
    { id: 'single', title: 'sSingle', meta: 'sSingleMeta', price: '$50', icon: '#i-mic' },
    { id: 'four', title: 'sFour', meta: 'sFourMeta', price: '$180', icon: '#i-bolt', tag: ['popular', 'warm'], hot: true },
    { id: 'eight', title: 'sEight', meta: 'sEightMeta', price: '$320', icon: '#i-trophy', tag: ['bestValue', 'soft'] }
  ];
  var pickedSession = 'intro';
  var dd = $('sessionDd');
  var ddList = $('ddList');
  var ddActive = 0;
  var CHECK = '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3.2" stroke-linecap="round" stroke-linejoin="round"><path d="m6 12 4 4 8-8"/></svg>';

  function sessionById(id) { return SESSIONS.filter(function (x) { return x.id === id; })[0] || SESSIONS[0]; }
  function iconHtml(x) { return '<span class="dd-ic' + (x.hot ? ' hot' : '') + '"><svg aria-hidden="true"><use href="' + x.icon + '"/></svg></span>'; }
  function esc(v) { var d = document.createElement('div'); d.textContent = v; return d.innerHTML; }
  function priceHtml(x) { return x.price ? esc(x.price) : esc(t('sFree')); }

  function renderSession() {
    var x = sessionById(pickedSession);
    $('ddIc').outerHTML = iconHtml(x).replace('class="dd-ic', 'id="ddIc" class="dd-ic');
    $('ddTitle').textContent = t(x.title);
    $('ddMeta').textContent = t(x.meta);
    $('ddPrice').innerHTML = priceHtml(x);
    $('ddPrice').classList.toggle('is-free', !x.price);
    ddList.innerHTML = SESSIONS.map(function (o, i) {
      var tag = o.tag ? '<span class="tag ' + o.tag[1] + '">' + esc(t(o.tag[0])) + '</span>' : '';
      return '<li class="dd-opt' + (i === ddActive ? ' active' : '') + '" role="option" id="dd-' + o.id + '" data-id="' + o.id + '" aria-selected="' + (o.id === pickedSession) + '">' +
        iconHtml(o) + '<span class="dd-txt"><b>' + esc(t(o.title)) + tag + '</b><small>' + esc(t(o.meta)) + '</small></span>' +
        '<span class="dd-price' + (o.price ? '' : ' is-free') + '">' + priceHtml(o) + '</span><span class="dd-check">' + CHECK + '</span></li>';
    }).join('');
  }
  function setDd(open) {
    dd.classList.toggle('open', open);
    ddList.hidden = !open;
    $('ddBtn').setAttribute('aria-expanded', String(open));
    if (open) {
      ddActive = Math.max(0, SESSIONS.indexOf(sessionById(pickedSession)));
      renderSession();
      ddList.setAttribute('aria-activedescendant', 'dd-' + SESSIONS[ddActive].id);
      ddList.focus({ preventScroll: true });
    }
  }
  function pickSession(id, flash) {
    pickedSession = sessionById(id).id;
    renderSession();
    if (flash) { dd.classList.remove('flash'); void dd.offsetWidth; dd.classList.add('flash'); }
  }
  $('ddBtn').addEventListener('click', function () { setDd(!dd.classList.contains('open')); });
  ddList.addEventListener('click', function (e) {
    var li = e.target.closest('.dd-opt');
    if (!li) return;
    pickSession(li.dataset.id);
    setDd(false);
    $('ddBtn').focus();
  });
  ddList.addEventListener('keydown', function (e) {
    if (e.key === 'ArrowDown' || e.key === 'ArrowUp') {
      e.preventDefault();
      ddActive = (ddActive + (e.key === 'ArrowDown' ? 1 : -1) + SESSIONS.length) % SESSIONS.length;
      renderSession();
      ddList.setAttribute('aria-activedescendant', 'dd-' + SESSIONS[ddActive].id);
    } else if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      pickSession(SESSIONS[ddActive].id);
      setDd(false);
      $('ddBtn').focus();
    } else if (e.key === 'Escape' || e.key === 'Tab') {
      setDd(false);
    }
  });
  document.addEventListener('click', function (e) { if (dd.classList.contains('open') && !dd.contains(e.target)) setDd(false); });

  // Package buttons pick that session in the booking form.
  all('[data-plan]').forEach(function (a) {
    a.addEventListener('click', function () { pickSession(a.dataset.plan, true); });
  });

  $('bookForm').addEventListener('submit', function (e) {
    e.preventDefault();
    var dayOk = pickedDay >= 0, timeOk = pickedTime >= 0;
    var fieldsOk = [fieldOk('fName'), fieldOk('fContact'), fieldOk('fPhone'), fieldOk('fReason')].every(Boolean);
    if (!(dayOk && timeOk && fieldsOk)) {
      // Show exactly what is missing, right where it is, and say it in one line by the button.
      var need = [];
      if (!dayOk) need.push([$('stepDay'), $('days'), $('dayHint')]);
      if (!timeOk) need.push([$('stepTime'), document.querySelector('.times'), $('timeHint')]);
      need.forEach(function (n) {
        n[0].classList.add('need');
        n[2].hidden = false;
        n[1].classList.remove('need-box'); void n[1].offsetWidth; n[1].classList.add('need-box');
      });
      if (!fieldsOk) $('stepDetails').classList.add('need');
      $('missing').hidden = true; void $('missing').offsetWidth;
      updateMissing();
      track('booking_incomplete', { missing: missingItems().length });
      var first = need.length ? need[0][0] : document.querySelector('.field.bad input, .field.bad textarea');
      if (first) first.scrollIntoView({ block: 'center', behavior: 'smooth' });
      if (!need.length && first && first.focus) first.focus({ preventScroll: true });
      return;
    }
    $('missing').hidden = true;
    var req = {
      name: $('fName').value.trim(),
      email: $('fContact').value.trim(),
      phone: $('fPhone').value.trim(),
      reason: $('fReason').value.trim(),
      description: $('fDesc').value.trim(),
      requestedCourse: pickedSession,
      requestedLabel: EN[sessionById(pickedSession).title] + (sessionById(pickedSession).price ? ' (' + sessionById(pickedSession).price + ')' : ''),
      preferredTime: preferredTime()
    };
    var subject = (req.requestedCourse === 'intro' ? EXTRA_EN.subject : 'Session request: ' + req.requestedLabel) + ', ' + req.preferredTime;
    var payload = {
      _subject: subject, _template: 'table', _captcha: 'false',
      'Requested session': req.requestedLabel, 'Preferred time': req.preferredTime,
      'Name': req.name, 'Email': req.email, 'Phone': req.phone, 'Phone area': phoneArea(req.phone) || '—', 'Reason': req.reason
    };
    if (req.description) payload['More details'] = req.description;
    req.contact = req.email + ' / ' + req.phone;
    var visitorEmail = req.email;
    if (visitorEmail) {
      // FormSubmit emails this message to the address in the "email" field.
      payload.email = visitorEmail;
      payload._autoresponse = confirmationText(req);
    }
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
        track('booking_sent', { session: req.requestedCourse });
        if (sent) {
          $('sentMail').hidden = !visitorEmail;
          $('bookForm').hidden = true;
          $('sent').hidden = false;
          $('bookCard').scrollIntoView({ block: 'center', behavior: 'smooth' });
          return;
        }
        // Fall back to an email draft so the request isn't lost.
        var body = 'Hi! I would like to book: ' + req.requestedLabel + '\n\n' +
          'Preferred time: ' + req.preferredTime + '\nName: ' + req.name + '\nEmail: ' + req.email + '\nPhone: ' + req.phone + (phoneArea(req.phone) ? ' (' + phoneArea(req.phone) + ')' : '') +
          '\nReason: ' + req.reason + '\n' + (req.description ? '\nMore details:\n' + req.description + '\n' : '');
        $('sendErr').classList.add('show');
        location.href = 'mailto:' + CONTACT_EMAIL + '?subject=' + encodeURIComponent(subject) + '&body=' + encodeURIComponent(body);
      });
  });

  function localTime() {
    var d = days[pickedDay];
    return weekday(d) + ' ' + d.getDate() + ' ' + t('months')[d.getMonth()] + '، ' + t(timeKeys[pickedTime]);
  }

  // A friendly copy for the visitor, in the language they used.
  function confirmationText(req) {
    var first = req.name.split(' ')[0];
    if (lang === 'ar') {
      return 'مرحبًا ' + first + '،\n\nشكرًا لتواصلك مع speakUnshaken! وصلنا طلبك:\n\n' +
        t(sessionById(req.requestedCourse).title) + '\n' + localTime() + '\n\n' +
        'سنرد عليك قريبًا لتأكيد الموعد. إن احتجت إلى تغيير أي شيء، فقط رد على هذه الرسالة أو اتصل بنا على 5347-995 (416).\n\n' +
        'نتطلع للقائك!\nفريق speakUnshaken';
    }
    return 'Hi ' + first + ',\n\nThanks for reaching out to speakUnshaken! We got your request:\n\n' +
      req.requestedLabel + '\n' + req.preferredTime + '\n\n' +
      "We'll get back to you soon to confirm your time. If anything changes, just reply to this email or call us at (416) 995-5347.\n\n" +
      'Looking forward to meeting you!\nThe speakUnshaken team';
  }

  function saveToBackend(req) {
    var body = { name: req.name, contact: req.contact, preferredTime: req.preferredTime, reason: req.reason, requestedCourse: req.requestedCourse };
    if (req.description) body.description = req.description;
    function post(b) {
      return fetch(API_BASE + '/v1/bookings', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(b),
        keepalive: true
      });
    }
    try {
      post(body).then(function (r) {
        // Older API versions reject unknown fields; save the rest anyway.
        if (r.status === 400) { delete body.requestedCourse; return post(body); }
      }).catch(function () {});
    } catch (_) {}
  }

  $('stepSession').classList.add('done');

  // The reason box grows with what's typed.
  function grow() { var el = $('fReason'); el.style.height = 'auto'; el.style.height = el.scrollHeight + 2 + 'px'; }
  $('fReason').addEventListener('input', grow);
  window.addEventListener('resize', grow);

  $('moreBtn').addEventListener('click', function () {
    $('descField').hidden = false;
    $('moreBtn').hidden = true;
    $('fDesc').focus();
  });

  $('again').addEventListener('click', function () {
    $('bookForm').reset();
    prefillBooking();
    pickedDay = -1;
    pickedTime = -1;
    all('.time').forEach(function (o) { o.setAttribute('aria-pressed', 'false'); });
    renderDays();
    all('.step').forEach(function (s) { s.classList.remove('done', 'need'); });
    $('missing').hidden = true;
    pickSession('intro');
    $('descField').hidden = true;
    $('moreBtn').hidden = false;
    $('sent').hidden = true;
    $('bookForm').hidden = false;
  });

  // ---------------------------------------------------------------- tracking
  // Counts in Vercel Analytics: which buttons people tap and how many send a request.
  function track(name, data) {
    try { if (window.va) window.va('event', { name: name, data: data || {} }); } catch (_) {}
  }
  document.addEventListener('click', function (e) {
    var el = e.target.closest('[data-cta], [data-track], [data-plan], a.game');
    if (!el) return;
    if (el.dataset.cta) track('book_click', { where: el.dataset.cta });
    else if (el.dataset.plan) track('package_click', { session: el.dataset.plan });
    else if (el.dataset.track) track(el.dataset.track);
    else track('game_click', { game: (el.dataset.game || el.getAttribute('href')).split('/').pop() });
  }, true);

  // ---------------------------------------------------------------- sticky CTA
  // Shown on phones once the hero is out of view, hidden near the form.
  var sticky = $('stickyCta');
  if ('IntersectionObserver' in window) {
    var heroOut = false;
    var bookIn = false;
    var footIn = false;
    var priceIn = false;
    var gamesIn = false;
    // Hidden near the form, the footer, the free-call card (which has its own
    // button) and the games, so it never covers the daily challenge card.
    var update = function () { sticky.classList.toggle('show', heroOut && !bookIn && !footIn && !priceIn && !gamesIn); };
    new IntersectionObserver(function (es) { gamesIn = es[0].isIntersecting; update(); }, { rootMargin: '0px 0px -12% 0px' }).observe($('games'));
    var free = document.querySelector('.free');
    if (free) new IntersectionObserver(function (es) { priceIn = es[0].isIntersecting; update(); }).observe(free);
    new IntersectionObserver(function (es) { heroOut = !es[0].isIntersecting; update(); }).observe($('top'));
    new IntersectionObserver(function (es) { bookIn = es[0].isIntersecting; update(); }, { rootMargin: '0px 0px -20% 0px' }).observe($('book'));
    new IntersectionObserver(function (es) { footIn = es[0].isIntersecting; update(); }).observe(document.querySelector('footer'));
    document.body.classList.add('has-sticky');
  }

  applyLanguage();
})();
