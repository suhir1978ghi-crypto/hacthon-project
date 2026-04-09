import 'dart:async';

import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  bool isMuted = true; // TODO: set to false later
  double _volume = 1.0;
  Timer? _fadeTimer;

  Future<void> init() async {
    await FlameAudio.audioCache.load('background.mp3');
    await FlameAudio.bgm.initialize();

    _volume = isMuted ? 0 : 1;

    await FlameAudio.bgm.play('background.mp3', volume: _volume);
  }

  void toggleMute() {
    isMuted = !isMuted;

    if (isMuted) {
      _fadeOut();
    } else {
      _fadeIn();
    }
  }

  void _fadeOut() {
    _fadeTimer?.cancel();

    _fadeTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) async {
      _volume -= 0.05;

      if (_volume <= 0) {
        _volume = 0;
        await FlameAudio.bgm.audioPlayer.setVolume(0);
        timer.cancel();
      } else {
        await FlameAudio.bgm.audioPlayer.setVolume(_volume);
      }
    });
  }

  void _fadeIn() {
    _fadeTimer?.cancel();
    FlameAudio.bgm.resume();
    _fadeTimer = Timer.periodic(const Duration(milliseconds: 50), (
      timer,
    ) async {
      _volume += 0.05;

      if (_volume >= 1) {
        _volume = 1;
        await FlameAudio.bgm.audioPlayer.setVolume(1);
        timer.cancel();
      } else {
        await FlameAudio.bgm.audioPlayer.setVolume(_volume);
      }
    });
  }
}
