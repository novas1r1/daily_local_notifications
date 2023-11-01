import 'dart:developer';
import 'dart:io';

import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:daily_local_notifications/src/utils/notification_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

const MethodChannel platform = MethodChannel('verena-zaiser.de/daily_local_notifications');

const String portName = 'notification_send_port';

class ReminderRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final NotificationConfig notificationConfig;

  const ReminderRepository({
    required this.flutterLocalNotificationsPlugin,
    required this.notificationConfig,
  });

  /// Initialize the flutter_local_notification plugin
  Future<void> init() async {
    await _configureLocalTimeZone();

    // app_icon needs to be a added as a drawable resource
    // to the Android head project
    final initializationSettingsAndroid = AndroidInitializationSettings(notificationConfig.iconName);

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
      // onDidReceiveBackgroundNotificationResponse: (details) => log(
      //   'NOTIFICATIONS::onDidReceiveBackgroundNotificationResponse:'
      //' $details',
      // ),
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // REQUEST PERMISSION
    await requestPermissions();
  }

  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else {
      final plugin = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

      if (plugin != null) {
        await plugin.requestNotificationsPermission();
        // deprecated
        // await plugin.requestPermission();
      }
    }
  }

  /// Schedules notifications for a specific [timeOfDay] each weekday active
  /// within [days]
  /// Cancels all setup notifications first
  Future<void> scheduleDailyNotificationByTimeAndDay(
    TimeOfDay timeOfDay,
    List<WeekDay> days,
  ) async {
    log('NOTIFICATIONS::scheduleDailyNotificationByTimeAndDay: '
        '$timeOfDay, $days');

    await cancelAllNotifications();

    final activeDays = days.where((day) => day.isActive).map((day) => day.dayIndex).toList();

    if (activeDays.isNotEmpty) {
      log('NOTIFICATIONS::scheduleNotifications for: $timeOfDay, $activeDays');

      for (final activeDay in activeDays) {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          activeDay,
          notificationConfig.title,
          notificationConfig.description,
          _nextInstanceOfDay(timeOfDay, activeDay),
          NotificationDetails(
            android: AndroidNotificationDetails(
              notificationConfig.channelId,
              notificationConfig.channelName,
              channelDescription: notificationConfig.channelDescription,
            ),
          ),
          // deprecated
          // androidAllowWhileIdle: true,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    }
  }

  void onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) {
    log('NOTIFICATIONS::onDidReceiveLocalNotification');
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
  void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse,
  ) {
    final payload = notificationResponse.payload;

    if (notificationResponse.payload != null) {
      log('NOTIFICATIONS::notification payload: $payload');
    }
  }

  Future<void> cancelNotification(int id, String? tag) async {
    log('NOTIFICATIONS::cancelNotification id: $id');
    await flutterLocalNotificationsPlugin.cancel(id, tag: tag);
  }

  Future<void> cancelAllNotifications() async {
    log('NOTIFICATIONS::cancelAllNotifications');
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  tz.TZDateTime _nextInstanceOfTimeOfDay(TimeOfDay timeOfDay) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  tz.TZDateTime _nextInstanceOfDay(TimeOfDay timeOfDay, int dayIndex) {
    var scheduledDate = _nextInstanceOfTimeOfDay(timeOfDay);

    while (scheduledDate.weekday != dayIndex) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    log('NOTIFICATIONS::scheduledDate: $scheduledDate');
    return scheduledDate;
  }
}
