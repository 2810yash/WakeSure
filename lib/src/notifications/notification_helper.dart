import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/alarm_screen.dart';

class NotificationHelper {
  static final notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(
      android: androidSettings,
    );

    const AndroidNotificationChannel androidChannel =
    AndroidNotificationChannel(
      'alarm_channel_v2',
      'Alarm Notifications',
      description: 'Channel for alarm notifications',
      importance: Importance.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    await notifications.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const AlarmScreen()),
              (route) => false,
        );
      },
    );

    tz.initializeTimeZones();
  }

  static Future<void> scheduleAlarm(DateTime scheduledTime) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel_v2',
      'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      category: AndroidNotificationCategory.alarm,
      fullScreenIntent: true,
      visibility: NotificationVisibility.public,
      ticker: 'alarm',
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alarm'),
      audioAttributesUsage: AudioAttributesUsage.alarm,
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await notifications.zonedSchedule(
      id:0,
      title: 'WakeSure Alarm',
      body: 'Time to wake up!',
      scheduledDate: tzTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}