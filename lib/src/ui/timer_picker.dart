import 'package:daily_local_notifications/src/providers/reminder_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';

class TimePicker extends StatelessWidget {
  final bool is24HourMode;
  final TextStyle? normalTextStyle;
  final TextStyle? selectedTextStyle;
  final bool is2D;

  const TimePicker({
    super.key,
    required this.is24HourMode,
    required this.is2D,
    required this.normalTextStyle,
    required this.selectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Consumer<ReminderSettingsProvider>(
      builder: (context, provider, child) {
        return TimePickerSpinner(
          is24HourMode: is24HourMode,
          time: DateTime(
            now.year,
            now.month,
            now.day,
            provider.reminderTime.hour,
            provider.reminderTime.minute,
          ),
          normalTextStyle: normalTextStyle,
          highlightedTextStyle: selectedTextStyle,
          spacing: 24,
          itemHeight: 60,
          isForce2Digits: is2D,
          onTimeChange: (time) => provider.updateReminderTime(time),
        );
      },
    );
  }
}
