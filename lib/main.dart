import 'package:flutter/material.dart';
import 'package:wake_sure/src/notifications/notification_helper.dart';
import 'package:wake_sure/src/screens/alarm_screen.dart';
import 'package:wake_sure/src/screens/set_alarm_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: SetAlarmScreen(),
    );
  }
}
