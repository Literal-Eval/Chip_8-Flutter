import 'dart:typed_data';

import 'package:chip_8_flutter/models/display.dart';
import 'package:flutter/foundation.dart';

class DisplayViewModel extends ChangeNotifier {
  List <Uint8List> get buffer => ScreenBuffer.buffer;

  bool changed = false;

  void notify() {
    changed = true;
    notifyListeners();
  }
}