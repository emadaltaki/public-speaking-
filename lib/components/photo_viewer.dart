import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/models.dart';
import '../theme/colors.dart';
import '../theme/styles.dart';
import '../translations/translations.dart';

/// Opens a full-screen viewer where photos can be zoomed and swiped through.
Future<void> showPhotoViewer(
  BuildContext context, {
  required List<GalleryItem> items,
  int initialIndex = 0,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: Translations.photoViewerClose,
    barrierColor: Colors.black.withValues(alpha: 0.96),
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, _, _) =>
        PhotoViewer(items: items, initialIndex: initialIndex),
    transitionBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

class PhotoViewer extends StatefulWidget {
  const PhotoViewer({super.key, required this.items, this.initialIndex = 0});

  final List<GalleryItem> items;
  final int initialIndex;

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  late final PageController _pages = PageController(
    initialPage: widget.initialIndex,
  );
  late int _index = widget.initialIndex;
  final List<TransformationController> _zoom = [];
  bool _zoomed = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.items.length; i++) {
      final controller = TransformationController();
      controller.addListener(() {
        if (i != _index) return;
        final zoomed = controller.value.getMaxScaleOnAxis() > 1.01;
        if (zoomed != _zoomed) setState(() => _zoomed = zoomed);
      });
      _zoom.add(controller);
    }
  }

  @override
  void dispose() {
    _pages.dispose();
    for (final controller in _zoom) {
      controller.dispose();
    }
    super.dispose();
  }

  void _go(int delta) {
    final target = _index + delta;
    if (target < 0 || target >= widget.items.length) return;
    _pages.animateToPage(
      target,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  void _resetZoom() {
    _zoom[_index].value = Matrix4.identity();
  }

  /// Double-tap toggles between fit and 2.5x zoom.
  void _toggleZoom(TapDownDetails details) {
    final controller = _zoom[_index];
    if (controller.value.getMaxScaleOnAxis() > 1.01) {
      controller.value = Matrix4.identity();
      return;
    }
    const scale = 2.5;
    final p = details.localPosition;
    controller.value = Matrix4.identity()
      ..translateByDouble(-p.dx * (scale - 1), -p.dy * (scale - 1), 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.items[_index];
    final many = widget.items.length > 1;
    final wide = MediaQuery.sizeOf(context).width >= AppStyles.tabletBreakpoint;

    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () =>
            Navigator.of(context).pop(),
        const SingleActivator(LogicalKeyboardKey.arrowLeft): () => _go(-1),
        const SingleActivator(LogicalKeyboardKey.arrowRight): () => _go(1),
      },
      child: Focus(
        autofocus: true,
        child: Material(
          type: MaterialType.transparency,
          child: SafeArea(
            child: Stack(
              children: [
                PageView.builder(
                  controller: _pages,
                  itemCount: widget.items.length,
                  // While zoomed in, drags pan the photo instead of paging.
                  physics: _zoomed
                      ? const NeverScrollableScrollPhysics()
                      : const PageScrollPhysics(),
                  onPageChanged: (i) {
                    _resetZoom();
                    setState(() {
                      _index = i;
                      _zoomed = false;
                    });
                  },
                  itemBuilder: (context, i) {
                    final photo = widget.items[i];
                    return GestureDetector(
                      onDoubleTapDown: _toggleZoom,
                      onDoubleTap: () {},
                      child: InteractiveViewer(
                        transformationController: _zoom[i],
                        minScale: 1,
                        maxScale: 5,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              wide ? 80 : 0,
                              64,
                              wide ? 80 : 0,
                              96,
                            ),
                            child: Semantics(
                              label: photo.alt,
                              image: true,
                              child: Image.asset(
                                photo.assetPath,
                                fit: BoxFit.contain,
                                excludeFromSemantics: true,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: _ViewerButton(
                    icon: Icons.close_rounded,
                    tooltip: Translations.photoViewerClose,
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                if (many && wide && _index > 0)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _ViewerButton(
                        icon: Icons.chevron_left_rounded,
                        tooltip: Translations.photoViewerPrevious,
                        onPressed: () => _go(-1),
                      ),
                    ),
                  ),
                if (many && wide && _index < widget.items.length - 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _ViewerButton(
                        icon: Icons.chevron_right_rounded,
                        tooltip: Translations.photoViewerNext,
                        onPressed: () => _go(1),
                      ),
                    ),
                  ),
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 20,
                  child: Center(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.caption,
                              textAlign: TextAlign.center,
                              style: AppStyles.title.copyWith(
                                color: AppColors.onNavy,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              [
                                if (many)
                                  '${_index + 1} / ${widget.items.length}',
                                Translations.photoViewerHint,
                              ].join('  ·  '),
                              textAlign: TextAlign.center,
                              style: AppStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
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

class _ViewerButton extends StatelessWidget {
  const _ViewerButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      iconSize: 30,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.12),
        foregroundColor: Colors.white,
        hoverColor: Colors.white.withValues(alpha: 0.2),
        minimumSize: const Size(48, 48),
      ),
      icon: Icon(icon),
    );
  }
}
