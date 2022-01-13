import 'package:chip_8_flutter/data/constants.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({
    required this.text,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String text;
  final Function onPressed;

  @override
  _MenuButtonState createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _btnHeightController;
  late final Animation _btnHeightAnimation;

  @override
  void initState() {
    super.initState();

    _btnHeightController = AnimationController(
      vsync: this,
      lowerBound: 0,
      upperBound: 1,
      duration: const Duration(milliseconds: 100),
    );

    _btnHeightAnimation = _btnHeightController.drive(
      CurveTween(curve: Curves.easeIn),
    );

    _btnHeightController.addStatusListener(_handleCallback);
  }

  void _handleCallback(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      widget.onPressed();
    }
  }

  void _handleTapDown() {
    _btnHeightController.forward();

    if (_btnHeightController.value >= 1) {
      widget.onPressed();
    }
  }

  void _handleTapUp() {
    _btnHeightController.reverse();
  }

  @override
  void dispose() {
    _btnHeightController.removeStatusListener(_handleCallback);
    _btnHeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _btnHeightAnimation,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final double gap = constraints.maxHeight * 0.1;
          return GestureDetector(
            onTapDown: (_) => _handleTapDown(),
            onTapCancel: _handleTapUp,
            onTapUp: (_) => _handleTapUp(),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: constraints.maxHeight - gap,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: _btnHeightAnimation.value * gap,
                  child: Container(
                    height: constraints.maxHeight - gap,
                    decoration: BoxDecoration(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Center(
                      child: Text(
                        widget.text,
                        style: const TextStyle(
                          fontSize: 30,
                          color: kSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
