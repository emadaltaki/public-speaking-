/// All user-facing copy. Widgets should read from here instead of literals.
class Translations {
  Translations._();

  static const String siteName = 'Speak Up Fearless';
  static const String pageTitle =
      'Public Speaking Classes in Mississauga | Speak Up Fearless';

  /// Online scheduling page (Calendly, Cal.com, ...) for the free intro call.
  /// Leave empty to fall back to an email draft.
  static const String bookingUrl = '';

  static const String emailFallbackTitle = 'Opening your email app…';
  static const String emailFallbackBody =
      "If nothing opens, email us at speakupfearless@gmail.com or call (416) 995-5347.";
  static const String emailFallbackCopy = 'Copy email';
  static const String emailCopied = 'Email address copied.';

  static const String photoViewerClose = 'Close photo';
  static const String photoViewerPrevious = 'Previous photo';
  static const String photoViewerNext = 'Next photo';
  static const String photoViewerHint = 'Pinch, scroll or double-tap to zoom';
  static const String photoEnlarge = 'View larger';
  static const String heroPhotoCaption = 'Learning by doing';

  static const String pricingIncludes =
      'Every session includes guided speaking practice, constructive feedback and confidence-building exercises in a supportive group.';

  static const String bookingHeadline = 'Book Your Free Intro Call';
  static const String bookingIntro =
      "Pick a day and time that suits you. We'll reply to confirm.";
  static const String bookingFormTitle = 'Choose a time for your free call';
  static const String bookingPickDay = 'Pick a day';
  static const String bookingPickTime = 'Pick a time';
  static const String bookingTimeMorning = 'Morning (9am–12pm)';
  static const String bookingTimeAfternoon = 'Afternoon (12–5pm)';
  static const String bookingTimeEvening = 'Evening (5–9pm)';
  static const String bookingChoiceRequired = 'Please pick a day and a time.';
  static const String bookingYourDetails = 'Your details';
  static const String bookingContactLabel = 'Email or phone';
  static const String bookingContactRequired =
      'Please add an email or phone number.';
  static const String bookingDescriptionLabel =
      'Anything you would like us to know? (optional)';
  static const String bookingDescriptionHint =
      'For example: what makes speaking hard for you, or what you hope to work on.';
  static const String bookingSubmit = 'Send Request';
  static const String bookingSending = 'Sending…';
  static const String bookingNote =
      "Your request comes straight to us. We'll reply to confirm your time.";
  static const String bookingSentTitle = 'Request sent!';
  static const String bookingSentBody =
      "Thanks! We'll get back to you soon to confirm your time.";
  static const String bookingSendAnother = 'Request another time';
  static const String bookingSendFailed =
      "We couldn't send it from here, so we opened an email with your request instead.";
  static const String bookingEmailSubject = 'Free intro call request';
  static const String bookingPreferToTalk = 'Prefer to talk first?';

  static const String navGames = 'Games';
  static const String gamesBackToSite = 'Back to site';
  static const String gamesEyebrow = 'Practice anywhere';
  static const String gamesTitle = 'Speaking Games';
  static const String gamesIntro =
      'Quick games to build speaking confidence, on your own or with friends.';
  static const String gamesComingSoon = 'COMING SOON';
  static const String gamesPlay = 'Play';

