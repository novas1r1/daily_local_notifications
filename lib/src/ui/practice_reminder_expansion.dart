import 'package:daily_local_notifications/src/ui/day_toggle_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class PracticeReminderExpansion extends StatelessWidget {
  final TimeOfDay? initialTimeOfDay;
  final bool isReminderEnabled;
  final Widget reminderTitleText;
  final Function(bool) onUpdateReminderEnabled;
  final Function(TimeOfDay) onUpdateReminderTime;

  const PracticeReminderExpansion({
    super.key,
    this.initialTimeOfDay,
    this.isReminderEnabled = false,
    this.reminderTitleText = const Text('Reminder Title'),
    required this.onUpdateReminderEnabled,
    required this.onUpdateReminderTime,
  });

  @override
  Widget build(BuildContext context) {
    final timePicked = initialTimeOfDay ?? TimeOfDay.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isReminderEnabled,
              title: reminderTitleText,
              onChanged: onUpdateReminderEnabled,
            ),
            if (isReminderEnabled)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DayToggleButtons(
                    onToggleDailyReminder: (bool) {
                      // TODO
                    },
                    onToggleWeekDay: (WeekDay) {
                      // TODO
                    },
                  ),
                  _TimePicker(
                    timePicked: timePicked,
                    onUpdateReminderTime: onUpdateReminderTime,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _TimePicker extends StatelessWidget {
  final TimeOfDay timePicked;
  final Function(TimeOfDay) onUpdateReminderTime;

  const _TimePicker({
    required this.timePicked,
    required this.onUpdateReminderTime,
  });

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
      is24HourMode: false,
      time: DateTime(
        2000,
        1,
        1,
        timePicked.hour,
        timePicked.minute,
      ),
      normalTextStyle: const TextStyle(
        fontSize: 24,
        color: Colors.grey,
      ),
      highlightedTextStyle: const TextStyle(
        fontSize: 24,
        color: Colors.orange,
      ),
      spacing: 24,
      itemHeight: 60,
      isForce2Digits: true,
      onTimeChange: (time) {
        final timeOfDay = TimeOfDay.fromDateTime(time);
        onUpdateReminderTime(timeOfDay);
      },
    );
  }
}
