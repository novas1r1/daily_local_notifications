import 'dart:developer';

import 'package:daily_local_notifications/daily_local_notifications.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Local Notifications',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Daily Local Notifications'),
        ),
        body: DailyLocalNotifications(
          notificationConfig: const NotificationConfig(),
          config: const DailyLocalNotificationsConfig(),
          stylingConfig: StylingConfig(
            activeColor: Theme.of(context).primaryColor,
            inactiveColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          reminderTitleText: Text(
            'Reminder Title',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          reminderRepeatText: Text(
            'Repeat',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          reminderDailyText: Text(
            'Daily',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          timeNormalTextStyle: const TextStyle(fontSize: 24, color: Colors.grey),
          timeSelectedTextStyle: TextStyle(
            fontSize: 24,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
          onNotificationsUpdated: () => log('Notifications updated'),
        ),
      ),
    );
  }
}
