import 'package:flutter/material.dart';

import '../data/models.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';
import 'community_scene.dart';

class GalleryTile extends StatefulWidget {
  const GalleryTile({super.key, required this.item, this.onTap});

  final GalleryItem item;

  /// Opens the photo larger; the tile shows a pointer and hint when set.
  final VoidCallback? onTap;

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
      button: widget.onTap != null,
      onTap: widget.onTap,
      child: MouseRegion(
        cursor: widget.onTap != null
            ? SystemMouseCursors.zoomIn
            : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
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
                    // Decode near display size: much lighter to scroll.
                    cacheWidth: 900,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                    errorBuilder: (context, error, stackTrace) =>
                        const CommunityScene(),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 180),
                    opacity: _hovered ? 1 : 0.85,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: const [0.45, 1],
                          colors: [
                            AppColors.navyDeep.withValues(alpha: 0),
                            AppColors.navyDeep.withValues(alpha: 0.78),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        widget.item.caption,
                        style: AppStyles.title.copyWith(
                          color: AppColors.onNavy,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  if (widget.onTap != null)
                    Positioned(
                      top: 14,
                      right: 14,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 180),
                        opacity: _hovered ? 1 : 0.75,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.navyDeep.withValues(alpha: 0.55),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.zoom_out_map_rounded,
                            size: 18,
                            color: AppColors.onNavy,
                            semanticLabel: Translations.photoEnlarge,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
