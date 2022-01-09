class Keypad {
  static List<bool> keys = List.filled(0xF, false);

  static void setPressed(int key) {
    clearPressed();
    keys[key] = true;
  }

  static int? getPressed() {
    for (int i = 0; i <= 0xF; i++) {
      if (keys[i]) {
        return i;
      }
    }

    return null;
  }

  static void clearPressed() {
    // keys.setAll(0, List.filled(0xF, false));

    for (int i = 0; i <= 0xF; i++) {
      keys[i] = false;
    }
  }
}