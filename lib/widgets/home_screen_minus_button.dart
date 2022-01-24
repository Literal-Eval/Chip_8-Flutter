import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/widgets/custom_painters/minus_button_painter.dart';
import 'package:flutter/material.dart';

class HomeScreenMinusButton extends StatelessWidget {
  const HomeScreenMinusButton({
    required this.onPressed,
    required this.isRunning,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;
  final bool isRunning;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        size: Size(
          SizeConfig.widthPercent * 12,
          SizeConfig.widthPercent * 12,
        ),
        painter: MinusButtonPainter(isRunning: isRunning),
      ),
    );
  }
}
