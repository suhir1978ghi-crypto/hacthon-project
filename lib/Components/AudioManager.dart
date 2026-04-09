import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  bool isMuted = false;

  Future<void> init() async {
    await FlameAudio.audioCache.load('background.mp3');
    FlameAudio.bgm.initialize();
    FlameAudio.bgm.play('background.mp3', volume: 1.0);
  }

  void toggleMute() {
    isMuted = !isMuted;

    if (isMuted) {
      FlameAudio.bgm.pause();
    } else {
      FlameAudio.bgm.resume();
    }
  }
}
