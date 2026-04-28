// lib/core/services/audio_service.dart
import 'package:flame_audio/flame_audio.dart';
import 'storage_service.dart';

class AudioService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    await FlameAudio.audioCache.loadAll([
      'engine_idle.mp3',
      'engine_rev.mp3',
      'nitro_boost.mp3',
      'crash.mp3',
      'win.mp3',
      'lose.mp3',
      'countdown_beep.mp3',
      'race_start.mp3',
      'menu_music.mp3',
      'race_music.mp3',
      'btn_tap.mp3',
    ]);
  }

  // ── SFX ───────────────────────────────────────────────────────
  static Future<void> playEngineIdle() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.loopLongAudio('engine_idle.mp3', volume: 0.5);
  }

  static Future<void> playEngineRev(double speedRatio) async {
    if (!StorageService.soundEnabled) return;
    final vol = (0.3 + speedRatio * 0.7).clamp(0.3, 1.0);
    await FlameAudio.play('engine_rev.mp3', volume: vol);
  }

  static Future<void> playNitro() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('nitro_boost.mp3', volume: 0.8);
  }

  static Future<void> playCrash() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('crash.mp3', volume: 0.9);
  }

  static Future<void> playWin() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('win.mp3', volume: 0.9);
  }

  static Future<void> playLose() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('lose.mp3', volume: 0.8);
  }

  static Future<void> playCountdownBeep() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('countdown_beep.mp3', volume: 0.7);
  }

  static Future<void> playRaceStart() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('race_start.mp3', volume: 1.0);
  }

  static Future<void> playBtnTap() async {
    if (!StorageService.soundEnabled) return;
    await FlameAudio.play('btn_tap.mp3', volume: 0.6);
  }

  // ── Music ─────────────────────────────────────────────────────
  static Future<void> playMenuMusic() async {
    if (!StorageService.musicEnabled) return;
    await FlameAudio.bgm.play('menu_music.mp3', volume: 0.4);
  }

  static Future<void> playRaceMusic() async {
    if (!StorageService.musicEnabled) return;
    await FlameAudio.bgm.play('race_music.mp3', volume: 0.5);
  }

  static Future<void> stopMusic() async {
    await FlameAudio.bgm.stop();
  }

  static Future<void> pauseMusic() async {
    await FlameAudio.bgm.pause();
  }

  static Future<void> resumeMusic() async {
    if (!StorageService.musicEnabled) return;
    await FlameAudio.bgm.resume();
  }

  static Future<void> stopAll() async {
    FlameAudio.audioCache.clearAll();
    await FlameAudio.bgm.stop();
    _initialized = false;
  }
}
