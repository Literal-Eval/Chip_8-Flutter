import 'dart:typed_data';

class Memory {
  static Uint8List memory = Uint8List(0x1000);

  static int memStart = 0x200; // Uint16
}
