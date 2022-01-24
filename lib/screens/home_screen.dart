import 'package:chip_8_flutter/chip_8/models/display.dart';
import 'package:chip_8_flutter/screens/select_rom.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/widgets/custom_painters/choose_emu_tile.dart';
import 'package:chip_8_flutter/widgets/custom_painters/home_screen_controls_painter.dart';
import 'package:chip_8_flutter/widgets/custom_painters/home_screen_display_painter.dart';
import 'package:chip_8_flutter/widgets/custom_painters/home_screen_wire_painter.dart';
import 'package:chip_8_flutter/widgets/home_screen_minus_button.dart';
import 'package:chip_8_flutter/widgets/home_screen_plus_button.dart';
import 'package:chip_8_flutter/widgets/home_screen_round_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int choosenEmuIndex = 0;
  bool isRunning = false;
  final emuCount = 3;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SizeConfig.init(context);
    ScreenBuffer.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomPaint(
              painter: HomeScreenDisplayPainter(isBackground: true),
              child: Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.widthPercent * 2,
                  right: SizeConfig.widthPercent * 2,
                  top: SizeConfig.heightPercent * 2,
                  bottom: SizeConfig.heightPercent * 6,
                ),
                width: SizeConfig.widthPercent * 80,
                height: SizeConfig.heightPercent * 35,
                child: isRunning
                    ? Container(
                        padding: EdgeInsets.only(
                          bottom: SizeConfig.heightPercent * 8,
                        ),
                        // color: kSecondaryColor,
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EmuListTile(
                                name: 'CHIP - 8',
                                isSelected: choosenEmuIndex == 0,
                              ),
                              SizedBox(
                                height: SizeConfig.heightPercent * 1,
                              ),
                              EmuListTile(
                                name: 'SCHIP - 8',
                                isSelected: choosenEmuIndex == 1,
                              ),
                              SizedBox(
                                height: SizeConfig.heightPercent * 1,
                              ),
                              EmuListTile(
                                name: 'NES',
                                isSelected: choosenEmuIndex == 2,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              ),
              foregroundPainter: HomeScreenDisplayPainter(
                isBackground: false,
                isRunning: isRunning,
              ),
            ),
            SizedBox(
              height: SizeConfig.heightPercent * 2,
            ),
            CustomPaint(
              painter: HomeScreenWirePainter(isRunning: isRunning),
              child: SizedBox(
                width: SizeConfig.widthPercent * 80,
                height: SizeConfig.heightPercent * 20,
              ),
            ),
            SizedBox(
              height: SizeConfig.heightPercent * 2,
            ),
            CustomPaint(
              painter: HomeScreenControlsPainter(isForeground: false),
              child: SizedBox(
                width: SizeConfig.widthPercent * 80,
                height: SizeConfig.heightPercent * 15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    HomeScreenPlusButton(
                      isRunning: isRunning,
                      onPressed: () {
                        if (isRunning) {
                          setState(() {
                            choosenEmuIndex = (choosenEmuIndex + 1) % emuCount;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: SizeConfig.widthPercent * 5,
                    ),
                    HomeScreenMinusButton(
                      isRunning: isRunning,
                      onPressed: () {
                        if (isRunning) {
                          setState(() {
                            choosenEmuIndex =
                                (choosenEmuIndex - 1 + 3) % emuCount;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      width: SizeConfig.widthPercent * 5,
                    ),
                    HomeScreenRoundButton(
                      isPower: true,
                      isRunning: isRunning,
                      onPressed: () {
                        setState(() {
                          isRunning = !isRunning;
                          choosenEmuIndex = 0;
                        });
                      },
                    ),
                    SizedBox(
                      width: SizeConfig.widthPercent * 5,
                    ),
                    HomeScreenRoundButton(
                      isPower: false,
                      isRunning: isRunning,
                      onPressed: () {
                        if (isRunning) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const SelectROMScreen();
                              },
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
              foregroundPainter: HomeScreenControlsPainter(
                isForeground: true,
                isRunning: isRunning,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
