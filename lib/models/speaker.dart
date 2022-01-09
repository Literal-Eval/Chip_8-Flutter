import 'package:just_audio/just_audio.dart';

class Speaker {
  static final _audioPlayer = AudioPlayer();

  static Future<void> load() async {
    await _audioPlayer.setAsset(
      'assets/sound/pickupCoin(8).wav',
    );
    await _audioPlayer.load();
  }

  static Future<void> play() async {
    _audioPlayer.seek(const Duration(milliseconds: 0));
    await _audioPlayer.play();
  }
}
