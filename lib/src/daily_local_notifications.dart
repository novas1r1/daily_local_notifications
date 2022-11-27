import 'package:daily_local_notifications/src/providers/reminder_settings.dart';
import 'package:daily_local_notifications/src/repositories/reminder_repository.dart';
import 'package:daily_local_notifications/src/repositories/shared_prefs_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Displays a row of toggle buttons for selecting days of the week.
/// Displays a daily-checkbox-button for selecting
/// or deselecting all days of the week.
class DailyLocalNotification extends StatefulWidget {
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

  /// Constructor for [DailyLocalNotification]
  const DailyLocalNotification({
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
  State<DailyLocalNotification> createState() => _DailyLocalNotificationState();
}

class _DailyLocalNotificationState extends State<DailyLocalNotification> {
  late Future<ReminderSettingsProvider> loadDependencies;

  @override
  void initState() {
    super.initState();
    loadDependencies = init();
  }

  /// Creates a [DailyLocalNotification] widget.
  Future<ReminderSettingsProvider> init() async {
    final reminderRepository = ReminderRepository(
      flutterLocalNotificationsPlugin: FlutterLocalNotificationsPlugin(),
    );

    final sharedPrefs = await SharedPreferences.getInstance();
    final sharedPrefsRepository = SharedPrefsRepository(
      sharedPrefs: sharedPrefs,
    );

    return ReminderSettingsProvider(
      reminderRepository: reminderRepository,
      sharedPrefsRepository: sharedPrefsRepository,
    )..init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ReminderSettingsProvider>(
      future: loadDependencies,
      builder: (
        BuildContext context,
        AsyncSnapshot<ReminderSettingsProvider> snapshot,
      ) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return ChangeNotifierProvider<ReminderSettingsProvider>.value(
            value: snapshot.data!,
            child: _DailyLocalNotificationWidget(
              reminderTitleText: widget.reminderTitleText,
              reminderRepeatText: widget.reminderRepeatText,
              reminderDailyText: widget.reminderDailyText,
              dayActiveColor: widget.dayActiveColor,
              dayInactiveColor: widget.dayInactiveColor,
              timeNormalTextStyle: widget.timeNormalTextStyle,
              timeSelectedTextStyle: widget.timeSelectedTextStyle,
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class _DailyLocalNotificationWidget extends StatelessWidget {
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

  /// Constructor for the [_DailyLocalNotificationWidget]
  const _DailyLocalNotificationWidget({
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
                        _DailyToggleButtons(
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

class _DailyToggleButtons extends StatefulWidget {
  final Widget reminderRepeatText;
  final Widget reminderDailyText;
  final Color dayActiveColor;
  final Color dayInactiveColor;

  const _DailyToggleButtons({
    required this.reminderRepeatText,
    required this.reminderDailyText,
    required this.dayActiveColor,
    required this.dayInactiveColor,
  });

  @override
  State<_DailyToggleButtons> createState() => _DailyToggleButtonsState();
}

class _DailyToggleButtonsState extends State<_DailyToggleButtons> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReminderSettingsProvider>(
      builder: (context, provider, child) {
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
                  activeColor: widget.dayActiveColor,
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
                                ? widget.dayActiveColor
                                : widget.dayInactiveColor,
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
