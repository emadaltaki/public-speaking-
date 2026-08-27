import 'package:flutter/material.dart';

import '../data/models.dart';
import '../data/site_content.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'gallery_tile.dart';
import 'section_container.dart';

class CommunityGallery extends StatelessWidget {
  const CommunityGallery({super.key, this.items});

  final List<GalleryItem>? items;

  @override
  Widget build(BuildContext context) {
    final gallery = items ?? SiteContent.gallery;
    return ColoredBox(
      color: AppColors.offWhite,
      child: SectionContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(Translations.galleryHeadline, style: AppStyles.headline),
            const SizedBox(height: 12),
            Text(Translations.galleryIntro, style: AppStyles.body),
            const SizedBox(height: 28),
            LayoutBuilder(
              builder: (context, constraints) {
                final wide = constraints.maxWidth >= 800;
                return Wrap(
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    for (final item in gallery)
                      SizedBox(
                        width: wide
                            ? (item.featured
                                ? (constraints.maxWidth - 14) * 0.62
                                : (constraints.maxWidth - 14) * 0.38)
                            : constraints.maxWidth,
                        height: item.featured ? 280 : 220,
                        child: GalleryTile(item: item),
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
