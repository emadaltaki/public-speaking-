import 'package:flutter/foundation.dart';

/// All user-facing copy. Widgets should read from here instead of literals.
class Translations {
  Translations._();

  /// Current language code: 'en' or 'ar'. The app rebuilds when it changes.
  static final ValueNotifier<String> language = ValueNotifier('en');

  static bool get isArabic => language.value == 'ar';

  /// Picks the English or Arabic text for the current language.
  static String l(String en, String ar) => isArabic ? ar : en;
  static String _l(String en, String ar) => l(en, ar);

  static String playerName(int n) => _l('Player $n', 'اللاعب $n');
  static String get yourOwnTopic => _l('Your Own Topic', 'موضوعك الخاص');
  static String youSpokeFor(String clock) =>
      _l('You spoke for $clock.', 'تحدثت لمدة $clock.');
  static String turnOf(String name) => _l("$name's turn", 'دور $name');
  static String finishedSentences(int n) =>
      _l('You finished $n sentences.', 'أكملت $n جمل.');
  static String timeRemaining(String clock) =>
      _l('Time remaining $clock', 'الوقت المتبقي $clock');
  static String spokenFor(String clock) =>
      _l('Spoken for $clock', 'مدة الحديث $clock');
  static String newWord(String word) =>
      _l('New word: $word', 'كلمة جديدة: $word');
  static String pitchOf(int level, String description) => _l(
    'Pitch $level of 10, $description',
    'طبقة الصوت $level من 10، $description',
  );
  static String isSpeaking(String name) =>
      _l('$name is speaking', '$name يتحدث الآن');
  static String wordSetName(String set) => isArabic
      ? const {
              'General': 'عام',
              'Business': 'أعمال',
              'Nature': 'طبيعة',
              'Food': 'طعام',
              'Travel': 'سفر',
              'Technology': 'تقنية',
              'Mixed': 'منوّعة',
              'Funny': 'مضحكة',
              'Everyday': 'يومية',
              'Work & School': 'العمل والدراسة',
              'Big Questions': 'أسئلة كبيرة',
            }[set] ??
            set
      : set;

  /// "1 minute", "2 minutes", "1:30 min".
  static String timerLabel(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    if (s != 0) {
      return _l(
        '$m:${s.toString().padLeft(2, '0')} min',
        '$m:${s.toString().padLeft(2, '0')} د',
      );
    }
    if (isArabic) {
      return m == 1 ? 'دقيقة واحدة' : (m == 2 ? 'دقيقتان' : '$m دقائق');
    }
    return m == 1 ? '1 minute' : '$m minutes';
  }

  static String seconds(int n) => _l('${n}s', '$n ث');

  /// Short label for tight spaces such as the phone header.
  static String get languageToggleShort => isArabic ? 'EN' : 'ع';

  static String get accountSignIn => _l('Sign in', 'تسجيل الدخول');
  static String get accountCreate => _l('Create account', 'إنشاء حساب');
  static String get accountTitle => _l('Your account', 'حسابك');
  static String get accountSignOut => _l('Sign out', 'تسجيل الخروج');
  static String get accountSignedOutTitle =>
      _l('Save your progress', 'احفظ تقدّمك');
  static String get accountSignedOutBody => _l(
    'Sign in to play the games and keep a history of every round.',
    'سجّل الدخول لتلعب الألعاب وتحتفظ بسجل كل جولة.',
  );
  static String get accountRounds => _l('Rounds played', 'الجولات');
  static String get accountSpeakingTime => _l('Speaking time', 'وقت الحديث');
  static String get accountByGame => _l('By game', 'حسب اللعبة');
  static String get accountRecent => _l('Recent rounds', 'آخر الجولات');
  static String get accountNoHistory => _l(
    'No rounds yet. Play a game and it will show up here.',
    'لا توجد جولات بعد. العب لعبة وستظهر هنا.',
  );
  static String roundsCount(int n) => isArabic
      ? (n == 1 ? 'جولة واحدة' : '$n جولات')
      : (n == 1 ? '1 round' : '$n rounds');
  static String minutesShort(int n) => _l('$n min', '$n د');

  static String get themeLight => _l('Light theme', 'المظهر الفاتح');
  static String get themeDark => _l('Dark theme', 'المظهر الداكن');

  static String get gamesGateTitle => _l('Sign up to play', 'سجّل لتلعب');
  static String get gamesGateBody => _l(
    'Create a free account to unlock all our speaking games and keep track of your practice.',
    'أنشئ حسابًا مجانيًا لتفتح جميع ألعاب التحدث وتتابع تدريبك.',
  );
  static String get gamesGateSignUp =>
      _l('Create free account', 'أنشئ حسابًا مجانيًا');
  static String get gamesGateSignIn =>
      _l('I already have an account', 'لدي حساب بالفعل');

  static String get languageToggle => isArabic ? 'English' : 'العربية';

  static const String siteName = 'Speak Up Fearless';
  static String get pageTitle => _l(
    'Public Speaking Classes in Mississauga | Speak Up Fearless',
    'دروس الخطابة في ميسيساغا | Speak Up Fearless',
  );

  /// Online scheduling page (Calendly, Cal.com, ...) for the free intro call.
  /// Leave empty to fall back to an email draft.
  static const String bookingUrl = '';

