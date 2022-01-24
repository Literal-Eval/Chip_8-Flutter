import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/widgets/custom_painters/plus_button_painter.dart';
import 'package:flutter/material.dart';

class HomeScreenPlusButton extends StatelessWidget {
  const HomeScreenPlusButton({
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
          SizeConfig.widthPercent * 15,
          SizeConfig.widthPercent * 15,
        ),
        painter: PlusButtonPainter(isRunning: isRunning),
      ),
    );
  }
}
