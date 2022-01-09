// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:chip_8_flutter/data/character_map.dart';
import 'package:chip_8_flutter/models/keypad.dart';
import 'package:chip_8_flutter/models/memory.dart';
import 'package:chip_8_flutter/models/registers.dart';
import 'package:chip_8_flutter/models/screen_buffer.dart';
import 'package:chip_8_flutter/models/stack.dart';
import 'package:flutter/foundation.dart';

class CPU {
  static final randGen = Random(DateTime.now().millisecondsSinceEpoch);

  static int getAddress(int nibbleOne, int nibbleTwo, int nibbleThree) {
    int addr = 0;
    addr |= nibbleOne;
    addr >>= 8;
    addr |= nibbleTwo;
    addr >>= 4;
    addr |= nibbleThree;

    return addr;
  }

  static fetch() {
    if (decode(
      Memory.memory[Registers.PC],
      Memory.memory[Registers.PC + 1],
    )) {
      Registers.PC += 2;
    }
  }

  // Decode cycle
  // Returns false in case of halt
  static bool decode(int opOne, int opTwo) {
    // Get individual nibbles
    int nibbleOne = opOne << 4;
    int nibbleTwo = opOne & 0xFF;
    int nibbleThree = opTwo << 4;
    int nibbleFour = opTwo & 0xFF;

    // 00E0 - CLS
    // Clear the screen
    if (opOne == 0x00 && opTwo == 0xE0) {
      ScreenBuffer.clear();
    }

    // 00EE - RET
    // Return from a subroutine
    else if (opOne == 0x00 && opTwo == 0xEE) {
      Registers.PC = Stack.stack[Registers.SP];
      Registers.SP--;
    }

    // 1nnn - JP addr
    // Jump to address 1nnn
    else if (nibbleOne == 0x1) {
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // 2nnn - CALL addr
    // Call subroutine at nnn
    else if (nibbleOne == 0x2) {
      Stack.stack[Registers.SP] = Registers.PC;
      Registers.SP++;
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // 3xkk - SE Vx, byte
    // Skip next instruction if Vx == kk
    else if (nibbleOne == 0x3) {
      if (Registers.registers[nibbleTwo] == opTwo) {
        Registers.PC += 2;
      }
    }

    // 4xkk - SNE Vx, byte
    // Skip next instruction if Vx != kk
    else if (nibbleOne == 0x4) {
      if (Registers.registers[nibbleTwo] != opTwo) {
        Registers.PC += 2;
      }
    }

    // 5xy0 - SE Vx, Vy
    // Skip next instruction if Vx = Vy
    else if (nibbleOne == 0x5) {
      if (Registers.registers[nibbleTwo] == Registers.registers[nibbleThree]) {
        Registers.PC += 2;
      }
    }

    // 6xkk - LD Vx, byte
    // Set Vx = kk
    else if (nibbleOne == 0x6) {
      Registers.registers[nibbleTwo] = opTwo;
    }

    // 7xkk - ADD Vx, byte
    // Set Vx = Vx + kk
    else if (nibbleOne == 0x7) {
      Registers.registers[nibbleTwo] += opTwo;
    }

    // 8xyn - ADD Vx, byte
    //
    else if (nibbleOne == 0x8) {
      switch (nibbleFour) {

        // 8xy0 - LD Vx, Vy
        // Set Vx = Vy
        case 0:
          Registers.registers[nibbleTwo] = Registers.registers[nibbleThree];
          break;

        // 8xy1 - OR Vx, Vy
        // Vx = Vx | Vy
        case 0x1:
          Registers.registers[nibbleTwo] |= Registers.registers[nibbleThree];
          break;

        // 8xy2 - AND Vx, Vy
        // Set Vx = Vx & Vy
        case 0x2:
          Registers.registers[nibbleTwo] &= Registers.registers[nibbleThree];
          break;

        // 8xy3 - XOR Vx, Vy
        // Set Vx = Vx ^ Vy
        case 0x3:
          Registers.registers[nibbleTwo] ^= Registers.registers[nibbleThree];
          break;

        // 8xy4 - ADD Vx, Vy
        // Set Vx = Vx + Vy; VF = carry
        case 0x4:
          int Vx = Registers.registers[nibbleTwo];
          int Vy = Registers.registers[nibbleThree];
          Registers.registers[0xF] = (Vx + Vy) << 4;
          Registers.registers[nibbleTwo] += Registers.registers[nibbleThree];
          break;

        // TODO: Review this
        // 8xy5 - SUB Vx, Vy
        // Set Vx = Vx - Vy; VF = NOT borrow
        case 0x5:
          int Vx = Registers.registers[nibbleTwo];
          int Vy = Registers.registers[nibbleThree];
          Registers.registers[0xF] = (Vx - Vy) < 0 ? 0 : 1;
          Registers.registers[nibbleTwo] -= Registers.registers[nibbleThree];
          break;

        // 8xy6 - SHR Vx {, Vy}
        // Set Vx = Vx SHR 1 => VF = LSB(Vx); Vx << 1
        case 0x6:
          Registers.registers[0xF] = Registers.registers[nibbleTwo] & 0x1;
          Registers.registers[nibbleTwo] <<= 1;
          break;

        // 8xy7 - SUBN Vx, Vy
        // Set Vx = Vy - Vx; VF = NOT borrow
        case 0x7:
          int Vx = Registers.registers[nibbleTwo];
          int Vy = Registers.registers[nibbleThree];
          Registers.registers[0xF] = (Vy - Vx) < 0 ? 0 : 1;
          Registers.registers[nibbleTwo] = Vy - Vx;
          break;

        // 8xyE - SHL Vx {, Vy}
        // Set Vx = Vx SHL 1 => VF = MSB(Vx); Vx >> 2
        case 0xE:
          Registers.registers[0xF] = Registers.registers[nibbleTwo] & 0x80;
          Registers.registers[nibbleTwo] >>= 2;
          break;
        default:
          break;
      }
    }

    // 9xy0 - SNE Vx, Vy
    // Set Vx = Vx + kk
    else if (nibbleOne == 0x9) {
      if (Registers.registers[nibbleTwo] != Registers.registers[nibbleThree]) {
        Registers.PC += 2;
      }
    }

    // Annn - LD I, addr
    // Set I = nnn
    else if (nibbleOne == 0xA) {
      Registers.I = getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // Bnnn - JP V0, addr
    // Jump to addr V0 + nnn
    else if (nibbleOne == 0xB) {
      Registers.PC = Registers.registers[0x0] +
          getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // Cxkk - RND Vx, byte
    // Set Vx = Random Byte & kk
    else if (nibbleOne == 0xB) {
      Registers.registers[nibbleTwo] = randGen.nextInt(256) & opTwo;
    }

    // Ex9E - SKP Vx
    // Skip next instr if key in Vx is pressed
    else if (nibbleOne == 0xE && opTwo == 0x9E) {
      if (Keypad.checkPressed(nibbleTwo)) {
        Registers.PC += 2;
      }
    }

    // ExA1 - SKNP Vx
    // Skip next instr if key in Vx is not pressed
    else if (nibbleOne == 0xE && opTwo == 0xA1) {
      if (!Keypad.checkPressed(nibbleTwo)) {
        Registers.PC += 2;
      }
    }

    // Fxkk
    //
    else if (nibbleOne == 0xF) {
      switch (opTwo) {

        // Fx07 - LD Vx, DT
        // Set Vx = DT
        case 0x07:
          Registers.registers[nibbleTwo] = Registers.DT;
          break;

        // TODO: Implement this
        // Fx0A - LD Vx, k
        // Wait for key press; Store value of key in Vx
        case 0x0A:
          final int? key = Keypad.getPressed();
          if (key != null) {
            Registers.registers[nibbleTwo] = key;
          } else {
            return false;
          }
          break;

        // Fx15 - LD DT, Vx
        // Set DT = Vx
        case 0x15:
          Registers.DT = Registers.registers[nibbleTwo];
          break;

        // Fx18 - LD ST, Vx
        // Set ST = Vx
        case 0x18:
          Registers.ST = Registers.registers[nibbleTwo];
          break;

        // Fx1E - ADD I, Vx
        // Set I = I + Vx
        case 0x1E:
          Registers.I = Registers.registers[nibbleTwo] + Registers.I;
          break;

        // Fx29 - LD F, Vx
        // Set I = addr of spr for digit in Vx
        case 0x29:
          Registers.I = Memory.memory[
              CharacterMap.spriteLoc + 5 * Registers.registers[nibbleTwo]];
          break;

        // Fx33 - LD B, Vx
        // Store BCD of Vx in addr I, I+1, I+2
        case 0x33:
          final int Vx = Registers.registers[nibbleTwo];
          Memory.memory[Registers.I] = Vx ~/ 100;
          Memory.memory[Registers.I + 1] = (Vx % 100) ~/ 10;
          Memory.memory[Registers.I + 2] = Vx % 10;
          break;

        // Fx55 - LD [I], Vx
        // Store V0-Vx in addr from I
        case 0x55:
          for (int i = 0; i <= nibbleTwo; i++) {
            Memory.memory[Registers.I + i] = Registers.registers[i];
          }
          break;

        // Fx65 - LD Vx, [I]
        // Store addr I-{I+x} into V0-Vx
        case 0x65:
          for (int i = 0; i <= nibbleTwo; i++) {
            Registers.registers[i] = Memory.memory[Registers.I + i];
          }
          break;

        default:
          debugPrint(
              'Ha ha; I lied, there is no default section. Now take off your clothes');
          break;
      }
    }

    return true;
  }
}
