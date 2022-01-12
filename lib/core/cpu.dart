// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:chip_8_flutter/core/file_handler.dart';
import 'package:chip_8_flutter/data/character_map.dart';
import 'package:chip_8_flutter/models/keypad.dart';
import 'package:chip_8_flutter/models/memory.dart';
import 'package:chip_8_flutter/models/registers.dart';
import 'package:chip_8_flutter/models/display.dart';
import 'package:chip_8_flutter/models/speaker.dart';
import 'package:chip_8_flutter/models/stack.dart';
import 'package:chip_8_flutter/view_models/display_view_model.dart';
import 'package:flutter/foundation.dart';

class CPU {
  static final randGen = Random(DateTime.now().millisecondsSinceEpoch);
  static late DisplayViewModel dvm;

  static void init(DisplayViewModel ndvm) async {
    dvm = ndvm;
    FileHandler.load('UFO');
    CharacterMap.init();
    Registers.PC = Memory.memStart;
    await Speaker.play();
  }

  static int getAddress(int nibbleOne, int nibbleTwo, int nibbleThree) {
    int addr = 0;
    addr |= nibbleOne;
    addr <<= 4;
    addr |= nibbleTwo;
    addr <<= 4;
    addr |= nibbleThree;

    return addr;
  }

  static fetch() {
    if (decode(
      Memory.memory[Registers.PC],
      Memory.memory[Registers.PC + 1],
    )) {
      Registers.PC += 2;
      // debugPrint('fetch ${Registers.PC}');
    }
  }

  static printBits(int byte) {
    String num = 'Input: ';
    for (int i = 0; i < 8; i++) {
      num += '${(byte >> (7 - i)) & 0x1}';
    }
    debugPrint(num);
  }

  // Decode cycle
  // Returns false in case of halt
  static bool decode(int opOne, int opTwo) {
    // Get individual nibbles
    int nibbleOne = opOne >> 4;
    int nibbleTwo = opOne & 0xF;
    int nibbleThree = opTwo >> 4;
    int nibbleFour = opTwo & 0xF;

    // debugPrint('decode $opOne $opTwo');
    // debugPrint('decode $nibbleOne $nibbleTwo $nibbleThree $nibbleFour');

    // 00E0 - CLS
    // Clear the screen
    if (opOne == 0x00 && opTwo == 0xE0) {
      // debugPrint('Clearing screen');
      ScreenBuffer.clear();
    }

    // 00EE - RET
    // Return from a subroutine
    else if (opOne == 0x00 && opTwo == 0xEE) {
      Registers.PC = Stack.stack[Registers.SP - 1];
      Registers.SP--;
      // return false;
    }

    // 1nnn - JP addr
    // Jump to address 1nnn
    else if (nibbleOne == 0x1) {
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
      // debugPrint('Jump to: ${getAddress(nibbleTwo, nibbleThree, nibbleFour)}');
      return false;
    }

    // 2nnn - CALL addr
    // Call subroutine at nnn
    else if (nibbleOne == 0x2) {
      Stack.stack[Registers.SP] = Registers.PC;
      Registers.SP++;
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
      return false;
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
      // debugPrint('Set 0x$nibbleTwo to $opTwo');
    }

    // 7xkk - ADD Vx, byte
    // Set Vx = Vx + kk
    else if (nibbleOne == 0x7) {
      Registers.registers[nibbleTwo] += opTwo;
      // debugPrint('Add $opTwo to 0x$nibbleTwo');
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
          Registers.registers[0xF] = (Vx + Vy) > 0xFF ? 1 : 0;
          Registers.registers[nibbleTwo] += Registers.registers[nibbleThree];
          // Registers.registers[nibbleTwo] &= 0xFFFF;
          break;

        // 8xy5 - SUB Vx, Vy
        // Set Vx = Vx - Vy; VF = NOT borrow
        case 0x5:
          int Vx = Registers.registers[nibbleTwo];
          int Vy = Registers.registers[nibbleThree];
          Registers.registers[0xF] = (Vx > Vy) ? 1 : 0;
          Registers.registers[nibbleTwo] -= Registers.registers[nibbleThree];
          break;

        // 8xy6 - SHR Vx {, Vy}
        // Set Vx = Vx SHR 1 => VF = LSB(Vx); Vx >> 1
        case 0x6:
          Registers.registers[0xF] = Registers.registers[nibbleTwo] & 0x1;
          Registers.registers[nibbleTwo] >>= 1;
          break;

        // 8xy7 - SUBN Vx, Vy
        // Set Vx = Vy - Vx; VF = NOT borrow
        case 0x7:
          int Vx = Registers.registers[nibbleTwo];
          int Vy = Registers.registers[nibbleThree];
          Registers.registers[0xF] = (Vy > Vx) ? 1 : 0;
          Registers.registers[nibbleTwo] = Vy - Vx;
          break;

        // 8xyE - SHL Vx {, Vy}
        // Set Vx = Vx SHL 1 => VF = MSB(Vx); Vx << 1
        case 0xE:
          Registers.registers[0xF] = Registers.registers[nibbleTwo] & 0x80;
          Registers.registers[nibbleTwo] <<= 1;
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
      // debugPrint('Set I to: ${getAddress(nibbleTwo, nibbleThree, nibbleFour)}');
    }

    // Bnnn - JP V0, addr
    // Jump to addr V0 + nnn
    else if (nibbleOne == 0xB) {
      Registers.PC = Registers.registers[0x0] +
          getAddress(nibbleTwo, nibbleThree, nibbleFour);
      return false;
    }

    // Cxkk - RND Vx, byte
    // Set Vx = Random Byte & kk
    else if (nibbleOne == 0xC) {
      Registers.registers[nibbleTwo] = randGen.nextInt(256) & opTwo;
    }

    // Dxyn - DRW Vx, Vy, nibble
    // Display n byte sprite starting at addr VI at coords(Vx, Vy)
    else if (nibbleOne == 0xD) {
      int currentByte = 0, oldState = 0, newState = 0;
      Registers.registers[0xF] = 0;

      final int x_cor = Registers.registers[nibbleTwo] % 64;
      final int y_cor = Registers.registers[nibbleThree] % 32;
      // debugPrint('Drawing $nibbleFour bytes from ($x_cor, $y_cor)');

      for (int y = 0; y < nibbleFour && y_cor + y < 32; y++) {
        currentByte = Memory.memory[Registers.I + y];
        // String currentRow = 'Output: ';
        // printBits(currentByte);

        for (int x = 0; x < 8 && x_cor + x < 64; x++) {
          oldState = ScreenBuffer.buffer[y_cor + y][x_cor + x];
          newState = ((currentByte >> (7 - x)) & 0x1) ^ oldState;
          // newState = ((currentByte >> (7 - x)) & 0x1);

          if (oldState == 1 && newState == 0 && Registers.registers[0xF] == 0) {
            Registers.registers[0xF] = 1;
          }

          ScreenBuffer.buffer[y_cor + y][x_cor + x] = newState;
          // currentRow += '${ScreenBuffer.buffer[y_cor + y][x_cor + x]}';
        }
        // debugPrint(currentRow);
      }

      dvm.notify();
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
          Registers.I += Registers.registers[nibbleTwo];
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
