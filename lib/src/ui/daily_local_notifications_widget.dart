import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

/// Displays a row of toggle buttons for selecting days of the week.
/// Displays a daily-checkbox-button for selecting
/// or deselecting all days of the week.
class DailyLocalNotificationWidget extends StatefulWidget {
  final bool isReminderEnabled;
  final Widget reminderTitleText;

  /// Widget for displaying the "Repeat" text on the left
  final Widget reminderRepeatText;

  /// Widget for displaying the "Daily" text for the toggle button on the right
  final Widget reminderDailyText;

  /// Active color for the day button
  /// Defaults to [Colors.blue]
  final Color dayActiveColor;

  /// Inactive color for the day button
  /// Defaults to [Colors.grey]
  final Color dayInactiveColor;

  const DailyLocalNotificationWidget({
    super.key,
    this.isReminderEnabled = false,
    this.reminderTitleText = const Text('Reminder Title'),
    this.reminderRepeatText = const Text('Repeat'),
    this.reminderDailyText = const Text('Daily'),
    this.dayActiveColor = Colors.orange,
    this.dayInactiveColor = Colors.grey,
  });

  @override
  State<DailyLocalNotificationWidget> createState() =>
      _DailyLocalNotificationWidgetState();
}

class _DailyLocalNotificationWidgetState
    extends State<DailyLocalNotificationWidget> {
  late bool isReminderEnabled;

  @override
  void initState() {
    super.initState();
    isReminderEnabled = widget.isReminderEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: isReminderEnabled,
              title: widget.reminderTitleText,
              onChanged: (bool value) {
                print('value: $value');
                setState(() {
                  isReminderEnabled = value;
                });
                // TODO save to shared preferences
              },
            ),
            if (isReminderEnabled)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DailyToggleButtons(
                    reminderRepeatText: widget.reminderRepeatText,
                    reminderDailyText: widget.reminderDailyText,
                    dayActiveColor: widget.dayActiveColor,
                    dayInactiveColor: widget.dayInactiveColor,
                  ),
                  const Flexible(child: _TimePicker()),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Save'),
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}

class _DailyToggleButtons extends StatefulWidget {
  final Widget reminderRepeatText;
  final Widget reminderDailyText;
  final Color dayActiveColor;
  final Color dayInactiveColor;

  const _DailyToggleButtons({
    this.reminderRepeatText = const Text('Repeat'),
    this.reminderDailyText = const Text('Daily'),
    required this.dayActiveColor,
    required this.dayInactiveColor,
  });

  @override
  State<_DailyToggleButtons> createState() => _DailyToggleButtonsState();
}

class _DailyToggleButtonsState extends State<_DailyToggleButtons> {
  late List<WeekDay> reminderDays;
  late bool isDailyReminderEnabled;

  @override
  void initState() {
    super.initState();
    reminderDays = WeekDay.initialWeekDays;
    if (reminderDays.every((element) => element.isActive)) {
      isDailyReminderEnabled = true;
    } else {
      isDailyReminderEnabled = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            widget.reminderRepeatText,
            const Spacer(),
            widget.reminderDailyText,
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: isDailyReminderEnabled,
              onChanged: (isDaily) => onToggleDailyReminder(isDaily ?? false),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              reminderDays.length,
              (index) => Expanded(
                child: GestureDetector(
                  onTap: () => onToggleWeekDay(reminderDays[index]),
                  child: Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: reminderDays[index].isActive
                            ? widget.dayActiveColor
                            : widget.dayInactiveColor,
                      ),
                      height: 45,
                      width: 45,
                      child: Center(
                        child: Text(reminderDays[index].firstLetter),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onToggleDailyReminder(bool value) {
    setState(() {
      isDailyReminderEnabled = value;

      if (value) {
        // set all days to active
        reminderDays =
            reminderDays.map((day) => day.copyWith(isActive: true)).toList();
      } else {
        // set all days to inactive
        reminderDays =
            reminderDays.map((day) => day.copyWith(isActive: false)).toList();
      }
    });
  }

  void onToggleWeekDay(WeekDay reminderDay) {
    setState(() {
      // toggle the day
      reminderDays = reminderDays
          .map(
            (day) => day.copyWith(
              isActive: day == reminderDay ? !day.isActive : day.isActive,
            ),
          )
          .toList();

      // enable daily reminder if all days are active
      if (reminderDays.every((day) => day.isActive)) {
        isDailyReminderEnabled = true;
      } else {
        isDailyReminderEnabled = false;
      }
    });
  }
}

class _TimePicker extends StatefulWidget {
  const _TimePicker();

  @override
  State<_TimePicker> createState() => _TimePickerState();
}

class _TimePickerState extends State<_TimePicker> {
  late TimeOfDay timeOfDay;

  @override
  void initState() {
    super.initState();
    timeOfDay = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return TimePickerSpinner(
      is24HourMode: false,
      time: DateTime(
        2000,
        1,
        1,
        timeOfDay.hour,
        timeOfDay.minute,
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
        setState(() {
          timeOfDay = TimeOfDay.fromDateTime(time);
        });
      },
    );
  }
}
