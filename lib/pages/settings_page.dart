import 'package:flutter/material.dart';

import '../state/app_scope.dart';
import '../widgets/page_header.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      bottom: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 120),
        children: [
          const PageHeader(
            title: 'Settings',
            subtitle: 'Project Rainbow',
          ),
          const SizedBox(height: 22),
          Text('Appearance', style: theme.textTheme.titleMedium),
          const SizedBox(height: 9),
          Card(
            child: Column(
              children: [
                RadioListTile<ThemeMode>(
                  title: const Text('Use system theme'),
                  subtitle: const Text('Follow Android light or dark mode'),
                  value: ThemeMode.system,
                  groupValue: store.themeMode,
                  onChanged: (value) {
                    if (value != null) store.setThemeMode(value);
                  },
                ),
                Divider(height: 1, color: theme.dividerColor),
                RadioListTile<ThemeMode>(
                  title: const Text('Light'),
                  value: ThemeMode.light,
                  groupValue: store.themeMode,
                  onChanged: (value) {
                    if (value != null) store.setThemeMode(value);
                  },
                ),
                Divider(height: 1, color: theme.dividerColor),
                RadioListTile<ThemeMode>(
                  title: const Text('Dark'),
                  value: ThemeMode.dark,
                  groupValue: store.themeMode,
                  onChanged: (value) {
                    if (value != null) store.setThemeMode(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          Text('Privacy & data', style: theme.textTheme.titleMedium),
          const SizedBox(height: 9),
          _SettingsCard(
            icon: Icons.lock_outline_rounded,
            title: 'Encryption',
            subtitle: 'Encrypted local database will live here',
            onTap: () => _comingSoon(context, 'Encryption'),
          ),
          const SizedBox(height: 9),
          _SettingsCard(
            icon: Icons.devices_other_rounded,
            title: 'Devices',
            subtitle: 'Trusted devices and pairing',
            onTap: () => _comingSoon(context, 'Devices'),
          ),
          const SizedBox(height: 9),
          _SettingsCard(
            icon: Icons.sync_rounded,
            title: 'Sync',
            subtitle: 'Relay status and local-first synchronization',
            onTap: () => _comingSoon(context, 'Sync'),
          ),
          const SizedBox(height: 9),
          _SettingsCard(
            icon: Icons.backup_outlined,
            title: 'Backup & recovery',
            subtitle: 'Encrypted exports and recovery configuration',
            onTap: () => _comingSoon(context, 'Backup & recovery'),
          ),
          const SizedBox(height: 22),
          Text('About', style: theme.textTheme.titleMedium),
          const SizedBox(height: 9),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info_outline_rounded),
              title: const Text('Project Rainbow'),
              subtitle: const Text('UI build 0.2.0'),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is the next backend phase.')),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right_rounded),
        onTap: onTap,
      ),
    );
  }
}
