import 'dart:math' as math;

import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class RoundButtonPainter extends CustomPainter {
  RoundButtonPainter({
    required this.isPower,
  });

  final bool isPower;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path.arcTo(
      Rect.fromLTWH(0, 0, size.width, size.height),
      0,
      1.99999 * math.pi,
      false,
    );

    final paint = Paint()
      ..strokeWidth = 15
      ..color = isPower ? kPowerButtonColor : kStartButtonColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fPaint = Paint()
      ..strokeWidth = 5
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(
      path.shift(const Offset(5, 10)),
      paint
        ..color = isPower ? kPowerButtonColor : kStartButtonColor
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
    );
    paint
      ..color = isPower ? kPowerButtonColor : kStartButtonColor
      ..maskFilter = null;
    canvas.drawPath(path, paint);
    canvas.drawPath(
      path,
      paint..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
    );
    canvas.drawPath(path, fPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