  static String get emailFallbackTitle =>
      _l('Opening your email app…', 'جارٍ فتح تطبيق البريد…');
  static String get emailFallbackBody => _l(
    "If nothing opens, email us at speakupfearless@gmail.com or call (416) 995-5347.",
    'إن لم يُفتح شيء، راسلنا على speakupfearless@gmail.com أو اتصل على 5347-995 (416).',
  );
  static String get emailFallbackCopy => _l('Copy email', 'نسخ البريد');

  static String get photoViewerClose => _l('Close photo', 'إغلاق الصورة');
  static String get photoViewerPrevious =>
      _l('Previous photo', 'الصورة السابقة');
  static String get photoViewerNext => _l('Next photo', 'الصورة التالية');
  static String get photoViewerHint => _l(
    'Pinch, scroll or double-tap to zoom',
    'قرّب بإصبعين أو بالتمرير أو بالنقر مرتين',
  );
  static String get photoEnlarge => _l('View larger', 'عرض أكبر');
  static String get heroPhotoCaption =>
      _l('Learning by doing', 'نتعلّم بالممارسة');

  static String get pricingIncludes => _l(
    'Every session includes guided speaking practice, constructive feedback and confidence-building exercises in a supportive group.',
    'كل جلسة تشمل تدريبًا موجّهًا على التحدث، وملاحظات بنّاءة، وتمارين لبناء الثقة ضمن مجموعة داعمة.',
  );

  static String get bookingHeadline =>
      _l('Book Your Free Intro Call', 'احجز مكالمتك التعريفية المجانية');
  static String get bookingIntro => _l(
    "Pick a day and time that suits you. We'll reply to confirm.",
    'اختر اليوم والوقت المناسبين لك، وسنرد عليك للتأكيد.',
  );
  static String get bookingFormTitle =>
      _l('Choose a time for your free call', 'اختر وقتًا لمكالمتك المجانية');
  static String get bookingPickDay => _l('Pick a day', 'اختر يومًا');
  static String get bookingPickTime => _l('Pick a time', 'اختر وقتًا');
  static String get bookingTimeMorning =>
      _l('Morning (9am–12pm)', 'صباحًا (من 9 إلى 12)');
  static String get bookingTimeAfternoon =>
      _l('Afternoon (12–5pm)', 'ظهرًا (من 12 إلى 5)');
  static String get bookingTimeEvening =>
      _l('Evening (5–9pm)', 'مساءً (من 5 إلى 9)');
  static String get bookingChoiceRequired =>
      _l('Please pick a day and a time.', 'يرجى اختيار يوم ووقت.');
  static String get bookingYourDetails => _l('Your details', 'بياناتك');
  static String get bookingContactLabel =>
      _l('Email or phone', 'البريد أو الهاتف');
  static String get bookingContactRequired => _l(
    'Please add an email or phone number.',
    'يرجى إضافة بريد إلكتروني أو رقم هاتف.',
  );
  static String get bookingReasonLabel =>
      _l('Why are you booking?', 'ما سبب الحجز؟');
  static String get bookingReasonHint => _l(
    'e.g. I get nervous presenting at work',
    'مثلًا: أتوتر عند تقديم العروض في العمل',
  );
  static String get bookingReasonRequired =>
      _l('Please tell us why you are booking.', 'يرجى إخبارنا بسبب الحجز.');
  static String get bookingDescriptionLabel => _l(
    'Anything else to share? (optional)',
    'هل تريد إضافة شيء آخر؟ (اختياري)',
  );
  static String get bookingDescriptionHint => _l(
    'For example: what makes speaking hard for you, or what you hope to work on.',
    'مثلًا: ما الذي يصعّب عليك التحدث، أو ما الذي تأمل أن تتدرب عليه.',
  );
  static String get bookingSubmit => _l('Send Request', 'أرسل الطلب');
  static String get bookingSending => _l('Sending…', 'جارٍ الإرسال…');
  static String get bookingNote => _l(
    "Your request comes straight to us. We'll reply to confirm your time.",
    'يصلنا طلبك مباشرة، وسنرد عليك لتأكيد الموعد.',
  );
  static String get bookingSentTitle => _l('Request sent!', 'تم إرسال الطلب!');
  static String get bookingSentBody => _l(
    "Thanks! We'll get back to you soon to confirm your time.",
    'شكرًا لك! سنتواصل معك قريبًا لتأكيد الموعد.',
  );
  static String get bookingSendAnother =>
      _l('Request another time', 'اطلب موعدًا آخر');
  static String get bookingSendFailed => _l(
    "We couldn't send it from here, so we opened an email with your request instead.",
    'لم نتمكن من الإرسال من هنا، لذلك فتحنا رسالة بريد تحتوي على طلبك.',
  );
  static String get bookingEmailSubject =>
      _l('Free intro call request', 'طلب مكالمة تعريفية مجانية');
  static String get bookingPreferToTalk =>
      _l('Prefer to talk first?', 'تفضّل التحدث أولًا؟');

