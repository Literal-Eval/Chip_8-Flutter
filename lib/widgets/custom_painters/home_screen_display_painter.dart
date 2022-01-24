import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class HomeScreenDisplayPainter extends CustomPainter {
  HomeScreenDisplayPainter({
    required this.isBackground,
  });

  final bool isBackground;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path
      ..lineTo(0, size.height * 0.8)
      ..lineTo(size.width, size.height * 0.8)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..moveTo(0, size.height * 0.6)
      ..lineTo(size.width, size.height * 0.6)
      ..moveTo(size.width * 0.4, size.height * 0.8)
      ..lineTo(size.width * 0.4, size.height * 0.9)
      ..moveTo(size.width * 0.6, size.height * 0.8)
      ..lineTo(size.width * 0.6, size.height * 0.9)
      ..moveTo(size.width * 0.2, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height * 0.9)
      ..lineTo(size.width * 0.8, size.height)
      ..lineTo(size.width * 0.2, size.height)
      ..lineTo(size.width * 0.2, size.height * 0.9);

    final paint = Paint()
      ..strokeWidth = 20
      ..color = kGreenNeonColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fPaint = Paint()
      ..strokeWidth = 8
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (isBackground) {
      canvas.drawPath(
        path.shift(const Offset(15, 20)),
        paint
          ..color = kGreenNeonColor
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5)
          ..strokeWidth = 5,
      );
      paint.color = kGreenNeonColor;
    }

    if (!isBackground) {
      canvas.drawPath(path, paint);
      canvas.drawPath(
        path,
        paint..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
      );
      canvas.drawPath(path, fPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
