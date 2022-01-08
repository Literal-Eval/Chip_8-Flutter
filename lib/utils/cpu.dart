import 'package:chip_8_flutter/models/screen_buffer.dart';

class CPU {
  static decode(int opOne, int opTwo) {
    if (opOne == 0x00 && opTwo == 0xE0) {
      ScreenBuffer.clear();
    }
  }
}