  static String get navGames => _l('Games', 'الألعاب');
  static String get gamesBackToSite => _l('Back to site', 'العودة إلى الموقع');
  static String get gamesEyebrow => _l('Practice anywhere', 'تدرّب في أي مكان');
  static String get gamesTitle => _l('Speaking Games', 'ألعاب الخطابة');
  static String get gamesIntro => _l(
    'Quick games to build speaking confidence, on your own or with friends.',
    'ألعاب سريعة لبناء الثقة في التحدث، وحدك أو مع أصدقائك.',
  );
  static String get gamesComingSoon => _l('COMING SOON', 'قريبًا');
  static String get gamesPlay => _l('Play', 'العب');
  static String get gamesHowToPlay => _l('How to play', 'طريقة اللعب');
  static String get gamesGotIt => _l('Got it!', 'فهمت!');
  static String get gamesImReady => _l("I'M READY", 'أنا جاهز');
  static String get gamesCueReady => _l('Ready?', 'مستعد؟');
  static String get gamesCueSet => _l('Set.', 'استعد.');
  static String get gamesCueGo => _l('Go!', 'انطلق!');

  static String get tripleStepSetupSubtitle =>
      _l('Set up your training round', 'جهّز جولة التدريب');
  static String get tripleStepBackToGames =>
      _l('Back to games', 'العودة إلى الألعاب');
  static String get tripleStepSingle => _l('Single Player', 'لاعب واحد');
  static String get tripleStepMulti => _l('Multiplayer', 'عدة لاعبين');
  static String get tripleStepPlayers => _l('Players', 'اللاعبون');
  static String get tripleStepAddPlayer => _l('Add player', 'أضف لاعبًا');
  static String get tripleStepRemovePlayer =>
      _l('Remove player', 'احذف اللاعب');
  static String get tripleStepTopics => _l('Number of topics', 'عدد الكلمات');
  static String get tripleStepTopicsHelp => _l(
    'How many surprise words will pop up while you speak.',
    'كم كلمة مفاجئة ستظهر أثناء حديثك.',
  );
  static String get tripleStepTimer => _l('Timer', 'المؤقت');
  static String get tripleStepSuggestTitle =>
      _l('Suggest a title', 'اقترح عنوانًا');
  static String get tripleStepSuggestTitleHelp => _l(
    'Get a random speech topic, or turn off to choose your own.',
    'احصل على موضوع عشوائي، أو أوقفه لتختار موضوعك بنفسك.',
  );
  static String get tripleStepSurvival => _l('Survival mode', 'وضع التحدّي');
  static String get tripleStepSurvivalHelp => _l(
    'Words keep coming at the same pace until you get stuck.',
    'تستمر الكلمات بالظهور بالسرعة نفسها حتى تتوقف.',
  );
  static String get tripleStepWordSet => _l('Word set', 'مجموعة الكلمات');
  static String get tripleStepStart => _l('START TRAINING', 'ابدأ التدريب');
  static String get tripleStepBackToSettings =>
      _l('Back to settings', 'العودة إلى الإعدادات');
  static String get tripleStepInstruction => _l(
    'Keep speaking on this topic. Work each new word into your speech as it appears.',
    'واصل الحديث عن هذا الموضوع، وأدخل كل كلمة جديدة في كلامك فور ظهورها.',
  );
  static String get tripleStepSurvivalInstruction => _l(
    'Words keep coming. Work each one in and see how long you can last.',
    'الكلمات لا تتوقف. أدخل كل واحدة في كلامك وانظر كم تصمد.',
  );
  static String get tripleStepPause => _l('Pause', 'إيقاف مؤقت');
  static String get tripleStepResume => _l('Resume', 'متابعة');
  static String get tripleStepFinish => _l('Finish', 'إنهاء');
  static String get tripleStepWords => _l('Your words', 'كلماتك');
  static String get tripleStepSpokenFor => _l('speaking time', 'مدة الحديث');
  static String get tripleStepStuck => _l("I'm stuck", 'توقفت');
  static String get tripleStepNextWordIn =>
      _l('Next word in', 'الكلمة التالية بعد');
  static String get tripleStepFirstWordSoon => _l(
    'Start speaking. Your first word is on its way…',
    'ابدأ الحديث. كلمتك الأولى في الطريق…',
  );
  static String get tripleStepNew => _l('NEW', 'جديد');
  static String get tripleStepComingUp => _l('Coming up…', 'قادمة…');
  static String get tripleStepTimeUp => _l("Time's up!", 'انتهى الوقت!');
  static String get tripleStepRoundEnded =>
      _l('Round finished', 'انتهت الجولة');
  static String get tripleStepEveryoneWent =>
      _l('Everyone has had a turn', 'الجميع أخذ دوره');
  static String get tripleStepNextPlayer => _l('Next', 'التالي');
  static String get tripleStepNewGame => _l('New game', 'لعبة جديدة');
  static String get tripleStepNextTopic => _l('Next topic', 'الموضوع التالي');
  static String get tripleStepRetry => _l('Retry', 'أعد المحاولة');
  static String get tripleStepSettings => _l('Settings', 'الإعدادات');

  static String get conductorSetupSubtitle =>
      _l('Train your vocal range', 'درّب مدى صوتك');
  static String get conductorReadyHint => _l(
    'When the number changes, change your pitch: 1 is low, 10 is high. Keep talking the whole time.',
    'عندما يتغيّر الرقم غيّر طبقة صوتك: 1 منخفض و10 مرتفع. استمر في الحديث طوال الوقت.',
  );
  static String get conductorPitch => _l('Pitch', 'طبقة الصوت');
  static String get conductorTopic => _l('Topic', 'الموضوع');
  static String get conductorPaused => _l(
    'Paused. Press play to continue.',
    'متوقف مؤقتًا. اضغط تشغيل للمتابعة.',
  );
  static String get conductorLevelLow => _l('Low and deep', 'منخفض وعميق');
  static String get conductorLevelLowMid => _l('Low and calm', 'منخفض وهادئ');
  static String get conductorLevelMid => _l('Natural voice', 'صوت طبيعي');
  static String get conductorLevelHighMid =>
      _l('Bright and lifted', 'مشرق ومرتفع قليلًا');
  static String get conductorLevelHigh => _l('High and bright', 'مرتفع ومشرق');

