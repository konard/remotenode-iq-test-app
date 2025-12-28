import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';
import '../utils/utils.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final localeNotifier = ref.read(localeProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ResponsiveContainer(
        maxWidth: 600,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Theme section
            _buildSectionHeader(context, 'Appearance'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.brightness_6),
                    title: const Text('Theme'),
                    subtitle: Text(_getThemeModeName(themeMode)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showThemeDialog(context, ref, themeMode),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Language section
            _buildSectionHeader(context, 'Language'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Language'),
                    subtitle: Text(localeNotifier.getLocaleName(locale)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _showLanguageDialog(context, ref, locale),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // About section
            _buildSectionHeader(context, 'About'),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text('About IQ Test'),
                    subtitle: const Text('Version 1.0.0'),
                    onTap: () => _showAboutDialog(context),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.privacy_tip_outlined),
                    title: const Text('Privacy Policy'),
                    trailing: const Icon(Icons.open_in_new, size: 20),
                    onTap: () {
                      // TODO: Open privacy policy
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  String _getThemeModeName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref, ThemeMode current) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(_getThemeModeName(mode)),
              value: mode,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  ref.read(themeModeProvider.notifier).setTheme(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref, Locale current) {
    final notifier = ref.read(localeProvider.notifier);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: LocaleNotifier.supportedLocales.map((locale) {
            return RadioListTile<Locale>(
              title: Text(notifier.getLocaleName(locale)),
              value: locale,
              groupValue: current,
              onChanged: (value) {
                if (value != null) {
                  notifier.setLocale(value);
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.psychology,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 12),
            const Text('IQ Test'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A comprehensive IQ test app that evaluates your cognitive '
              'abilities across 5 key areas: Verbal, Numerical, Logical, '
              'Spatial, and Pattern Recognition.',
            ),
            SizedBox(height: 16),
            Text(
              'This app is designed to provide a professional and fair '
              'testing experience with adaptive difficulty and detailed results.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
