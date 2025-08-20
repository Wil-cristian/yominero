import 'package:flutter/material.dart';
import 'models/notification.dart';

/// Displays a list of notifications. Users can mark each
/// notification as read. In a full application these
/// notifications would be fetched from a backend service and
/// updated accordingly.
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  // Sample notifications for demonstration. In a real app these
  // would be loaded from persistent storage or a server.
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Nueva oferta',
      description: 'Hay una nueva oferta en linterna LED',
    ),
    AppNotification(
      id: '2',
      title: 'Solicitud aceptada',
      description: 'Tu solicitud de topografía ha sido aceptada',
    ),
  ];

  void _markAsRead(int index) {
    setState(() {
      final notification = _notifications[index];
      _notifications[index] = AppNotification(
        id: notification.id,
        title: notification.title,
        description: notification.description,
        isRead: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: ListView.builder(
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.description),
            trailing: notification.isRead
                ? const Icon(Icons.check, color: Colors.green)
                : IconButton(
                    icon: const Icon(Icons.mark_email_read),
                    onPressed: () => _markAsRead(index),
                  ),
          );
        },
      ),
    );
  }
}