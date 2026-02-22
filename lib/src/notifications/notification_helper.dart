import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter/material.dart';
import '../../main.dart';
import '../screens/alarm_screen.dart';

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static void init() {
    _notifications.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (details) {
        navigatorKey.currentState?.push(
          MaterialPageRoute(builder: (_) => const AlarmScreen()),
        );
      },
    );
    tz.initializeTimeZones();
  }

  static Future<void> scheduleNotification(String title, String body) async {
    final androidDetails = AndroidNotificationDetails(
      'important_channel',
      'Important Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = now.add(const Duration(seconds: 5));

    await _notifications.zonedSchedule(
      id: 0,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static Future<void> scheduleAlarm(DateTime scheduledTime) async {
    final androidDetails = AndroidNotificationDetails(
      'alarm_channel',
      'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: true,
    );

    final iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final tzTime = tz.TZDateTime.from(scheduledTime, tz.local);

    await _notifications.zonedSchedule(
      id:0,
      title: 'WakeSure Alarm',
      body: 'Time to wake up!',
      scheduledDate: tzTime,
      notificationDetails: details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}