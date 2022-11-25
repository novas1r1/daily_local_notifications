import 'package:daily_local_notifications/src/services/notification_service.dart';

class ReminderRepository {
  final NotificationService notificationService;

  const ReminderRepository({required this.notificationService});

  Future<void> sendNotification() async {
    // await notificationProvider.sendNotification();
  }
}
