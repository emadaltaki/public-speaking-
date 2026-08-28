import 'models.dart';
import '../translations/translations.dart';

class SiteContent {
  SiteContent._();

  static const List<HowItWorksStep> howItWorks = [
    HowItWorksStep(
      number: '01',
      title: Translations.how1Title,
      body: Translations.how1Body,
    ),
    HowItWorksStep(
      number: '02',
      title: Translations.how2Title,
      body: Translations.how2Body,
    ),
    HowItWorksStep(
      number: '03',
      title: Translations.how3Title,
      body: Translations.how3Body,
    ),
    HowItWorksStep(
      number: '04',
      title: Translations.how4Title,
      body: Translations.how4Body,
    ),
  ];

  static const List<SessionType> sessions = [
    SessionType(
      title: Translations.sessionPracticeTitle,
      body: Translations.sessionPracticeBody,
    ),
    SessionType(
      title: Translations.sessionImpromptuTitle,
      body: Translations.sessionImpromptuBody,
    ),
    SessionType(
      title: Translations.sessionStoryTitle,
      body: Translations.sessionStoryBody,
    ),
    SessionType(
      title: Translations.sessionFeedbackTitle,
      body: Translations.sessionFeedbackBody,
    ),
    SessionType(
      title: Translations.sessionChallengeTitle,
      body: Translations.sessionChallengeBody,
    ),
  ];

  static const List<PricingPackage> pricing = [
    PricingPackage(
      title: Translations.pricingSingleTitle,
      price: Translations.pricingSinglePrice,
      meta: Translations.pricingSingleMeta,
      description: Translations.pricingSingleDesc,
      cta: Translations.pricingSingleCta,
      perSessionTable: Translations.pricingSinglePrice,
      features: [
        Translations.pricingFeatureGuided,
        Translations.pricingFeatureSupportive,
        Translations.pricingFeatureFeedback,
        Translations.pricingFeatureExercises,
      ],
    ),
    PricingPackage(
      title: Translations.pricingFourTitle,
      price: Translations.pricingFourPrice,
      badge: Translations.pricingFourBadge,
      wasPrice: Translations.pricingFourWas,
      saveLabel: Translations.pricingFourSave,
      perSession: Translations.pricingFourPer,
      description: Translations.pricingFourDesc,
      cta: Translations.pricingFourCta,
      highlighted: true,
      savingsTable: r'$20',
      perSessionTable: r'$45',
      features: [
        Translations.pricingFeatureFourSessions,
        Translations.pricingFeatureGuided,
        Translations.pricingFeatureSupportive,
        Translations.pricingFeatureFeedback,
        Translations.pricingFeatureExercises,
      ],
    ),
    PricingPackage(
      title: Translations.pricingEightTitle,
      price: Translations.pricingEightPrice,
      badge: Translations.pricingEightBadge,
      wasPrice: Translations.pricingEightWas,
      saveLabel: Translations.pricingEightSave,
      perSession: Translations.pricingEightPer,
      description: Translations.pricingEightDesc,
      cta: Translations.pricingEightCta,
      savingsTable: r'$80',
      perSessionTable: r'$40',
      features: [
        Translations.pricingFeatureEightSessions,
        Translations.pricingFeatureGuided,
        Translations.pricingFeatureSupportive,
        Translations.pricingFeatureFeedback,
        Translations.pricingFeatureExercises,
      ],
    ),
  ];

  static const List<GalleryItem> gallery = [
    GalleryItem(
      assetPath: 'assets/images/directing-participants-pic.jpeg',
      caption: Translations.galleryCaption1,
      alt: Translations.galleryAlt1,
      featured: true,
    ),
    GalleryItem(
      assetPath: 'assets/images/participant-podcast-pic.jpeg',
      caption: Translations.galleryCaption2,
      alt: Translations.galleryAlt2,
    ),
    GalleryItem(
      assetPath: 'assets/images/directing-consultant-pic-2.jpeg',
      caption: Translations.galleryCaption3,
      alt: Translations.galleryAlt3,
    ),
    GalleryItem(
      assetPath: 'assets/images/explaining-pic.jpeg',
      caption: Translations.galleryCaption4,
      alt: Translations.galleryAlt4,
      featured: true,
    ),
    GalleryItem(
      assetPath: 'assets/images/playing-a-game-pic.jpeg',
      caption: Translations.galleryCaption5Fixed,
      alt: Translations.galleryAlt5,
    ),
    GalleryItem(
      assetPath: 'assets/images/image-just-after-a-game-pic.jpeg',
      caption: Translations.galleryCaption6,
      alt: Translations.galleryAlt6,
    ),
  ];

  static const List<Testimonial> testimonials = [
    Testimonial(
      quote: Translations.testimonialEmadQuote,
      firstName: Translations.testimonialEmadName,
      role: Translations.testimonialEmadRole,
      photoAsset: 'assets/images/emad_pic.jpg',
      photoAlt: Translations.testimonialEmadPhotoAlt,
      isPlaceholder: false,
    ),
    Testimonial(
      quote: Translations.testimonialEliasQuote,
      firstName: Translations.testimonialEliasName,
      role: Translations.testimonialEliasRole,
      photoAsset: 'assets/images/Elias-image.jpeg',
      photoAlt: Translations.testimonialEliasPhotoAlt,
      isPlaceholder: false,
    ),
  ];

  static const List<FaqItem> faqs = [
    FaqItem(question: Translations.faqQ1, answer: Translations.faqA1),
    FaqItem(question: Translations.faqQ2, answer: Translations.faqA2),
    FaqItem(question: Translations.faqQ3, answer: Translations.faqA3),
    FaqItem(question: Translations.faqQ4, answer: Translations.faqA4),
    FaqItem(question: Translations.faqQ5, answer: Translations.faqA5),
    FaqItem(question: Translations.faqQ6, answer: Translations.faqA6),
    FaqItem(question: Translations.faqQ7, answer: Translations.faqA7),
    FaqItem(question: Translations.faqQ8, answer: Translations.faqA8),
    FaqItem(question: Translations.faqQ9, answer: Translations.faqA9),
  ];

  static const List<String> trustPoints = [
    Translations.trust1,
    Translations.trust2,
    Translations.trust3,
    Translations.trust4,
    Translations.trust5,
    Translations.trust6,
    Translations.trust7,
  ];

  static const List<String> anxietyCards = [
    Translations.anxietyCard1,
    Translations.anxietyCard2,
    Translations.anxietyCard3,
    Translations.anxietyCard4,
  ];

  static const List<String> missionSteps = [
    Translations.missionStepSpeak,
    Translations.missionStepPractice,
    Translations.missionStepReflect,
    Translations.missionStepImprove,
    Translations.missionStepGrow,
  ];
}
