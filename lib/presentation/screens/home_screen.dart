// lib/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/storage_service.dart';
import '../providers/game_provider.dart';
import '../widgets/stat_chip.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GameProvider>().load();
      AudioService.playMenuMusic();
    });
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameProvider>();
    final isOnline = context.watch<ConnectivityService>().isOnline;
    final adService = AdService();

    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
          ),

          // Speed lines decoration
          Positioned.fill(
            child: CustomPaint(painter: _SpeedLinesPainter()),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(game, isOnline),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildHeroSection(game),
                          const SizedBox(height: 32),
                          _buildMainActions(context, game),
                          const SizedBox(height: 24),
                          _buildQuickStats(game),
                          const SizedBox(height: 24),
                          if (isOnline) _buildEarnMore(context),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom banner ad
          if (isOnline && adService.isBannerReady && adService.bannerAd != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: AppTheme.surface,
                alignment: Alignment.center,
                child: AdWidget(ad: adService.bannerAd!),
                height: 52,
              ),
            ),

          // Offline indicator
          if (!isOnline)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.orange.withOpacity(0.85),
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(
                  '📡 Offline Mode — Ads & rewards unavailable',
                  textAlign: TextAlign.center,
                  style: AppTheme.labelS.copyWith(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar(GameProvider game, bool isOnline) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Row(
        children: [
          // Logo + title
          Row(
            children: [
              const Text('🏎️', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 8),
              Text(
                'Veloza Drive',
                style: GoogleFonts.rajdhani(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const Spacer(),
          // Coins
          _CoinBadge(coins: game.coins),
          const SizedBox(width: 8),
          // Settings
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/settings'),
            icon: const Icon(Icons.settings_outlined, color: AppTheme.textSecond),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection(GameProvider game) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1C2030), Color(0xFF13161C)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accent.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accent.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'LEVEL ${game.currentLevel}',
                      style: AppTheme.labelS.copyWith(color: AppTheme.accent),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      game.currentLevelModel.name,
                      style: AppTheme.headingL,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'vs ${game.currentLevelModel.opponentCarId.replaceAll('_', ' ').toUpperCase()}',
                      style: AppTheme.body,
                    ),
                  ],
                ),
              ),
              const Text('🏁', style: TextStyle(fontSize: 48)),
            ],
          ),
          const SizedBox(height: 20),
          // Difficulty indicator
          Row(
            children: [
              Text('DIFFICULTY: ', style: AppTheme.labelS),
              const SizedBox(width: 8),
              ...List.generate(5, (i) {
                final filled = i < (game.currentLevelModel.opponentSkill * 5).round();
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Container(
                    width: 20, height: 8,
                    decoration: BoxDecoration(
                      color: filled ? AppTheme.accent : AppTheme.divider,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 400.ms);
  }

  Widget _buildMainActions(BuildContext context, GameProvider game) {
    return Column(
      children: [
        // RACE button
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              '/race',
              arguments: game.currentLevel,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.play_arrow_rounded, size: 32),
                const SizedBox(width: 8),
                Text(
                  'RACE NOW',
                  style: GoogleFonts.rajdhani(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 3,
                  ),
                ),
              ],
            ),
          ),
        )
            .animate()
            .fadeIn(delay: 100.ms)
            .scale(delay: 100.ms, curve: Curves.elasticOut),

        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.directions_car_rounded,
                label: 'MY GARAGE',
                onTap: () => Navigator.pushNamed(context, '/garage'),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A237E), Color(0xFF0D47A1)],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.map_rounded,
                label: 'LEVELS',
                onTap: () => Navigator.pushNamed(context, '/levels'),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
                ),
              ),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),
      ],
    );
  }

  Widget _buildQuickStats(GameProvider game) {
    return Row(
      children: [
        Expanded(child: StatChip(label: 'WINS', value: '${game.totalWins}')),
        const SizedBox(width: 8),
        Expanded(child: StatChip(label: 'NITROS', value: '${game.nitroCount}', icon: '⚡')),
        const SizedBox(width: 8),
        Expanded(child: StatChip(label: 'CAR', value: game.selectedCar.name, small: true)),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildEarnMore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('EARN MORE', style: AppTheme.labelS.copyWith(color: AppTheme.accentGold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _RewardButton(
                  icon: '⚡',
                  label: '+3 Nitros',
                  sublabel: 'Watch ad',
                  onTap: () => context.read<GameProvider>().earnNitroFromAd(),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _RewardButton(
                  icon: '🪙',
                  label: '+500 Coins',
                  sublabel: 'Watch ad',
                  onTap: () =>
                      context.read<GameProvider>().earnCoinsFromAd(500),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }
}

// ── Supporting Widgets ─────────────────────────────────────────

class _CoinBadge extends StatelessWidget {
  final int coins;
  const _CoinBadge({required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.accentGold.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Text('🪙', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            _format(coins),
            style: GoogleFonts.rajdhani(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.accentGold,
            ),
          ),
        ],
      ),
    );
  }

  String _format(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Gradient gradient;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 76,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTheme.labelS.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardButton extends StatelessWidget {
  final String icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  const _RewardButton({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppTheme.surfaceAlt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.accentGold.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTheme.bodyBold),
                Text(sublabel, style: AppTheme.labelS),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpeedLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.accent.withOpacity(0.04)
      ..strokeWidth = 1;
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(size.width * i / 8, 0),
        Offset(size.width * i / 8 + 40, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
