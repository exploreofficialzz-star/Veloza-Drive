// lib/game/components/player_car.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/services/audio_service.dart';
import '../../data/models/car_model.dart';

class PlayerCar extends PositionComponent with CollisionCallbacks {
  final CarModel model;
  final dynamic gameRef;
  int laneIndex;

  // ── Physics ───────────────────────────────────────────────────
  double _currentSpeed = 0;        // px/s
  double _nitroTimer = 0;          // seconds remaining
  bool _isNitroActive = false;
  bool _racing = false;
  double _distanceTravelled = 0;

  // Lane transition
  int _targetLane = 1;
  double _laneTransitionProgress = 1.0; // 1.0 = settled
  static const double laneTransitionDuration = 0.35;
  double _visualX = 0;

  // Collision
  bool _isColliding = false;
  double _collisionTimer = 0;

  static const double nitroDuration = 3.0;
  static const double nitroBoostFactor = 1.6;

  double get distanceTravelled => _distanceTravelled;
  double get currentSpeed => _currentSpeed;
  bool get isNitroActive => _isNitroActive;

  PlayerCar({
    required this.model,
    required this.gameRef,
    required this.laneIndex,
  }) : super(priority: 10);

  @override
  Future<void> onLoad() async {
    _targetLane = laneIndex;
    _updateVisualX();
    size = Vector2(AppConstants.laneWidth * 0.70, 110);
    position = Vector2(_visualX - size.x / 2, gameRef.size.y * 0.65);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (!_racing) return;

    _updateSpeed(dt);
    _updateNitro(dt);
    _updateLaneTransition(dt);
    _updateDistance(dt);
    _updateCollision(dt);
  }

  void _updateSpeed(double dt) {
    final targetSpeed = _isNitroActive
        ? model.maxSpeed * nitroBoostFactor
        : _isColliding
            ? model.maxSpeed * 0.4
            : model.maxSpeed;

    final accelRate = _isColliding ? -model.braking : model.acceleration;
    final delta = targetSpeed - _currentSpeed;
    _currentSpeed += delta.sign *
        min(accelRate * dt, delta.abs());
    _currentSpeed = _currentSpeed.clamp(0, model.maxSpeed * nitroBoostFactor);
  }

  void _updateNitro(double dt) {
    if (_isNitroActive) {
      _nitroTimer -= dt;
      if (_nitroTimer <= 0) {
        _isNitroActive = false;
        _nitroTimer = 0;
      }
    }
  }

  void _updateLaneTransition(double dt) {
    if (_laneTransitionProgress < 1.0) {
      _laneTransitionProgress =
          (_laneTransitionProgress + dt / laneTransitionDuration).clamp(0.0, 1.0);
      final startX = laneIndex * AppConstants.laneWidth +
          AppConstants.laneWidth / 2 + gameRef.size.x * 0.05;
      final endX = _targetLane * AppConstants.laneWidth +
          AppConstants.laneWidth / 2 + gameRef.size.x * 0.05;
      final t = Curves.easeInOut.transform(_laneTransitionProgress);
      _visualX = startX + (endX - startX) * t;
      position.x = _visualX - size.x / 2;

      if (_laneTransitionProgress >= 1.0) {
        laneIndex = _targetLane;
        _updateVisualX();
      }
    }
  }

  void _updateDistance(double dt) {
    _distanceTravelled += _currentSpeed * dt * 0.05;
  }

  void _updateCollision(double dt) {
    if (_isColliding) {
      _collisionTimer -= dt;
      if (_collisionTimer <= 0) {
        _isColliding = false;
      }
    }
  }

  void _updateVisualX() {
    _visualX = laneIndex * AppConstants.laneWidth +
        AppConstants.laneWidth / 2 + gameRef.size.x * 0.05;
    position.x = _visualX - size.x / 2;
  }

  // ── Actions ───────────────────────────────────────────────────
  void startRace() => _racing = true;

  void stopRace() {
    _racing = false;
    _currentSpeed = 0;
  }

  void steerLeft() {
    if (_targetLane > 0) {
      laneIndex = _targetLane;
      _targetLane--;
      _laneTransitionProgress = 0.0;
    }
  }

