import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/models/speaker.dart';
import 'package:chip_8_flutter/screens/console.dart';
import 'package:chip_8_flutter/core/file_handler.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    MaterialApp(
      home: const Chip(),
      theme: ThemeData.dark().copyWith(
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kPrimaryColor,
        textTheme: const TextTheme(
          bodyText2: TextStyle(
            color: kSecondaryColor,
          ),
        ),
      ),
    ),
  );
  await Speaker.load();
}

class Chip extends StatelessWidget {
  const Chip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Load'),
          onPressed: () async {
            FileHandler.load('IBM');
            await Speaker.play();
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const Console();
            }));
          },
        ),
      ),
    );
  }
}
