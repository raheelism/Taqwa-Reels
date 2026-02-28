import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

// ═══════════════════════════════════════════════════════════════════════════════
// TOP-LEVEL CALLBACK — runs in a BACKGROUND ISOLATE (no Flutter UI available).
// This is what fires when WorkManager triggers the task, even if the app
// has been swiped away or the device rebooted.
// ═══════════════════════════════════════════════════════════════════════════════

@pragma('vm:entry-point')
void notificationCallbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    if (taskName == NotificationService.taskName) {
      try {
        // 1. Initialise the notification plugin (fresh isolate — no prior state)
        final plugin = FlutterLocalNotificationsPlugin();
        const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
        const initSettings = InitializationSettings(android: androidInit);
        await plugin.initialize(settings: initSettings);

        // 2. Pick a random ayah
        final ayah = NotificationService.pickAyah();

        // 3. Show the notification NOW
        final bodyText = ayah['text'] ?? '';
        final androidDetails = AndroidNotificationDetails(
          NotificationService.channelId,
          NotificationService.channelName,
          channelDescription: 'Daily Quranic ayah reminder',
          importance: Importance.high,
          priority: Priority.high,
          styleInformation: BigTextStyleInformation(bodyText),
        );
        await plugin.show(
          id: NotificationService.notifId,
          title: '📖 ${ayah['surah']}',
          body: bodyText,
          notificationDetails: NotificationDetails(android: androidDetails),
        );
        debugPrint('NotificationService [BG]: Notification shown — ${ayah['surah']}');

        // 4. Re-schedule for tomorrow at the same time ──────────────────────
        //    Read hour/minute from inputData (passed when task was registered)
        final hour = inputData?['hour'] as int? ?? 7;
        final minute = inputData?['minute'] as int? ?? 0;

        // Calculate delay until tomorrow's target time
        tz.initializeTimeZones();
        try {
          final tzInfo = await FlutterTimezone.getLocalTimezone();
          tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
        } catch (_) {}

        final now = tz.TZDateTime.now(tz.local);
        var nextFire =
            tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
        // Always push to tomorrow (we just fired for today)
        nextFire = nextFire.add(const Duration(days: 1));
        // Edge case: if the time already passed today and we somehow got a
        // negative diff, add another day
        if (nextFire.isBefore(now)) {
          nextFire = nextFire.add(const Duration(days: 1));
        }
        final delay = nextFire.difference(now);

        await Workmanager().registerOneOffTask(
          NotificationService.taskName,
          NotificationService.taskName,
          initialDelay: delay,
          existingWorkPolicy: ExistingWorkPolicy.replace,
          inputData: {'hour': hour, 'minute': minute},
          constraints: Constraints(
            networkType: NetworkType.notRequired,
          ),
        );
        debugPrint(
            'NotificationService [BG]: Next fire in ${delay.inMinutes}min '
            '(${nextFire.hour}:${nextFire.minute} ${nextFire.timeZoneName})');
      } catch (e, stack) {
        debugPrint('NotificationService [BG]: Error — $e\n$stack');
      }
    }
    return Future.value(true);
  });
}

/// Manages daily ayah reminder notifications — fully local, no server.
///
/// Uses **WorkManager** for scheduling (survives app kill + MIUI)
/// and **flutter_local_notifications** for displaying the notification.
class NotificationService {
  static const _boxName = 'notification_settings';
  static const channelId = 'daily_ayah';
  static const channelName = 'Daily Ayah Reminder';
  static const notifId = 1001;
  static const taskName = 'daily_ayah_reminder';

  static final _plugin = FlutterLocalNotificationsPlugin();
  static Box<dynamic>? _box;

