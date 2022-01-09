import 'dart:typed_data';

import 'package:chip_8_flutter/models/display.dart';
import 'package:flutter/foundation.dart';

class DisplayViewModel extends ChangeNotifier {
  List <Uint8List> buffer = ScreenBuffer.buffer;

  void update() {
    buffer = ScreenBuffer.buffer;
    notifyListeners();
  }
}