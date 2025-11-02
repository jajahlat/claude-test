import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            context,
            title: 'Reading Preferences',
            children: [
              _buildTile(
                context,
                icon: Icons.format_size_rounded,
                title: 'Font Size',
                subtitle: '16px',
                onTap: () {
                  // Show font size selector
                },
              ),
              _buildTile(
                context,
                icon: Icons.text_fields_rounded,
                title: 'Font Family',
                subtitle: 'Lora',
                onTap: () {
                  // Show font family selector
                },
              ),
              _buildTile(
                context,
                icon: Icons.color_lens_rounded,
                title: 'Background Color',
                onTap: () {
                  // Show color picker
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: 'Notifications',
            children: [
              Consumer<UserProvider>(
                builder: (context, userProvider, _) {
                  final user = userProvider.currentUser;
                  if (user == null) return const SizedBox.shrink();

                  return Column(
                    children: [
                      _buildTile(
                        context,
                        icon: Icons.notifications_rounded,
                        title: 'Enable Notifications',
                        trailing: Switch(
                          value: user.preferences.notificationsEnabled,
                          onChanged: (value) {
                            userProvider.toggleNotifications(value);
                          },
                        ),
                      ),
                      _buildTile(
                        context,
                        icon: Icons.format_quote_rounded,
                        title: 'Daily Quotes',
                        trailing: Switch(
                          value: user.preferences.dailyQuotesEnabled,
                          onChanged: (value) {
                            userProvider.toggleDailyQuotes(value);
                          },
                        ),
                      ),
                      if (user.preferences.dailyQuotesEnabled)
                        _buildTile(
                          context,
                          icon: Icons.schedule_rounded,
                          title: 'Quote Time',
                          subtitle: user.preferences.dailyQuoteTime,
                          onTap: () {
                            // Show time picker
                          },
                        ),
                    ],
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: 'General',
            children: [
              _buildTile(
                context,
                icon: Icons.language_rounded,
                title: 'Language',
                subtitle: 'English',
                onTap: () {
                  _showLanguageSelector(context);
                },
              ),
              _buildTile(
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
            ],
          ),

          const SizedBox(height: 24),

          _buildSection(
            context,
            title: 'About',
            children: [
              _buildTile(
                context,
                icon: Icons.info_rounded,
                title: 'About Faydabook',
                onTap: () {
                  _showAboutDialog(context);
                },
              ),
              _buildTile(
                context,
                icon: Icons.privacy_tip_rounded,
                title: 'Privacy Policy',
                onTap: () {
                  // Open privacy policy
                },
              ),
              _buildTile(
                context,
                icon: Icons.description_rounded,
                title: 'Terms of Service',
                onTap: () {
                  // Open terms of service
                },
              ),
              _buildTile(
                context,
                icon: Icons.bug_report_rounded,
                title: 'Report a Bug',
                onTap: () {
                  // Open bug report form
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Card(
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(Icons.arrow_forward_ios_rounded, size: 16)
              : null),
      onTap: onTap,
    );
  }

  void _showLanguageSelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('English'),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .changeLanguage('en');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('العربية'),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .changeLanguage('ar');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Français'),
                onTap: () {
                  Provider.of<UserProvider>(context, listen: false)
                      .changeLanguage('fr');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
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
        const SizedBox(height: 16),
        const Text(
          'May Allah shower His blessings upon the Shaykh and all seekers of knowledge.',
        ),
      ],
    );
  }
}
