import 'package:flutter/material.dart';

import 'contact/contact_submit_handler.dart';
import 'games/game_catalog.dart';
import 'games/games_hub_page.dart';
import 'games/triple_step/triple_step_setup_page.dart';
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
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        final Widget page = switch (settings.name) {
          AppRoutes.games => const GamesHubPage(),
          AppRoutes.tripleStep => const TripleStepSetupPage(),
          _ => HomePage(contactHandler: contactHandler),
        };
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => page,
        );
      },
    );
  }
}