  static const String tripleStepSetupSubtitle = 'Set up your training round';
  static const String tripleStepBackToGames = 'Back to games';
  static const String tripleStepSingle = 'Single Player';
  static const String tripleStepMulti = 'Multiplayer';
  static const String tripleStepPlayers = 'Players';
  static const String tripleStepAddPlayer = 'Add player';
  static const String tripleStepRemovePlayer = 'Remove player';
  static const String tripleStepTopics = 'Number of topics';
  static const String tripleStepTopicsHelp =
      'How many surprise words will pop up while you speak.';
  static const String tripleStepTimer = 'Timer';
  static const String tripleStepSuggestTitle = 'Suggest a title';
  static const String tripleStepSuggestTitleHelp =
      'Get a random speech topic, or turn off to choose your own.';
  static const String tripleStepSurvival = 'Survival mode';
  static const String tripleStepSurvivalHelp =
      'Words keep coming at the same pace until you get stuck.';
  static const String tripleStepWordSet = 'Word set';
  static const String tripleStepStart = 'START TRAINING';
  static const String tripleStepBackToSettings = 'Back to settings';
  static const String tripleStepInstruction =
      'Keep speaking on this topic. Work each new word into your speech as it appears.';
  static const String tripleStepSurvivalInstruction =
      'Words keep coming. Work each one in and see how long you can last.';
  static const String tripleStepPause = 'Pause';
  static const String tripleStepResume = 'Resume';
  static const String tripleStepFinish = 'Finish';
  static const String tripleStepWords = 'Your words';
  static const String tripleStepSpokenFor = 'speaking time';
  static const String tripleStepStuck = "I'm stuck";
  static const String tripleStepNextWordIn = 'Next word in';
  static const String tripleStepFirstWordSoon =
      'Start speaking. Your first word is on its way…';
  static const String tripleStepNew = 'NEW';
  static const String tripleStepComingUp = 'Coming up…';
  static const String tripleStepTimeUp = "Time's up!";
  static const String tripleStepRoundEnded = 'Round finished';
  static const String tripleStepEveryoneWent = 'Everyone has had a turn';
  static const String tripleStepNextPlayer = 'Next';
  static const String tripleStepNewGame = 'New game';
  static const String tripleStepNextTopic = 'Next topic';
  static const String tripleStepRetry = 'Retry';
  static const String tripleStepSettings = 'Settings';

  static const String footerPrivacy = 'Privacy Policy';
  static const String privacyTitle = 'Privacy Policy';
  static const String privacyClose = 'Close';
  static const String privacyBody =
      'Speak Up Fearless respects your privacy.\n\n'
      'What we collect: this website does not store anything you type. When you request a time through the booking form, your name, email or phone, and preferred time are sent to us by email through FormSubmit (formsubmit.co), a form-forwarding service. If you email or call us, we receive your name, contact details, and whatever you choose to share.\n\n'
      'How we use it: only to reply to you, arrange sessions, and keep in touch about sessions you have asked about. We never sell or rent your information.\n\n'
      'Website statistics: we may use privacy-friendly, cookie-free analytics that count visits without identifying you.\n\n'
      'Your choices: you can ask us at any time to see, correct, or delete the information we hold about you by emailing speakupfearless@gmail.com.\n\n'
      "We follow Canada's Personal Information Protection and Electronic Documents Act (PIPEDA).";
  static const String contactEmail = 'speakupfearless@gmail.com';

  /// Inbox that receives booking requests sent from the site.
  static const String bookingInboxEmail = 'speakupunshaken@gmail.com';
  static const String mailtoUri = 'mailto:speakupfearless@gmail.com';
  static const String contactPhoneDisplay = '(416) 995-5347';
  static const String telUri = 'tel:+14169955347';

  static const String skipToContent = 'Skip to content';
  static const String openMenu = 'Open menu';
  static const String closeMenu = 'Close menu';

  static const String navHome = 'Home';
  static const String navWhy = 'Why We Do This';
  static const String navSessions = 'Sessions';
  static const String navCommunity = 'Our Community';
  static const String navFaq = 'FAQ';
  static const String navContact = 'Contact';
  static const String navJoinUs = 'Join Us';

  static const String ctaJoin = 'Join the Community';
  static const String ctaStartJourney = 'Start Your Journey';
  static const String ctaTalkToUs = 'Talk to Us';
  static const String ctaReadyToSpeak = "I'm Ready to Speak";
  static const String ctaLearnSessions = 'Learn About Our Sessions';
  static const String ctaEmailUs = 'Email Us';
  static const String ctaCallUs = 'Call Us';
  static const String ctaSendMessage = 'Send Message';

  static const String heroHeadline = "You Don't Have to Be Fearless to Speak.";
  static const String heroSupport =
      "Public speaking anxiety is normal. Practice with a supportive group in Mississauga and build real confidence, one step at a time.";
  static const String heroTrust =
      'A supportive space to practice. No judgment. No pressure. Just progress.';
  static const String heroImageAlt =
      'A host leading a Speak Up Fearless workshop in front of a small group';
  static const String heroLocation = 'Now meeting in Mississauga, Ontario';
  static const String heroBadgeTitle = 'Everyone participates';
  static const String heroBadgeBody = 'Mistakes are part of learning.';

  static const String eyebrowWhy = "You're not alone";
  static const String eyebrowMission = 'Our mission';
  static const String eyebrowHow = 'The process';
  static const String eyebrowSessions = 'What we practice';
  static const String eyebrowPricing = 'Pricing';
  static const String eyebrowCommunity = 'In the room';
  static const String eyebrowHosts = 'Meet your hosts';
  static const String eyebrowTrust = 'Why it works';
  static const String eyebrowExpect = 'Next steps';
  static const String eyebrowFaq = 'Questions & answers';
  static const String eyebrowContact = 'Get in touch';

