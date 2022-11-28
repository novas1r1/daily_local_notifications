class DailyLocalNotificationsConfig {
  /// Translation for weekdays shown for the day toggle buttons
  /// Defaults to ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
  /// 'Saturday', 'Sunday']
  final List<String> weekDayTranslations;
  final String saveButtonText;
  final bool use24HourFormat;
  final bool useCupertinoSwitch;

  /// Constructor for [DailyLocalNotificationsConfig]
  DailyLocalNotificationsConfig({
    this.weekDayTranslations = const [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ],
    this.use24HourFormat = true,
    this.useCupertinoSwitch = true,
    this.saveButtonText = 'Save',
  });
}
