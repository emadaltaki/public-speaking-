import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/account/auth_service.dart';
import 'package:speak_up_fearless/account/auth_storage.dart';
import 'package:speak_up_fearless/contact/contact_submit_handler.dart';
import 'package:speak_up_fearless/theme/styles.dart';
import 'package:speak_up_fearless/translations/translations.dart';

void configureTestFonts() {
  TestWidgetsFlutterBinding.ensureInitialized();
}

void setSurface(WidgetTester tester, {required Size size}) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Widget wrapForTest(Widget child) {
  return MaterialApp(theme: AppStyles.theme, home: child);
}

class RecordingContactHandler implements ContactSubmitHandler {
  ContactFormData? lastSubmitted;
  int emailOpens = 0;
  int phoneOpens = 0;
  String statusMessage = Translations.contactFormNote;
  ContactSubmitKind kind = ContactSubmitKind.mailtoOpened;

  @override
  Future<ContactSubmitResult> submit(ContactFormData data) async {
    lastSubmitted = data;
    return ContactSubmitResult(kind: kind, userMessage: statusMessage);
  }

  @override
  Future<bool> openEmailClient({String? subject, String? body}) async {
    emailOpens += 1;
    return true;
  }

  @override
  Future<bool> openPhoneClient() async {
    phoneOpens += 1;
    return true;
  }
}

/// Signs in a fake member, as the sign-in page would. Signs out after the
/// test.
void signInForTest() {
  writeStoredUser(
    'firebase:authUser:${AuthService.apiKey}:[DEFAULT]',
    '{"uid":"test-user","email":"test@example.com","displayName":"Test User"}',
  );
  AuthService.reload();
  addTearDown(AuthService.signOut);
}
