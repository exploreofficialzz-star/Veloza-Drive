// lib/presentation/screens/levels_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../data/models/level_model.dart';
import '../providers/game_provider.dart';
import 'race_screen.dart';

class LevelsScreen extends StatelessWidget {
  const LevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text('LEVELS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: game.allLevels.length,
        itemBuilder: (ctx, i) {
          final level = game.allLevels[i];
          final isUnlocked = game.isLevelUnlocked(level.id);
          final isCurrent = level.id == game.currentLevel;

          return _LevelTile(
            level: level,
            isUnlocked: isUnlocked,
            isCurrent: isCurrent,
            onTap: () => _onTap(ctx, level, isUnlocked, game),
          ).animate(delay: (i * 30).ms).fadeIn().scale(
                begin: const Offset(0.85, 0.85),
              );
        },
      ),
    );
  }

  void _onTap(BuildContext ctx, LevelModel level, bool isUnlocked,
      GameProvider game) async {
    if (isUnlocked) {
      Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => RaceScreen(levelId: level.id)),
      );
      return;
    }

    // Locked — show unlock dialog
    if (level.requiresAdOrWait) {
      _showUnlockDialog(ctx, level, game);
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: Text('Win level ${level.id - 1} to unlock this!'),
          backgroundColor: AppTheme.surfaceAlt,
        ),
      );
    }
  }

  void _showUnlockDialog(
      BuildContext ctx, LevelModel level, GameProvider game) {
    final isOnline = ctx.read<ConnectivityService>().isOnline;

    showModalBottomSheet(
      context: ctx,
      backgroundColor: AppTheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔒', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text('Level ${level.id}: ${level.name}',
                style: AppTheme.headingM, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              level.unlockHint ?? 'Watch an ad to unlock this level',
              style: AppTheme.body,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (isOnline && AdService().isRewardedReady)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    final unlocked =
                        await game.unlockLevelWithAd(level.id);
                    if (unlocked && ctx.mounted) {
                      Navigator.push(
                        ctx,
                        MaterialPageRoute(
                            builder: (_) => RaceScreen(levelId: level.id)),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentGold,
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('📺  WATCH AD TO UNLOCK'),
                ),
              ),
            if (!isOnline)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceAlt,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '📡 Go online to watch an ad and unlock this level.',
                  style: AppTheme.body,
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: AppTheme.body),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelTile extends StatelessWidget {
  final LevelModel level;
  final bool isUnlocked;
  final bool isCurrent;
  final VoidCallback onTap;

  const _LevelTile({
    required this.level,
    required this.isUnlocked,
    required this.isCurrent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: isCurrent
              ? AppTheme.accentGradient
              : isUnlocked
                  ? const LinearGradient(
                      colors: [Color(0xFF1C2030), Color(0xFF13161C)],
                    )
                  : const LinearGradient(
                      colors: [Color(0xFF0F1118), Color(0xFF0A0C10)],
                    ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isCurrent
                ? AppTheme.accent
                : isUnlocked
                    ? AppTheme.divider
                    : AppTheme.divider.withOpacity(0.3),
            width: isCurrent ? 2 : 1,
          ),
          boxShadow: isCurrent
              ? [
                  BoxShadow(
                    color: AppTheme.accent.withOpacity(0.3),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Text(
              isUnlocked ? _envEmoji(level.environment) : '🔒',
              style: TextStyle(
                fontSize: 26,
                color: isUnlocked ? null : null,
              ),
            ),
            const SizedBox(height: 6),
            // Level number
            Text(
              '${level.id}',
              style: GoogleFonts.rajdhani(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: isCurrent
                    ? Colors.white
                    : isUnlocked
                        ? AppTheme.textPrimary
                        : AppTheme.textSecond.withOpacity(0.4),
              ),
            ),
            if (isUnlocked) ...[
              const SizedBox(height: 2),
              Text(
                level.name,
                style: AppTheme.labelS.copyWith(fontSize: 8),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            if (level.requiresAdOrWait && !isUnlocked) ...[
              const SizedBox(height: 2),
              const Text('📺', style: TextStyle(fontSize: 12)),
            ],
            if (isCurrent) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'NOW',
                  style: AppTheme.labelS.copyWith(
                      color: Colors.white, fontSize: 8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _envEmoji(TrackEnvironment env) {
    switch (env) {
      case TrackEnvironment.city: return '🏙️';
      case TrackEnvironment.highway: return '🛣️';
      case TrackEnvironment.coastal: return '🌊';
      case TrackEnvironment.industrial: return '🏭';
    }
  }
}
