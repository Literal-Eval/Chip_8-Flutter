import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class Speaker {
  Speaker() {
    SystemSound.play(SystemSoundType.click);
    load();
  }

  late final int _id;

  final Soundpool _soundPool = Soundpool.fromOptions(
    options: const SoundpoolOptions(streamType: StreamType.notification),
  );

  Future<void> load() async {
    _id = await rootBundle.load("assets/sound/beep.mid").then((ByteData soundData) {
      return _soundPool.load(soundData);
    });

    await _soundPool.play(_id);
  }
}
