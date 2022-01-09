import 'package:chip_8_flutter/models/memory.dart';
import 'package:flutter/services.dart';

class FileHandler {
  static void load(String fileName) async {
    // Load ROM as ByteList (as we need binary data)

    final byteList =
        (await rootBundle.load('assets/roms/$fileName')).buffer.asUint8List();

    // Load ROM into memory
    for (int i = 0; i < byteList.length; i++) {
      Memory.memory[Memory.memStart + i] = byteList[i];
    }
  }
}
