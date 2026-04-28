// lib/core/services/storage_service.dart
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class StorageService {
  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    // First launch defaults
    if (!_prefs.containsKey(AppConstants.keyCurrentLevel)) {
      await _prefs.setInt(AppConstants.keyCurrentLevel, 1);
    }
    if (!_prefs.containsKey(AppConstants.keyUnlockedLevels)) {
      await _prefs.setStringList(AppConstants.keyUnlockedLevels, ['1']);
    }
    if (!_prefs.containsKey(AppConstants.keyUnlockedCars)) {
      await _prefs.setStringList(
          AppConstants.keyUnlockedCars, ['striker_s1']);
    }
    if (!_prefs.containsKey(AppConstants.keySelectedCar)) {
      await _prefs.setString(AppConstants.keySelectedCar, 'striker_s1');
    }
    if (!_prefs.containsKey(AppConstants.keyCoinBalance)) {
      await _prefs.setInt(AppConstants.keyCoinBalance, 0);
    }
    if (!_prefs.containsKey(AppConstants.keyNitroCount)) {
      await _prefs.setInt(AppConstants.keyNitroCount, 3);
    }
    if (!_prefs.containsKey(AppConstants.keySoundEnabled)) {
      await _prefs.setBool(AppConstants.keySoundEnabled, true);
    }
    if (!_prefs.containsKey(AppConstants.keyMusicEnabled)) {
      await _prefs.setBool(AppConstants.keyMusicEnabled, true);
    }
    if (!_prefs.containsKey(AppConstants.keyNotificationsEnabled)) {
      await _prefs.setBool(AppConstants.keyNotificationsEnabled, true);
    }
  }

  // ── Level ─────────────────────────────────────────────────────
  static int get currentLevel =>
      _prefs.getInt(AppConstants.keyCurrentLevel) ?? 1;

  static Future<void> setCurrentLevel(int level) =>
      _prefs.setInt(AppConstants.keyCurrentLevel, level);

  static List<int> get unlockedLevels {
    final raw =
        _prefs.getStringList(AppConstants.keyUnlockedLevels) ?? ['1'];
    return raw.map(int.parse).toList();
  }

  static Future<void> unlockLevel(int level) async {
    final current = unlockedLevels;
    if (!current.contains(level)) {
      current.add(level);
      await _prefs.setStringList(
        AppConstants.keyUnlockedLevels,
        current.map((e) => e.toString()).toList(),
      );
    }
  }

  // ── Cars ──────────────────────────────────────────────────────
  static List<String> get unlockedCars =>
      _prefs.getStringList(AppConstants.keyUnlockedCars) ?? ['striker_s1'];

  static Future<void> unlockCar(String carId) async {
    final current = unlockedCars;
    if (!current.contains(carId)) {
      current.add(carId);
      await _prefs.setStringList(AppConstants.keyUnlockedCars, current);
    }
  }

  static String get selectedCar =>
      _prefs.getString(AppConstants.keySelectedCar) ?? 'striker_s1';

  static Future<void> setSelectedCar(String carId) =>
      _prefs.setString(AppConstants.keySelectedCar, carId);

  // ── Coins ─────────────────────────────────────────────────────
  static int get coins =>
      _prefs.getInt(AppConstants.keyCoinBalance) ?? 0;

  static Future<void> addCoins(int amount) =>
      _prefs.setInt(AppConstants.keyCoinBalance, coins + amount);

  static Future<bool> spendCoins(int amount) async {
    if (coins >= amount) {
      await _prefs.setInt(AppConstants.keyCoinBalance, coins - amount);
      return true;
    }
    return false;
  }

  // ── Nitro ─────────────────────────────────────────────────────
  static int get nitroCount =>
      _prefs.getInt(AppConstants.keyNitroCount) ?? 3;

  static Future<void> addNitro(int count) =>
      _prefs.setInt(AppConstants.keyNitroCount, nitroCount + count);

  static Future<bool> useNitro() async {
    if (nitroCount > 0) {
      await _prefs.setInt(AppConstants.keyNitroCount, nitroCount - 1);
      return true;
    }
    return false;
  }

  // ── Stats ─────────────────────────────────────────────────────
  static int get totalWins =>
      _prefs.getInt(AppConstants.keyTotalWins) ?? 0;

  static Future<void> incrementWins() =>
      _prefs.setInt(AppConstants.keyTotalWins, totalWins + 1);

  static int get raceCount =>
      _prefs.getInt(AppConstants.keyRaceCount) ?? 0;

  static Future<void> incrementRaceCount() =>
      _prefs.setInt(AppConstants.keyRaceCount, raceCount + 1);

  // ── Settings ──────────────────────────────────────────────────
  static bool get soundEnabled =>
      _prefs.getBool(AppConstants.keySoundEnabled) ?? true;

  static Future<void> setSoundEnabled(bool val) =>
      _prefs.setBool(AppConstants.keySoundEnabled, val);

  static bool get musicEnabled =>
      _prefs.getBool(AppConstants.keyMusicEnabled) ?? true;

  static Future<void> setMusicEnabled(bool val) =>
      _prefs.setBool(AppConstants.keyMusicEnabled, val);

  static bool get notificationsEnabled =>
      _prefs.getBool(AppConstants.keyNotificationsEnabled) ?? true;

  static Future<void> setNotificationsEnabled(bool val) =>
      _prefs.setBool(AppConstants.keyNotificationsEnabled, val);

  static bool get onboardingDone =>
      _prefs.getBool(AppConstants.keyOnboardingDone) ?? false;

  static Future<void> setOnboardingDone() =>
      _prefs.setBool(AppConstants.keyOnboardingDone, true);

  // ── Full reset (debug) ────────────────────────────────────────
  static Future<void> resetAll() => _prefs.clear();
}
