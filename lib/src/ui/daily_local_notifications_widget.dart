import 'package:daily_local_notifications/src/ui/practice_reminder_expansion.dart';
import 'package:flutter/material.dart';

class DailyLocalNotificationsWidget extends StatefulWidget {
  const DailyLocalNotificationsWidget({super.key});

  @override
  _DailyLocalNotificationsWidgetState createState() =>
      _DailyLocalNotificationsWidgetState();
}

class _DailyLocalNotificationsWidgetState
    extends State<DailyLocalNotificationsWidget> {
  @override
  Widget build(BuildContext context) {
    return PracticeReminderExpansion(
      onUpdateReminderEnabled: (bool) {
        // TODO
      },
      onUpdateReminderTime: (TimeOfDay) {
        // TODO
      },
    ); /* ChecksboxListTile(
      contentPadding: EdgeInsets.zero,
      value: true,
      onChanged: (isChecked) =>
          context.read<FeatureFlagCubit>().toggleNotifications(),
      title: const Text('Enable Notifications'),
    ) */
  }
}
