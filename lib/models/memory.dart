import 'dart:ffi';

import 'dart:typed_data';

class Memory {
  static Uint8List memory = Uint8List.fromList(List.filled(0xFFF, 0));
  // static Uint16 memStart = 0x200 as Uint16;
  static int memStart = 0x200;
}