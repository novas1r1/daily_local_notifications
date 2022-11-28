class NotificationConfig {
  final String title;
  final String description;
  final String channelId;
  final String channelName;
  final String channelDescription;
  final String iconName;

  const NotificationConfig({
    this.title = 'Notification Title',
    this.description = 'Notification Description',
    this.channelId = 'daily_notification_channel_id',
    this.channelName = 'daily_notification_channel_name',
    this.channelDescription = 'daily_notification_channel_description',
    this.iconName = 'app_icon',
  });
}