  // ── 30 curated ayah snippets for notification rotation ──
  static const _ayahPool = <Map<String, String>>[
    {'surah': 'Al-Baqarah 2:286', 'text': 'Allah does not burden a soul beyond that it can bear.'},
    {'surah': 'Ash-Sharh 94:5-6', 'text': 'Indeed, with hardship comes ease. Indeed, with hardship comes ease.'},
    {'surah': 'Al-Baqarah 2:152', 'text': 'So remember Me; I will remember you.'},
    {'surah': 'Al-Ankabut 29:69', 'text': 'And those who strive for Us — We will surely guide them to Our ways.'},
    {'surah': 'Ar-Ra\'d 13:28', 'text': 'Verily, in the remembrance of Allah do hearts find rest.'},
    {'surah': 'At-Talaq 65:3', 'text': 'And whoever relies upon Allah — then He is sufficient for him.'},
    {'surah': 'Al-Baqarah 2:45', 'text': 'And seek help through patience and prayer.'},
    {'surah': 'Ali \'Imran 3:139', 'text': 'So do not weaken and do not grieve, and you will be superior if you are believers.'},
    {'surah': 'An-Nahl 16:97', 'text': 'Whoever does righteousness — We will surely cause him to live a good life.'},
    {'surah': 'Al-Mulk 67:1', 'text': 'Blessed is He in whose hand is dominion, and He is over all things competent.'},
    {'surah': 'Taha 20:114', 'text': 'My Lord, increase me in knowledge.'},
    {'surah': 'Al-Hashr 59:22', 'text': 'He is Allah, other than whom there is no deity, Knower of the unseen and the witnessed.'},
    {'surah': 'Ibrahim 14:7', 'text': 'If you are grateful, I will surely increase you.'},
    {'surah': 'Az-Zumar 39:53', 'text': 'Do not despair of the mercy of Allah. Indeed, Allah forgives all sins.'},
    {'surah': 'Al-Isra 17:80', 'text': 'My Lord, cause me to enter a sound entrance and to exit a sound exit.'},
    {'surah': 'Al-Furqan 25:74', 'text': 'Our Lord, grant us from among our wives and offspring comfort to our eyes.'},
    {'surah': 'Al-A\'raf 7:56', 'text': 'Indeed, the mercy of Allah is near to the doers of good.'},
    {'surah': 'Al-Mu\'minun 23:1', 'text': 'Certainly will the believers have succeeded.'},
    {'surah': 'Al-Baqarah 2:186', 'text': 'I am near. I respond to the invocation of the supplicant when he calls upon Me.'},
    {'surah': 'Al-Imran 3:173', 'text': 'Sufficient for us is Allah, and He is the best Disposer of affairs.'},
    {'surah': 'Al-Hadid 57:4', 'text': 'And He is with you wherever you are.'},
    {'surah': 'An-Nur 24:35', 'text': 'Allah is the Light of the heavens and the earth.'},
    {'surah': 'Ar-Rahman 55:13', 'text': 'So which of the favors of your Lord would you deny?'},
    {'surah': 'Al-Fatiha 1:5', 'text': 'It is You we worship and You we ask for help.'},
    {'surah': 'Al-Ikhlas 112:1', 'text': 'Say, "He is Allah, the One."'},
    {'surah': 'Ya-Sin 36:58', 'text': '"Peace!" — a word from a Merciful Lord.'},
    {'surah': 'Al-Qadr 97:1', 'text': 'Indeed, We sent it down during the Night of Decree.'},
    {'surah': 'Ad-Duha 93:5', 'text': 'And your Lord is going to give you, and you will be satisfied.'},
    {'surah': 'Al-Kahf 18:10', 'text': 'Our Lord, grant us from Yourself mercy and prepare for us guidance.'},
    {'surah': 'Al-Asr 103:1-3', 'text': 'By time, indeed mankind is in loss — except those who believe and do righteous deeds.'},
  ];

  // ── Init ──

  static Future<void> init() async {
    // 1. Initialize timezone database & set device-local timezone
    tz.initializeTimeZones();
    try {
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
    } catch (e) {
      debugPrint('NotificationService: Could not detect timezone — $e');
    }

    // 2. Open settings store
    _box = await Hive.openBox(_boxName);

    // 3. Initialize notification display plugin
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);
    await _plugin.initialize(settings: initSettings);

    // 4. Initialize WorkManager
    await Workmanager().initialize(
      notificationCallbackDispatcher,
    );

