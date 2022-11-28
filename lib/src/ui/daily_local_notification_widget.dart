import 'package:daily_local_notifications/src/providers/reminder_settings_provider.dart';
import 'package:daily_local_notifications/src/ui/daily_toggle_buttons.dart';
import 'package:daily_local_notifications/src/ui/timer_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyLocalNotificationWidget extends StatelessWidget {
  /// Widget for displaying the "Reminder Title" text
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

  final TextStyle timeNormalTextStyle;
  final TextStyle timeSelectedTextStyle;

  /// Constructor for the [DailyLocalNotificationWidget]
  const DailyLocalNotificationWidget({
    super.key,
    required this.reminderTitleText,
    required this.reminderRepeatText,
    required this.reminderDailyText,
    required this.dayActiveColor,
    required this.dayInactiveColor,
    required this.timeNormalTextStyle,
    required this.timeSelectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderSettingsProvider>(
      builder: (context, provider, child) {
        return Container(
          color: Theme.of(context).backgroundColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: provider.isReminderEnabled,
                    title: reminderTitleText,
                    onChanged: (bool isEnabled) =>
                        provider.updateReminderEnabled(isEnabled),
                  ),
                  if (provider.isReminderEnabled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DailyToggleButtons(
                          reminderRepeatText: reminderRepeatText,
                          reminderDailyText: reminderDailyText,
                          dayActiveColor: dayActiveColor,
                          dayInactiveColor: dayInactiveColor,
                        ),
                        TimePicker(
                          is24HourMode: true,
                          is2D: true,
                          normalTextStyle: timeNormalTextStyle,
                          selectedTextStyle: timeSelectedTextStyle,
                        ),
                        ElevatedButton(
                          onPressed: () => provider.scheduleNotifications(),
                          child: const Text('Save'),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