  static String get podcastDifficulty => _l('Difficulty', 'الصعوبة');
  static String get podcastDifficultyHelp => _l(
    'How often the microphone jumps to someone else.',
    'كم مرة ينتقل الميكروفون إلى شخص آخر.',
  );
  static String get podcastPlayers => _l('Number of players', 'عدد اللاعبين');
  static String get podcastNext => _l('NEXT', 'التالي');
  static String get podcastBackToRules =>
      _l('Back to settings', 'العودة إلى الإعدادات');
  static String get podcastWhoIsPlaying => _l("Who's playing?", 'من يلعب؟');
  static String get podcastReadyHint => _l(
    'Everyone talks about this topic. When your name shows up, it is your turn to speak.',
    'الجميع يتحدث عن هذا الموضوع. عندما يظهر اسمك يحين دورك للكلام.',
  );
  static String get podcastNowSpeaking => _l('Now speaking', 'يتحدث الآن');
  static String get podcastEnd =>
      _l('Great conversation, everyone!', 'حوار رائع يا جماعة!');

  static String get autocompleteSubtitle => _l('Rapid fire', 'أسئلة سريعة');
  static String get autocompleteSecondsPerRound =>
      _l('How long per round?', 'مدة كل جولة؟');
  static String get autocompleteRounds =>
      _l('How many rounds?', 'عدد الجولات؟');
  static String get autocompletePhraseSet => _l('Sentence set', 'مجموعة الجمل');
  static String get autocompleteReadyHint => _l(
    'Finish each sentence out loud before the timer runs out. Any answer works!',
    'أكمل كل جملة بصوت عالٍ قبل انتهاء المؤقت. أي إجابة مقبولة!',
  );
  static String get autocompleteNext => _l('Next', 'التالي');
  static String get autocompleteDone => _l('All done!', 'انتهينا!');
  static String get autocompletePlayAgain => _l('Play again', 'العب مجددًا');

  static String get footerPrivacy => _l('Privacy Policy', 'سياسة الخصوصية');
  static String get privacyTitle => _l('Privacy Policy', 'سياسة الخصوصية');
  static String get privacyClose => _l('Close', 'إغلاق');
  static String get privacyBody => _l(
    'Speak Up Fearless respects your privacy.\n\n'
        'What we collect: this website does not store anything you type. When you request a time through the booking form, your name, email or phone, and preferred time are sent to us by email through FormSubmit (formsubmit.co), a form-forwarding service. If you email or call us, we receive your name, contact details, and whatever you choose to share.\n\n'
        'How we use it: only to reply to you, arrange sessions, and keep in touch about sessions you have asked about. We never sell or rent your information.\n\n'
        'Website statistics: we may use privacy-friendly, cookie-free analytics that count visits without identifying you.\n\n'
        'Your choices: you can ask us at any time to see, correct, or delete the information we hold about you by emailing speakupfearless@gmail.com.\n\n'
        "We follow Canada's Personal Information Protection and Electronic Documents Act (PIPEDA).",
    'تحترم Speak Up Fearless خصوصيتك.\n\nما نجمعه: لا يحفظ هذا الموقع أي شيء تكتبه. عندما تطلب موعدًا عبر نموذج الحجز، يُرسل إلينا اسمك وبريدك أو هاتفك والوقت المفضّل عبر البريد من خلال خدمة FormSubmit (formsubmit.co) لإعادة توجيه النماذج. وإذا راسلتنا أو اتصلت بنا، نتلقى اسمك وبيانات التواصل وما تختار مشاركته.\n\nكيف نستخدمها: فقط للرد عليك وترتيب الجلسات والتواصل بخصوص الجلسات التي سألت عنها. لا نبيع معلوماتك ولا نؤجّرها أبدًا.\n\nإحصاءات الموقع: قد نستخدم أدوات تحليل تحترم الخصوصية ولا تستخدم ملفات تعريف الارتباط، تحسب الزيارات دون التعرف عليك.\n\nخياراتك: يمكنك في أي وقت أن تطلب الاطلاع على معلوماتك لدينا أو تصحيحها أو حذفها بمراسلة speakupfearless@gmail.com.\n\nنلتزم بقانون حماية المعلومات الشخصية والوثائق الإلكترونية الكندي (PIPEDA).',
  );
  static const String contactEmail = 'speakupfearless@gmail.com';

  /// Inbox that receives booking requests sent from the site.
  static const String bookingInboxEmail = 'speakupunshaken@gmail.com';
  static const String mailtoUri = 'mailto:speakupfearless@gmail.com';
  static const String contactPhoneDisplay = '(416) 995-5347';
  static const String telUri = 'tel:+14169955347';
  static String get contactJoinSubject => _l(
    'Speak Up Fearless: I would like to join',
    'Speak Up Fearless: أرغب في الانضمام',
  );

