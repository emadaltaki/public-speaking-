import 'package:url_launcher/url_launcher.dart';

import '../translations/translations.dart';
import 'contact_submit_handler.dart';

class MailtoContactSubmitHandler implements ContactSubmitHandler {
  const MailtoContactSubmitHandler();

  static const String _email = Translations.contactEmail;

  Uri _compose({String? subject, String? body}) {
    return Uri(
      scheme: 'mailto',
      path: _email,
      queryParameters: {
        if (subject != null && subject.isNotEmpty) 'subject': subject,
        if (body != null && body.isNotEmpty) 'body': body,
      },
    );
  }

  @override
  Future<bool> openEmailClient({String? subject, String? body}) {
    return launchUrl(_compose(subject: subject, body: body));
  }

  @override
  Future<bool> openPhoneClient() {
    return launchUrl(Uri.parse(Translations.telUri));
  }

  @override
  Future<ContactSubmitResult> submit(ContactFormData data) async {
    final launched = await openEmailClient(
      subject: 'Speak Up Fearless — message from ${data.name}',
      body: data.mailtoBody,
    );
    if (launched) {
      return const ContactSubmitResult(
        kind: ContactSubmitKind.mailtoOpened,
        userMessage: Translations.contactFormNote,
      );
    }
    return const ContactSubmitResult(
      kind: ContactSubmitKind.unavailable,
      userMessage: Translations.contactNoBackend,
    );
  }
}
