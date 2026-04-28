# 🏎️ Veloza Drive

> A realistic 1v1 car challenge racing game built with Flutter & Flame.  
> Built by **ChAs · ChAs Tech Group**

---

## 🚀 Features

| Feature | Details |
|---|---|
| 🎮 Game Engine | Flame 1.18 — custom canvas rendering |
| 🏎️ Cars | 12 cars across 4 tiers (Starter → Elite) |
| 🏁 Levels | 30 levels with increasing difficulty |
| 🌍 Environments | City, Highway, Coastal, Industrial |
| 🌙 Day/Night | 4 time-of-day variants per level |
| 🚗 Traffic | Dynamic lane-changing traffic AI |
| ⚡ Nitro | Tap-to-boost mechanic |
| 📺 Ads | Banner + Interstitial + Rewarded (AdMob) |
| 📡 Offline | Full offline gameplay, ads gated online |
| 🔔 Notifications | Daily challenge + comeback reminders |

---

## 🛠️ Setup

### Prerequisites
- Flutter SDK `>=3.22.0`
- Android Studio / VS Code
- Android SDK (API 21+)

### 1. Clone & install
```bash
git clone https://github.com/ChAsTechGroup/veloza_drive.git
cd veloza_drive
flutter pub get
```

### 2. Run debug
```bash
flutter run
```

### 3. Build debug APK
```bash
flutter build apk --debug
```

---

## 🔐 Release Build & Signing

### Generate keystore (one-time)
```bash
keytool -genkey -v \
  -keystore android/keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias veloza_drive
```

### Create `android/key.properties`
```properties
storeFile=keystore.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=veloza_drive
keyPassword=YOUR_KEY_PASSWORD
```

### Build signed release APK
```bash
flutter build apk --release
```

---

## 🤖 GitHub Actions CI/CD

### Required GitHub Secrets

| Secret | Description |
|---|---|
| `KEYSTORE_BASE64` | Base64-encoded keystore: `base64 -w 0 keystore.jks` |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias (e.g. `veloza_drive`) |
| `KEY_PASSWORD` | Key password |

### Workflows
- **Push to any branch** → builds debug APK
- **Push to `main`** → builds release APK + AAB
- **Tag `v*`** → creates GitHub Release with APK

---

## 📱 Ad Configuration

The project uses **AdMob test IDs** by default.  
Before releasing, replace in `lib/core/constants/app_constants.dart`:

```dart
// Replace with your real AdMob IDs
static const String admobAppIdAndroid = 'ca-app-pub-XXXXXXXX~XXXXXXXX';
static const String bannerAdUnitIdAndroid = 'ca-app-pub-XXXXXXXX/XXXXXXXX';
static const String interstitialAdUnitIdAndroid = 'ca-app-pub-XXXXXXXX/XXXXXXXX';
static const String rewardedAdUnitIdAndroid = 'ca-app-pub-XXXXXXXX/XXXXXXXX';
```

Also update `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_REAL_ID"/>
```

---

## 🎵 Audio Assets Required

Place these files in `assets/audio/`:

| File | Description |
|---|---|
| `engine_idle.mp3` | Engine idle loop |
| `engine_rev.mp3` | Engine rev sound |
| `nitro_boost.mp3` | Nitro activation |
| `crash.mp3` | Collision sound |
| `win.mp3` | Race win jingle |
| `lose.mp3` | Race loss sound |
| `countdown_beep.mp3` | 3-2-1 beep |
| `race_start.mp3` | Race start horn |
| `menu_music.mp3` | Menu background music |
| `race_music.mp3` | Race background music |
| `btn_tap.mp3` | Button tap sound |

> 💡 **Free sources**: [freesound.org](https://freesound.org), [mixkit.co](https://mixkit.co/free-sound-effects/)

---

## 🖼️ Image Assets Required

Place in `assets/images/`:
- App icon (use Flutter launcher icons package or Android Studio)

---

## 📁 Project Structure

```
lib/
├── core/
│   ├── constants/     # App constants, car data, level data
│   ├── services/      # Storage, ads, audio, connectivity, notifications
│   └── theme/         # AppTheme, colors, typography
├── data/
│   └── models/        # CarModel, LevelModel
├── game/
│   ├── components/    # Flame components (cars, road, HUD, traffic)
│   └── racing_game.dart
├── presentation/
│   ├── providers/     # GameProvider (state management)
│   ├── screens/       # All screens
│   └── widgets/       # Reusable widgets
└── main.dart
```

---

## 🏗️ Built With

- [Flutter](https://flutter.dev) — Cross-platform UI
- [Flame](https://flame-engine.org) — 2D game engine
- [Google Mobile Ads](https://pub.dev/packages/google_mobile_ads) — AdMob
- [Provider](https://pub.dev/packages/provider) — State management
- [Connectivity Plus](https://pub.dev/packages/connectivity_plus) — Network detection
- [Flutter Local Notifications](https://pub.dev/packages/flutter_local_notifications) — Push notifications
- [Shared Preferences](https://pub.dev/packages/shared_preferences) — Local storage
- [Flutter Animate](https://pub.dev/packages/flutter_animate) — UI animations
- [Google Fonts](https://pub.dev/packages/google_fonts) — Rajdhani + Inter fonts

---

## 👨‍💻 Author

**ChAs · ChAs Tech Group**  
Building apps that matter. 🚀

---

*© 2025 ChAs Tech Group. All rights reserved.*
