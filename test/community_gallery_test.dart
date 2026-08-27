import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/community_gallery.dart';
import 'package:speak_up_fearless/data/models.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('gallery renders captions from provided data', (tester) async {
    setSurface(tester, size: const Size(900, 1400));
    const first = [
      GalleryItem(
        assetPath: 'assets/images/gallery_01.png',
        caption: 'Practicing together',
        alt: 'Practice alt',
      ),
      GalleryItem(
        assetPath: 'assets/images/gallery_02.png',
        caption: 'Finding your voice',
        alt: 'Voice alt',
      ),
    ];

    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(
          body: SingleChildScrollView(
            child: CommunityGallery(items: first),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Practicing together'), findsOneWidget);
    expect(find.text('Finding your voice'), findsOneWidget);

    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(
          body: SingleChildScrollView(
            child: CommunityGallery(
              items: [
                GalleryItem(
                  assetPath: 'assets/images/gallery_03.png',
                  caption: 'Learning through feedback',
                  alt: 'Feedback alt',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Practicing together'), findsNothing);
    expect(find.text('Learning through feedback'), findsOneWidget);
  });
}
