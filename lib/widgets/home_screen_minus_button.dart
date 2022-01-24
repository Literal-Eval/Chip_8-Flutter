import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/widgets/custom_painters/minus_button_painter.dart';
import 'package:flutter/material.dart';

class HomeScreenMinusButton extends StatelessWidget {
  const HomeScreenMinusButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: CustomPaint(
        size: Size(
          SizeConfig.widthPercent * 15,
          SizeConfig.widthPercent * 15,
        ),
        painter: MinusButtonPainter(),
      ),
    );
  }
}
