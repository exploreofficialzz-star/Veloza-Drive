// lib/game/components/road_component.dart
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart' hide TimeOfDay;
import '../../data/models/level_model.dart';
import '../../core/constants/app_constants.dart';

class RoadComponent extends PositionComponent with HasGameReference<FlameGame> {
  final LevelModel level;
  double _scrollOffset = 0;
  static const double scrollSpeed = 300;

  RoadComponent({required this.level}) : super(priority: 0);

  @override
  Future<void> onLoad() async {
    size = game.canvasSize;
  }

  @override
  void update(double dt) {
    _scrollOffset = (_scrollOffset + scrollSpeed * dt) % size.y;
  }

  @override
  void render(Canvas canvas) {
    _drawSky(canvas);
    _drawRoad(canvas);
    _drawLaneMarkers(canvas);
    _drawSideWalks(canvas);
    _drawEnvironment(canvas);
  }

  void _drawSky(Canvas canvas) {
    final skyRect = Rect.fromLTWH(0, 0, size.x, size.y * 0.35);
    final skyPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [level.skyColor, _darkenColor(level.skyColor, 0.3)],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // Stars at night
    if (level.timeOfDay == TimeOfDay.night) {
      _drawStars(canvas, skyRect);
    }

    // Sun/Moon
    _drawCelestialBody(canvas, skyRect);
  }

  void _drawStars(Canvas canvas, Rect skyRect) {
    final starPaint = Paint()..color = Colors.white.withOpacity(0.7);
    final stars = [
      Offset(size.x * 0.1, size.y * 0.05),
      Offset(size.x * 0.25, size.y * 0.08),
      Offset(size.x * 0.45, size.y * 0.04),
      Offset(size.x * 0.62, size.y * 0.10),
      Offset(size.x * 0.78, size.y * 0.06),
      Offset(size.x * 0.88, size.y * 0.12),
      Offset(size.x * 0.15, size.y * 0.15),
      Offset(size.x * 0.55, size.y * 0.18),
      Offset(size.x * 0.92, size.y * 0.20),
    ];
    for (final s in stars) {
      canvas.drawCircle(s, 1.5, starPaint);
    }
  }

  void _drawCelestialBody(Canvas canvas, Rect skyRect) {
    final paint = Paint();
    if (level.timeOfDay == TimeOfDay.night) {
      paint.color = Colors.white.withOpacity(0.9);
      canvas.drawCircle(
          Offset(size.x * 0.8, size.y * 0.08), 16, paint);
    } else if (level.timeOfDay == TimeOfDay.day ||
        level.timeOfDay == TimeOfDay.dawn) {
      paint.color = const Color(0xFFFFF176).withOpacity(0.95);
      canvas.drawCircle(
          Offset(size.x * 0.15, size.y * 0.07), 20, paint);
      // Glow
      paint.color = const Color(0xFFFFF176).withOpacity(0.2);
      paint.maskFilter = const MaskFilter.blur(BlurStyle.normal, 18);
      canvas.drawCircle(
          Offset(size.x * 0.15, size.y * 0.07), 32, paint);
    }
  }

  void _drawRoad(Canvas canvas) {
    final roadLeft = size.x * 0.05;
    final roadRight = size.x * 0.95;
    final roadTop = size.y * 0.30;

    final roadPaint = Paint()..color = level.roadColor;
    canvas.drawRect(
      Rect.fromLTRB(roadLeft, roadTop, roadRight, size.y),
      roadPaint,
    );

    // Road edges
    final edgePaint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(0.6)
      ..strokeWidth = 3;
    canvas.drawLine(Offset(roadLeft, roadTop), Offset(roadLeft, size.y), edgePaint);
    canvas.drawLine(Offset(roadRight, roadTop), Offset(roadRight, size.y), edgePaint);
  }

  void _drawLaneMarkers(Canvas canvas) {
    final roadLeft = size.x * 0.05;
    final laneW = AppConstants.laneWidth;
    final markerPaint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..strokeWidth = 2;

    const dashHeight = 40.0;
    const dashGap = 30.0;
    const period = dashHeight + dashGap;

    for (int lane = 1; lane < AppConstants.numberOfLanes; lane++) {
      final x = roadLeft + laneW * lane;
      double y = -(period - (_scrollOffset % period));
      while (y < size.y) {
        canvas.drawLine(
          Offset(x, y + size.y * 0.30),
          Offset(x, (y + dashHeight).clamp(0.0, size.y) + size.y * 0.30),
          markerPaint,
        );
        y += period;
      }
    }
  }

