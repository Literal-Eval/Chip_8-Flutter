import 'dart:math';

import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class HomeScreenControlsPainter extends CustomPainter {
  HomeScreenControlsPainter({
    required this.isForeground,
    this.isRunning = false,
  });

  final bool isForeground;
  final bool isRunning;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0);

    final paint = Paint()
      ..strokeWidth = 15
      ..color = kBlueNeonColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final fPaint = Paint()
      ..strokeWidth = 5
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    if (!isForeground) {
      canvas.drawPath(
        path.shift(const Offset(5, 20)),
        paint..color = Colors.black,
      );
    } else {
      if (!isRunning) {
        paint.color = kBlueNeonColor;
        canvas.drawPath(path, paint);
      } else {
        paint.color = kBlueNeonColor;
        canvas.drawPath(path, paint);
        canvas.drawPath(
          path,
          paint..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10),
        );
        canvas.drawPath(path, fPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant HomeScreenControlsPainter oldDelegate) {
    return isRunning != oldDelegate.isRunning;
  }
}
