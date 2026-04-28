// lib/game/components/traffic_car.dart
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class TrafficCar extends PositionComponent with CollisionCallbacks {
  final int laneIndex;
  final double speed;
  final dynamic gameRef;

  static const _colors = [
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
    Color(0xFF37474F),
    Color(0xFFBF360C),
    Color(0xFF880E4F),
  ];

  late Color _bodyColor;

  TrafficCar({
    required this.laneIndex,
    required this.speed,
    required this.gameRef,
  }) : super(priority: 8);

  @override
  Future<void> onLoad() async {
    _bodyColor = _colors[Random().nextInt(_colors.length)];
    size = Vector2(AppConstants.laneWidth * 0.68, 100);
    final x = laneIndex * AppConstants.laneWidth +
        AppConstants.laneWidth / 2 +
        gameRef.size.x * 0.05;
    position = Vector2(x - size.x / 2, -size.y);
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    // Traffic scrolls downward relative to player speed
    final relativeSpeed = 150.0 + speed; // px/s
    position.y += relativeSpeed * dt;

    // Remove when off screen
    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final w = size.x;
    final h = size.y;

    final bodyPaint = Paint()..color = _bodyColor;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.05, h * 0.1, w * 0.90, h * 0.80),
        const Radius.circular(7),
      ),
      bodyPaint,
    );

    // Roof
    final roofPaint = Paint()
      ..color = Color.lerp(_bodyColor, Colors.black, 0.4)!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.18, h * 0.25, w * 0.64, h * 0.30),
        const Radius.circular(5),
      ),
      roofPaint,
    );

    // Brake lights (top, facing player)
    final brakePaint = Paint()..color = const Color(0xFFEF5350).withOpacity(0.9);
    canvas.drawOval(Rect.fromLTWH(w * 0.08, h * 0.10, w * 0.18, h * 0.06), brakePaint);
    canvas.drawOval(Rect.fromLTWH(w * 0.74, h * 0.10, w * 0.18, h * 0.06), brakePaint);

    // Wheels
    final wheelPaint = Paint()..color = const Color(0xFF1A1A1A);
    canvas.drawCircle(Offset(w * 0.15, h * 0.18), 8, wheelPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.18), 8, wheelPaint);
    canvas.drawCircle(Offset(w * 0.15, h * 0.82), 8, wheelPaint);
    canvas.drawCircle(Offset(w * 0.85, h * 0.82), 8, wheelPaint);
  }
}
