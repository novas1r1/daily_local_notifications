import 'package:daily_local_notifications/src/providers/reminder_settings_provider.dart';
import 'package:daily_local_notifications/src/ui/daily_toggle_buttons.dart';
import 'package:daily_local_notifications/src/ui/timer_picker.dart';
import 'package:flutter/cupertino.dart';
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
  final Color activeColor;

  /// Inactive color for the day button
  /// Defaults to [Colors.grey]
  final Color inactiveColor;

  final Color backgroundColor;

  final TextStyle timeNormalTextStyle;
  final TextStyle timeSelectedTextStyle;

  final EdgeInsets contentPadding;

  /// Constructor for the [DailyLocalNotificationWidget]
  const DailyLocalNotificationWidget({
    super.key,
    required this.reminderTitleText,
    required this.reminderRepeatText,
    required this.reminderDailyText,
    required this.activeColor,
    required this.inactiveColor,
    required this.backgroundColor,
    required this.timeNormalTextStyle,
    required this.timeSelectedTextStyle,
    required this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderSettingsProvider>(
      builder: (context, provider, child) {
        return Container(
          padding: contentPadding,
          color: backgroundColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  if (provider.config.useCupertinoSwitch)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        reminderTitleText,
                        CupertinoSwitch(
                          activeColor: activeColor,
                          value: provider.isReminderEnabled,
                          onChanged: (bool isEnabled) => provider.updateReminderEnabled(isEnabled),
                        ),
                      ],
                    )
                  else
                    SwitchListTile(
                      activeColor: activeColor,
                      inactiveTrackColor: inactiveColor,
                      contentPadding: EdgeInsets.zero,
                      value: provider.isReminderEnabled,
                      title: reminderTitleText,
                      onChanged: (bool isEnabled) => provider.updateReminderEnabled(isEnabled),
                    ),
                  if (provider.isReminderEnabled)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DailyToggleButtons(
                          reminderRepeatText: reminderRepeatText,
                          reminderDailyText: reminderDailyText,
                          activeColor: activeColor,
                          inactiveColor: inactiveColor,
                        ),
                        TimePicker(
                          is24HourMode: provider.config.use24HourFormat,
                          is2D: true,
                          normalTextStyle: timeNormalTextStyle,
                          selectedTextStyle: timeSelectedTextStyle,
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
