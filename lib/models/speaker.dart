import 'package:just_audio/just_audio.dart';

class Speaker {
  static final _beepPlayer = AudioPlayer();
  static final _musicPlayer = AudioPlayer();

  static Future<void> load() async {
    await _beepPlayer.setAsset(
      'assets/sound/pickupCoin(8).wav',
    );

    await _musicPlayer.setAsset(
      'assets/sound/beep.wav',
    );
  }

  static Future<void> play() async {
    _beepPlayer.seek(const Duration(milliseconds: 0));
    await _beepPlayer.play();
  }
}
