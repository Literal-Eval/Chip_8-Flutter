// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

class Registers {

  // General Registers

  static Uint8List registers = Uint8List(0xF);
  static int DT = 0;      // Uint8
  static int ST = 0;      // Uint8
  static int I = 0;       // Uint16

  // Pseudo Registers

  static int PC = 0;      // Uint16
  static int SP = 0;      // Uint8 
}