// lib/presentation/screens/garage_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../data/models/car_model.dart';
import '../providers/game_provider.dart';
import '../widgets/car_stat_bar.dart';

class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> {
  CarTier _selectedTier = CarTier.starter;

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('GARAGE'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                const Text('🪙', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 4),
                Text(
                  '${game.coins}',
                  style: GoogleFonts.rajdhani(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _TierFilterBar(
            selected: _selectedTier,
            onSelect: (t) => setState(() => _selectedTier = t),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: game.allCars
                  .where((c) => c.tier == _selectedTier)
                  .length,
              itemBuilder: (ctx, i) {
                final cars = game.allCars
                    .where((c) => c.tier == _selectedTier)
                    .toList();
                return _CarCard(
                  car: cars[i],
                  isUnlocked: game.isCarUnlocked(cars[i].id),
                  isSelected: game.selectedCar.id == cars[i].id,
                  onSelect: () => game.selectCar(cars[i]),
                  onUnlockCoins: () => _unlockWithCoins(ctx, cars[i], game),
                  onUnlockAd: () => _unlockWithAd(ctx, cars[i], game),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _unlockWithCoins(
      BuildContext ctx, CarModel car, GameProvider game) async {
    final success = await game.unlockCarWithCoins(car);
    if (!success && ctx.mounted) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Not enough coins! Need ${car.unlockCost} 🪙'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
  }

  void _unlockWithAd(
      BuildContext ctx, CarModel car, GameProvider game) async {
    final isOnline = ctx.read<ConnectivityService>().isOnline;
    if (!isOnline) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('No internet connection!')),
      );
      return;
    }
    await game.unlockCarWithAd(car);
  }
}

class _TierFilterBar extends StatelessWidget {
  final CarTier selected;
  final ValueChanged<CarTier> onSelect;

  const _TierFilterBar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: AppTheme.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: CarTier.values.map((tier) {
            final isSelected = tier == selected;
            return GestureDetector(
              onTap: () => onSelect(tier),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.accent : AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.accent
                        : AppTheme.divider,
                  ),
                ),
                child: Text(
                  _tierLabel(tier),
                  style: AppTheme.labelS.copyWith(
                    color: isSelected
                        ? Colors.white
                        : AppTheme.textSecond,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _tierLabel(CarTier t) {
    switch (t) {
      case CarTier.starter: return 'STARTER';
      case CarTier.mid: return 'MID-LEVEL';
      case CarTier.highPerformance: return 'HIGH PERF';
      case CarTier.elite: return 'ELITE';
    }
  }
}

class _CarCard extends StatelessWidget {
  final CarModel car;
  final bool isUnlocked;
  final bool isSelected;
  final VoidCallback onSelect;
  final VoidCallback onUnlockCoins;
  final VoidCallback onUnlockAd;

  const _CarCard({
    required this.car,
    required this.isUnlocked,
    required this.isSelected,
    required this.onSelect,
    required this.onUnlockCoins,
    required this.onUnlockAd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppTheme.accent
              : isUnlocked
                  ? AppTheme.divider
                  : AppTheme.divider.withOpacity(0.5),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.accent.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Car preview strip
          Container(
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  car.color.withOpacity(0.3),
                  car.accentColor.withOpacity(0.1),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              children: [
                // Car icon
                Center(
                  child: Opacity(
                    opacity: isUnlocked ? 1.0 : 0.4,
                    child: Text(
                      '🏎️',
                      style: TextStyle(
                        fontSize: 56,
                        shadows: [
                          Shadow(
                            color: car.color.withOpacity(0.8),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (!isUnlocked)
                  const Center(
                    child: Text('🔒', style: TextStyle(fontSize: 32)),
                  ),
                if (isSelected)
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppTheme.accent,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'SELECTED',
                        style: AppTheme.labelS
                            .copyWith(color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(car.name, style: AppTheme.headingM),
                          const SizedBox(height: 2),
                          Text(car.description, style: AppTheme.body),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: _tierGradient(car.tier),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        car.tierLabel,
                        style: AppTheme.labelS.copyWith(
                            color: Colors.white, fontSize: 9),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Stats
                CarStatBar(label: 'SPEED', value: car.speedRating),
                const SizedBox(height: 6),
                CarStatBar(label: 'ACCEL', value: car.accelRating),
                const SizedBox(height: 6),
                CarStatBar(label: 'HANDLE', value: car.handlingRating),
                const SizedBox(height: 6),
                CarStatBar(label: 'BRAKE', value: car.brakingRating),

                const SizedBox(height: 16),

                // Actions
                if (isUnlocked)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSelected ? null : onSelect,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isSelected ? AppTheme.divider : AppTheme.accent,
                      ),
                      child: Text(isSelected ? 'IN USE' : 'SELECT'),
                    ),
                  )
                else ...[
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onUnlockCoins,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.accentGold,
                            side: const BorderSide(color: AppTheme.accentGold),
                          ),
                          child: Text(
                            '🪙 ${car.unlockCost}',
                            style: GoogleFonts.rajdhani(
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onUnlockAd,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentGold,
                            foregroundColor: Colors.black,
                          ),
                          child: const Text('📺 WATCH AD'),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.05, end: 0);
  }

  LinearGradient _tierGradient(CarTier tier) {
    switch (tier) {
      case CarTier.starter:
        return const LinearGradient(colors: [Color(0xFF424242), Color(0xFF616161)]);
      case CarTier.mid:
        return const LinearGradient(colors: [Color(0xFF1565C0), Color(0xFF1976D2)]);
      case CarTier.highPerformance:
        return const LinearGradient(colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)]);
      case CarTier.elite:
        return AppTheme.goldGradient;
    }
  }
}
