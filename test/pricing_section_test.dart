import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/pricing_section.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('pricing cards show CAD amounts, badges, and no-pressure copy', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 2000));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: PricingSection(
              onJoin: () {},
              onTalk: () {},
              onBookIntro: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(Translations.pricingIntroTitle), findsOneWidget);
    expect(find.text(Translations.pricingIntroPrice), findsOneWidget);
    expect(find.text(Translations.pricingIntroCta), findsOneWidget);
    expect(find.text(Translations.pricingSinglePrice), findsWidgets);
    expect(find.text(Translations.pricingFourPrice), findsWidgets);
    expect(find.text(Translations.pricingEightPrice), findsWidgets);
    expect(find.text(Translations.pricingFourWas), findsOneWidget);
    expect(find.text(Translations.pricingEightWas), findsOneWidget);
    expect(find.text(Translations.pricingFourBadge), findsOneWidget);
    expect(find.text(Translations.pricingEightBadge), findsOneWidget);
    expect(find.text(Translations.pricingCurrencyNote), findsOneWidget);
    expect(find.text(Translations.pricingReassureBody), findsOneWidget);
    expect(find.text(Translations.ctaJoin), findsOneWidget);
    expect(find.text(Translations.ctaTalkToUs), findsOneWidget);

    final struck = tester.widget<Text>(find.text(Translations.pricingFourWas));
    expect(struck.style?.decoration, TextDecoration.lineThrough);
  });

  testWidgets('pricing stacks on a narrow viewport', (tester) async {
    setSurface(tester, size: const Size(390, 3200));
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: PricingSection(
              onJoin: () {},
              onTalk: () {},
              onBookIntro: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(Translations.pricingSingleCta), findsOneWidget);
    expect(find.text(Translations.pricingFourCta), findsOneWidget);
    expect(find.text(Translations.pricingEightCta), findsOneWidget);
  });

  testWidgets('free explanation CTA uses the book-intro callback', (
    tester,
  ) async {
    setSurface(tester, size: const Size(1280, 2000));
    var booked = 0;
    await tester.pumpWidget(
      wrapForTest(
        Scaffold(
          body: SingleChildScrollView(
            child: PricingSection(
              onJoin: () {},
              onTalk: () {},
              onBookIntro: () => booked += 1,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(Translations.pricingIntroCta));
    expect(booked, 1);
  });
}
