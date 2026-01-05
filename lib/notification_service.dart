import 'dart:io';
import 'dart:async';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logging/logging.dart';
import 'package:obatin/shared_prefs_helper.dart';
import 'package:obatin/user.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:url_launcher/url_launcher.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // Singleton pattern
  NotificationService._internal(); // Private constructor
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final Completer<void> _initializationCompleter =
      Completer<void>(); // Added completer
  bool _isInitialized = false;
  final Logger _logger = Logger('NotificationService');

  // Inisialisasi (Dipanggil di main.dart)
  Future<void> init() async {
    if (!_initializationCompleter.isCompleted) {
      try {
        // Ensure init is only called once
        tz.initializeTimeZones(); // Setup zona waktu
        String timeZoneName;
        try {
          if (Platform.isAndroid || Platform.isIOS) {
            timeZoneName =
                (await FlutterTimezone.getLocalTimezone()).identifier;
          } else {
            timeZoneName = 'Asia/Jakarta'; // Default for Windows
          }
        } catch (e) {
          timeZoneName = 'Asia/Jakarta'; // Fallback in case of error
        }
        tz.setLocalLocation(tz.getLocation(timeZoneName));

        // Request notification permission
        await requestNotificationPermission();

        // Create notification channel for Android
        await _createNotificationChannel();

        // Android Settings (Ganti 'app_icon' dengan '@mipmap/launcher_icon')
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/launcher_icon');

        // iOS Settings
        const DarwinInitializationSettings iosSettings =
            DarwinInitializationSettings(
              requestAlertPermission: true,
              requestBadgePermission: true,
              requestSoundPermission: true,
            );

        const InitializationSettings initializationSettings =
            InitializationSettings(
              android: initializationSettingsAndroid,
              iOS: iosSettings,
            );

        await _flutterLocalNotificationsPlugin.initialize(
          initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse response) async {
                try {
                  // Aksi saat notifikasi diklik
                  if (response.payload != null) {
                    await _sendWhatsAppToCaregiver(response.payload!);
                  }
                } catch (e) {
                  _logger.warning('Failed to handle notification response: $e');
                }
              },
        );
        _logger.info('Notification service initialized successfully');
        _isInitialized = true;
        _initializationCompleter.complete(); // Mark as complete
      } catch (e, stackTrace) {
        _logger.severe(
          'Failed to initialize notification service: $e',
          e,
          stackTrace,
        );
        _initializationCompleter.completeError(e); // Complete with error
      }
    }
  }

  // Ensure initialization is complete before using _flutterLocalNotificationsPlugin
  Future<void> _ensureInitialized() async {
    if (!_initializationCompleter.isCompleted) {
      await _initializationCompleter.future;
    }
  }

  // Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id_obat_v2', // ubah ID
      'Pengingat Obat',
      description: 'Channel untuk alarm minum obat',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Request notification permission
  Future<void> requestNotificationPermission() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      _logger.info('Notification permission granted');
    } else if (status.isDenied) {
      _logger.warning('Notification permission denied');
    } else if (status.isPermanentlyDenied) {
      _logger.warning(
        'Notification permission permanently denied, opening app settings',
      );
      await openAppSettings();
    }

    // Request exact alarm permission (required for Android 12+)
    final exactAlarmStatus = await Permission.scheduleExactAlarm.request();
    if (exactAlarmStatus.isGranted) {
      _logger.info('Exact alarm permission granted');
    } else if (exactAlarmStatus.isDenied) {
      _logger.warning('Exact alarm permission denied');
    } else if (exactAlarmStatus.isPermanentlyDenied) {
      _logger.warning(
        'Exact alarm permission permanently denied, opening app settings',
      );
      await openAppSettings();
    }

    // Request background execution permission
    final batteryStatus = await Permission.ignoreBatteryOptimizations.request();
    if (batteryStatus.isGranted) {
      _logger.info('Battery optimization permission granted');
    } else if (batteryStatus.isDenied) {
      _logger.warning('Battery optimization permission denied');
    } else if (batteryStatus.isPermanentlyDenied) {
      _logger.warning(
        'Battery optimization permission permanently denied, opening app settings',
      );
      await openAppSettings();
    }
  }

  // Fungsi Membatalkan Notifikasi
  Future<void> cancelNotification(int id) async {
    try {
      // Wait for initialization to complete
      await _ensureInitialized();
      // Double check if initialization was successful
      if (_isInitialized) {
        await _flutterLocalNotificationsPlugin.cancel(id);
      } else {
        _logger.warning(
          'Notification service initialization failed, cannot cancel notification $id',
        );
      }
    } catch (e) {
      _logger.warning('Failed to cancel notification $id: $e');
    }
  }

  // Fungsi Membatalkan Semua Notifikasi
  Future<void> cancelAllNotifications() async {
    await _ensureInitialized(); // Ensure initialized
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      _logger.warning('Failed to cancel all notifications: $e');
      // Do not rethrow to allow scheduling to proceed
    }
  }





  // Fungsi Menampilkan Notifikasi Sederhana
  Future<void> showNotification({
    int id = 0,
    String title = 'Notification',
    String body = 'This is a notification message',
  }) async {
    await _ensureInitialized(); // Ensure initialized
    if (Platform.isAndroid || Platform.isIOS) {
      // Check permission status
      final permissionStatus = await Permission.notification.status;
      if (!permissionStatus.isGranted) {
        _logger.warning('Notification permission not granted');
        return;
      }


      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          'channel_id_obat_v2',
          'Pengingat Obat',
          channelDescription: 'Channel untuk alarm minum obat',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true, // ubah ke true
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
      await _flutterLocalNotificationsPlugin.show(
        id,
        title,
        body,
        notificationDetails,
      );
      _logger.info('Notification shown: $title - $body');
    } else {
      _logger.warning('Notifications not supported on this platform');
    }
  }

  // Fungsi Menjadwalkan Notifikasi
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDateTime,
    bool repeatDaily = true,
  }) async {
    try {
      await _ensureInitialized(); // Ensure initialized

      // Check notification permission
      final permissionStatus = await Permission.notification.status;
      if (!permissionStatus.isGranted) {
        _logger.warning(
          'Notification permission not granted, cannot schedule notification',
        );
        return;
      }

      // Check exact alarm permission for Android
      if (Platform.isAndroid) {
        final exactAlarmStatus = await Permission.scheduleExactAlarm.status;
        if (!exactAlarmStatus.isGranted) {
          _logger.warning(
            'Exact alarm permission not granted, cannot schedule notification',
          );
          return;
        }
      }

      if (Platform.isAndroid || Platform.isIOS) {
        var scheduledDate = tz.TZDateTime.from(scheduledDateTime, tz.local);

        // Jika waktu yang dijadwalkan sudah lewat hari ini,
        // jadwalkan untuk besok pada waktu yang sama.
        if (scheduledDate.isBefore(tz.TZDateTime.now(tz.local))) {
          scheduledDate = scheduledDate.add(const Duration(days: 1));
          _logger.info(
            'Scheduled time was in the past, rescheduled to tomorrow: $scheduledDate',
          );
        }

        _logger.info(
          'Attempting to schedule notification: ID=$id, Title=$title, Time=$scheduledDate, Repeat=$repeatDaily',
        );

        // Schedule the local notification
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          NotificationDetails(
            android: AndroidNotificationDetails(
              'channel_id_obat',
              'Pengingat Obat',
              channelDescription: 'Channel untuk alarm minum obat',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              enableVibration: true, // Enable vibration
              fullScreenIntent: false, // Show as heads-up notification
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          matchDateTimeComponents: repeatDaily
              ? DateTimeComponents.time
              : null, // Conditional repetition
          payload: body, // Kirim isi pesan ke fungsi klik
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );

        _logger.info(
          'Notification scheduled successfully: $title at $scheduledDate (ID: $id)',
        );
      } else {
        _logger.warning(
          'Scheduled notifications not supported on this platform',
        );
      }
    } catch (e, stackTrace) {
      _logger.severe('Failed to schedule notification: $e', e, stackTrace);
      rethrow;
    }
  }   // <-- ini penutup fungsi scheduleNotification

  // Fungsi Kirim WA ke Caregiver (Semi-Otomatis)
  Future<void> _sendWhatsAppToCaregiver(String message) async {
    final prefsHelper = SharedPreferencesHelper();
    final User? user = await prefsHelper.getLoggedInUser();

    String phone = "628123456789"; // Default / fallback number
    if (user != null && user.nomorPerawat.isNotEmpty) {
      phone = user.nomorPerawat;
    } else {
      // print("Warning: Caregiver number not found in user data. Using default.");
    }

    // Ensure the phone number starts with '62' (Indonesia country code) and remove any '+'
    if (phone.startsWith('+')) {
      phone = phone.substring(1);
    }
    if (!phone.startsWith('62')) {
      phone = '62$phone';
    }

    String text = "Laporan Otomatis: $message. Mohon ingatkan pengguna.";
    final Uri url = Uri.parse("https://wa.me/$phone?text=$text");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      // print("Gagal membuka WhatsApp");
    }
  }
}