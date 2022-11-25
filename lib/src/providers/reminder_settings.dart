import 'package:daily_local_notifications/daily_local_notifications.dart';
import 'package:daily_local_notifications/src/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';

class ReminderSettings {
  final ReminderRepository reminderRepository;
  final SharedPrefsRepository sharedPrefsRepository;

  List<WeekDay> reminderDays = [];
  TimeOfDay reminderTime = TimeOfDay.now();
  bool isReminderEnabled = false;

  ReminderSettings({
    required this.reminderRepository,
    required this.sharedPrefsRepository,
  });

  bool get isDailyActive => reminderDays.every((element) => element.isActive);

  /// Initially sets reminder time saved in sharedPrefs
  void init() {
    final reminderTime = sharedPrefsRepository.getReminderTime();
    final isReminderEnabled = sharedPrefsRepository.isReminderEnabled();
    final reminderDays = sharedPrefsRepository.getReminderDays();

    // notifyListeners();
  }

  // TODO store current time in shared prefs
  // TODO load initial time from shared prefs or set current time
  // TODO setup local notifications (delete old notifications if updated)
  // TODO 24hour format
  Future<void> updateReminderTime(TimeOfDay selectedTime) async {
    await sharedPrefsRepository.setReminderTime(selectedTime);
    reminderTime = selectedTime;

    // notifyListeners();
  }

  Future<void> updateReminderEnabled(bool isEnabled) async {
    await sharedPrefsRepository.setReminderEnabled(
      isEnabled: isEnabled,
    );

    isReminderEnabled = isEnabled;

    // notifyListeners();
  }

  Future<void> toggleDay(WeekDay day) async {
    final updatedReminderDays = reminderDays.toList();
    final index = updatedReminderDays.indexWhere(
      (element) => element.shortName == day.shortName,
    );

    updatedReminderDays[index] = updatedReminderDays[index].copyWith(
      isActive: !updatedReminderDays[index].isActive,
    );

    await sharedPrefsRepository.setReminderDays(updatedReminderDays);

    reminderDays = updatedReminderDays;

    // notifyListeners();
  }

  Future<void> toggleAllDays({required bool isActive}) async {
    final updatedReminderDays = reminderDays
        .toList()
        .map((e) => e.copyWith(isActive: isActive))
        .toList();

    await sharedPrefsRepository.setReminderDays(updatedReminderDays);

    reminderDays = updatedReminderDays;

    // notifyListeners();
  }
}
