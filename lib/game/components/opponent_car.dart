// lib/game/components/opponent_car.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/models/car_model.dart';

class OpponentCar extends PositionComponent with CollisionCallbacks {
  final CarModel model;
  final double skill;          // 0.0–1.0
  final dynamic gameRef;
  int laneIndex;

  double _currentSpeed = 0;
  double _distanceTravelled = 0;
  bool _racing = false;

  // Rubber-band AI
  double _rubberBandFactor = 1.0;
  final _random = Random();
  double _laneChangeTimer = 0;
  double _targetLaneX = 0;
  double _visualX = 0;

  double get distanceTravelled => _distanceTravelled;
  double get currentSpeed => _currentSpeed;

  OpponentCar({
    required this.model,
    required this.skill,
    required this.gameRef,
    required this.laneIndex,
  }) : super(priority: 9);

  @override
  Future<void> onLoad() async {
    size = Vector2(AppConstants.laneWidth * 0.70, 110);
    _updateVisualX();
    position = Vector2(_visualX - size.x / 2, gameRef.size.y * 0.40);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!_racing) return;
    _updateAI(dt);
    _updateDistance(dt);
    _laneChangeTimer -= dt;
    if (_laneChangeTimer <= 0) {
      _doRandomLaneChange();
      _laneChangeTimer = 2.0 + _random.nextDouble() * 3.0;
    }
  }

  void _updateAI(double dt) {
    // Rubber-band: if player is far ahead, AI speeds up
    final playerProgress = gameRef.playerProgress as double;
    final myProgress = gameRef.opponentProgress as double;
    final gap = playerProgress - myProgress;

    if (gap > 0.1) {
      _rubberBandFactor = 1.0 + gap * 1.5 * skill;
    } else if (gap < -0.1) {
      _rubberBandFactor = 0.85; // Slow down slightly when player is behind
    } else {
      _rubberBandFactor = 1.0;
    }

    final targetSpeed = model.maxSpeed * skill * _rubberBandFactor;
    final delta = targetSpeed - _currentSpeed;
    _currentSpeed +=
        delta.sign * min(model.acceleration * 0.8 * dt, delta.abs());
    _currentSpeed = _currentSpeed.clamp(0, model.maxSpeed * 1.3);
  }

  void _updateDistance(double dt) {
    _distanceTravelled += _currentSpeed * dt * 0.05;
  }

  void _doRandomLaneChange() {
    if (_random.nextDouble() > 0.4) return; // 40% chance
    final newLane = _random.nextInt(AppConstants.numberOfLanes);
    laneIndex = newLane;
    _updateVisualX();
  }

  void _updateVisualX() {
    _targetLaneX = laneIndex * AppConstants.laneWidth +
        AppConstants.laneWidth / 2 +
        gameRef.size.x * 0.05;
    _visualX = _targetLaneX;
    position.x = _visualX - size.x / 2;
  }

  void startRace() => _racing = true;
  void stopRace() {
    _racing = false;
    _currentSpeed = 0;
  }

  @override
  void render(Canvas canvas) {
    _drawCar(canvas);
  }

  void _drawCar(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Body
    final bodyPaint = Paint()..color = model.color;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.1, w * 0.90, h * 0.75),
        const Radius.circular(8),
      ),
      bodyPaint,
    );

    // Roof
    final roofPaint = Paint()
      ..color = Color.lerp(model.color, Colors.black, 0.35)!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.15, h * 0.25, w * 0.70, h * 0.35),
        const Radius.circular(6),
      ),
      roofPaint,
    );

    // Windshield
    final glassPaint = Paint()..color = const Color(0xFF78909C).withOpacity(0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.55, w * 0.64, h * 0.18),
        const Radius.circular(4),
      ),
      glassPaint,
    );

    // Headlights (bottom since opponent faces player)
    final lightPaint = Paint()..color = const Color(0xFFFFF176).withOpacity(0.6);
    canvas.drawOval(Rect.fromLTWH(w * 0.07, h * 0.83, w * 0.2, h * 0.07), lightPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.73, h * 0.83, w * 0.2, h * 0.07), lightPaint);

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF212121);
    final rimPaint = Paint()
      ..color = model.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    _drawWheel(canvas, Offset(w * 0.15, h * 0.20), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.85, h * 0.20), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.15, h * 0.78), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.85, h * 0.78), wheelPaint, rimPaint);
  }

  void _drawWheel(Canvas canvas, Offset center, Paint wheel, Paint rim) {
    canvas.drawCircle(center, 9, wheel);
    canvas.drawCircle(center, 5, rim);
  }
}
