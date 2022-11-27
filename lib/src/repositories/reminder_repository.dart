import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const MethodChannel platform =
    MethodChannel('verena-zaiser.de/daily_local_notifications');

const String portName = 'notification_send_port';

class ReminderRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  const ReminderRepository({
    required this.flutterLocalNotificationsPlugin,
  });

  /// Initialize the flutter_local_notification plugin
  Future<void> init() async {
    await _configureLocalTimeZone();

    // app_icon needs to be a added as a drawable resource
    // to the Android head project
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    /// The DarwinInitializationSettings class provides default settings on how the notification be presented when it is triggered and the application is in the foreground on iOS/macOS. There are optional named parameters that can be modified to suit your application's purposes. Here, it is omitted and the default values for these named properties is set such that all presentation options (alert, sound, badge) are enabled.
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  Future<void> sendNotification() async {
    // await notificationProvider.sendNotification();
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    print('onDidReceiveLocalNotification');
  }

  /// (onDidReceiveNotificationResponse) that should fire when a notification
  /// has been tapped on via the onDidReceiveNotificationResponse callback.
  /// Specifying this callback is entirely optional but here it will trigger
  /// navigation to another page and display the payload associated with the
  /// notification. This callback cannot be used to handle when a
  /// notification launched an app.
  /// the getNotificationAppLaunchDetails method when the app starts if you
  /// need to handle when a notification triggering the launch for an app
  /// e.g. change the home route of the app for deep-linking
  Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) async {
    final payload = notificationResponse.payload;

    if (notificationResponse.payload != null) {
      debugPrint('notification payload: $payload');
    }
    /* await Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
    ); */
  }

  /* REQUEST PERMISSION IOS
  final bool result = await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
    ?.requestPermissions(
    alert: true,
    badge: true,
    sound: true,
  );*/

  Future<void> cancelNotification(int id, String? tag) async {
    await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  /// To test we don't validate past dates when using `matchDateTimeComponents`
  Future<void> scheduleWeeklyMondayTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'weekly scheduled notification title',
      'weekly scheduled notification body',
      _nextInstanceOfMondayTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'weekly notification channel id',
          'weekly notification channel name',
          channelDescription: 'weekly notificationdescription',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  Future<void> scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'daily scheduled notification title',
      'daily scheduled notification body',
      _nextInstanceOfTenAM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily notification channel id',
          'daily notification channel name',
          channelDescription: 'daily notification description',
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfMondayTenAM() {
    var scheduledDate = _nextInstanceOfTenAM();
    while (scheduledDate.weekday != DateTime.monday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfTenAM() {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
