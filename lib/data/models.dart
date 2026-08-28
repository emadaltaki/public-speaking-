class GalleryItem {
  const GalleryItem({
    required this.assetPath,
    required this.caption,
    required this.alt,
    this.featured = false,
  });

  final String assetPath;
  final String caption;
  final String alt;
  final bool featured;
}

class Testimonial {
  const Testimonial({
    required this.quote,
    required this.firstName,
    this.role,
    this.photoAsset,
    this.photoAlt,
    this.isPlaceholder = true,
  });

  final String quote;
  final String firstName;
  final String? role;
  final String? photoAsset;
  final String? photoAlt;
  final bool isPlaceholder;
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class HowItWorksStep {
  const HowItWorksStep({
    required this.number,
    required this.title,
    required this.body,
  });

  final String number;
  final String title;
  final String body;
}

class SessionType {
  const SessionType({required this.title, required this.body});

  final String title;
  final String body;
}

class PricingPackage {
  const PricingPackage({
    required this.title,
    required this.price,
    required this.description,
    required this.cta,
    required this.features,
    this.meta,
    this.badge,
    this.wasPrice,
    this.saveLabel,
    this.perSession,
    this.highlighted = false,
    this.savingsTable = '—',
    this.perSessionTable = '',
  });

  final String title;
  final String price;
  final String description;
  final String cta;
  final List<String> features;
  final String? meta;
  final String? badge;
  final String? wasPrice;
  final String? saveLabel;
  final String? perSession;
  final bool highlighted;
  final String savingsTable;
  final String perSessionTable;
}
