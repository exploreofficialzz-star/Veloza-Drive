// lib/core/services/ad_service.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';
import 'connectivity_service.dart';

class AdService extends ChangeNotifier {
  static final AdService _instance = AdService._();
  factory AdService() => _instance;
  AdService._();

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;

  bool _isBannerReady = false;
  bool _isInterstitialReady = false;
  bool _isRewardedReady = false;
  int _racesSinceInterstitial = 0;

  bool get isBannerReady => _isBannerReady;
  bool get isInterstitialReady => _isInterstitialReady;
  bool get isRewardedReady => _isRewardedReady;
  BannerAd? get bannerAd => _bannerAd;

  // ── IDs ───────────────────────────────────────────────────────
  String get _bannerId => Platform.isAndroid
      ? AppConstants.bannerAdUnitIdAndroid
      : AppConstants.bannerAdUnitIdIos;

  String get _interstitialId => Platform.isAndroid
      ? AppConstants.interstitialAdUnitIdAndroid
      : AppConstants.interstitialAdUnitIdIos;

  String get _rewardedId => Platform.isAndroid
      ? AppConstants.rewardedAdUnitIdAndroid
      : AppConstants.rewardedAdUnitIdIos;

  // ── Init ──────────────────────────────────────────────────────
  Future<void> init() async {
    if (!ConnectivityService().isOnline) return;
    await MobileAds.instance.initialize();
    loadBanner();
    loadInterstitial();
    loadRewarded();
  }

  // ── Banner ────────────────────────────────────────────────────
  void loadBanner() {
    if (!ConnectivityService().isOnline) return;
    _bannerAd = BannerAd(
      adUnitId: _bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          _isBannerReady = true;
          notifyListeners();
        },
        onAdFailedToLoad: (ad, err) {
          _isBannerReady = false;
          ad.dispose();
          Future.delayed(const Duration(seconds: 30), loadBanner);
        },
      ),
    )..load();
  }

  // ── Interstitial ──────────────────────────────────────────────
  void loadInterstitial() {
    if (!ConnectivityService().isOnline) return;
    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialReady = true;
          notifyListeners();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              _isInterstitialReady = false;
              loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (_, __) {
              _isInterstitialReady = false;
              loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _isInterstitialReady = false;
          Future.delayed(const Duration(seconds: 30), loadInterstitial);
        },
      ),
    );
  }

  /// Call after every race. Shows ad every N races.
  Future<void> onRaceCompleted() async {
    _racesSinceInterstitial++;
    if (_racesSinceInterstitial >= AppConstants.racesBeforeInterstitial &&
        _isInterstitialReady) {
      await showInterstitial();
      _racesSinceInterstitial = 0;
    }
  }

  Future<void> showInterstitial() async {
    if (!_isInterstitialReady || _interstitialAd == null) return;
    await _interstitialAd!.show();
    _isInterstitialReady = false;
  }

  // ── Rewarded ──────────────────────────────────────────────────
  void loadRewarded() {
    if (!ConnectivityService().isOnline) return;
    RewardedAd.load(
      adUnitId: _rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _isRewardedReady = true;
          notifyListeners();
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (_) {
              _isRewardedReady = false;
              loadRewarded();
            },
            onAdFailedToShowFullScreenContent: (_, __) {
              _isRewardedReady = false;
              loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (_) {
          _isRewardedReady = false;
          Future.delayed(const Duration(seconds: 30), loadRewarded);
        },
      ),
    );
  }

  /// Show rewarded ad. Returns true if user earned reward.
  Future<bool> showRewarded() async {
    if (!_isRewardedReady || _rewardedAd == null) return false;

    final completer = Completer<bool>();
    _rewardedAd!.show(
      onUserEarnedReward: (_, __) => completer.complete(true),
    );
    _isRewardedReady = false;

    // Timeout safety
    Future.delayed(const Duration(seconds: 60), () {
      if (!completer.isCompleted) completer.complete(false);
    });

    return completer.future;
  }

  // ── Cleanup ───────────────────────────────────────────────────
  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _isBannerReady = false;
    _isInterstitialReady = false;
    _isRewardedReady = false;
  }
}
