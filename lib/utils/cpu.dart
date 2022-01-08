// ignore_for_file: non_constant_identifier_names

import 'package:chip_8_flutter/models/registers.dart';
import 'package:chip_8_flutter/models/screen_buffer.dart';

class CPU {
  static int getAddress(int nibbleOne, int nibbleTwo, int nibbleThree) {
    int addr = 0;
    addr |= nibbleOne;
    addr >>= 8;
    addr |= nibbleTwo;
    addr >>= 4;
    addr |= nibbleThree;

    return addr;
  }

  static decode(int opOne, int opTwo) {
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

    // TODO: implement RET

    // 1nnn - JP addr
    // Jump to address 1nnn
    else if (nibbleOne == 1) {
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // 2nnn - CALL addr
    // Call subroutine at nnn
    else if (nibbleOne == 2) {
      Registers.SP++;
      Registers.PC = getAddress(nibbleTwo, nibbleThree, nibbleFour);
    }

    // 3xkk - SE Vx, byte
    // Skip next instruction if Vx == kk
    else if (nibbleOne == 3) {
      if (Registers.registers[nibbleTwo] == opTwo) {
        Registers.PC += 2;
      }
    }

    // 4xkk - SNE Vx, byte
    // Skip next instruction if Vx != kk
    else if (nibbleOne == 4) {
      if (Registers.registers[nibbleTwo] != opTwo) {
        Registers.PC += 2;
      }
    }

    // 5xy0 - SE Vx, Vy
    // Skip next instruction if Vx = Vy
    else if (nibbleOne == 5) {
      if (Registers.registers[nibbleTwo] == Registers.registers[nibbleThree]) {
        Registers.PC += 2;
      }
    }

    // 6xkk - LD Vx, byte
    // Set Vx = kk
    else if (nibbleOne == 6) {
      Registers.registers[nibbleTwo] = opTwo;
    }

    // 7xkk - ADD Vx, byte
    // Set Vx = Vx + kk
    else if (nibbleOne == 7) {
      Registers.registers[nibbleTwo] += opTwo;
    }

    // 8xyn - ADD Vx, byte
    // 
    else if (nibbleOne == 8) {
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
          Registers.registers[0xF] = (Vx + Vy) << 4;
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
      }
    }

    // 9xy0 - SNE Vx, Vy
    // Set Vx = Vx + kk
    else if (nibbleOne == 9) {
      if (Registers.registers[nibbleTwo] != Registers.registers[nibbleThree]) {
        Registers.PC += 2;
      }
    }
  }
}
