class Keypad {
  static List<bool> keys = List.filled(0x10, false);

  static void setPressed(String keyName) {
    clearPressed();
    int key = int.parse(keyName, radix: 0x10);
    keys[key] = true;
  }

  static int? getPressed() {
    for (int i = 0; i < 0x10; i++) {
      if (keys[i]) {
        return i;
      }
    }

    return null;
  }

  static void clearPressed() {
    // keys.setAll(0, List.filled(0xF, false));

    for (int i = 0; i < 0x10; i++) {
      keys[i] = false;
    }
  }

  static List<String> keyMap = [
    '1', '2', '3', 'C', //
    '4', '5', '6', 'D', //
    '7', '8', '9', 'E', //
    'A', '0', 'B', 'F', //
  ];
}
