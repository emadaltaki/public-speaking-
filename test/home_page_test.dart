import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/app_navbar.dart';
import 'package:speak_up_fearless/components/site_footer.dart';
import 'package:speak_up_fearless/components/skip_to_content_link.dart';
import 'package:speak_up_fearless/pages/home_page.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('home page renders the trust-journey headlines', (tester) async {
    setSurface(tester, size: const Size(1280, 9000));
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.heroHeadline), findsOneWidget);
    expect(find.text(Translations.ctaJoin), findsWidgets);
    expect(find.text(Translations.anxietyHeadline), findsOneWidget);
    expect(find.text(Translations.missionHeadline), findsOneWidget);
    expect(find.text(Translations.howHeadline), findsOneWidget);
    expect(find.text(Translations.sessionsHeadline), findsOneWidget);
    expect(find.text(Translations.pricingHeadline), findsOneWidget);
    expect(find.text(Translations.galleryHeadline), findsWidgets);
    expect(find.text(Translations.testimonialsHeadline), findsOneWidget);
    expect(find.text(Translations.trustHeadline), findsOneWidget);
    expect(find.text(Translations.expectHeadline), findsOneWidget);
    expect(find.text(Translations.faqHeadline), findsWidgets);
    expect(find.text(Translations.contactHeadline), findsOneWidget);
    expect(find.text(Translations.footerCopyright), findsOneWidget);
    expect(find.text(Translations.contactEmail), findsWidgets);
    expect(find.text(Translations.contactPhoneDisplay), findsWidgets);
    expect(find.byTooltip('Twitter'), findsNothing);
    expect(find.byTooltip('Instagram'), findsNothing);
  });

  testWidgets('desktop nav shows destinations and Join Us', (tester) async {
    setSurface(tester, size: const Size(1280, 1200));
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.navHome), findsWidgets);
    expect(find.text(Translations.navWhy), findsOneWidget);
    expect(find.text(Translations.navJoinUs), findsOneWidget);
    expect(find.byTooltip(Translations.openMenu), findsNothing);
  });

  testWidgets('mobile nav opens hamburger destinations', (tester) async {
    setSurface(tester, size: const Size(390, 2400));
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(find.byTooltip(Translations.openMenu), findsOneWidget);
    await tester.tap(find.byTooltip(Translations.openMenu));
    await tester.pumpAndSettle();

    expect(find.text(Translations.navWhy), findsOneWidget);
    expect(find.text(Translations.navSessions), findsWidgets);
    expect(find.text(Translations.navJoinUs), findsOneWidget);
  });

  testWidgets('trust checklist and what-to-expect steps are visible', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 9000));
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.trust1), findsOneWidget);
    expect(find.text(Translations.trust7), findsOneWidget);
    expect(find.text(Translations.expect1Body), findsOneWidget);
    expect(find.text(Translations.expect4Body), findsOneWidget);
  });

  testWidgets('navbar and footer bands span the full viewport width', (
    tester,
  ) async {
    const viewport = Size(1600, 9000);
    setSurface(tester, size: viewport);
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(AppNavbar)).width, viewport.width);
    expect(tester.getSize(find.byType(SiteFooter)).width, viewport.width);
  });

  testWidgets('header keeps the brand left and the Join Us CTA right', (
    tester,
  ) async {
    const viewport = Size(1600, 1200);
    setSurface(tester, size: viewport);
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    final brand = tester.getRect(find.text(Translations.siteName).first);
    final cta = tester.getRect(
      find.widgetWithText(FilledButton, Translations.navJoinUs),
    );

    expect(brand.left, lessThan(150));
    expect(cta.right, greaterThan(viewport.width - 120));
  });

  testWidgets('skip link stays collapsed until it receives focus', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 1200));
    await tester.pumpWidget(
      wrapForTest(HomePage(contactHandler: RecordingContactHandler())),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(SkipToContentLink)).width, 0);
  });
}
