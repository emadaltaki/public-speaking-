import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'account/account_page.dart';
import 'contact/contact_submit_handler.dart';
import 'games/game_catalog.dart';
import 'games/games_hub_page.dart';
import 'games/autocomplete/autocomplete_setup_page.dart';
import 'games/conductor/conductor_setup_page.dart';
import 'games/podcast/podcast_setup_page.dart';
import 'games/triple_step/triple_step_setup_page.dart';
import 'pages/home_page.dart';
import 'theme/styles.dart';
import 'theme/theme_controller.dart';
import 'translations/translations.dart';

class SpeakUpFearlessApp extends StatefulWidget {
  const SpeakUpFearlessApp({super.key, this.contactHandler});

  final ContactSubmitHandler? contactHandler;

  @override
  State<SpeakUpFearlessApp> createState() => _SpeakUpFearlessAppState();
}

class _SpeakUpFearlessAppState extends State<SpeakUpFearlessApp> {
  /// The page on screen. Switching the theme or language rebuilds the app,
  /// and this keeps the visitor on the same page instead of the start page.
  final _CurrentRoute _current = _CurrentRoute();

  @override
  Widget build(BuildContext context) {
    // Rebuild everything when the language changes; Arabic switches the
    // layout to right-to-left through the locale.
    return ListenableBuilder(
      listenable: Listenable.merge([
        Translations.language,
        ThemeController.dark,
      ]),
      builder: (context, _) => MaterialApp(
        key: ValueKey(
          '${Translations.language.value}-${ThemeController.isDark}',
        ),
        locale: Locale(Translations.language.value),
        supportedLocales: const [Locale('en'), Locale('ar')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        title: Translations.pageTitle,
        debugShowCheckedModeBanner: false,
        theme: AppStyles.theme,
        // Open only the requested page on a direct link. Building the home page
        // underneath it trips a SelectionArea bug for off-screen routes.
        navigatorObservers: [_current],
        onGenerateInitialRoutes: (name) {
          final start = _current.name ?? (name.isEmpty ? AppRoutes.home : name);
          return [_route(RouteSettings(name: start))];
        },
        onGenerateRoute: _route,
      ),
    );
  }

  Route<void> _route(RouteSettings settings) {
    final Widget page = switch (settings.name) {
      AppRoutes.games => const GamesHubPage(),
      AppRoutes.account => const AccountPage(),
      AppRoutes.tripleStep => const TripleStepSetupPage(),
      AppRoutes.conductor => const ConductorSetupPage(),
      AppRoutes.podcast => const PodcastSetupPage(),
      AppRoutes.autocomplete => const AutocompleteSetupPage(),
      _ => HomePage(contactHandler: widget.contactHandler),
    };
    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}

/// Remembers the name of the route on top of the navigator.
class _CurrentRoute extends NavigatorObserver {
  String? name;

  void _set(Route<dynamic>? route) {
    final n = route?.settings.name;
    if (n != null) name = n;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _set(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _set(previousRoute);

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _set(newRoute);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _set(previousRoute);
}
