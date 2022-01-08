import 'package:chip_8_flutter/utils/file_handler.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Chip()));
}

class Chip extends StatelessWidget {
  const Chip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          child: const Text('Load'),
          onPressed: () {
            FileHandler.load('IBM');
          },
        ),
      ),
    );
  }
}
