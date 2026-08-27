import 'package:flutter/material.dart';

import '../theme/colors.dart';

/// Warm, non-stock visual of people supporting people. Replace assets later.
class CommunityScene extends StatelessWidget {
  const CommunityScene({super.key, this.semanticLabel});

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel ?? 'Community gathering',
      image: true,
      child: const CustomPaint(
        painter: CommunityScenePainter(),
        child: SizedBox.expand(),
      ),
    );
  }
}

class CommunityScenePainter extends CustomPainter {
  const CommunityScenePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = AppColors.lightBlue;
    canvas.drawRRect(
      RRect.fromRectAndRadius(Offset.zero & size, const Radius.circular(20)),
      bg,
    );

    final floor = Paint()..color = const Color(0xFFE4EEF1);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * 0.62, size.width, size.height * 0.38),
      floor,
    );

    void person(double cx, double cy, double s, Color fill) {
      final paint = Paint()..color = fill;
      canvas.drawCircle(Offset(cx, cy - s * 1.15), s * 0.42, paint);
      final body = Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(
              center: Offset(cx, cy),
              width: s * 1.15,
              height: s * 1.55,
            ),
            Radius.circular(s * 0.5),
          ),
        );
      canvas.drawPath(body, paint);
    }

    person(size.width * 0.28, size.height * 0.58, size.width * 0.11, AppColors.navy);
    person(size.width * 0.50, size.height * 0.50, size.width * 0.13, AppColors.teal);
    person(size.width * 0.72, size.height * 0.58, size.width * 0.11, AppColors.personAccent);

    final glow = Paint()
      ..color = AppColors.teal.withValues(alpha: 0.12)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 24);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.42), size.width * 0.28, glow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
