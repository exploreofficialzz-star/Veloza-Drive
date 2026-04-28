// lib/presentation/screens/race_screen.dart
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_constants.dart';
import '../../core/constants/car_data.dart';
import '../../core/constants/level_data.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/theme/app_theme.dart';
import '../../data/models/level_model.dart';
import '../../game/racing_game.dart';
import '../providers/game_provider.dart';

class RaceScreen extends StatefulWidget {
  final int levelId;
  const RaceScreen({super.key, required this.levelId});

  @override
  State<RaceScreen> createState() => _RaceScreenState();
}

class _RaceScreenState extends State<RaceScreen> {
  late RacingGame _game;
  bool _won = false;
  bool _finished = false;
  bool _secondChanceUsed = false;

  @override
  void initState() {
    super.initState();
    final gameProvider = context.read<GameProvider>();
    final level = LevelData.getById(widget.levelId);
    final opponentModel = CarData.getById(level.opponentCarId);

    _game = RacingGame(
      playerCarModel: gameProvider.selectedCar,
      opponentCarModel: opponentModel,
      level: level,
      onRaceWon: _handleWin,
      onRaceLost: _handleLoss,
      onPause: () {},
    );
  }

  void _handleWin() async {
    if (_finished) return;
    setState(() {
      _won = true;
      _finished = true;
    });
    final gameProvider = context.read<GameProvider>();
    final reward = LevelData.getById(widget.levelId).coinReward;
    await gameProvider.onRaceWon(widget.levelId, reward);
    await AudioService.playWin();
  }

  void _handleLoss() {
    if (_finished) return;
    setState(() {
      _won = false;
      _finished = true;
    });
    AudioService.playLose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GameWidget(
        game: _game,
        overlayBuilderMap: {
          AppConstants.overlayCountdown: (ctx, game) =>
              _CountdownOverlay(game: game as RacingGame),
          AppConstants.overlayHud: (ctx, game) =>
              _HudOverlay(game: game as RacingGame),
          AppConstants.overlayPause: (ctx, game) =>
              _PauseOverlay(
                onResume: () => (game as RacingGame).resumeRace(),
                onQuit: () => _quit(ctx),
              ),
          AppConstants.overlayRaceResult: (ctx, game) =>
              _ResultOverlay(
                won: _won,
                levelId: widget.levelId,
                secondChanceUsed: _secondChanceUsed,
                onRetry: () => _retry(ctx),
                onSecondChance: () => _secondChance(ctx, game as RacingGame),
                onNext: () => _nextLevel(ctx),
                onQuit: () => _quit(ctx),
              ),
        },
      ),
    );
  }

  void _retry(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(builder: (_) => RaceScreen(levelId: widget.levelId)),
    );
  }

  void _nextLevel(BuildContext ctx) {
    final next = widget.levelId + 1;
    if (next <= LevelData.allLevels.length) {
      Navigator.of(ctx).pushReplacement(
        MaterialPageRoute(builder: (_) => RaceScreen(levelId: next)),
      );
    } else {
      Navigator.of(ctx).pushNamedAndRemoveUntil('/home', (_) => false);
    }
  }

  void _secondChance(BuildContext ctx, RacingGame game) async {
    final earned = await AdService().showRewarded();
    if (earned && mounted) {
      setState(() {
        _secondChanceUsed = true;
        _finished = false;
        _won = false;
      });
      game.overlays.remove(AppConstants.overlayRaceResult);
      game.resumeRace();
    }
  }

  void _quit(BuildContext ctx) {
    AudioService.stopMusic();
    Navigator.of(ctx).pushNamedAndRemoveUntil('/home', (_) => false);
  }
}

// ── Countdown Overlay ─────────────────────────────────────────

class _CountdownOverlay extends StatelessWidget {
  final RacingGame game;
  const _CountdownOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: game,
        builder: (_, __) {
          final t = game.countdownTimer.ceil();
          final label = t > 0 ? '$t' : 'GO!';
          return Text(
            label,
            style: GoogleFonts.rajdhani(
              fontSize: 96,
              fontWeight: FontWeight.w900,
              color: t > 0 ? AppTheme.accentGold : AppTheme.success,
              shadows: [
                Shadow(
                  color: (t > 0 ? AppTheme.accentGold : AppTheme.success)
                      .withOpacity(0.6),
                  blurRadius: 30,
                ),
              ],
            ),
          ).animate(key: ValueKey(t)).scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 300.ms,
                curve: Curves.elasticOut,
              );
        },
      ),
    );
  }
}

