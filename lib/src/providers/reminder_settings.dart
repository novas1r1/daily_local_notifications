import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:daily_local_notifications/src/repositories/reminder_repository.dart';
import 'package:daily_local_notifications/src/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';

class ReminderSettingsProvider extends ChangeNotifier {
  final ReminderRepository reminderRepository;
  final SharedPrefsRepository sharedPrefsRepository;

  List<WeekDay> reminderDays = [];
  TimeOfDay reminderTime = TimeOfDay.now();
  bool isReminderEnabled = false;
  bool isDailyReminderEnabled = true;

  ReminderSettingsProvider({
    required this.reminderRepository,
    required this.sharedPrefsRepository,
  });

  /// Initially sets reminder settings saved in sharedPrefs
  void init() {
    reminderTime = sharedPrefsRepository.getReminderTime();
    isReminderEnabled = sharedPrefsRepository.isReminderEnabled();
    reminderDays = sharedPrefsRepository.getReminderDays();

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

  void updateReminderTime(DateTime dateTime) {
    reminderTime = TimeOfDay.fromDateTime(dateTime);
    notifyListeners();
  }

  Future<void> updateReminderEnabled(bool isEnabled) async {
    isReminderEnabled = isEnabled;

    if (!isEnabled) {
      await clearReminder();
    }

    notifyListeners();
  }

  void updateDailyReminderEnabled(bool isEnabled) {
    isDailyReminderEnabled = isEnabled;

    if (isEnabled) {
      // set all days to active
      reminderDays =
          reminderDays.map((day) => day.copyWith(isActive: true)).toList();
    } else {
      // set all days to inactive
      reminderDays =
          reminderDays.map((day) => day.copyWith(isActive: false)).toList();
    }

    notifyListeners();
  }

  void toggleDay(WeekDay day) {
    final updatedReminderDays = reminderDays.toList();
    final index = updatedReminderDays.indexWhere(
      (element) => element.shortName == day.shortName,
    );

    updatedReminderDays[index] = updatedReminderDays[index].copyWith(
      isActive: !updatedReminderDays[index].isActive,
    );

    reminderDays = updatedReminderDays;
    checkIfDailyReminderChecked();

    notifyListeners();
  }

  Future<void> scheduleNotifications() async {
    print('Scheduling notifications..., isReminderEnabled: $isReminderEnabled, '
        'reminderDays: $reminderDays, reminderTime: $reminderTime');
    await sharedPrefsRepository.setReminderDays(reminderDays);
    await sharedPrefsRepository.setReminderTime(reminderTime);
    await sharedPrefsRepository.setReminderEnabled(isReminderEnabled);

    // TODO schedule notifications
  }

  Future<void> clearReminder() async {
    // TODO remove all notifications

    reminderDays = WeekDay.initialWeekDays;
    isReminderEnabled = false;
    checkIfDailyReminderChecked();

    await sharedPrefsRepository.setReminderDays(WeekDay.initialWeekDays);
    await sharedPrefsRepository.setReminderEnabled(false);
  }
}
