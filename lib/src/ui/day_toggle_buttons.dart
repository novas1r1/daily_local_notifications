import 'package:daily_local_notifications/src/models/week_day.dart';
import 'package:flutter/material.dart';

class DayToggleButtons extends StatelessWidget {
  final Widget reminderRepeatText;
  final Widget reminderDailyText;
  final bool isReminderEnabled;
  final Function(bool) onToggleDailyReminder;
  final List<WeekDay> reminderDays;
  final Function(WeekDay) onToggleWeekDay;
  final Color? dayActiveColor;
  final Color? dayInactiveColor;

  const DayToggleButtons({
    super.key,
    this.reminderRepeatText = const Text('Repeat'),
    this.reminderDailyText = const Text('Daily'),
    this.isReminderEnabled = false,
    required this.onToggleDailyReminder,
    this.reminderDays = const [],
    required this.onToggleWeekDay,
    this.dayActiveColor = Colors.orange,
    this.dayInactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            reminderRepeatText,
            const Spacer(),
            reminderDailyText,
            Checkbox(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              value: isReminderEnabled,
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
                            ? dayActiveColor
                            : dayInactiveColor,
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
}
