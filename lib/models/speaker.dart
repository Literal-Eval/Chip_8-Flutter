import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class Speaker {
  static late int _id = -1;

  static final Soundpool _soundPool = Soundpool.fromOptions(
    options: const SoundpoolOptions(streamType: StreamType.music),
  );

  static Future<void> load() async {    
    _id = await rootBundle
        .load("assets/sound/beep_new.mid")
        .then((ByteData soundData) {
      return _soundPool.load(soundData);
    });
  }

  static Future<void> play() async {
    if (_id == -1) return;
    await _soundPool.play(_id);
  }
}
