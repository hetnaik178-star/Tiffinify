class AppNotificationModel {
  final String id, title, body, type;
  bool isRead;
  final DateTime createdAt;

  AppNotificationModel({required this.id, required this.title, required this.body,
                        this.type = 'info', this.isRead = false, DateTime? createdAt})
      : createdAt = createdAt ?? DateTime.now();
}