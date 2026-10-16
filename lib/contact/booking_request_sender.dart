import 'dart:convert';

import 'package:http/http.dart' as http;

import '../translations/translations.dart';

class BookingRequest {
  const BookingRequest({
    required this.name,
    required this.contact,
    required this.preferredTime,
    this.description = '',
  });

  final String name;
  final String contact;
  final String preferredTime;

  /// Optional note from the visitor about what they'd like help with.
  final String description;

  String get subject => '${Translations.bookingEmailSubject} — $preferredTime';

  String get body =>
      'Hi! I would like to book a free intro call.\n\n'
      'Preferred time: $preferredTime\n'
      'Name: $name\n'
      'Email or phone: $contact\n'
      '${description.isEmpty ? '' : '\nAbout me:\n$description\n'}';
}

abstract class BookingRequestSender {
  /// Returns true when the request reached the inbox.
  Future<bool> send(BookingRequest request);
}

/// Posts booking requests to FormSubmit, which forwards them by email to
/// [Translations.bookingInboxEmail]. No account is needed: the first request sends
/// a one-time activation email to that address, which must be confirmed.
class FormSubmitBookingSender implements BookingRequestSender {
  FormSubmitBookingSender({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  static final Uri _endpoint = Uri.parse(
    'https://formsubmit.co/ajax/${Translations.bookingInboxEmail}',
  );

  @override
  Future<bool> send(BookingRequest request) async {
    try {
      final response = await _client
          .post(
            _endpoint,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              '_subject': request.subject,
              '_template': 'table',
              '_captcha': 'false',
              'Preferred time': request.preferredTime,
              'Name': request.name,
              'Email or phone': request.contact,
              if (request.description.isNotEmpty)
                'About me': request.description,
            }),
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) {
        return false;
      }
      final data = jsonDecode(response.body);
      return data is Map && '${data['success']}' == 'true';
    } catch (_) {
      return false;
    }
  }
}