  void _drawSideWalks(Canvas canvas) {
    final sidewalkPaint = Paint()..color = const Color(0xFF546E7A);
    // Left
    canvas.drawRect(
        Rect.fromLTWH(0, size.y * 0.30, size.x * 0.05, size.y), sidewalkPaint);
    // Right
    canvas.drawRect(
        Rect.fromLTWH(size.x * 0.95, size.y * 0.30, size.x * 0.05, size.y),
        sidewalkPaint);
  }

  void _drawEnvironment(Canvas canvas) {
    switch (level.environment) {
      case TrackEnvironment.city:
        _drawBuildings(canvas);
      case TrackEnvironment.highway:
        _drawTrees(canvas);
      case TrackEnvironment.coastal:
        _drawCoastal(canvas);
      case TrackEnvironment.industrial:
        _drawIndustrial(canvas);
    }
  }

  void _drawBuildings(Canvas canvas) {
    final buildingPaint = Paint()..color = const Color(0xFF1A237E).withOpacity(0.8);
    final windowPaint = Paint()..color = const Color(0xFFFFEB3B).withOpacity(0.7);

    final buildings = [
      _Building(0.0, 0.05, 0.25, 0.32),
      _Building(0.96, 0.05, 0.25, 0.30),
      _Building(0.0, 0.06, 0.18, 0.28),
      _Building(0.97, 0.06, 0.20, 0.25),
    ];

    for (final b in buildings) {
      final rect = Rect.fromLTWH(
        b.left * size.x,
        b.top * size.y,
        b.width * size.x,
        b.height * size.y,
      );
      canvas.drawRect(rect, buildingPaint);
      // Windows
      for (int row = 0; row < 4; row++) {
        for (int col = 0; col < 2; col++) {
          canvas.drawRect(
            Rect.fromLTWH(
              rect.left + 4 + col * 8,
              rect.top + 4 + row * 10,
              5, 6,
            ),
            windowPaint,
          );
        }
      }
    }
  }

  void _drawTrees(Canvas canvas) {
    final trunkPaint = Paint()..color = const Color(0xFF5D4037);
    final leafPaint = Paint()..color = const Color(0xFF2E7D32).withOpacity(0.85);

    final treePositions = [0.01, 0.02, 0.03, 0.97, 0.98, 0.99];
    for (final x in treePositions) {
      final baseX = x * size.x;
      final baseY = size.y * 0.30;
      final offset = (_scrollOffset * 0.5) % 200;
      for (int i = 0; i < 4; i++) {
        final yPos = baseY + (i * 200 - offset + 200) % 800;
        if (yPos > size.y) continue;
        canvas.drawRect(
            Rect.fromLTWH(baseX - 3, yPos, 6, 20), trunkPaint);
        canvas.drawCircle(Offset(baseX, yPos - 10), 16, leafPaint);
      }
    }
  }

  void _drawCoastal(Canvas canvas) {
    final waterPaint = Paint()
      ..color = const Color(0xFF0288D1).withOpacity(0.6)
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF0288D1).withOpacity(0.8),
          const Color(0xFF26C6DA).withOpacity(0.4),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.x * 0.05, size.y));

    canvas.drawRect(
        Rect.fromLTWH(0, size.y * 0.30, size.x * 0.04, size.y), waterPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.x * 0.96, size.y * 0.30, size.x * 0.04, size.y),
        waterPaint);
  }

  void _drawIndustrial(Canvas canvas) {
    final wallPaint = Paint()..color = const Color(0xFF37474F).withOpacity(0.9);
    canvas.drawRect(
        Rect.fromLTWH(0, size.y * 0.30, size.x * 0.05, size.y), wallPaint);
    canvas.drawRect(
        Rect.fromLTWH(size.x * 0.95, size.y * 0.30, size.x * 0.05, size.y),
        wallPaint);
  }

  Color _darkenColor(Color c, double amount) {
    return Color.fromARGB(
      c.alpha,
      (c.red * (1 - amount)).round().clamp(0, 255),
      (c.green * (1 - amount)).round().clamp(0, 255),
      (c.blue * (1 - amount)).round().clamp(0, 255),
    );
  }
}

class _Building {
  final double left, top, width, height;
  const _Building(this.left, this.top, this.width, this.height);
}