  static const String anxietyHeadline =
      "If Speaking Makes You Nervous, You're Not Alone.";
  static const String anxietyCard1 = 'My heart starts racing.';
  static const String anxietyCard2 = 'I overthink everything I want to say.';
  static const String anxietyCard3 = "I'm afraid people will judge me.";
  static const String anxietyCard4 = "I know what I want to say, but I freeze.";
  static const String anxietyHuman =
      "These feelings don't mean you're bad at speaking. They mean you're human.";
  static const String anxietyFollow =
      'Our goal isn\'t to tell you to "just be confident." We create opportunities to practice in a supportive environment so confidence can grow naturally.';

  static const String missionHeadline = "We're Here to Normalize Anxiety.";
  static const String missionP1 =
      'Public speaking anxiety is extremely common, yet many people feel like they\'re the only ones experiencing it.';
  static const String missionP2 = 'Speak Up Fearless exists to change that.';
  static const String missionP3 =
      'We believe people shouldn\'t have to wait until they "feel confident" before they start speaking.';
  static const String missionInstead = 'Instead:';
  static const String missionStepSpeak = 'Speak';
  static const String missionStepPractice = 'Practice';
  static const String missionStepReflect = 'Reflect';
  static const String missionStepImprove = 'Improve';
  static const String missionStepGrow = 'Grow';
  static const String missionQuote =
      "Confidence isn't the absence of anxiety. It's knowing you can move forward even when anxiety shows up.";

  static const String howHeadline = 'How It Works';
  static const String how1Title = 'Show Up';
  static const String how1Body =
      'Join a welcoming session where everyone is learning.';
  static const String how2Title = 'Speak';
  static const String how2Body =
      'Practice speaking in a supportive environment.';
  static const String how3Title = 'Reflect';
  static const String how3Body = 'Learn what worked and where you can improve.';
  static const String how4Title = 'Grow';
  static const String how4Body =
      'Build confidence through repetition and community.';

  static const String sessionsHeadline = 'Practice Without the Pressure.';
  static const String sessionsIntro =
      'A regular place to practice speaking. Community and skills, not clinical treatment.';
  static const String sessionPracticeTitle = 'Speaking Practice';
  static const String sessionPracticeBody =
      'Practice expressing ideas clearly and confidently.';
  static const String sessionImpromptuTitle = 'Impromptu Speaking';
  static const String sessionImpromptuBody =
      "Learn how to think and respond when you're put on the spot.";
  static const String sessionStoryTitle = 'Storytelling';
  static const String sessionStoryBody =
      'Learn how to turn experiences and ideas into engaging stories.';
  static const String sessionFeedbackTitle = 'Feedback & Growth';
  static const String sessionFeedbackBody =
      'Receive constructive feedback in a supportive environment.';
  static const String sessionChallengeTitle = 'Confidence Challenges';
  static const String sessionChallengeBody =
      'Small challenges designed to gradually push comfort zones.';

