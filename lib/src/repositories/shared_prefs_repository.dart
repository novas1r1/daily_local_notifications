import 'dart:convert';

import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const SP_REMINDER_TIME_key = 'reminder_time';
const SP_REMINDER_ENABLED_KEY = 'reminder_enabled';
const SP_REMINDER_WEEK_DAYS = 'reminder_week_days';

class SharedPrefsRepository {
  final SharedPreferences sharedPrefs;

  const SharedPrefsRepository({required this.sharedPrefs});

  TimeOfDay getReminderTime() {
    final reminderTimeString = sharedPrefs.getString(SP_REMINDER_TIME_key);

    if (reminderTimeString != null) {
      final hour = int.parse(reminderTimeString.split(':').first);
      final minute = int.parse(reminderTimeString.split(':').last);

      return TimeOfDay(hour: hour, minute: minute);
    }

    return TimeOfDay.now();
  }

  Future<void> setReminderTime(TimeOfDay time) async {
    final reminderTimeString = '${time.hour}:${time.minute}';

    await sharedPrefs.setString(SP_REMINDER_TIME_key, reminderTimeString);
  }

  bool isReminderEnabled() {
    final reminderTime = sharedPrefs.getBool(SP_REMINDER_ENABLED_KEY);

    return reminderTime ?? false;
  }

  Future<void> setReminderEnabled(bool isEnabled) => sharedPrefs.setBool(SP_REMINDER_ENABLED_KEY, isEnabled);

  List<WeekDay> getReminderDays(List<String> weekDayTranslations) {
    final reminderDaysString = sharedPrefs.getString(SP_REMINDER_WEEK_DAYS);

    late List<WeekDay> reminderDays;

    if (reminderDaysString != null) {
      final reminderDaysList = jsonDecode(reminderDaysString) as List;
      final reminderDaysUpdated = <WeekDay>[];
      for (var i = 0; i < reminderDaysList.length; i++) {
        reminderDaysUpdated.add(
          WeekDay.fromJson(
            reminderDaysList[i] as String,
            weekDayTranslations[i],
          ),
        );
      }

      reminderDays = reminderDaysUpdated;
    } else {
      reminderDays = WeekDay.initialWeekDaysFromTranslations(weekDayTranslations);
    }

    return reminderDays;
  }

  Future<void> setReminderDays(List<WeekDay> reminderDays) async {
    final reminderDaysString = jsonEncode(reminderDays);

    await sharedPrefs.setString(
      SP_REMINDER_WEEK_DAYS,
      reminderDaysString,
    );
  }
}
