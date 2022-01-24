import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class HomeScreenWirePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path
      ..moveTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.5, size.height * 0.8)
      ..lineTo(size.width * 0.8, size.height * 0.8)
      ..lineTo(size.width * 0.8, size.height * 0.6)
      ..lineTo(size.width * 0.2, size.height * 0.6)
      ..lineTo(size.width * 0.2, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.4)
      ..lineTo(size.width * 0.5, size.height * 0.0);

    final paint = Paint()
      ..color = kBlueNeonColor
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    final fPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(
      path.shift(const Offset(5, 20)),
      paint..color = Colors.black,
    );
    paint.color = kBlueNeonColor;
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