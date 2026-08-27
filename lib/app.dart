import 'package:flutter/material.dart';

import 'contact/contact_submit_handler.dart';
import 'pages/home_page.dart';
import 'theme/styles.dart';
import 'translations/translations.dart';

class SpeakUpFearlessApp extends StatelessWidget {
  const SpeakUpFearlessApp({super.key, this.contactHandler});

  final ContactSubmitHandler? contactHandler;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Translations.pageTitle,
      debugShowCheckedModeBanner: false,
      theme: AppStyles.theme,
      home: HomePage(contactHandler: contactHandler),
    );
  }
}
