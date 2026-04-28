// lib/game/racing_game.dart
import 'dart:math';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/services/audio_service.dart';
import '../data/models/car_model.dart';
import '../data/models/level_model.dart';
import 'components/player_car.dart';
import 'components/opponent_car.dart';
import 'components/road_component.dart';
import 'components/traffic_car.dart';
import 'components/hud_component.dart';
import 'components/nitro_component.dart';

enum RaceState { countdown, racing, paused, finished }

class RacingGame extends FlameGame
    with TapCallbacks, HasCollisionDetection {
  // ── Config ────────────────────────────────────────────────────
  final CarModel playerCarModel;
  final CarModel opponentCarModel;
  final LevelModel level;
  final VoidCallback onRaceWon;
  final VoidCallback onRaceLost;
  final VoidCallback onPause;

  RacingGame({
    required this.playerCarModel,
    required this.opponentCarModel,
    required this.level,
    required this.onRaceWon,
    required this.onRaceLost,
    required this.onPause,
  });

  // ── Components ────────────────────────────────────────────────
  late PlayerCar playerCar;
  late OpponentCar opponentCar;
  late RoadComponent road;
  late HudComponent hud;

  // ── State ─────────────────────────────────────────────────────
  RaceState raceState = RaceState.countdown;
  double _countdownTimer = 3.0;
  double _raceTimer = 0.0;
  double _playerProgress = 0.0;   // 0.0–1.0
  double _opponentProgress = 0.0;
  bool _finishCalled = false;

  // Traffic
  final _trafficSpawnTimer = _SpawnTimer(interval: 2.5);
  final _random = Random();
  int _trafficCount = 0;

  // ── Lifecycle ─────────────────────────────────────────────────
  @override
  Future<void> onLoad() async {
    // Background / road
    road = RoadComponent(level: level);
    await add(road);

    // Cars
    playerCar = PlayerCar(
      model: playerCarModel,
      gameRef: this,
      laneIndex: 1,
    );
    await add(playerCar);

    opponentCar = OpponentCar(
      model: opponentCarModel,
      skill: level.opponentSkill,
      gameRef: this,
      laneIndex: 0,
    );
    await add(opponentCar);

    // HUD overlay
    hud = HudComponent(game: this);
    await add(hud);

    // Overlays
    overlays.add(AppConstants.overlayCountdown);

    await AudioService.playRaceMusic();
  }

  @override
  void update(double dt) {
    super.update(dt);

    switch (raceState) {
      case RaceState.countdown:
        _updateCountdown(dt);
      case RaceState.racing:
        _updateRace(dt);
      case RaceState.paused:
        break;
      case RaceState.finished:
        break;
    }
  }

  void _updateCountdown(double dt) {
    _countdownTimer -= dt;
    if (_countdownTimer <= 0) {
      raceState = RaceState.racing;
      overlays.remove(AppConstants.overlayCountdown);
      overlays.add(AppConstants.overlayHud);
      AudioService.playRaceStart();
      playerCar.startRace();
      opponentCar.startRace();
    }
  }

  void _updateRace(double dt) {
    _raceTimer += dt;

    // Progress based on distance travelled
    _playerProgress =
        (playerCar.distanceTravelled / level.distanceMeters).clamp(0.0, 1.0);
    _opponentProgress =
        (opponentCar.distanceTravelled / level.distanceMeters).clamp(0.0, 1.0);

    // Spawn traffic
    if (_trafficCount < level.trafficDensity) {
      if (_trafficSpawnTimer.tick(dt)) {
        _spawnTraffic();
      }
    }

    // Check finish
    if (!_finishCalled) {
      if (_playerProgress >= 1.0) {
        _finishCalled = true;
        _endRace(won: true);
      } else if (_opponentProgress >= 1.0) {
        _finishCalled = true;
        _endRace(won: false);
      }
    }
  }

  void _spawnTraffic() {
    final lane = _random.nextInt(AppConstants.numberOfLanes);
    // Don't spawn on player's current lane always
    final spawnLane =
        (lane == playerCar.laneIndex && _random.nextBool()) ? (lane + 1) % 3 : lane;

    final traffic = TrafficCar(
      laneIndex: spawnLane,
      speed: 80 + _random.nextDouble() * 60,
      gameRef: this,
    );
    add(traffic);
    _trafficCount++;
  }

  // ── Input ─────────────────────────────────────────────────────
  @override
  void onTapUp(TapUpEvent event) {
    if (raceState != RaceState.racing) return;
    final x = event.devicePosition.x;
    final screenWidth = size.x;

    if (x < screenWidth * 0.33) {
      playerCar.steerLeft();
    } else if (x > screenWidth * 0.66) {
      playerCar.steerRight();
    } else {
      playerCar.activateNitro();
    }
  }

  // ── Nitro ─────────────────────────────────────────────────────
  void activateNitro() {
    if (raceState != RaceState.racing) return;
    playerCar.activateNitro();
  }

  // ── Finish ────────────────────────────────────────────────────
  void _endRace({required bool won}) {
    raceState = RaceState.finished;
    playerCar.stopRace();
    opponentCar.stopRace();

    if (won) {
      AudioService.playWin();
      onRaceWon();
    } else {
      AudioService.playLose();
      onRaceLost();
    }

    overlays.remove(AppConstants.overlayHud);
    overlays.add(AppConstants.overlayRaceResult);
  }

  // ── Pause/Resume ──────────────────────────────────────────────
  void pauseRace() {
    if (raceState != RaceState.racing) return;
    raceState = RaceState.paused;
    pauseEngine();
    AudioService.pauseMusic();
    overlays.add(AppConstants.overlayPause);
    onPause();
  }

  void resumeRace() {
    if (raceState != RaceState.paused) return;
    overlays.remove(AppConstants.overlayPause);
    raceState = RaceState.racing;
    resumeEngine();
    AudioService.resumeMusic();
  }

  // ── Accessors for HUD ────────────────────────────────────────
  double get playerProgress => _playerProgress;
  double get opponentProgress => _opponentProgress;
  double get raceTimer => _raceTimer;
  double get countdownTimer => _countdownTimer;
  bool get playerIsAhead => _playerProgress >= _opponentProgress;
}

class _SpawnTimer {
  final double interval;
  double _elapsed = 0;

  _SpawnTimer({required this.interval});

  bool tick(double dt) {
    _elapsed += dt;
    if (_elapsed >= interval) {
      _elapsed = 0;
      return true;
    }
    return false;
  }
}
