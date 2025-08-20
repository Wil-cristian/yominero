import 'package:flutter/material.dart';

/// A basic settings page that allows the user to toggle
/// notifications and choose between light and dark themes. In a
/// production app these preferences would be persisted and used to
/// configure the rest of the application.
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: _notificationsEnabled,
            onChanged: (value) {
              setState(() {
                _notificationsEnabled = value;
              });
            },
          ),
          SwitchListTile(
            title: const Text('Tema oscuro'),
            value: _darkTheme,
            onChanged: (value) {
              setState(() {
                _darkTheme = value;
              });
            },
          ),
        ],
      ),
    );
  }
}