// lib/core/services/notification_service.dart
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../constants/app_constants.dart';
import 'storage_service.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _plugin.initialize(settings);
  }

  static Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static Future<void> scheduleDailyChallenge() async {
    if (!StorageService.notificationsEnabled) return;

    await _plugin.cancel(AppConstants.dailyChallengeNotifId);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_challenge',
        'Daily Challenge',
        channelDescription: 'Daily racing challenge reminder',
        importance: Importance.high,
        priority: Priority.high,
        color: Color(0xFFE53935),
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
        styleInformation: BigTextStyleInformation(
          'A new daily challenge is waiting! Race, win, and earn bonus coins 🏎️',
        ),
      ),
      iOS: DarwinNotificationDetails(badgeNumber: 1),
    );

    await _plugin.periodicallyShow(
      AppConstants.dailyChallengeNotifId,
      '🏁 Daily Challenge Ready!',
      'Jump in and race for bonus coins today!',
      RepeatInterval.daily,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> scheduleComeBack() async {
    if (!StorageService.notificationsEnabled) return;

    await _plugin.cancel(AppConstants.comeBackNotifId);

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'come_back',
        'Come Back Reminder',
        channelDescription: 'Reminder to continue racing',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        color: Color(0xFFFFAB00),
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.periodicallyShow(
      AppConstants.comeBackNotifId,
      '⚡ Your rivals are gaining on you!',
      'Come back and reclaim your position on the track.',
      RepeatInterval.everyMinute, // Replace with daily in production
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  static Future<void> showRaceWon(int coins) async {
    if (!StorageService.notificationsEnabled) return;

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'race_results',
        'Race Results',
        channelDescription: 'Race result notifications',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        color: Color(0xFF00E676),
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      0,
      '🏆 Race Won!',
      'You earned $coins coins. Keep it up!',
      details,
    );
  }

  static Future<void> cancelAll() => _plugin.cancelAll();
}

// ignore: avoid_classes_with_only_static_members
class Color {
  final int value;
  const Color(this.value);
}
