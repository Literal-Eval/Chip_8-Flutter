import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/models/screen_buffer.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:flutter/material.dart';

class Screen extends StatefulWidget {
  const Screen({Key? key}) : super(key: key);

  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthPercent * 90,
      height: SizeConfig.widthPercent * 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeConfig.widthPercent * 2),
        border: Border.all(
          color: kSecondaryColor,
          width: SizeConfig.widthPercent * 2,
        ),
      ),
      child: CustomPaint(
        child: SizedBox(
          width: SizeConfig.widthPercent * 90,
          height: SizeConfig.widthPercent * 45,
        ),
        painter: ScreenPainter(),
      ),
    );
  }
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..color = kSecondaryColor
      ..strokeJoin = StrokeJoin.round;

    final double blockHeight = size.height / 32;
    final double blockWidth = size.width / 64;

    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 64; x++) {
        if (ScreenBuffer.buffer[y][x] == 0) {
          canvas.drawRect(
            Rect.fromLTWH(
                x * blockWidth, y * blockHeight, blockWidth, blockHeight),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
