// lib/core/constants/level_data.dart
import '../../data/models/level_model.dart';

class LevelData {
  LevelData._();

  static const List<LevelModel> allLevels = [
    // ── BEGINNER BLOCK (1–5) ───────────────────────────────────────
    LevelModel(
      id: 1, name: 'Street Debut', opponentCarId: 'striker_s1',
      opponentSkill: 0.35, trafficDensity: 1, obstacleDensity: 0,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.city,
      distanceMeters: 1200, coinReward: 100,
    ),
    LevelModel(
      id: 2, name: 'City Rush', opponentCarId: 'striker_s1',
      opponentSkill: 0.42, trafficDensity: 2, obstacleDensity: 0,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.city,
      distanceMeters: 1400, coinReward: 120,
    ),
    LevelModel(
      id: 3, name: 'Morning Sprint', opponentCarId: 'venom_v2',
      opponentSkill: 0.45, trafficDensity: 2, obstacleDensity: 1,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.highway,
      distanceMeters: 1600, coinReward: 140,
    ),
    LevelModel(
      id: 4, name: 'The Bypass', opponentCarId: 'venom_v2',
      opponentSkill: 0.50, trafficDensity: 3, obstacleDensity: 1,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.highway,
      distanceMeters: 1800, coinReward: 160,
    ),
    LevelModel(
      id: 5, name: 'Twilight Run',
      opponentCarId: 'ghost_g1',
      opponentSkill: 0.52, trafficDensity: 3, obstacleDensity: 1,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.city,
      distanceMeters: 2000, coinReward: 200,
      requiresAdOrWait: true, unlockHint: 'Watch an ad or wait 5 min to unlock',
      waitMinutes: 5,
    ),
    // ── INTERMEDIATE BLOCK (6–12) ──────────────────────────────────
    LevelModel(
      id: 6, name: 'Industrial Drag', opponentCarId: 'ghost_g1',
      opponentSkill: 0.55, trafficDensity: 3, obstacleDensity: 2,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.industrial,
      distanceMeters: 2200, coinReward: 250,
    ),
    LevelModel(
      id: 7, name: 'Night Circuit', opponentCarId: 'apex_a3',
      opponentSkill: 0.58, trafficDensity: 4, obstacleDensity: 2,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.city,
      distanceMeters: 2400, coinReward: 280,
    ),
    LevelModel(
      id: 8, name: 'Coast Highway', opponentCarId: 'apex_a3',
      opponentSkill: 0.60, trafficDensity: 4, obstacleDensity: 2,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.coastal,
      distanceMeters: 2600, coinReward: 300,
    ),
    LevelModel(
      id: 9, name: 'Rush Hour', opponentCarId: 'storm_st',
      opponentSkill: 0.63, trafficDensity: 6, obstacleDensity: 2,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.city,
      distanceMeters: 2800, coinReward: 340,
    ),
    LevelModel(
      id: 10, name: 'Storm Chaser', opponentCarId: 'storm_st',
      opponentSkill: 0.65, trafficDensity: 5, obstacleDensity: 3,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.highway,
      distanceMeters: 3000, coinReward: 380,
      requiresAdOrWait: true, unlockHint: 'Watch ad to unlock Storm level',
      waitMinutes: 10,
    ),
    LevelModel(
      id: 11, name: 'Blade Run', opponentCarId: 'blade_bx',
      opponentSkill: 0.67, trafficDensity: 5, obstacleDensity: 3,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.industrial,
      distanceMeters: 3200, coinReward: 420,
    ),
    LevelModel(
      id: 12, name: 'Night Blade', opponentCarId: 'blade_bx',
      opponentSkill: 0.70, trafficDensity: 6, obstacleDensity: 3,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.city,
      distanceMeters: 3400, coinReward: 460,
    ),
    // ── HIGH PERFORMANCE BLOCK (13–21) ────────────────────────────
    LevelModel(
      id: 13, name: 'Raptor Unleashed', opponentCarId: 'raptor_rx',
      opponentSkill: 0.72, trafficDensity: 6, obstacleDensity: 3,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.highway,
      distanceMeters: 3600, coinReward: 520,
    ),
    LevelModel(
      id: 14, name: 'Coastal Fury', opponentCarId: 'raptor_rx',
      opponentSkill: 0.74, trafficDensity: 6, obstacleDensity: 4,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.coastal,
      distanceMeters: 3800, coinReward: 560,
    ),
    LevelModel(
      id: 15, name: 'Phantom Strike',
      opponentCarId: 'phantom_px',
      opponentSkill: 0.76, trafficDensity: 7, obstacleDensity: 4,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.highway,
      distanceMeters: 4000, coinReward: 620,
      requiresAdOrWait: true, unlockHint: 'Watch ad or wait 15 min',
      waitMinutes: 15,
    ),
    LevelModel(
      id: 16, name: 'Urban Legend', opponentCarId: 'phantom_px',
      opponentSkill: 0.77, trafficDensity: 7, obstacleDensity: 4,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.city,
      distanceMeters: 4200, coinReward: 660,
    ),
    LevelModel(
      id: 17, name: 'Industrial Titan', opponentCarId: 'titan_tx',
      opponentSkill: 0.79, trafficDensity: 7, obstacleDensity: 4,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.industrial,
      distanceMeters: 4400, coinReward: 720,
    ),
    LevelModel(
      id: 18, name: 'Night Terror', opponentCarId: 'titan_tx',
      opponentSkill: 0.81, trafficDensity: 8, obstacleDensity: 4,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.city,
      distanceMeters: 4600, coinReward: 780,
    ),
    LevelModel(
      id: 19, name: 'Titan Returns', opponentCarId: 'titan_tx',
      opponentSkill: 0.83, trafficDensity: 8, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.coastal,
      distanceMeters: 4800, coinReward: 840,
    ),
    LevelModel(
      id: 20, name: 'Grid Destroyer', opponentCarId: 'titan_tx',
      opponentSkill: 0.85, trafficDensity: 8, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.highway,
      distanceMeters: 5000, coinReward: 900,
      requiresAdOrWait: true, unlockHint: 'Watch ad to enter Elite zone',
      waitMinutes: 20,
    ),
    LevelModel(
      id: 21, name: 'Ghost Protocol', opponentCarId: 'phantom_px',
      opponentSkill: 0.86, trafficDensity: 9, obstacleDensity: 5,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.industrial,
      distanceMeters: 5200, coinReward: 960,
    ),
    // ── ELITE BLOCK (22–30) ────────────────────────────────────────
    LevelModel(
      id: 22, name: 'Nova Rising', opponentCarId: 'nova_n1',
      opponentSkill: 0.87, trafficDensity: 9, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.city,
      distanceMeters: 5400, coinReward: 1100,
    ),
    LevelModel(
      id: 23, name: 'Gold Rush', opponentCarId: 'nova_n1',
      opponentSkill: 0.88, trafficDensity: 9, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.highway,
      distanceMeters: 5600, coinReward: 1200,
    ),
    LevelModel(
      id: 24, name: 'Specter Mode', opponentCarId: 'specter_s9',
      opponentSkill: 0.90, trafficDensity: 9, obstacleDensity: 5,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.coastal,
      distanceMeters: 5800, coinReward: 1300,
      requiresAdOrWait: true, unlockHint: 'Watch ad to face Specter',
      waitMinutes: 30,
    ),
    LevelModel(
      id: 25, name: 'Cyber Grid', opponentCarId: 'specter_s9',
      opponentSkill: 0.91, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.city,
      distanceMeters: 6000, coinReward: 1400,
    ),
    LevelModel(
      id: 26, name: 'Coastal Elite', opponentCarId: 'specter_s9',
      opponentSkill: 0.92, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.day, environment: TrackEnvironment.coastal,
      distanceMeters: 6200, coinReward: 1500,
    ),
    LevelModel(
      id: 27, name: 'Ultra Duel', opponentCarId: 'apex_ultra',
      opponentSkill: 0.93, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dusk, environment: TrackEnvironment.highway,
      distanceMeters: 6400, coinReward: 1700,
    ),
    LevelModel(
      id: 28, name: 'Midnight Ultra', opponentCarId: 'apex_ultra',
      opponentSkill: 0.94, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.industrial,
      distanceMeters: 6600, coinReward: 1900,
    ),
    LevelModel(
      id: 29, name: 'The Final Circuit', opponentCarId: 'apex_ultra',
      opponentSkill: 0.96, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.dawn, environment: TrackEnvironment.city,
      distanceMeters: 6800, coinReward: 2200,
    ),
    LevelModel(
      id: 30, name: 'APEX CHAMPIONSHIP',
      opponentCarId: 'apex_ultra',
      opponentSkill: 1.0, trafficDensity: 10, obstacleDensity: 5,
      timeOfDay: TimeOfDay.night, environment: TrackEnvironment.coastal,
      distanceMeters: 8000, coinReward: 5000,
      requiresAdOrWait: true,
      unlockHint: 'Watch an ad to enter the APEX Championship!',
    ),
  ];

  static LevelModel getById(int id) =>
      allLevels.firstWhere((l) => l.id == id);
}
