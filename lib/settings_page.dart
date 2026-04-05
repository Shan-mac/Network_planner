import 'package:flutter/material.dart';
import 'main.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = themeNotifier.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("App Settings"),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: isDarkMode, 
              onChanged: (val) {
                setState(() {
                  themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                });
              },
            ), 
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Notifications"),
            trailing: Switch(
              value: notificationsEnabled, 
              onChanged: (val) {
                setState(() {
                  notificationsEnabled = val;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(val ? "Notifications Enabled" : "Notifications Disabled"),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ), 
          ),
          const SizedBox(height: 20),
          const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent)),
          const SizedBox(height: 10),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text("Version"),
            trailing: Text("1.0.0", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}