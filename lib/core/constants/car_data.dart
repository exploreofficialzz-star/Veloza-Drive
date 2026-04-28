// lib/core/constants/car_data.dart
import 'dart:ui';
import '../../data/models/car_model.dart';

class CarData {
  CarData._();

  static const List<CarModel> allCars = [
    // ─── TIER 1: STARTER ───────────────────────────────────────────
    CarModel(
      id: 'striker_s1',
      name: 'Striker S1',
      tier: CarTier.starter,
      maxSpeed: 280,
      acceleration: 180,
      handling: 0.72,
      braking: 380,
      nitroMultiplier: 1.4,
      color: Color(0xFFE53935),  // Rally Red
      accentColor: Color(0xFFFFFFFF),
      unlockLevel: 1,
      unlockCost: 0,
      description: 'Entry-level street machine. Punchy, reliable, forgiving.',
      isStarterCar: true,
    ),
    CarModel(
      id: 'venom_v2',
      name: 'Venom V2',
      tier: CarTier.starter,
      maxSpeed: 310,
      acceleration: 200,
      handling: 0.70,
      braking: 400,
      nitroMultiplier: 1.45,
      color: Color(0xFF1E88E5),  // Street Blue
      accentColor: Color(0xFF90CAF9),
      unlockLevel: 3,
      unlockCost: 0,
      description: 'Sleek and aerodynamic. Built for urban circuits.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'ghost_g1',
      name: 'Ghost G1',
      tier: CarTier.starter,
      maxSpeed: 330,
      acceleration: 210,
      handling: 0.68,
      braking: 420,
      nitroMultiplier: 1.45,
      color: Color(0xFFE0E0E0),  // Pearl White
      accentColor: Color(0xFF424242),
      unlockLevel: 5,
      unlockCost: 500,
      description: 'Clean lines, crisp handling. A fan favourite.',
      isStarterCar: false,
    ),

    // ─── TIER 2: MID-LEVEL ─────────────────────────────────────────
    CarModel(
      id: 'apex_a3',
      name: 'Apex A3',
      tier: CarTier.mid,
      maxSpeed: 380,
      acceleration: 260,
      handling: 0.65,
      braking: 460,
      nitroMultiplier: 1.5,
      color: Color(0xFF43A047),  // Circuit Green
      accentColor: Color(0xFFA5D6A7),
      unlockLevel: 7,
      unlockCost: 1200,
      description: 'Mid-range beast. Corners like it\'s on rails.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'storm_st',
      name: 'Storm ST',
      tier: CarTier.mid,
      maxSpeed: 400,
      acceleration: 280,
      handling: 0.63,
      braking: 480,
      nitroMultiplier: 1.5,
      color: Color(0xFFFB8C00),  // Burnt Orange
      accentColor: Color(0xFFFFE082),
      unlockLevel: 10,
      unlockCost: 2000,
      description: 'Turbocharged street racer. Loud. Fast. Addictive.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'blade_bx',
      name: 'Blade BX',
      tier: CarTier.mid,
      maxSpeed: 420,
      acceleration: 295,
      handling: 0.61,
      braking: 500,
      nitroMultiplier: 1.55,
      color: Color(0xFF6A1B9A),  // Velocity Purple
      accentColor: Color(0xFFCE93D8),
      unlockLevel: 12,
      unlockCost: 2800,
      description: 'Sharp. Aggressive. A carbon-fibre mid-tier weapon.',
      isStarterCar: false,
    ),

    // ─── TIER 3: HIGH PERFORMANCE ──────────────────────────────────
    CarModel(
      id: 'raptor_rx',
      name: 'Raptor RX',
      tier: CarTier.highPerformance,
      maxSpeed: 490,
      acceleration: 360,
      handling: 0.57,
      braking: 560,
      nitroMultiplier: 1.6,
      color: Color(0xFFFFD600),  // Lightning Yellow
      accentColor: Color(0xFF212121),
      unlockLevel: 15,
      unlockCost: 4500,
      description: 'Track monster. Raw power, razor-sharp reactions.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'phantom_px',
      name: 'Phantom PX',
      tier: CarTier.highPerformance,
      maxSpeed: 520,
      acceleration: 390,
      handling: 0.55,
      braking: 580,
      nitroMultiplier: 1.6,
      color: Color(0xFF00ACC1),  // Neon Teal
      accentColor: Color(0xFF80DEEA),
      unlockLevel: 18,
      unlockCost: 6000,
      description: 'Phantom-smooth at 200mph. Control is everything.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'titan_tx',
      name: 'Titan TX',
      tier: CarTier.highPerformance,
      maxSpeed: 550,
      acceleration: 420,
      handling: 0.52,
      braking: 600,
      nitroMultiplier: 1.65,
      color: Color(0xFFD32F2F),  // Carbon Red
      accentColor: Color(0xFF212121),
      unlockLevel: 21,
      unlockCost: 8000,
      description: 'Heavyweight supercar. One nitro and you\'re gone.',
      isStarterCar: false,
    ),

    // ─── TIER 4: ELITE ─────────────────────────────────────────────
    CarModel(
      id: 'nova_n1',
      name: 'Nova N1',
      tier: CarTier.elite,
      maxSpeed: 620,
      acceleration: 480,
      handling: 0.48,
      braking: 650,
      nitroMultiplier: 1.7,
      color: Color(0xFFFFAB00),  // Gold Rush
      accentColor: Color(0xFF4E342E),
      unlockLevel: 24,
      unlockCost: 12000,
      description: 'Gold plated fury. Legend status on every track.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'specter_s9',
      name: 'Specter S9',
      tier: CarTier.elite,
      maxSpeed: 660,
      acceleration: 520,
      handling: 0.46,
      braking: 680,
      nitroMultiplier: 1.75,
      color: Color(0xFF00E5FF),  // Cyber Cyan
      accentColor: Color(0xFF0D47A1),
      unlockLevel: 27,
      unlockCost: 18000,
      description: 'Digital ghost. Zero to insane in 1.8 seconds.',
      isStarterCar: false,
    ),
    CarModel(
      id: 'apex_ultra',
      name: 'Apex Ultra',
      tier: CarTier.elite,
      maxSpeed: 720,
      acceleration: 580,
      handling: 0.44,
      braking: 720,
      nitroMultiplier: 1.8,
      color: Color(0xFF37474F),  // Carbon Black
      accentColor: Color(0xFF00E5FF),
      unlockLevel: 30,
      unlockCost: 25000,
      description: 'The pinnacle. Unlock it. Own the road.',
      isStarterCar: false,
    ),
  ];

  static CarModel getById(String id) =>
      allCars.firstWhere((c) => c.id == id, orElse: () => allCars.first);

  static List<CarModel> getByTier(CarTier tier) =>
      allCars.where((c) => c.tier == tier).toList();
}