  static String get skipToContent => _l('Skip to content', 'انتقل إلى المحتوى');
  static String get openMenu => _l('Open menu', 'افتح القائمة');
  static String get closeMenu => _l('Close menu', 'أغلق القائمة');

  static String get navHome => _l('Home', 'الرئيسية');
  static String get navWhy => _l('Why We Do This', 'لماذا نفعل هذا');
  static String get navSessions => _l('Sessions', 'الجلسات');
  static String get navCommunity => _l('Our Community', 'مجتمعنا');
  static String get navFaq => _l('FAQ', 'الأسئلة الشائعة');
  static String get navContact => _l('Contact', 'تواصل معنا');
  static String get navJoinUs => _l('Join Us', 'انضم إلينا');

  static String get ctaLearnSessions =>
      _l('Learn About Our Sessions', 'تعرّف على جلساتنا');
  static String get ctaEmailUs => _l('Email Us', 'راسلنا');
  static String get ctaCallUs => _l('Call Us', 'اتصل بنا');

  static String get heroHeadline => _l(
    "You Don't Have to Be Fearless to Speak.",
    'لست بحاجة لأن تكون بلا خوف لكي تتحدث.',
  );
  static String get heroSupport => _l(
    "Public speaking anxiety is normal. Practice with a supportive group in Mississauga and build real confidence, one step at a time.",
    'القلق من التحدث أمام الناس أمر طبيعي. تدرّب مع مجموعة داعمة في ميسيساغا وابنِ ثقة حقيقية، خطوة بخطوة.',
  );
  static String get heroTrust => _l(
    'A supportive space to practice. No judgment. No pressure. Just progress.',
    'مساحة داعمة للتدرّب. بلا أحكام. بلا ضغط. تقدّم فقط.',
  );
  static String get heroImageAlt => _l(
    'A host leading a Speak Up Fearless workshop in front of a small group',
    'مضيف يقود ورشة Speak Up Fearless أمام مجموعة صغيرة',
  );
  static String get heroLocation => _l(
    'Now meeting in Mississauga, Ontario',
    'نلتقي الآن في ميسيساغا، أونتاريو',
  );
  static String get heroBadgeTitle =>
      _l('Everyone participates', 'الجميع يشارك');
  static String get heroBadgeBody =>
      _l('Mistakes are part of learning.', 'الأخطاء جزء من التعلّم.');

  static String get eyebrowWhy => _l("You're not alone", 'لست وحدك');
  static String get eyebrowHow => _l('The process', 'الطريقة');
  static String get eyebrowSessions => _l('What we practice', 'ماذا نتدرّب');
  static String get eyebrowPricing => _l('Pricing', 'الأسعار');
  static String get eyebrowCommunity => _l('In the room', 'من داخل القاعة');
  static String get eyebrowHosts => _l('Meet your hosts', 'تعرّف على المضيفين');
  static String get eyebrowFaq => _l('Questions & answers', 'أسئلة وأجوبة');
  static String get eyebrowContact => _l('Get in touch', 'تواصل معنا');

  static String get anxietyHeadline => _l(
    "If Speaking Makes You Nervous, You're Not Alone.",
    'إن كان التحدث يوترك، فأنت لست وحدك.',
  );
  static String get anxietyCard1 =>
      _l('My heart starts racing.', 'قلبي يبدأ بالخفقان بسرعة.');
  static String get anxietyCard2 => _l(
    'I overthink everything I want to say.',
    'أفكّر كثيرًا في كل ما أريد قوله.',
  );
  static String get anxietyCard3 =>
      _l("I'm afraid people will judge me.", 'أخاف أن يحكم عليّ الناس.');
  static String get anxietyCard4 => _l(
    "I know what I want to say, but I freeze.",
    'أعرف ما أريد قوله، لكنني أتجمّد.',
  );
  static String get anxietyHuman => _l(
    "These feelings don't mean you're bad at speaking. They mean you're human.",
    'هذه المشاعر لا تعني أنك سيئ في التحدث، بل تعني أنك إنسان.',
  );

  static String get missionStepSpeak => _l('Speak', 'تحدّث');
  static String get missionStepPractice => _l('Practice', 'تدرّب');
  static String get missionStepReflect => _l('Reflect', 'تأمّل');
  static String get missionStepImprove => _l('Improve', 'تحسّن');
  static String get missionStepGrow => _l('Grow', 'انمُ');

  static String get howHeadline => _l('How It Works', 'كيف تعمل');
  static String get how1Title => _l('Show Up', 'احضر');
  static String get how1Body => _l(
    'Join a welcoming session where everyone is learning.',
    'انضم إلى جلسة ترحيبية يتعلّم فيها الجميع.',
  );
  static String get how2Title => _l('Speak', 'تحدّث');
  static String get how2Body => _l(
    'Practice speaking in a supportive environment.',
    'تدرّب على التحدث في بيئة داعمة.',
  );
  static String get how3Title => _l('Reflect', 'تأمّل');
  static String get how3Body => _l(
    'Learn what worked and where you can improve.',
    'تعرّف على ما نجح وأين يمكنك التحسّن.',
  );
  static String get how4Title => _l('Grow', 'انمُ');
  static String get how4Body => _l(
    'Build confidence through repetition and community.',
    'ابنِ ثقتك بالتكرار وبالمجتمع.',
  );

