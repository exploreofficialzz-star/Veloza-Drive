// lib/presentation/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/storage_service.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/notification_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late bool _sound;
  late bool _music;
  late bool _notifications;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _sound = StorageService.soundEnabled;
    _music = StorageService.musicEnabled;
    _notifications = StorageService.notificationsEnabled;
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) setState(() => _version = 'v${info.version}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text('SETTINGS')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _SectionHeader(title: 'AUDIO'),
          _SettingTile(
            icon: Icons.volume_up_rounded,
            title: 'Sound Effects',
            subtitle: 'Engine, crash, nitro sounds',
            value: _sound,
            onChanged: (v) async {
              setState(() => _sound = v);
              await StorageService.setSoundEnabled(v);
            },
          ).animate().fadeIn(delay: 50.ms),
          _SettingTile(
            icon: Icons.music_note_rounded,
            title: 'Background Music',
            subtitle: 'Menu and race music',
            value: _music,
            onChanged: (v) async {
              setState(() => _music = v);
              await StorageService.setMusicEnabled(v);
              if (v) {
                await AudioService.playMenuMusic();
              } else {
                await AudioService.stopMusic();
              }
            },
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 24),

          _SectionHeader(title: 'NOTIFICATIONS'),
          _SettingTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Daily challenges & reminders',
            value: _notifications,
            onChanged: (v) async {
              setState(() => _notifications = v);
              await StorageService.setNotificationsEnabled(v);
              if (v) {
                await NotificationService.requestPermission();
                await NotificationService.scheduleDailyChallenge();
              } else {
                await NotificationService.cancelAll();
              }
            },
          ).animate().fadeIn(delay: 150.ms),
          const SizedBox(height: 24),

          _SectionHeader(title: 'DATA'),
          _ActionTile(
            icon: Icons.delete_outline_rounded,
            title: 'Reset All Progress',
            subtitle: 'Clears all levels, cars and coins',
            color: AppTheme.danger,
            onTap: () => _confirmReset(context),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 32),

          // About card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.divider),
            ),
            child: Column(
              children: [
                const Text('🏎️', style: TextStyle(fontSize: 36)),
                const SizedBox(height: 8),
                Text('Veloza Drive', style: AppTheme.headingM),
                const SizedBox(height: 4),
                Text(_version, style: AppTheme.body),
                const SizedBox(height: 8),
                Text(
                  'By ChAs · ChAs Tech Group',
                  style: GoogleFonts.rajdhani(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.accentGold,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 250.ms),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.surface,
        title: Text('Reset Progress?', style: AppTheme.headingM),
        content: Text(
          'This will erase ALL your progress — levels, cars, and coins. This cannot be undone.',
          style: AppTheme.body,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: AppTheme.body),
          ),
          ElevatedButton(
            onPressed: () async {
              await StorageService.resetAll();
              await StorageService.init();
              if (ctx.mounted) {
                Navigator.of(ctx)
                    .pushNamedAndRemoveUntil('/splash', (_) => false);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            child: const Text('RESET'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(title,
          style: AppTheme.labelS.copyWith(color: AppTheme.accent)),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.accent, size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.bodyBold),
                Text(subtitle, style: AppTheme.body.copyWith(fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.accent,
            inactiveThumbColor: AppTheme.textSecond,
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTheme.bodyBold.copyWith(color: color)),
                  Text(subtitle, style: AppTheme.body.copyWith(fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: color.withOpacity(0.6)),
          ],
        ),
      ),
    );
  }
}
