import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/models/keypad.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.widthPercent * 95,
      height: SizeConfig.heightPercent * 50,
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(SizeConfig.widthPercent * 2),
      //   border: Border.all(
      //     color: kPrimaryColor,
      //     width: SizeConfig.widthPercent * 2,
      //   ),
      // ),
      child: Center(
        child: GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          children: Keypad.keyMap
              .map((keyName) => KeypadButton(keyName: keyName))
              .toList(),
        ),
      ),
    );
  }
}

class KeypadButton extends StatelessWidget {
  const KeypadButton({
    required this.keyName,
    Key? key,
  }) : super(key: key);

  final String keyName;

  @override
  Widget build(BuildContext context) {
    return Material(
      // shadowColor: kShadowColor,
      color: kSecondaryColor,
      child: InkWell(
        splashColor: kPrimaryColor.withOpacity(0.5),
        child: Center(
          child: Text(
            keyName,
            style: TextStyle(
              fontSize: SizeConfig.widthPercent * 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'NEONLEDLight',
            ),
          ),
        ),
        onTap: () {
          Keypad.setPressed(keyName);
        },
      ),
    );
  }
}
