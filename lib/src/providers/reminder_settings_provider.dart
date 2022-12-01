import 'dart:developer';

import 'package:daily_local_notifications/daily_local_notifications.dart';
import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:daily_local_notifications/src/repositories/reminder_repository.dart';
import 'package:daily_local_notifications/src/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';

class ReminderSettingsProvider extends ChangeNotifier {
  final ReminderRepository reminderRepository;
  final SharedPrefsRepository sharedPrefsRepository;
  final DailyLocalNotificationsConfig config;

  List<WeekDay> reminderDays = [];
  TimeOfDay reminderTime = TimeOfDay.now();
  bool isReminderEnabled = false;
  bool isDailyReminderEnabled = true;

  ReminderSettingsProvider({
    required this.reminderRepository,
    required this.sharedPrefsRepository,
    required this.config,
  });

  /// Initially sets reminder settings saved in sharedPrefs
  Future<void> init() async {
    await reminderRepository.init();

    reminderTime = sharedPrefsRepository.getReminderTime();
    isReminderEnabled = sharedPrefsRepository.isReminderEnabled();
    reminderDays =
        sharedPrefsRepository.getReminderDays(config.weekDayTranslations);

    checkIfDailyReminderChecked();

    notifyListeners();
  }

  void checkIfDailyReminderChecked() {
    if (reminderDays.every((day) => day.isActive)) {
      isDailyReminderEnabled = true;
    } else {
      isDailyReminderEnabled = false;
    }

    notifyListeners();
  }

  Future<void> updateReminderTime(DateTime dateTime) async {
    reminderTime = TimeOfDay.fromDateTime(dateTime);
    await scheduleNotifications();
    notifyListeners();
  }

  Future<void> updateReminderEnabled(bool isEnabled) async {
    isReminderEnabled = isEnabled;

    if (!isEnabled) {
      await clearReminder();
    } else {
      await scheduleNotifications();
    }

    notifyListeners();
  }

  /// Checks if daily reminder should be enabled or disabled
  Future<void> updateDailyReminderEnabled(bool isEnabled) async {
    isDailyReminderEnabled = isEnabled;

    if (isEnabled) {
      reminderDays =
          reminderDays.map((day) => day.copyWith(isActive: true)).toList();
    } else {
      reminderDays =
          reminderDays.map((day) => day.copyWith(isActive: false)).toList();
    }

    await scheduleNotifications();

    notifyListeners();
  }

  Future<void> toggleDay(WeekDay day) async {
    final updatedReminderDays = reminderDays.toList();
    final index = updatedReminderDays.indexWhere(
      (element) => element.shortName == day.shortName,
    );

    updatedReminderDays[index] = updatedReminderDays[index].copyWith(
      isActive: !updatedReminderDays[index].isActive,
    );

    reminderDays = updatedReminderDays;
    checkIfDailyReminderChecked();

    await scheduleNotifications();

    notifyListeners();
  }

  Future<void> scheduleNotifications() async {
    log('NOTIFICATIONS::scheduleNotifications: '
        'isReminderEnabled: $isReminderEnabled, '
        'reminderDays: $reminderDays, '
        'reminderTime: $reminderTime');

    await sharedPrefsRepository.setReminderDays(reminderDays);
    await sharedPrefsRepository.setReminderTime(reminderTime);
    await sharedPrefsRepository.setReminderEnabled(isReminderEnabled);

    await reminderRepository.scheduleDailyNotificationByTimeAndDay(
      reminderTime,
      reminderDays,
    );
  }

  Future<void> clearReminder() async {
    log('NOTIFICATIONS::clearReminder');
    reminderDays =
        WeekDay.initialWeekDaysFromTranslations(config.weekDayTranslations);
    isReminderEnabled = false;
    checkIfDailyReminderChecked();

    await sharedPrefsRepository.setReminderDays(reminderDays);
    await sharedPrefsRepository.setReminderEnabled(false);

    await reminderRepository.cancelAllNotifications();
  }
}
