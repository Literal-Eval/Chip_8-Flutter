import 'dart:typed_data';

class Memory {
  static Uint8List memory = Uint8List(0xFFF);

  static int memStart = 0x200; // Uint16
}
