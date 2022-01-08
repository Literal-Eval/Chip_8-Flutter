// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';

class Registers {

  // General Registers

  static Array <Uint8> registers = const Array(0xF);
  static Uint8 DT = 0 as Uint8;
  static Uint8 ST = 0 as Uint8;
  static Uint16 I = 0 as Uint16;

  // Pseudo Registers

  static Uint16 PC = 0 as Uint16;
}