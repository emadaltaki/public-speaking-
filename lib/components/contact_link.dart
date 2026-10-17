import 'package:flutter/widgets.dart';
import 'package:url_launcher/link.dart';

import '../translations/translations.dart';

/// Wraps a button in a real `<a href>` on the web. In-app browsers such as
/// Instagram's ignore phone and email links opened from script, but follow
/// a normal link tap.
class ContactLink extends StatelessWidget {
  const ContactLink({super.key, required this.uri, required this.builder});

  final Uri uri;
  final Widget Function(BuildContext context, VoidCallback? open) builder;

  static final Uri phone = Uri.parse(Translations.telUri);

  static Uri email({String? subject}) => Uri.parse(
    subject == null
        ? Translations.mailtoUri
        : '${Translations.mailtoUri}?subject=${Uri.encodeComponent(subject)}',
  );

  @override
  Widget build(BuildContext context) {
    return Link(
      uri: uri,
      target: LinkTarget.self,
      builder: (context, followLink) => builder(context, followLink),
    );
  }
}