  void steerRight() {
    if (_targetLane < AppConstants.numberOfLanes - 1) {
      laneIndex = _targetLane;
      _targetLane++;
      _laneTransitionProgress = 0.0;
    }
  }

  void activateNitro() {
    if (_isNitroActive) return;
    _isNitroActive = true;
    _nitroTimer = nitroDuration;
    AudioService.playNitro();
  }

  // ── Collision ─────────────────────────────────────────────────
  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (!_isColliding) {
      _isColliding = true;
      _collisionTimer = 1.2;
      _currentSpeed *= 0.3;
      AudioService.playCrash();
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  // ── Render ────────────────────────────────────────────────────
  @override
  void render(Canvas canvas) {
    _drawCar(canvas);
    if (_isNitroActive) _drawNitroFlame(canvas);
    if (_isColliding) _drawCollisionEffect(canvas);
  }

  void _drawCar(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    // Body
    final bodyPaint = Paint()..color = model.color;
    final bodyRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.05, h * 0.1, w * 0.90, h * 0.75),
      const Radius.circular(8),
    );
    canvas.drawRRect(bodyRRect, bodyPaint);

    // Roof
    final roofPaint = Paint()
      ..color = Color.lerp(model.color, Colors.black, 0.3)!;
    final roofRRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.15, h * 0.25, w * 0.70, h * 0.35),
      const Radius.circular(6),
    );
    canvas.drawRRect(roofRRect, roofPaint);

    // Windshield
    final glassPaint = Paint()..color = const Color(0xFF90CAF9).withOpacity(0.7);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.27, w * 0.64, h * 0.18),
        const Radius.circular(4),
      ),
      glassPaint,
    );

    // Headlights
    final lightPaint = Paint()..color = const Color(0xFFFFF176).withOpacity(0.9);
    canvas.drawOval(Rect.fromLTWH(w * 0.07, h * 0.08, w * 0.2, h * 0.07), lightPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.73, h * 0.08, w * 0.2, h * 0.07), lightPaint);

    // Tail lights
    final tailPaint = Paint()..color = const Color(0xFFE53935).withOpacity(0.9);
    canvas.drawOval(Rect.fromLTWH(w * 0.07, h * 0.84, w * 0.18, h * 0.06), tailPaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.75, h * 0.84, w * 0.18, h * 0.06), tailPaint);

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF212121);
    final rimPaint = Paint()..color = model.accentColor;
    _drawWheel(canvas, Offset(w * 0.15, h * 0.78), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.85, h * 0.78), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.15, h * 0.20), wheelPaint, rimPaint);
    _drawWheel(canvas, Offset(w * 0.85, h * 0.20), wheelPaint, rimPaint);

    // Accent stripe
    final stripePaint = Paint()..color = model.accentColor.withOpacity(0.6);
    canvas.drawRect(Rect.fromLTWH(w * 0.05, h * 0.50, w * 0.90, h * 0.03),
        stripePaint);
  }

  void _drawWheel(Canvas canvas, Offset center, Paint wheelPaint, Paint rimPaint) {
    canvas.drawCircle(center, 9, wheelPaint);
    canvas.drawCircle(center, 5, rimPaint..style = PaintingStyle.stroke..strokeWidth = 2);
  }

  void _drawNitroFlame(Canvas canvas) {
    final flamePaint = Paint()
      ..color = AppTheme.nitro.withOpacity(0.85)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(
      Rect.fromLTWH(size.x * 0.25, size.y * 0.88, size.x * 0.50, size.y * 0.14),
      flamePaint,
    );
    final corePaint = Paint()..color = Colors.white.withOpacity(0.9);
    canvas.drawOval(
      Rect.fromLTWH(size.x * 0.35, size.y * 0.90, size.x * 0.30, size.y * 0.08),
      corePaint,
    );
  }

  void _drawCollisionEffect(Canvas canvas) {
    final paint = Paint()
      ..color = Colors.orange.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.x, size.y),
        const Radius.circular(8),
      ),
      paint,
    );
  }
}

// Local reference for nitro color
class AppTheme {
  static const Color nitro = Color(0xFF00B0FF);
}
