import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lays cards out in rows of equal-height tiles, as many per row as fit.
class ResponsiveCardGrid extends StatelessWidget {
  const ResponsiveCardGrid({
    super.key,
    required this.children,
    this.minTileWidth = 250,
    this.gap = 20,
  });

  final List<Widget> children;
  final double minTileWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final count = math.max(
          1,
          math.min(
            children.length,
            ((width + gap) / (minTileWidth + gap)).floor(),
          ),
        );
        final tileWidth = count == 1
            ? width
            : (width - gap * (count - 1)) / count;

        final rows = <Widget>[];
        for (var start = 0; start < children.length; start += count) {
          final end = math.min(start + count, children.length);
          final rowChildren = <Widget>[];
          for (var i = start; i < end; i++) {
            if (i != start) {
              rowChildren.add(SizedBox(width: gap));
            }
            rowChildren.add(SizedBox(width: tileWidth, child: children[i]));
          }
          if (rows.isNotEmpty) {
            rows.add(SizedBox(height: gap));
          }
          rows.add(
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        );
      },
    );
  }
}
