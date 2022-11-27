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
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        backgroundColor: Colors.black87,
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white, fontSize: 10),
          bodyMedium: TextStyle(color: Colors.white, fontSize: 12),
          bodyLarge: TextStyle(color: Colors.white, fontSize: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.deepPurple),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ),
      home: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Daily Local Notifications'),
            ),
            body: DailyLocalNotification(
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
              dayActiveColor: Theme.of(context).primaryColor,
              dayInactiveColor: Theme.of(context).primaryColor.withOpacity(0.3),
              timeNormalTextStyle:
                  const TextStyle(fontSize: 24, color: Colors.grey),
              timeSelectedTextStyle: TextStyle(
                fontSize: 24,
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
