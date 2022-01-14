import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class ScreenBuffer {
  static List<Uint8List> buffer = [];

  static init() {
    for (int y = 0; y < 32; y++) {
      Uint8List clist = Uint8List(64);
      buffer.add(clist);
    }
  }

  static printBuffer() {
    for (int y = 0; y < 32; y++) {
      String row = '$y: ';
      for (int x = 0; x < 64; x++) {
        row += '${buffer[y][x]}';
      }
      debugPrint(row);
    }
  }

  static clear() {
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 64; x++) {
        buffer[y][x] = 0;
      }
    }
  }
}
