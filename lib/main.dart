import 'package:flutter/material.dart';
import 'package:wake_sure/src/notifications/notification_helper.dart';
import 'package:wake_sure/src/screens/alarm_screen.dart';
import 'package:wake_sure/src/screens/set_alarm_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationHelper.init();

  final details =
  await NotificationHelper.notifications.getNotificationAppLaunchDetails();

  runApp(MyApp(
    launchedFromAlarm: details?.didNotificationLaunchApp ?? false,
  ));
}

class MyApp extends StatelessWidget {
  final bool launchedFromAlarm;
  const MyApp({super.key, required this.launchedFromAlarm});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: launchedFromAlarm
          ? const AlarmScreen()
          : const SetAlarmScreen(),
    );
  }
}