  static const String pricingHeadline = 'Start Where You Are. Grow From There.';
  static const String pricingSupport =
      "Start with a free call. Continue only when you're ready.";
  static const String pricingCurrencyNote = 'Prices are in CAD (\$).';
  static const String pricingIntroBadge = 'FREE';
  static const String pricingIntroTitle = 'Free Online Explanation Session';
  static const String pricingIntroPrice = '\$0';
  static const String pricingIntroMeta = '15–20 minutes · online video call';
  static const String pricingIntroDesc =
      'Meet a host and see how sessions work. No speaking required, no pressure to join.';
  static const String pricingIntroCta = 'Book a Free Explanation Session';
  static const String pricingIntroFeatureMeet = 'Meet a host';
  static const String pricingIntroFeatureUnderstand =
      'Understand how sessions work';
  static const String pricingIntroFeatureFit =
      'See if it feels like a fit — no commitment';
  static const String pricingIntroEmailSubject =
      'Speak Up Fearless — free explanation session';
  static const String pricingIntroEmailBody =
      'Hi — I would like to book a free online explanation session to understand how Speak Up Fearless works.';
  static const String pricingSingleTitle = 'Single Session';
  static const String pricingSinglePrice = '\$50';
  static const String pricingSingleMeta = '1 speaking session';
  static const String pricingSingleDesc =
      'A great way to experience Speak Up Fearless and take your first step.';
  static const String pricingSingleCta = 'Start With One Session';
  static const String pricingFourTitle = '4-Session Package';
  static const String pricingFourBadge = 'MOST POPULAR';
  static const String pricingFourWas = '\$200';
  static const String pricingFourPrice = '\$180';
  static const String pricingFourSave = 'Save \$20 · 10% OFF';
  static const String pricingFourPer = '\$45 per session';
  static const String pricingFourDesc =
      'Build consistency and give yourself more opportunities to practice, reflect, and grow.';
  static const String pricingFourCta = 'Build Consistency';
  static const String pricingEightTitle = '8-Session Package';
  static const String pricingEightBadge = 'BEST VALUE';
  static const String pricingEightWas = '\$400';
  static const String pricingEightPrice = '\$320';
  static const String pricingEightSave = 'Save \$80 · 20% OFF';
  static const String pricingEightPer = '\$40 per session';
  static const String pricingEightDesc =
      'Build momentum through regular practice and make speaking confidence part of your routine.';
  static const String pricingEightCta = 'Build Momentum';
  static const String pricingFeatureGuided = 'Guided speaking practice';
  static const String pricingFeatureSupportive = 'Supportive environment';
  static const String pricingFeatureFeedback = 'Constructive feedback';
  static const String pricingFeatureExercises = 'Confidence-building exercises';
  static const String pricingFeatureFourSessions = '4 speaking sessions';
  static const String pricingFeatureEightSessions = '8 speaking sessions';
  static const String pricingTablePackage = 'Package';
  static const String pricingTableTotal = 'Total';
  static const String pricingTableSavings = 'Savings';
  static const String pricingTablePer = 'Per Session';
  static const String pricingTableDash = '—';
  static const String pricingReassureTitle =
      "Not sure you're ready for a package? That's okay.";
  static const String pricingReassureBody =
      'Start with a free explanation session, or try one paid session. There is no pressure to commit to more.';
  static const String pricingCtaHeadline = 'Ready to take the first step?';
  static const String pricingCtaBody =
      "Book a free explanation session, choose a session package, or reach out if you have questions. We're happy to help you find the right place to start.";

  static const String galleryHeadline = 'Our Community';
  static const String galleryIntro =
      'Real sessions, real people, finding their voice together.';
  static const String galleryCaption1 = 'Practicing together';
  static const String galleryCaption2 = 'Finding your voice';
  static const String galleryCaption3 = 'Learning through feedback';
  static const String galleryCaption4 = 'Learning by doing';
  static const String galleryCaption5Fixed = 'Workshops that feel human';
  static const String galleryCaption6 = 'Behind the scenes';
  static const String galleryAlt1 =
      'Members seated around a long table, watching a facilitator introduce a speaking exercise';
  static const String galleryAlt2 =
      'A member speaking to the room in front of a slide for the Podcast speaking game';
  static const String galleryAlt3 =
      'A facilitator pointing to the Triple Step exercise on screen while participants follow along';
  static const String galleryAlt4 =
      'A host presenting the "Let\'s Learn by Doing" ground rules to the group';
  static const String galleryAlt5 =
      'Three people at the front of the room during a speaking game, with the group watching';
  static const String galleryAlt6 =
      'A candid moment just after a speaking game, with the group still laughing along';

  static const String testimonialsHeadline = 'The People Behind the Sessions.';
  static const String testimonialsIntro =
      'We run every session ourselves. Here is why we started, and what we are trying to build with the people who show up.';
  static const String testimonialPlaceholderLabel = 'Placeholder';
  static const String testimonialEmadQuote =
      'I know what it feels like to have something worth saying and freeze anyway. Speak Up Fearless is the room I wanted back then — you practice first, and confidence follows.';
  static const String testimonialEmadName = 'Emad';
  static const String testimonialEmadRole = 'Co-Founder and Host';
  static const String testimonialEliasQuote =
      'Nobody here waits until they feel ready. We show up, we speak, we give each other honest and kind feedback, and everyone leaves knowing what to work on next.';
  static const String testimonialEliasName = 'Elias';
  static const String testimonialEliasRole = 'Co-Founder and Host';
  static const String testimonialEmadPhotoAlt =
      'Portrait of Emad, founder and host';
  static const String testimonialEliasPhotoAlt =
      'Portrait of Elias, co-founder and host';

