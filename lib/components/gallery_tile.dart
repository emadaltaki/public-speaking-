import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import 'community_scene.dart';

class GalleryTile extends StatefulWidget {
  const GalleryTile({super.key, required this.item});

  final GalleryItem item;

  @override
  State<GalleryTile> createState() => _GalleryTileState();
}

class _GalleryTileState extends State<GalleryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.item.alt,
      image: true,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1,
          duration: const Duration(milliseconds: 180),
          child: ClipRRect(
            borderRadius: AppStyles.cardRadius,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  widget.item.assetPath,
                  fit: BoxFit.cover,
                  excludeFromSemantics: true,
                  errorBuilder: (context, error, stackTrace) =>
                      const CommunityScene(),
                ),
                ColoredBox(
                  color: AppColors.navy.withValues(alpha: _hovered ? 0.28 : 0.18),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      widget.item.caption,
                      style: AppStyles.title.copyWith(
                        color: AppColors.onNavy,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
