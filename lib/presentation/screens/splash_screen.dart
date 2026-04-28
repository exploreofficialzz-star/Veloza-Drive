// lib/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/ad_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool _ready = false;
  String _status = 'Initializing...';
  late AnimationController _engineController;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _engineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(milliseconds: 300));

    setState(() => _status = 'Loading game data...');
    await StorageService.init();
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() => _status = 'Connecting...');
    await ConnectivityService().init();
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() => _status = 'Loading ads...');
    await AdService().init();
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() => _status = 'Setting up notifications...');
    await NotificationService.init();
    if (StorageService.notificationsEnabled) {
      await NotificationService.requestPermission();
      await NotificationService.scheduleDailyChallenge();
    }

    setState(() => _status = 'Loading audio...');
    await AudioService.init();

    await Future.delayed(const Duration(milliseconds: 600));
    setState(() {
      _status = 'Ready!';
      _ready = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  void dispose() {
    _engineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          // Background grid lines
          CustomPaint(
            painter: _GridPainter(),
            size: Size.infinite,
          ),

          // Road speed lines
          ...List.generate(
            8,
            (i) => Positioned(
              left: 20.0 + i * 50,
              top: 0,
              bottom: 0,
              child: AnimatedBuilder(
                animation: _engineController,
                builder: (_, __) {
                  final offset =
                      (_engineController.value * MediaQuery.of(context).size.height * 2) %
                          MediaQuery.of(context).size.height;
                  return Transform.translate(
                    offset: Offset(0, offset),
                    child: Container(
                      width: 2,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppTheme.accent.withOpacity(0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo container
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [Color(0xFF1C2030), Color(0xFF0A0C10)],
                    ),
                    border: Border.all(
                      color: AppTheme.accent.withOpacity(0.8),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🏎️', style: TextStyle(fontSize: 64)),
                  ),
                )
                    .animate()
                    .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut),

                const SizedBox(height: 32),

                // Game title
                Text(
                  'VELOZA',
                  style: GoogleFonts.rajdhani(
                    fontSize: 68,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accent,
                    letterSpacing: 8,
                    shadows: [
                      Shadow(
                        color: AppTheme.accent.withOpacity(0.5),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 500.ms)
                    .slideY(begin: 0.3, end: 0),

                Text(
                  'DRIVE',
                  style: GoogleFonts.rajdhani(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecond,
                    letterSpacing: 12,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms, duration: 500.ms),

                const SizedBox(height: 60),

                // Loading bar
                if (!_ready)
                  Column(
                    children: [
                      SizedBox(
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            backgroundColor:
                                AppTheme.divider,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.accent),
                            minHeight: 3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _status,
                        style: AppTheme.labelS,
                      ),
                    ],
                  ).animate().fadeIn(delay: 800.ms),

                if (_ready)
                  Text(
                    '🚀 Let\'s Race!',
                    style: GoogleFonts.rajdhani(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.success,
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(duration: 300.ms).scale(),
              ],
            ),
          ),

          // Owner credit at bottom
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  'By ChAs',
                  style: GoogleFonts.rajdhani(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentGold,
                    letterSpacing: 3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'ChAs Tech Group',
                  style: AppTheme.labelS.copyWith(
                    color: AppTheme.textSecond.withOpacity(0.6),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 1000.ms),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