  static String get sessionsHeadline =>
      _l('Practice Without the Pressure.', 'تدرّب بلا ضغط.');
  static String get sessionsIntro => _l(
    'A regular place to practice speaking. Community and skills, not clinical treatment.',
    'مكان منتظم للتدرّب على التحدث. مجتمع ومهارات، وليس علاجًا سريريًا.',
  );
  static String get sessionPracticeTitle =>
      _l('Speaking Practice', 'التدرّب على التحدث');
  static String get sessionPracticeBody => _l(
    'Practice expressing ideas clearly and confidently.',
    'تدرّب على التعبير عن أفكارك بوضوح وثقة.',
  );
  static String get sessionImpromptuTitle =>
      _l('Impromptu Speaking', 'الحديث الارتجالي');
  static String get sessionImpromptuBody => _l(
    "Learn how to think and respond when you're put on the spot.",
    'تعلّم كيف تفكر وتجيب عندما تُفاجأ بسؤال.',
  );
  static String get sessionStoryTitle => _l('Storytelling', 'سرد القصص');
  static String get sessionStoryBody => _l(
    'Learn how to turn experiences and ideas into engaging stories.',
    'تعلّم كيف تحوّل تجاربك وأفكارك إلى قصص مشوّقة.',
  );
  static String get sessionFeedbackTitle =>
      _l('Feedback & Growth', 'الملاحظات والتطوّر');
  static String get sessionFeedbackBody => _l(
    'Receive constructive feedback in a supportive environment.',
    'احصل على ملاحظات بنّاءة في بيئة داعمة.',
  );
  static String get sessionChallengeTitle =>
      _l('Confidence Challenges', 'تحدّيات الثقة');
  static String get sessionChallengeBody => _l(
    'Small challenges designed to gradually push comfort zones.',
    'تحدّيات صغيرة مصمّمة لتوسيع منطقة راحتك تدريجيًا.',
  );

  static String get pricingHeadline => _l(
    'Start Where You Are. Grow From There.',
    'ابدأ من حيث أنت. وانمُ من هناك.',
  );
  static String get pricingSupport => _l(
    "Start with a free call. Continue only when you're ready.",
    'ابدأ بمكالمة مجانية، وتابع فقط عندما تكون مستعدًا.',
  );
  static String get pricingCurrencyNote =>
      _l('Prices are in CAD (\$).', 'الأسعار بالدولار الكندي (\$).');
  static String get pricingIntroBadge => _l('FREE', 'مجاني');
  static String get pricingIntroTitle =>
      _l('Free Online Explanation Session', 'جلسة تعريفية مجانية عبر الإنترنت');
  static const String pricingIntroPrice = '\$0';
  static String get pricingIntroMeta => _l(
    '15–20 minutes · online video call',
    '15–20 دقيقة · مكالمة فيديو عبر الإنترنت',
  );
  static String get pricingIntroDesc => _l(
    'Meet a host and see how sessions work. No speaking required, no pressure to join.',
    'قابل أحد المضيفين وتعرّف على طريقة الجلسات. لا يُطلب منك التحدث، ولا ضغط للانضمام.',
  );
  static String get pricingIntroCta =>
      _l('Book a Free Explanation Session', 'احجز جلسة تعريفية مجانية');
  static String get pricingIntroFeatureMeet =>
      _l('Meet a host', 'قابل أحد المضيفين');
  static String get pricingIntroFeatureUnderstand =>
      _l('Understand how sessions work', 'افهم كيف تعمل الجلسات');
  static String get pricingIntroFeatureFit => _l(
    'See if it feels right, with no commitment',
    'تأكد إن كانت مناسبة لك دون أي التزام',
  );
  static String get pricingSingleTitle => _l('Single Session', 'جلسة واحدة');
  static const String pricingSinglePrice = '\$50';
  static String get pricingSingleMeta =>
      _l('1 speaking session', 'جلسة تحدّث واحدة');
  static String get pricingSingleDesc => _l(
    'A great way to experience Speak Up Fearless and take your first step.',
    'طريقة رائعة لتجربة Speak Up Fearless واتخاذ خطوتك الأولى.',
  );
  static String get pricingSingleCta =>
      _l('Start With One Session', 'ابدأ بجلسة واحدة');
  static String get pricingFourTitle => _l('4-Session Package', 'باقة 4 جلسات');
  static String get pricingFourBadge => _l('MOST POPULAR', 'الأكثر طلبًا');
  static const String pricingFourWas = '\$200';
  static const String pricingFourPrice = '\$180';
  static String get pricingFourSave =>
      _l('Save \$20 · 10% OFF', 'وفّر 20\$ · خصم 10%');
  static String get pricingFourPer => _l('\$45 per session', '45\$ للجلسة');
  static String get pricingFourDesc => _l(
    'Build consistency and give yourself more opportunities to practice, reflect, and grow.',
    'ابنِ الاستمرارية وامنح نفسك فرصًا أكثر للتدرّب والتأمل والنمو.',
  );
  static String get pricingFourCta =>
      _l('Build Consistency', 'ابنِ الاستمرارية');
  static String get pricingEightTitle =>
      _l('8-Session Package', 'باقة 8 جلسات');
  static String get pricingEightBadge => _l('BEST VALUE', 'أفضل قيمة');
  static const String pricingEightWas = '\$400';
  static const String pricingEightPrice = '\$320';
  static String get pricingEightSave =>
      _l('Save \$80 · 20% OFF', 'وفّر 80\$ · خصم 20%');
  static String get pricingEightPer => _l('\$40 per session', '40\$ للجلسة');
  static String get pricingEightDesc => _l(
    'Build momentum through regular practice and make speaking confidence part of your routine.',
    'اكتسب الزخم بالتدرّب المنتظم واجعل الثقة في التحدث جزءًا من روتينك.',
  );
  static String get pricingEightCta => _l('Build Momentum', 'اكتسب الزخم');
  static String get pricingFeatureGuided =>
      _l('Guided speaking practice', 'تدريب موجّه على التحدث');
  static String get pricingFeatureSupportive =>
      _l('Supportive environment', 'بيئة داعمة');
  static String get pricingFeatureFeedback =>
      _l('Constructive feedback', 'ملاحظات بنّاءة');
  static String get pricingFeatureExercises =>
      _l('Confidence-building exercises', 'تمارين لبناء الثقة');
  static String get pricingFeatureFourSessions =>
      _l('4 speaking sessions', '4 جلسات تحدّث');
  static String get pricingFeatureEightSessions =>
      _l('8 speaking sessions', '8 جلسات تحدّث');