// ── HUD Overlay (tap zones) ────────────────────────────────────

class _HudOverlay extends StatelessWidget {
  final RacingGame game;
  const _HudOverlay({required this.game});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Left steer zone
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: MediaQuery.of(context).size.width * 0.33,
          child: GestureDetector(
            onTap: () => game.playerCar.steerLeft(),
            child: Container(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: _TapHint(label: '◄', opacity: 0.25),
                ),
              ),
            ),
          ),
        ),

        // Right steer zone
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: MediaQuery.of(context).size.width * 0.33,
          child: GestureDetector(
            onTap: () => game.playerCar.steerRight(),
            child: Container(
              color: Colors.transparent,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _TapHint(label: '►', opacity: 0.25),
                ),
              ),
            ),
          ),
        ),

        // Nitro zone (center)
        Positioned(
          bottom: 100,
          left: MediaQuery.of(context).size.width * 0.33,
          right: MediaQuery.of(context).size.width * 0.33,
          child: GestureDetector(
            onTap: () => game.activateNitro(),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: AppTheme.nitroGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.nitro.withOpacity(0.4),
                    blurRadius: 12,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  '⚡ NITRO',
                  style: GoogleFonts.rajdhani(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Pause button
        Positioned(
          top: 12,
          right: 12,
          child: SafeArea(
            child: GestureDetector(
              onTap: () => game.pauseRace(),
              child: Container(
                width: 40, height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24),
                ),
                child: const Icon(Icons.pause, color: Colors.white, size: 20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TapHint extends StatelessWidget {
  final String label;
  final double opacity;
  const _TapHint({required this.label, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 32,
        color: Colors.white.withOpacity(opacity),
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

// ── Pause Overlay ─────────────────────────────────────────────

class _PauseOverlay extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onQuit;
  const _PauseOverlay({required this.onResume, required this.onQuit});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.75),
      child: Center(
        child: Container(
          width: 280,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.divider),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('PAUSED', style: AppTheme.headingL),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onResume,
                  child: const Text('RESUME'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: onQuit,
                child: Text(
                  'QUIT RACE',
                  style: AppTheme.body.copyWith(color: AppTheme.danger),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Result Overlay ────────────────────────────────────────────

class _ResultOverlay extends StatelessWidget {
  final bool won;
  final int levelId;
  final bool secondChanceUsed;
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final VoidCallback onQuit;
  final Function(BuildContext, RacingGame) onSecondChance;

  const _ResultOverlay({
    required this.won,
    required this.levelId,
    required this.secondChanceUsed,
    required this.onRetry,
    required this.onNext,
    required this.onQuit,
    required this.onSecondChance,
  });

  @override
  Widget build(BuildContext context) {
    final level = LevelData.getById(levelId);
    final adService = AdService();

    return Container(
      color: Colors.black.withOpacity(0.80),
      child: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: won
                  ? [const Color(0xFF1B5E20), AppTheme.surface]
                  : [const Color(0xFF7F0000), AppTheme.surface],
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: won ? AppTheme.success : AppTheme.danger,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                won ? '🏆' : '💨',
                style: const TextStyle(fontSize: 56),
              ).animate().scale(
                    begin: const Offset(0.3, 0.3),
                    duration: 500.ms,
                    curve: Curves.elasticOut,
                  ),
              const SizedBox(height: 12),
              Text(
                won ? 'RACE WON!' : 'RACE LOST',
                style: AppTheme.headingL.copyWith(
                  color: won ? AppTheme.success : AppTheme.danger,
                ),
              ),
              if (won) ...[
                const SizedBox(height: 8),
                Text(
                  '+${level.coinReward} coins',
                  style: GoogleFonts.rajdhani(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentGold,
                  ),
                ),
              ],
              const SizedBox(height: 28),

              // Won actions
              if (won) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onNext,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.success),
                    child: const Text('NEXT LEVEL'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onRetry,
                  child: Text('Replay', style: AppTheme.body),
                ),
              ],

              // Lost actions
              if (!won) ...[
                // Second chance via ad
                if (!secondChanceUsed && adService.isRewardedReady)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => onSecondChance(
                          context,
                          // ignore: invalid_use_of_protected_member
                          WidgetsBinding.instance.focusManager.rootScope
                              as RacingGame),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('📺  WATCH AD — 2ND CHANCE'),
                    ),
                  ),
                if (!secondChanceUsed && adService.isRewardedReady)
                  const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onRetry,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accent),
                    child: const Text('RETRY'),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: onQuit,
                  child: Text('Quit', style: AppTheme.body),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
