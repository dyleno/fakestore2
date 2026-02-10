import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 2,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: const Text(
          'Instellingen',
          style: TextStyle(
              fontWeight: FontWeight.w800, fontSize: 24, letterSpacing: -0.5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsGroup('Algemeen', [
            _buildSettingsItem(Icons.language, 'Taal', 'Nederlands'),
            _buildSettingsItem(
                Icons.notifications_outlined, 'Meldingen', 'Aan'),
            _buildSettingsItem(Icons.dark_mode_outlined, 'Thema', 'Systeem'),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup('Account', [
            _buildSettingsItem(Icons.person_outline, 'Profiel', null),
            _buildSettingsItem(
                Icons.shopping_bag_outlined, 'Bestellingen', null),
            _buildSettingsItem(Icons.payment, 'Betaalmethoden', null),
          ]),
          const SizedBox(height: 24),
          _buildSettingsGroup('Overige', [
            _buildSettingsItem(Icons.help_outline, 'Help & Support', null),
            _buildSettingsItem(Icons.info_outline, 'Over de app', null),
            _buildSettingsItem(Icons.logout, 'Uitloggen', null,
                isDestructive: true),
          ]),
        ],
      ),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ),
        Card(
          elevation: 0,
          color: Colors.grey[50],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsItem(IconData icon, String title, String? trailing,
      {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon,
          color: isDestructive ? Colors.red : const Color(0xFF6C63FF)),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDestructive ? Colors.red : Colors.black87,
        ),
      ),
      trailing: trailing != null
          ? Text(trailing, style: const TextStyle(color: Colors.grey))
          : const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
      onTap: () {},
    );
  }
}
