import 'package:flutter/material.dart';

import '../theme/colors.dart';

class SpeechMarkLogo extends StatelessWidget {
  const SpeechMarkLogo({super.key, this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Speak Up Fearless logo',
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: const SpeechMarkLogoPainter(),
      ),
    );
  }
}

class SpeechMarkLogoPainter extends CustomPainter {
  const SpeechMarkLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final bubble = Paint()..color = AppColors.teal;
    final arrow = Paint()
      ..color = AppColors.offWhite
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final r = RRect.fromLTRBR(
      size.width * 0.08,
      size.height * 0.08,
      size.width * 0.92,
      size.height * 0.72,
      Radius.circular(size.width * 0.22),
    );
    canvas.drawRRect(r, bubble);

    final tail = Path()
      ..moveTo(size.width * 0.28, size.height * 0.68)
      ..lineTo(size.width * 0.22, size.height * 0.92)
      ..lineTo(size.width * 0.48, size.height * 0.68);
    canvas.drawPath(tail, bubble);

    final path = Path()
      ..moveTo(size.width * 0.38, size.height * 0.48)
      ..lineTo(size.width * 0.5, size.height * 0.28)
      ..lineTo(size.width * 0.62, size.height * 0.48)
      ..moveTo(size.width * 0.5, size.height * 0.28)
      ..lineTo(size.width * 0.5, size.height * 0.56);
    canvas.drawPath(path, arrow);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
