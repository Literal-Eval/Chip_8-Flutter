import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:flutter/material.dart';

class EmuListTile extends StatefulWidget {
  const EmuListTile({
    required this.name,
    required this.isSelected,
    Key? key,
  }) : super(key: key);

  final String name;
  final bool isSelected;

  @override
  State<EmuListTile> createState() => _EmuListTileState();
}

class _EmuListTileState extends State<EmuListTile> {
  @override
  Widget build(BuildContext context) {
    bool isSelected = widget.isSelected;
    return SizedBox(
      width: SizeConfig.widthPercent * 50,
      child: Row(
        children: [
          CustomPaint(
            size: Size(
              SizeConfig.widthPercent * 5,
              SizeConfig.widthPercent * 5,
            ),
            foregroundPainter: _ArrowPainter(
              isSelected: isSelected,
            ),
          ),
          SizedBox(
            width: SizeConfig.widthPercent * 4,
          ),
          Text(
            widget.name,
            style: TextStyle(
              fontSize: SizeConfig.heightPercent * 3,
              color: kGreenNeonColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Abang',
              shadows: const [
                Shadow(
                  color: Colors.black,
                  // blurRadius: 10,
                  offset: Offset(8, 8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrowPainter extends CustomPainter {
  _ArrowPainter({
    required this.isSelected,
  });

  final bool isSelected;
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();

    path
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height / 2)
      ..lineTo(0, 0);

    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;

    if (isSelected) {
      canvas.drawPath(
        path,
        paint
          ..color = kGreenNeonColor
          ..strokeWidth = 5
          ..maskFilter = const MaskFilter.blur(
            BlurStyle.normal,
            1,
          ),
      );
      paint = Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return isSelected != oldDelegate.isSelected;
  }
}
