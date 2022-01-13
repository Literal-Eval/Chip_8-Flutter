import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/models/display.dart';
import 'package:chip_8_flutter/screens/console.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/view_models/display_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          color: kPrimaryColor,
          width: SizeConfig.widthPercent * 2,
        ),
      ),
      child: Consumer(builder: (context, ref, _) {
        return CustomPaint(
          child: SizedBox(
            width: SizeConfig.widthPercent * 90,
            height: SizeConfig.widthPercent * 45,
          ),
          painter: ScreenPainter(
            dvm: ref.watch(screenBufferProvider),
          ),
        );
      }),
    );
  }
}

class ScreenPainter extends CustomPainter {
  ScreenPainter({
    required this.dvm,
  });

  final DisplayViewModel dvm;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..color = kPrimaryColor
      ..strokeJoin = StrokeJoin.round;

    final double blockHeight = size.height / 32;
    final double blockWidth = size.width / 64;

    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 64; x++) {
        if (ScreenBuffer.buffer[y][x] == 1) {
          canvas.drawRect(
            Rect.fromLTWH(
                x * blockWidth, y * blockHeight, blockWidth, blockHeight),
            paint,
          );
        }
      }
    }

    dvm.changed = false;
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return dvm.changed;
  }
}
