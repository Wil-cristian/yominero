class AppNotification {
  final String id;
  final String title;
  final String description;
  final bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.description,
    this.isRead = false,
  });
}
