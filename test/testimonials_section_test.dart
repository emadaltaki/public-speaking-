import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/testimonials_section.dart';
import 'package:speak_up_fearless/data/site_content.dart';
import 'package:speak_up_fearless/translations/translations.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('shows the two hosts with their headshots', (tester) async {
    setSurface(tester, size: const Size(1200, 1600));

    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(
          body: SingleChildScrollView(child: TestimonialsSection()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(SiteContent.testimonials.length, 2);
    expect(find.text(Translations.testimonialEmadName), findsOneWidget);
    expect(find.text(Translations.testimonialEliasName), findsOneWidget);
    expect(find.text(Translations.testimonialEmadRole), findsOneWidget);
    expect(find.text(Translations.testimonialEliasRole), findsOneWidget);
    expect(find.text(Translations.testimonialPlaceholderLabel), findsNothing);

    final assetNames = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => (image.image as AssetImage).assetName)
        .toList();

    expect(assetNames, [
      'assets/images/emad_pic.jpg',
      'assets/images/Elias-image.jpeg',
    ]);
  });
}
