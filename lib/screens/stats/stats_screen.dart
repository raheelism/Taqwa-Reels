import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../data/services/stats_service.dart';
import '../../data/services/notification_service.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  late bool _notifEnabled;
  late int _notifHour;
  late int _notifMinute;

  @override
  void initState() {
    super.initState();
    _notifEnabled = NotificationService.isEnabled;
    _notifHour = NotificationService.reminderHour;
    _notifMinute = NotificationService.reminderMinute;
  }

  @override
  Widget build(BuildContext context) {
    final streak = StatsService.currentStreak;
    final longest = StatsService.longestStreak;
    final reels = StatsService.totalReelsCreated;
    final images = StatsService.totalImagesSaved;
    final shares = StatsService.totalShares;
    final ayahs = StatsService.totalAyahsUsed;
    final daysActive = StatsService.daysActive;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Stats'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Streak Hero ──
            _buildStreakCard(streak, longest),
            const SizedBox(height: AppSpacing.lg),

            // ── Stats Grid ──
            _sectionHeader('Activity'),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(child: _statTile(Icons.video_library_rounded, '$reels', 'Reels Created', AppColors.primary)),
                const SizedBox(width: 10),
                Expanded(child: _statTile(Icons.image_rounded, '$images', 'Images Saved', AppColors.secondary)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statTile(Icons.share_rounded, '$shares', 'Times Shared', AppColors.success)),
                const SizedBox(width: 10),
                Expanded(child: _statTile(Icons.menu_book_rounded, '$ayahs', 'Ayahs Used', AppColors.warning)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(child: _statTile(Icons.calendar_today_rounded, '$daysActive', 'Days Active', const Color(0xFF9575CD))),
                const SizedBox(width: 10),
                Expanded(child: _statTile(Icons.emoji_events_rounded, '$longest', 'Best Streak', const Color(0xFFEF5350))),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // ── Daily Reminder ──
            _sectionHeader('Daily Ayah Reminder'),
            const SizedBox(height: AppSpacing.sm),
            _buildReminderCard(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  // ── Streak card ──

  Widget _buildStreakCard(int streak, int longest) {
    final percent = longest > 0 ? (streak / longest).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A3A5C), Color(0xFF0D253F)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withAlpha(50)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          CircularPercentIndicator(
            radius: 52,
            lineWidth: 7,
            percent: percent,
            center: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$streak',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'days',
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            progressColor: AppColors.primary,
            backgroundColor: AppColors.primary.withAlpha(30),
            circularStrokeCap: CircularStrokeCap.round,
            animation: true,
            animationDuration: 800,
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded,
                        color: AppColors.primary, size: 22),
                    const SizedBox(width: 6),
                    Text(
                      'Current Streak',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  streak == 0
                      ? 'Create a reel today to start your streak!'
                      : streak == 1
                          ? 'Great start! Keep it going tomorrow.'
                          : '$streak days of consistent dawah — MashaAllah!',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                if (longest > 1) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '🏆 Best: $longest days',
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Stat tile ──

  Widget _statTile(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.outfit(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // ── Reminder card ──

  Widget _buildReminderCard() {
    final timeText =
        '${_notifHour.toString().padLeft(2, '0')}:${_notifMinute.toString().padLeft(2, '0')}';

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: _notifEnabled
              ? AppColors.primary.withAlpha(60)
              : Colors.white.withAlpha(15),
        ),
      ),
      child: Column(
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              'Daily Ayah Notification',
              style: GoogleFonts.outfit(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              _notifEnabled
                  ? 'You\'ll receive a Quranic ayah every day'
                  : 'Get a daily reminder with a beautiful ayah',
              style: GoogleFonts.outfit(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            value: _notifEnabled,
            activeTrackColor: AppColors.primary,
            onChanged: (v) async {
              final success = await NotificationService.setEnabled(v);
              if (success) {
                setState(() => _notifEnabled = v);
                if (v && mounted) {
                  // Show autostart guide for Xiaomi/MIUI devices
                  await NotificationService.showAutoStartGuideIfNeeded(context);
                }
              }
            },
          ),
          if (_notifEnabled) ...[
            const Divider(height: 1, color: AppColors.bgCardLight),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.access_time_rounded,
                  color: AppColors.primary),
              title: Text(
                'Reminder Time',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              trailing: GestureDetector(
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime:
                        TimeOfDay(hour: _notifHour, minute: _notifMinute),
                    builder: (ctx, child) => Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppColors.primary,
                          surface: AppColors.bgCard,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (picked != null) {
                    await NotificationService.setTime(
                        picked.hour, picked.minute);
                    setState(() {
                      _notifHour = picked.hour;
                      _notifMinute = picked.minute;
                    });
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withAlpha(20),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    timeText,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) => Row(
        children: [
          Container(
            width: 3,
            height: 18,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      );
}
