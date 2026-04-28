// lib/data/models/level_model.dart
import 'dart:ui';

enum TimeOfDay { dawn, day, dusk, night }
enum TrackEnvironment { highway, city, industrial, coastal }

class LevelModel {
  final int id;
  final String name;
  final String opponentCarId;
  final double opponentSkill;     // 0.0–1.0 AI difficulty
  final int trafficDensity;       // 0–10
  final int obstacleDensity;      // 0–5
  final TimeOfDay timeOfDay;
  final TrackEnvironment environment;
  final int distanceMeters;
  final int coinReward;
  final bool requiresAdOrWait;    // progression gate
  final int? waitMinutes;         // null = watch ad, int = wait X mins
  final String? unlockHint;

  const LevelModel({
    required this.id,
    required this.name,
    required this.opponentCarId,
    required this.opponentSkill,
    required this.trafficDensity,
    required this.obstacleDensity,
    required this.timeOfDay,
    required this.environment,
    required this.distanceMeters,
    required this.coinReward,
    this.requiresAdOrWait = false,
    this.waitMinutes,
    this.unlockHint,
  });

  Color get skyColor {
    switch (timeOfDay) {
      case TimeOfDay.dawn:
        return const Color(0xFFFF8A65);
      case TimeOfDay.day:
        return const Color(0xFF42A5F5);
      case TimeOfDay.dusk:
        return const Color(0xFF7B1FA2);
      case TimeOfDay.night:
        return const Color(0xFF0D1B2A);
    }
  }

  Color get roadColor {
    switch (environment) {
      case TrackEnvironment.highway:
        return const Color(0xFF37474F);
      case TrackEnvironment.city:
        return const Color(0xFF263238);
      case TrackEnvironment.industrial:
        return const Color(0xFF424242);
      case TrackEnvironment.coastal:
        return const Color(0xFF455A64);
    }
  }
}