  static const String trustHeadline = 'A Place Where You Can Start Small.';
  static const String trust1 = 'No experience required';
  static const String trust2 = 'No need to be naturally confident';
  static const String trust3 = 'Supportive environment';
  static const String trust4 = 'Practice at your own pace';
  static const String trust5 = 'Constructive feedback';
  static const String trust6 = 'Community over competition';
  static const String trust7 = 'Everyone starts somewhere';

  static const String expectHeadline = 'What Happens When You Reach Out?';
  static const String expect1Title = 'Step 1';
  static const String expect1Body =
      'Email us and ask for a free online explanation session.';
  static const String expect2Title = 'Step 2';
  static const String expect2Body = "We'll respond and answer your questions.";
  static const String expect3Title = 'Step 3';
  static const String expect3Body =
      "We'll hop on a short call and walk through how our sessions work.";
  static const String expect4Title = 'Step 4';
  static const String expect4Body = "You decide when you're ready to join.";
  static const String expectReassure =
      'No pressure. No awkward sales call. Just a conversation.';

  static const String faqHeadline = 'FAQ';
  static const String faqQ1 = 'Do I need public speaking experience?';
  static const String faqA1 =
      'No. We welcome people who are just starting. You do not need to feel confident before you join — the community is how confidence grows.';
  static const String faqQ2 = "What if I'm extremely nervous?";
  static const String faqA2 =
      "Then you're in the right place. Nervousness is common here. We normalize it, understand it, and practice speaking through it — together.";
  static const String faqQ3 = 'Do I have to speak during my first session?';
  static const String faqA3 =
      "We'll explain what a typical session looks like when you reach out, and you can start at a pace that feels manageable. There is no pressure to perform.";
  static const String faqQ4 = 'Who can join?';
  static const String faqA4 =
      'Anyone who wants a supportive space to practice speaking. If you are not sure whether it is a fit, email us and we will help you decide.';
  static const String faqQ5 = 'How often are sessions held?';
  static const String faqA5 =
      "We'll share the current schedule when you get in touch, so you have accurate dates rather than outdated information here.";
  static const String faqQ6 = 'Are sessions online or in person?';
  static const String faqA6 =
      "We'll explain how sessions currently run when you email us, including format and what to expect on the day.";
  static const String faqQ7 = 'What happens during a typical session?';
  static const String faqA7 =
      'Sessions focus on practice, reflection, and constructive feedback in a supportive environment. We will walk you through the flow before you join.';
  static const String faqQ8 = 'How much does it cost?';
  static const String faqA8 =
      'Packages are listed in CAD on this page: \$50 for a single session, \$180 for four sessions, and \$320 for eight sessions. A free online explanation session is available if you want to talk first. Email us if you have questions about which starting point is right for you.';
  static const String faqQ9 = 'Can I talk to you before joining a session?';
  static const String faqA9 =
      'Yes. We offer a free online explanation session so you can talk with a host, understand what we do, and ask questions. There is no speaking required and no pressure to join.';

  static const String contactHeadline = 'Ready to Take the First Step?';
  static const String contactSupport =
      "You don't have to feel ready. You just have to be willing to start.";
  static const String contactNameLabel = 'Name';
  static const String contactEmailLabel = 'Email';
  static const String contactMessageLabel = 'Message';
  static const String contactNameHint = 'Your name';
  static const String contactEmailHint = 'you@example.com';
  static const String contactMessageHint = 'What would you like to ask?';
  static const String contactNameRequired = 'Please enter your name.';
  static const String contactEmailRequired = 'Please enter your email.';
  static const String contactEmailInvalid =
      'Please enter a valid email address.';
  static const String contactMessageRequired = 'Please enter a message.';
  static const String contactFormNote =
      'Sending this form opens your email app with a drafted message. Nothing is sent until you hit send there.';
  static const String contactNoBackend =
      "Email isn't connected as a server yet. Use Email Us, or send the drafted message from your email app.";
  static const String contactMailtoFallback =
      'If your email app did not open, write to speakupfearless@gmail.com.';

  static const String footerBlurb =
      'A supportive community helping people become more comfortable, confident, and courageous speakers.';
  static const String footerMission = 'Our Mission';
  static const String footerCommunity = 'Community';
  static const String footerExplore = 'Explore';
  static const String footerContactLabel = 'Contact';
  static const String footerCopyright =
      '© 2026 Speak Up Fearless. All rights reserved.';
}
