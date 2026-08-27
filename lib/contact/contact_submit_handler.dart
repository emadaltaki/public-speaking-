class ContactFormData {
  const ContactFormData({
    required this.name,
    required this.email,
    required this.message,
  });

  final String name;
  final String email;
  final String message;

  String get mailtoBody =>
      'Name: $name\nEmail: $email\n\n$message';
}

enum ContactSubmitKind { mailtoOpened, unavailable }

class ContactSubmitResult {
  const ContactSubmitResult({
    required this.kind,
    required this.userMessage,
  });

  final ContactSubmitKind kind;
  final String userMessage;
}

abstract class ContactSubmitHandler {
  Future<ContactSubmitResult> submit(ContactFormData data);

  Future<bool> openEmailClient({String? subject, String? body});
}
