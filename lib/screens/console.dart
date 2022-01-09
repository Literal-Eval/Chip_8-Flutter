import 'package:chip_8_flutter/widgets/keyboard.dart';
import 'package:chip_8_flutter/widgets/screen.dart';
import 'package:flutter/material.dart';

class Console extends StatefulWidget {
  const Console({Key? key}) : super(key: key);

  @override
  _ConsoleState createState() => _ConsoleState();
}

class _ConsoleState extends State<Console> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Chip_8'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Screen(),
          SizedBox(
            width: double.infinity,
          ),
          Keyboard(),
        ],
      ),
    );
  }
}