  static String get galleryHeadline => _l('Our Community', 'مجتمعنا');
  static String get galleryIntro => _l(
    'Real sessions, real people, finding their voice together.',
    'جلسات حقيقية وأشخاص حقيقيون، يجدون صوتهم معًا.',
  );
  static String get galleryCaption1 => _l('Practicing together', 'نتدرّب معًا');
  static String get galleryCaption2 => _l('Finding your voice', 'نجد صوتنا');
  static String get galleryCaption3 =>
      _l('Learning through feedback', 'نتعلّم من الملاحظات');
  static String get galleryCaption4 =>
      _l('Learning by doing', 'نتعلّم بالممارسة');
  static String get galleryCaption5Fixed =>
      _l('Workshops that feel human', 'ورش عمل إنسانية');
  static String get galleryCaption6 => _l('Behind the scenes', 'خلف الكواليس');
  static String get galleryAlt1 => _l(
    'Members seated around a long table, watching a facilitator introduce a speaking exercise',
    'أعضاء جالسون حول طاولة طويلة يشاهدون الميسّر وهو يقدّم تمرين تحدّث',
  );
  static String get galleryAlt2 => _l(
    'A member speaking to the room in front of a slide for the Podcast speaking game',
    'عضو يتحدث أمام القاعة بجانب شريحة لعبة البودكاست',
  );
  static String get galleryAlt3 => _l(
    'A facilitator pointing to the Triple Step exercise on screen while participants follow along',
    'ميسّر يشير إلى تمرين Triple Step على الشاشة بينما يتابع المشاركون',
  );
  static String get galleryAlt4 => _l(
    'A host presenting the "Let\'s Learn by Doing" ground rules to the group',
    'مضيف يعرض قواعد "لنتعلّم بالممارسة" على المجموعة',
  );
  static String get galleryAlt5 => _l(
    'Three people at the front of the room during a speaking game, with the group watching',
    'ثلاثة أشخاص في مقدمة القاعة خلال لعبة تحدّث والمجموعة تشاهد',
  );
  static String get galleryAlt6 => _l(
    'A candid moment just after a speaking game, with the group still laughing along',
    'لحظة عفوية بعد لعبة تحدّث والمجموعة ما زالت تضحك',
  );

  static String get testimonialsHeadline =>
      _l('The People Behind the Sessions.', 'الأشخاص وراء الجلسات.');
  static String get testimonialPlaceholderLabel => _l('Placeholder', 'مثال');
  static String get testimonialEmadQuote => _l(
    'I know what it feels like to have something worth saying and freeze anyway. Speak Up Fearless is the room I wanted back then. You practice first, and confidence follows.',
    'أعرف شعور أن يكون لديك ما يستحق القول ثم تتجمّد رغم ذلك. Speak Up Fearless هو المكان الذي تمنّيته حينها. تتدرّب أولًا، ثم تأتي الثقة.',
  );
  static const String testimonialEmadName = 'Emad';
  static String get testimonialEmadRole =>
      _l('Co-Founder and Host', 'شريك مؤسس ومضيف');
  static String get testimonialEliasQuote => _l(
    'Nobody here waits until they feel ready. We show up, we speak, we give each other honest and kind feedback, and everyone leaves knowing what to work on next.',
    'لا أحد هنا ينتظر حتى يشعر بالاستعداد. نحضر، ونتحدث، ونقدّم لبعضنا ملاحظات صادقة ولطيفة، ويغادر الجميع وهم يعرفون ما يعملون عليه بعد ذلك.',
  );
  static const String testimonialEliasName = 'Elias';
  static String get testimonialEliasRole =>
      _l('Co-Founder and Host', 'شريك مؤسس ومضيف');
  static String get testimonialEmadPhotoAlt =>
      _l('Portrait of Emad, founder and host', 'صورة عماد، المؤسس والمضيف');
  static String get testimonialEliasPhotoAlt => _l(
    'Portrait of Elias, co-founder and host',
    'صورة إلياس، الشريك المؤسس والمضيف',
  );

