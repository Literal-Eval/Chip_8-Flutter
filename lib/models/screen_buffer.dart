import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class ScreenBuffer extends ChangeNotifier{
  static List <Uint8List> buffer = List.filled(32, Uint8List(64));

  static clear() {
    for (int y = 0; y < 32; y++) {
      for (int x = 0; x < 64; x++) {
        buffer[y][x] = 0;
      }
    }
  }

  static update() {
    // notifyListeners();
  }
}