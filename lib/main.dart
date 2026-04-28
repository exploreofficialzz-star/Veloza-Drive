// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/ad_service.dart';
import 'presentation/providers/game_provider.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/race_screen.dart';
import 'presentation/screens/garage_screen.dart';
import 'presentation/screens/levels_screen.dart';
import 'presentation/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock portrait
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Immersive UI
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => AdService()),
      ],
      child: const ChasRacingApp(),
    ),
  );
}

class ChasRacingApp extends StatelessWidget {
  const ChasRacingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Veloza Drive',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return _slide(const SplashScreen(), settings);
          case '/home':
            return _slide(const HomeScreen(), settings);
          case '/garage':
            return _slide(const GarageScreen(), settings);
          case '/levels':
            return _slide(const LevelsScreen(), settings);
          case '/settings':
            return _slide(const SettingsScreen(), settings);
          case '/race':
            final levelId = settings.arguments as int? ?? 1;
            return _slide(RaceScreen(levelId: levelId), settings);
          default:
            return _slide(const HomeScreen(), settings);
        }
      },
    );
  }

  PageRoute _slide(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, animation, __, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }
}
