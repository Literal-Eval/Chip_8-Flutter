import 'package:chip_8_flutter/data/constants.dart';
import 'package:chip_8_flutter/chip_8/models/speaker.dart';
import 'package:chip_8_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const HomeScreen(),
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