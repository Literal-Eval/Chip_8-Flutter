import 'dart:ffi';

class Memory {
  static Array <Uint8> memory = const Array(0xFFF);
  static Uint16 memStart = 0x200 as Uint16;
}