import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/models/display.dart';
import 'package:chip_8_flutter/models/speaker.dart';
import 'package:chip_8_flutter/screens/console.dart';
import 'package:chip_8_flutter/utils/size_config.dart';
import 'package:chip_8_flutter/widgets/menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const Chip(),
        theme: ThemeData.dark().copyWith(
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: kSecondaryColor,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: kSecondaryColor,
            titleTextStyle: TextStyle(
              color: kPrimaryColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Abang',
            ),
            iconTheme: IconThemeData(color: kPrimaryColor),
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
      ),
    ),
  );
  await Speaker.load();
}

class Chip extends StatefulWidget {
  const Chip({Key? key}) : super(key: key);

  @override
  State<Chip> createState() => _ChipState();
}

class _ChipState extends State<Chip> {
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
            SizedBox(
              width: SizeConfig.widthPercent * 60,
              height: SizeConfig.heightPercent * 10,
              child: MenuButton(
                text: 'CHIP-8',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const Console();
                  }));
                },
              ),
            ),
            SizedBox(
              height: SizeConfig.heightPercent * 2,
            ),
            SizedBox(
              width: SizeConfig.widthPercent * 60,
              height: SizeConfig.heightPercent * 10,
              child: MenuButton(
                text: 'SCHIP-8',
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: SizeConfig.heightPercent * 2,
            ),
            SizedBox(
              width: SizeConfig.widthPercent * 60,
              height: SizeConfig.heightPercent * 10,
              child: MenuButton(
                text: 'NES',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
