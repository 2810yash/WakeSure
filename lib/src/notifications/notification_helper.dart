import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static init() {
    _notifications.initialize(
      settings: InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
    );
    tz.initializeTimeZones();
  }

  static schedulNotifications(String title, String body) async {
    print("\n\nin Schedule notifications\n\n");
    var androidNotificationDetails = AndroidNotificationDetails(
      'important notification',
      'SAK ASH',
      importance: Importance.max,
      priority: Priority.high,
    );
    var iosNotificationDetails = DarwinNotificationDetails();
    var notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    await _notifications.zonedSchedule(
      id: 0,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime(
        tz.local,
        2026,
      ).add(const Duration(seconds: 1)),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}
