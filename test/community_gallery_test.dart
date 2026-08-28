import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speak_up_fearless/components/community_gallery.dart';
import 'package:speak_up_fearless/components/community_scene.dart';
import 'package:speak_up_fearless/data/models.dart';
import 'package:speak_up_fearless/data/site_content.dart';

import 'support/test_helpers.dart';

void main() {
  setUpAll(configureTestFonts);

  testWidgets('gallery renders captions from provided data', (tester) async {
    setSurface(tester, size: const Size(900, 1400));
    const first = [
      GalleryItem(
        assetPath: 'assets/images/directing-participants-pic.jpeg',
        caption: 'Practicing together',
        alt: 'Practice alt',
      ),
      GalleryItem(
        assetPath: 'assets/images/participant-podcast-pic.jpeg',
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
                  assetPath: 'assets/images/directing-consultant-pic-2.jpeg',
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

  testWidgets('each tile renders the photo declared on its item',
      (tester) async {
    setSurface(tester, size: const Size(1200, 2400));

    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(
          body: SingleChildScrollView(child: CommunityGallery()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final assetNames = tester
        .widgetList<Image>(find.byType(Image))
        .map((image) => (image.image as AssetImage).assetName)
        .toList();

    expect(
      assetNames,
      SiteContent.gallery.map((item) => item.assetPath).toList(),
    );
  });

  testWidgets('a missing photo falls back to the painted scene',
      (tester) async {
    setSurface(tester, size: const Size(900, 1400));

    await tester.pumpWidget(
      wrapForTest(
        const Scaffold(
          body: SingleChildScrollView(
            child: CommunityGallery(
              items: [
                GalleryItem(
                  assetPath: 'assets/images/does-not-exist.jpeg',
                  caption: 'Behind the scenes',
                  alt: 'Missing alt',
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CommunityScene), findsOneWidget);
    expect(find.text('Behind the scenes'), findsOneWidget);
  });
}
