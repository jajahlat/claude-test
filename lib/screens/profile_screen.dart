import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final user = userProvider.currentUser;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Profile Header
                _buildProfileHeader(context, user.name, user.email),
                const SizedBox(height: 32),

                // Statistics
                _buildStatistics(context),
                const SizedBox(height: 32),

                // Settings Options
                _buildSettingsOptions(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, String name, String email) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(
              fontSize: 36,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(context, '12', 'Books Read'),
            _buildStatItem(context, '5', 'Currently Reading'),
            _buildStatItem(context, '24', 'Favorites'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildSettingsOptions(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          context,
          icon: Icons.nightlight_round,
          title: 'Dark Mode',
          trailing: Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (_) {
                  themeProvider.toggleTheme();
                },
              );
            },
          ),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: 'English',
          onTap: () {
            // Show language selection
          },
        ),
        _buildSettingsTile(
          context,
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
          ),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.format_quote_rounded,
          title: 'Daily Quotes',
          trailing: Switch(
            value: true,
            onChanged: (value) {},
          ),
        ),
        _buildSettingsTile(
          context,
          icon: Icons.info_rounded,
          title: 'About',
          onTap: () {
            _showAboutDialog(context);
          },
        ),
      ],
    );
  }

  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: trailing ??
            const Icon(Icons.arrow_forward_ios_rounded, size: 16),
        onTap: onTap,
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Faydabook',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.menu_book_rounded, size: 48),
      children: [
        const Text(
          'An Islamic ebook and audiobook app dedicated to the teachings of Shaykh Ibrahim Niass (radiyallahu anhu).',
        ),
      ],
    );
  }
}
