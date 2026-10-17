import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/site_content.dart';
import '../translations/translations.dart';
import 'gallery_tile.dart';
import 'photo_viewer.dart';
import '../theme/colors.dart';
import 'section_container.dart';
import 'section_header.dart';

class CommunityGallery extends StatelessWidget {
  const CommunityGallery({super.key, this.items});

  final List<GalleryItem>? items;

  @override
  Widget build(BuildContext context) {
    final gallery = items ?? SiteContent.gallery;
    return ColoredBox(
      color: AppColors.surface,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              eyebrow: Translations.eyebrowCommunity,
              title: Translations.galleryHeadline,
              intro: Translations.galleryIntro,
            ),
            const SizedBox(height: 40),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 800;
                void open(int index) => showPhotoViewer(
                  context,
                  items: gallery,
                  initialIndex: index,
                );
                if (!wide) {
                  return Column(
                    children: [
                      for (var i = 0; i < gallery.length; i++) ...[
                        if (i > 0) const SizedBox(height: 16),
                        SizedBox(
                          height: 240,
                          child: GalleryTile(
                            item: gallery[i],
                            onTap: () => open(i),
                          ),
                        ),
                      ],
                    ],
                  );
                }
                // Pair tiles into rows; a featured tile takes the wider share.
                final rows = <Widget>[];
                for (var i = 0; i < gallery.length; i += 2) {
                  final first = gallery[i];
                  final second = i + 1 < gallery.length ? gallery[i + 1] : null;
                  int flexFor(GalleryItem item) {
                    if (second == null) return 1;
                    if (first.featured == second.featured) return 1;
                    return item.featured ? 62 : 38;
                  }

                  if (rows.isNotEmpty) rows.add(const SizedBox(height: 16));
                  rows.add(
                    SizedBox(
                      height: 320,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: flexFor(first),
                            child: GalleryTile(
                              item: first,
                              onTap: () => open(i),
                            ),
                          ),
                          if (second != null) ...[
                            const SizedBox(width: 16),
                            Expanded(
                              flex: flexFor(second),
                              child: GalleryTile(
                                item: second,
                                onTap: () => open(i + 1),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }
                return Column(children: rows);
              },
            ),
          ],
        ),
      ),
    );
  }
}
