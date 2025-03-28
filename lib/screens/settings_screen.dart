// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        Text('Settings', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),

        ListTile(
          leading: Icon(Icons.category),
          title: Text('Manage Categories'),
          subtitle: Text('Add, edit or remove expense categories'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement category management screen
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coming soon...')));
          },
        ),

        ListTile(
          leading: Icon(Icons.backup),
          title: Text('Backup & Restore'),
          subtitle: Text('Save your data or restore from a backup'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement backup/restore functionality
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coming soon...')));
          },
        ),

        ListTile(
          leading: Icon(Icons.privacy_tip),
          title: Text('Privacy Settings'),
          subtitle: Text('Control app permissions and privacy'),
          trailing: Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            // TODO: Implement privacy settings screen
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Coming soon...')));
          },
        ),

        Divider(height: 32),

        ListTile(
          leading: Icon(Icons.info_outline),
          title: Text('About'),
          subtitle: Text('Version 1.0.0'),
        ),
      ],
    );
  }
}
