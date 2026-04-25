import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';
import '../blocs/settings_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _appVersion = 'v1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'StreamPro v${info.version} (Build ${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocConsumer<SettingsBloc, SettingsState>(
        listener: (context, state) {
          if (state is SettingsActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is SettingsLoading || state is SettingsInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SettingsLoaded || state is SettingsActionSuccess) {
            final config = state is SettingsLoaded ? state.config : (state as SettingsActionSuccess).config;
            return ListView(
              children: [
                _buildSectionHeader('Playback'),
                ListTile(
                  title: const Text('Playback Settings'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.settingsPlayback),
                ),
                _buildSectionHeader('Notifications'),
                SwitchListTile(
                  title: const Text('Push Notifications'),
                  value: config.notificationsEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleNotifications()),
                ),
                _buildSectionHeader('Privacy & Parental Controls'),
                ListTile(
                  title: const Text('Parental Controls'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.settingsParental),
                ),
                ListTile(
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.privacy),
                ),
                ListTile(
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.terms),
                ),
                _buildSectionHeader('Storage'),
                ListTile(
                  title: const Text('Clear Image Cache'),
                  subtitle: const Text('Cached thumbnails: 12 MB'),
                  onTap: () => _confirmAction(context, 'Clear image cache?', () {
                    context.read<SettingsBloc>().add(ClearImageCache());
                  }),
                ),
                ListTile(
                  title: const Text('Clear Watch History'),
                  onTap: () => _confirmAction(context, 'Clear all watch history?', () {
                    context.read<SettingsBloc>().add(ClearWatchHistory());
                  }),
                ),
                ListTile(
                  title: const Text('Clear All Downloads'),
                  onTap: () => _confirmAction(context, 'Delete all downloaded videos?', () {
                    context.read<SettingsBloc>().add(ClearAllDownloads());
                  }),
                ),
                _buildSectionHeader('About'),
                ListTile(
                  title: const Text('App Version'),
                  subtitle: Text(_appVersion),
                ),
                ListTile(
                  title: const Text('Help & FAQ'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.help),
                ),
                ListTile(
                  title: const Text('About StreamPro'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push(AppRoutes.about),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 8),
      child: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.secondary),
      ),
    );
  }

  void _confirmAction(BuildContext context, String title, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onConfirm();
            },
            child: const Text('Confirm', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
