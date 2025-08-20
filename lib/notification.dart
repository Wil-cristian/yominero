/// A simple notification model used for displaying alerts and
/// messages to the user. Notifications can be marked as read.
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
