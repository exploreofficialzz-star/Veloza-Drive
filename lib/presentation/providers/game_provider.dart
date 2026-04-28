// lib/presentation/providers/game_provider.dart
import 'package:flutter/foundation.dart';
import '../../core/constants/car_data.dart';
import '../../core/constants/level_data.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/ad_service.dart';
import '../../data/models/car_model.dart';
import '../../data/models/level_model.dart';

class GameProvider extends ChangeNotifier {
  // ── State ─────────────────────────────────────────────────────
  late CarModel _selectedCar;
  late int _currentLevel;
  late List<String> _unlockedCars;
  late List<int> _unlockedLevels;
  late int _coins;
  late int _nitroCount;
  late int _totalWins;
  bool _isLoading = false;

  // ── Getters ───────────────────────────────────────────────────
  CarModel get selectedCar => _selectedCar;
  int get currentLevel => _currentLevel;
  List<String> get unlockedCarIds => _unlockedCars;
  List<int> get unlockedLevelIds => _unlockedLevels;
  int get coins => _coins;
  int get nitroCount => _nitroCount;
  int get totalWins => _totalWins;
  bool get isLoading => _isLoading;

  List<CarModel> get allCars => CarData.allCars;
  List<LevelModel> get allLevels => LevelData.allLevels;

  List<CarModel> get unlockedCars =>
      CarData.allCars.where((c) => _unlockedCars.contains(c.id)).toList();

  bool isCarUnlocked(String carId) => _unlockedCars.contains(carId);
  bool isLevelUnlocked(int levelId) => _unlockedLevels.contains(levelId);

  LevelModel get currentLevelModel => LevelData.getById(_currentLevel);

  // ── Init ──────────────────────────────────────────────────────
  Future<void> load() async {
    _isLoading = true;
    notifyListeners();

    _selectedCar = CarData.getById(StorageService.selectedCar);
    _currentLevel = StorageService.currentLevel;
    _unlockedCars = List<String>.from(StorageService.unlockedCars);
    _unlockedLevels = List<int>.from(StorageService.unlockedLevels);
    _coins = StorageService.coins;
    _nitroCount = StorageService.nitroCount;
    _totalWins = StorageService.totalWins;

    _isLoading = false;
    notifyListeners();
  }

  // ── Car Selection ─────────────────────────────────────────────
  Future<void> selectCar(CarModel car) async {
    if (!isCarUnlocked(car.id)) return;
    _selectedCar = car;
    await StorageService.setSelectedCar(car.id);
    notifyListeners();
  }

  Future<bool> unlockCarWithCoins(CarModel car) async {
    if (isCarUnlocked(car.id)) return true;
    final spent = await StorageService.spendCoins(car.unlockCost);
    if (!spent) return false;
    await StorageService.unlockCar(car.id);
    _unlockedCars.add(car.id);
    _coins = StorageService.coins;
    notifyListeners();
    return true;
  }

  Future<void> unlockCarWithAd(CarModel car) async {
    if (isCarUnlocked(car.id)) return;
    final earned = await AdService().showRewarded();
    if (earned) {
      await StorageService.unlockCar(car.id);
      _unlockedCars.add(car.id);
      notifyListeners();
    }
  }

  // ── Race Results ──────────────────────────────────────────────
  Future<void> onRaceWon(int levelId, int coinReward) async {
    _totalWins++;
    _coins += coinReward;
    await StorageService.incrementWins();
    await StorageService.addCoins(coinReward);
    await StorageService.incrementRaceCount();

    // Unlock next level
    final nextLevel = levelId + 1;
    if (nextLevel <= LevelData.allLevels.length &&
        !isLevelUnlocked(nextLevel)) {
      _unlockedLevels.add(nextLevel);
      await StorageService.unlockLevel(nextLevel);
      if (nextLevel > _currentLevel) {
        _currentLevel = nextLevel;
        await StorageService.setCurrentLevel(nextLevel);
      }
    }

    await AdService().onRaceCompleted();
    notifyListeners();
  }

  Future<void> onRaceLost() async {
    await StorageService.incrementRaceCount();
    await AdService().onRaceCompleted();
    notifyListeners();
  }

  // ── Nitro ─────────────────────────────────────────────────────
  Future<bool> useNitro() async {
    final used = await StorageService.useNitro();
    if (used) {
      _nitroCount = StorageService.nitroCount;
      notifyListeners();
    }
    return used;
  }

  Future<void> earnNitroFromAd() async {
    final earned = await AdService().showRewarded();
    if (earned) {
      await StorageService.addNitro(3);
      _nitroCount = StorageService.nitroCount;
      notifyListeners();
    }
  }

  // ── Level gate: watch ad to unlock ───────────────────────────
  Future<bool> unlockLevelWithAd(int levelId) async {
    final earned = await AdService().showRewarded();
    if (earned) {
      _unlockedLevels.add(levelId);
      await StorageService.unlockLevel(levelId);
      notifyListeners();
      return true;
    }
    return false;
  }

  // ── Coins from ad ─────────────────────────────────────────────
  Future<void> earnCoinsFromAd(int amount) async {
    final earned = await AdService().showRewarded();
    if (earned) {
      await StorageService.addCoins(amount);
      _coins = StorageService.coins;
      notifyListeners();
    }
  }
}