  static String get trust1 => _l('No experience required', 'لا تحتاج إلى خبرة');
  static String get trust2 =>
      _l('No need to be naturally confident', 'لا تحتاج أن تكون واثقًا بطبعك');
  static String get trust3 => _l('Supportive environment', 'بيئة داعمة');
  static String get trust4 =>
      _l('Practice at your own pace', 'تدرّب بالسرعة التي تناسبك');
  static String get trust5 => _l('Constructive feedback', 'ملاحظات بنّاءة');
  static String get trust6 =>
      _l('Community over competition', 'مجتمع لا منافسة');
  static String get trust7 =>
      _l('Everyone starts somewhere', 'الجميع يبدأ من مكان ما');

  static String get faqHeadline => _l('FAQ', 'الأسئلة الشائعة');
  static String get faqQ1 => _l(
    'Do I need public speaking experience?',
    'هل أحتاج إلى خبرة في التحدث أمام الناس؟',
  );
  static String get faqA1 => _l(
    'No. We welcome people who are just starting. You do not need to feel confident before you join. The community is how confidence grows.',
    'لا. نرحّب بمن يبدأ للتو. لا تحتاج أن تشعر بالثقة قبل الانضمام، فالمجتمع هو ما ينمّي الثقة.',
  );
  static String get faqQ2 =>
      _l("What if I'm extremely nervous?", 'ماذا لو كنت متوترًا جدًا؟');
  static String get faqA2 => _l(
    "Then you're in the right place. Nervousness is common here. We normalize it, understand it, and practice speaking through it together.",
    'إذًا أنت في المكان الصحيح. التوتر أمر شائع هنا. نتقبّله ونفهمه ونتدرّب على التحدث رغمه معًا.',
  );
  static String get faqQ3 => _l(
    'Do I have to speak during my first session?',
    'هل عليّ التحدث في جلستي الأولى؟',
  );
  static String get faqA3 => _l(
    "We'll explain what a typical session looks like when you reach out, and you can start at a pace that feels manageable. There is no pressure to perform.",
    'سنشرح لك كيف تبدو الجلسة المعتادة عندما تتواصل معنا، ويمكنك البدء بالسرعة التي تناسبك. لا ضغط عليك للأداء.',
  );
  static String get faqQ4 => _l('Who can join?', 'من يمكنه الانضمام؟');
  static String get faqA4 => _l(
    'Anyone who wants a supportive space to practice speaking. If you are not sure whether it is a fit, email us and we will help you decide.',
    'كل من يريد مساحة داعمة للتدرّب على التحدث. إن لم تكن متأكدًا من مناسبتها لك، راسلنا وسنساعدك على القرار.',
  );
  static String get faqQ5 =>
      _l('How often are sessions held?', 'كم مرة تُعقد الجلسات؟');
  static String get faqQ7 => _l(
    'What happens during a typical session?',
    'ماذا يحدث خلال الجلسة المعتادة؟',
  );
  static String get faqA7 => _l(
    'Sessions focus on practice, reflection, and constructive feedback in a supportive environment. We will walk you through the flow before you join.',
    'تركّز الجلسات على التدرّب والتأمل والملاحظات البنّاءة في بيئة داعمة. سنشرح لك سير الجلسة قبل انضمامك.',
  );
  static String get faqQ8 => _l('How much does it cost?', 'كم التكلفة؟');
  static String get faqQ9 => _l(
    'Can I talk to you before joining a session?',
    'هل يمكنني التحدث معكم قبل الانضمام إلى جلسة؟',
  );
  static String get faqA9 => _l(
    'Yes. We offer a free online explanation session so you can talk with a host, understand what we do, and ask questions. There is no speaking required and no pressure to join.',
    'نعم. نقدّم جلسة تعريفية مجانية عبر الإنترنت لتتحدث مع أحد المضيفين وتفهم ما نفعله وتطرح أسئلتك. لا يُطلب منك التحدث ولا ضغط للانضمام.',
  );

  static String get contactNameLabel => _l('Name', 'الاسم');
  static String get contactNameRequired =>
      _l('Please enter your name.', 'يرجى إدخال اسمك.');
  static String get contactFormNote => _l(
    'Sending this form opens your email app with a drafted message. Nothing is sent until you hit send there.',
    'إرسال هذا النموذج يفتح تطبيق البريد برسالة جاهزة. لن يُرسل شيء حتى تضغط إرسال هناك.',
  );
  static String get contactNoBackend => _l(
    "Email isn't connected as a server yet. Use Email Us, or send the drafted message from your email app.",
    'البريد غير متصل بخادم بعد. استخدم "راسلنا"، أو أرسل الرسالة الجاهزة من تطبيق البريد.',
  );

  static String get footerBlurb => _l(
    'A supportive community helping people become more comfortable, confident, and courageous speakers.',
    'مجتمع داعم يساعد الناس ليصبحوا متحدثين أكثر راحة وثقة وشجاعة.',
  );
  static String get footerMission => _l('Our Mission', 'رسالتنا');
  static String get footerCommunity => _l('Community', 'المجتمع');
  static String get footerExplore => _l('Explore', 'استكشف');
  static String get footerContactLabel => _l('Contact', 'تواصل');
  static String get footerCopyright => _l(
    '© 2026 Speak Up Fearless. All rights reserved.',
    '© 2026 Speak Up Fearless. جميع الحقوق محفوظة.',
  );
}
