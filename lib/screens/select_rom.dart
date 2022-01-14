import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/data/rom_data.dart';
import 'package:chip_8_flutter/screens/console.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SelectROMScreen extends StatelessWidget {
  const SelectROMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: SizeConfig.widthPercent * 80,
          height: SizeConfig.heightPercent * 80,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: kPrimaryColor, width: 5),
                ),
              ),
              Positioned(
                left: SizeConfig.widthPercent * 10,
                top: SizeConfig.heightPercent * -1,
                child: Container(
                  color: kSecondaryColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.widthPercent * 4),
                  child: const Text(
                    'ROMS',
                    style: TextStyle(
                      backgroundColor: kSecondaryColor,
                      fontSize: 20,
                      fontFamily: 'Noir-Regular',
                    ),
                  ),
                ),
              ),
              ListView(
                physics: const BouncingScrollPhysics(),
                children: roms.map(
                  (rom) {
                    return ListTile(
                      title: Text(
                        rom.name,
                        style: const TextStyle(
                          fontFamily: 'Noir-Regular',
                          fontSize: 20,
                          color: kPrimaryColor,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Console(romName: rom.fileName),
                          ),
                        );
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
