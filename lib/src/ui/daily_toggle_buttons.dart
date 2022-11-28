import 'package:daily_local_notifications/src/providers/reminder_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyToggleButtons extends StatelessWidget {
  final Widget reminderRepeatText;
  final Widget reminderDailyText;
  final Color dayActiveColor;
  final Color dayInactiveColor;

  const DailyToggleButtons({
    super.key,
    required this.reminderRepeatText,
    required this.reminderDailyText,
    required this.dayActiveColor,
    required this.dayInactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderSettingsProvider>(
      builder: (context, provider, child) {
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
                  activeColor: dayActiveColor,
                  checkColor: Colors.white,
                  value: provider.isDailyReminderEnabled,
                  onChanged: (isDaily) =>
                      provider.updateDailyReminderEnabled(isDaily ?? false),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  provider.reminderDays.length,
                  (index) => Expanded(
                    child: GestureDetector(
                      onTap: () =>
                          provider.toggleDay(provider.reminderDays[index]),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: provider.reminderDays[index].isActive
                                ? dayActiveColor
                                : dayInactiveColor,
                          ),
                          height: 45,
                          width: 45,
                          child: Center(
                            child:
                                Text(provider.reminderDays[index].firstLetter),
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
      },
    );
  }
}
