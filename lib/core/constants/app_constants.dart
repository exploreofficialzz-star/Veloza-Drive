// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Veloza Drive';
  static const String packageName = 'com.chastechgroup.veloza_drive';
  static const String owner = 'ChAs Tech Group';

  // AdMob IDs — Replace with real IDs before production release
  // Test App ID (Android)
  static const String admobAppIdAndroid =
      'ca-app-pub-3940256099942544~3347511713';
  // Test App ID (iOS)
  static const String admobAppIdIos =
      'ca-app-pub-3940256099942544~1458002511';

  // Test Ad Unit IDs (swap for live IDs in production)
  static const String bannerAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/6300978111';
  static const String bannerAdUnitIdIos =
      'ca-app-pub-3940256099942544/2934735716';

  static const String interstitialAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/1033173712';
  static const String interstitialAdUnitIdIos =
      'ca-app-pub-3940256099942544/4411468910';

  static const String rewardedAdUnitIdAndroid =
      'ca-app-pub-3940256099942544/5224354917';
  static const String rewardedAdUnitIdIos =
      'ca-app-pub-3940256099942544/1712485313';

  // Game Config
  static const int racesBeforeInterstitial = 3;
  static const int totalCars = 12;
  static const int totalLevels = 30;

  // Physics defaults
  static const double pixelsPerUnit = 1.0;
  static const double laneWidth = 80.0;
  static const int numberOfLanes = 3;

  // Storage Keys
  static const String keySelectedCar = 'selected_car';
  static const String keyCurrentLevel = 'current_level';
  static const String keyUnlockedCars = 'unlocked_cars';
  static const String keyUnlockedLevels = 'unlocked_levels';
  static const String keyTotalWins = 'total_wins';
  static const String keyRaceCount = 'race_count';
  static const String keyNitroCount = 'nitro_count';
  static const String keyCoinBalance = 'coin_balance';
  static const String keyOnboardingDone = 'onboarding_done';
  static const String keySoundEnabled = 'sound_enabled';
  static const String keyMusicEnabled = 'music_enabled';
  static const String keyNotificationsEnabled = 'notifications_enabled';

  // Overlay names
  static const String overlayHud = 'hud';
  static const String overlayPause = 'pause';
  static const String overlayRaceResult = 'race_result';
  static const String overlayCountdown = 'countdown';

  // Notification IDs
  static const int dailyChallengeNotifId = 1001;
  static const int comeBackNotifId = 1002;
}
