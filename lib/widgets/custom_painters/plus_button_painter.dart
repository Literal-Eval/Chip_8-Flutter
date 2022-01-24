import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class PlusButtonPainter extends CustomPainter {
  PlusButtonPainter({
    required this.isRunning,
  });

  final bool isRunning;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path
      ..moveTo(0, size.height / 2)
      ..lineTo(size.width, size.height / 2)
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width / 2, size.height);

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
        paint..maskFilter = const MaskFilter.blur(BlurStyle.outer, 5),
      );
      canvas.drawPath(path, fPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
