// lib/game/components/nitro_component.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class NitroComponent extends PositionComponent {
  double _timer = 0;
  bool _active = false;

  NitroComponent() : super(priority: 11);

  void activate() => _active = true;
  void deactivate() => _active = false;

  @override
  void update(double dt) {
    if (_active) _timer += dt * 10;
  }

  @override
  void render(Canvas canvas) {
    if (!_active) return;

    final paint = Paint()
      ..color = const Color(0xFF00E5FF).withOpacity(0.6 + 0.3 * (_timer % 1))
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(size.x / 2, size.y * 0.9),
        width: size.x * 0.4,
        height: size.y * 0.15,
      ),
      paint,
    );
  }
}
