class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  const ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });
}
