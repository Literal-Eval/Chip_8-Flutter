// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:typed_data';

class Registers {

  // General Registers

  static Uint8List registers = Uint8List(0xF);
  static Uint8 DT = 0 as Uint8;
  static Uint8 ST = 0 as Uint8;
  static Uint16 I = 0 as Uint16;

  // Pseudo Registers

  static Uint16 PC = 0 as Uint16;
}