    // 5. If reminders are enabled, ensure the schedule is active
    if (isEnabled) {
      await _scheduleWithWorkManager();
    }
  }

  // ── Public API ──

  /// Whether daily reminders are currently enabled.
  static bool get isEnabled =>
      _box?.get('enabled', defaultValue: false) ?? false;

  /// The hour of day (0-23) when the notification fires. Default 7 AM.
  static int get reminderHour => _box?.get('hour', defaultValue: 7) ?? 7;

  /// The minute of the hour. Default 0.
  static int get reminderMinute => _box?.get('minute', defaultValue: 0) ?? 0;

  /// Enable or disable daily reminders.
  /// Returns `true` if the operation succeeded.
  static Future<bool> setEnabled(bool enabled) async {
    if (enabled) {
      // Request notification permission on Android 13+ (API 33)
      final status = await Permission.notification.request();
      if (!status.isGranted) {
        debugPrint('NotificationService: Notification permission denied');
        return false;
      }
    }

    await _box?.put('enabled', enabled);

    if (enabled) {
      await _scheduleWithWorkManager();
      // Show an instant confirmation so user knows it works
      await _showConfirmation(
        'Daily Reminder Set ✅',
        'You\'ll receive a Quranic ayah daily at '
            '${reminderHour.toString().padLeft(2, '0')}:'
            '${reminderMinute.toString().padLeft(2, '0')}',
      );
    } else {
      await Workmanager().cancelByUniqueName(taskName);
      await _plugin.cancel(id: notifId);
      await _plugin.cancel(id: notifId + 1);
    }
    return true;
  }

  /// Set the reminder time (24h format).
  static Future<void> setTime(int hour, int minute) async {
    await _box?.put('hour', hour);
    await _box?.put('minute', minute);
    if (isEnabled) {
      // Re-detect timezone in case user changed it since app launch
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      } catch (_) {}
      await _scheduleWithWorkManager();
      // Show confirmation with the new time
      await _showConfirmation(
        'Reminder Time Updated ✅',
        'Daily ayah notification now set for '
            '${hour.toString().padLeft(2, '0')}:'
            '${minute.toString().padLeft(2, '0')}',
      );
    }
  }

  // ── Internal ──

  /// Schedules a one-off WorkManager task that fires at the user's chosen time.
  /// When the task fires (in background isolate), it shows the notification
  /// and self-chains by scheduling the next day's task.
  static Future<void> _scheduleWithWorkManager() async {
    final hour = reminderHour;
    final minute = reminderMinute;

    final now = tz.TZDateTime.now(tz.local);
    var nextFire =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (nextFire.isBefore(now)) {
      nextFire = nextFire.add(const Duration(days: 1));
    }
    final delay = nextFire.difference(now);

    await Workmanager().registerOneOffTask(
      taskName,
      taskName,
      initialDelay: delay,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      inputData: {'hour': hour, 'minute': minute},
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );

    debugPrint(
        'NotificationService: WorkManager scheduled — fires in '
        '${delay.inMinutes}min at ${nextFire.hour}:${nextFire.minute} '
        '(${nextFire.timeZoneName})');
  }

  /// Instantly shows a notification so the user gets immediate feedback.
  static Future<void> _showConfirmation(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: 'Daily Quranic ayah reminder',
      importance: Importance.high,
      priority: Priority.high,
    );
    await _plugin.show(
      id: notifId + 1,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(android: androidDetails),
    );
  }

  /// Picks a random ayah based on day-of-year for rotation.
  static Map<String, String> pickAyah() {
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays;
    final idx = (dayOfYear + Random(42).nextInt(100)) % _ayahPool.length;
    return _ayahPool[idx];
  }

  /// Shows a dialog guiding Xiaomi / MIUI users to enable autostart.
  static Future<void> showAutoStartGuideIfNeeded(BuildContext context) async {
    // Only show once
    final shown =
        _box?.get('autostart_guide_shown', defaultValue: false) ?? false;
    if (shown) return;
    await _box?.put('autostart_guide_shown', true);
    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          '⚠️ For Reliable Notifications',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        content: const Text(
          'If notifications don\'t arrive on time, '
          'please check your phone settings:\n\n'
          '1. Settings → Apps → TaqwaReels\n'
          '2. Enable "Autostart" (if available)\n'
          '3. Battery → No restrictions\n\n'
          'This ensures your daily ayah arrives reliably.',
          style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it',
                style: TextStyle(color: Color(0xFFBB86FC))),
          ),
        ],
      ),
    );
  }
}
