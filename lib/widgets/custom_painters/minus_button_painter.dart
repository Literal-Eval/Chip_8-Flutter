import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class MinusButtonPainter extends CustomPainter {
  MinusButtonPainter({
    required this.isRunning,
  });

  final bool isRunning;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2);

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

    canvas.drawPath(
      path.shift(const Offset(5, 10)),
      paint..color = Colors.black,
    );
    paint.color = kBlueNeonColor;
    canvas.drawPath(path, paint);

    if (isRunning) {
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
