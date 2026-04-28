// lib/data/models/car_model.dart
import 'dart:ui';

enum CarTier { starter, mid, highPerformance, elite }

class CarModel {
  final String id;
  final String name;
  final CarTier tier;
  final double maxSpeed;       // km/h
  final double acceleration;   // 0-100 km/h in units
  final double handling;       // 0.0 - 1.0
  final double braking;        // braking force
  final double nitroMultiplier;
  final Color color;
  final Color accentColor;
  final int unlockLevel;
  final int unlockCost;        // coins
  final String description;
  final bool isStarterCar;

  const CarModel({
    required this.id,
    required this.name,
    required this.tier,
    required this.maxSpeed,
    required this.acceleration,
    required this.handling,
    required this.braking,
    required this.nitroMultiplier,
    required this.color,
    required this.accentColor,
    required this.unlockLevel,
    required this.unlockCost,
    required this.description,
    this.isStarterCar = false,
  });

  String get tierLabel {
    switch (tier) {
      case CarTier.starter:
        return 'STARTER';
      case CarTier.mid:
        return 'MID-LEVEL';
      case CarTier.highPerformance:
        return 'HIGH PERF';
      case CarTier.elite:
        return 'ELITE';
    }
  }

  // Normalised 0-100 stats for UI display
  int get speedRating => ((maxSpeed / 720) * 100).round().clamp(0, 100);
  int get accelRating => ((acceleration / 580) * 100).round().clamp(0, 100);
  int get handlingRating => (handling * 100).round().clamp(0, 100);
  int get brakingRating => ((braking / 720) * 100).round().clamp(0, 100);
}
