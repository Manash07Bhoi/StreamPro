import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/mixins/safe_pop_mixin.dart';
import '../blocs/settings_bloc.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SafePopMixin {
  String _appVersion = 'v1.0.0';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appVersion = 'v${info.version} (Build ${info.buildNumber})';
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        safePop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          title: const Text('Settings', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: safePop,
          ),
        ),
        body: BlocBuilder<SettingsBloc, SettingsState>(
          builder: (context, state) {
            if (state is SettingsLoading || state is SettingsInitial) {
              return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
            }

            // We use the latest config, even if in error state, assuming we have one from Loaded/Success
            final config = sl<SettingsBloc>().state is SettingsLoaded
                ? (sl<SettingsBloc>().state as SettingsLoaded).config
                : (sl<SettingsBloc>().state is SettingsActionSuccess ? (sl<SettingsBloc>().state as SettingsActionSuccess).config : null);

            if (config == null) return const Center(child: Text('Failed to load settings'));

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              children: [
                _buildSectionHeader('Playback'),
                _buildListTile(
                  icon: Icons.play_circle_outline,
                  title: 'Playback Settings',
                  onTap: () => context.push('/settings/playback'),
                ),

                _buildSectionHeader('Notifications'),
                _buildSwitchTile(
                  icon: Icons.notifications_none,
                  title: 'Push Notifications',
                  value: config.notificationsEnabled,
                  onChanged: (val) => context.read<SettingsBloc>().add(ToggleNotifications()),
                ),

                _buildSectionHeader('Privacy & Parental Controls'),
                _buildListTile(
                  icon: Icons.admin_panel_settings_outlined,
                  title: 'Parental Controls',
                  trailing: Text(config.parentalControlEnabled ? 'On' : 'Off', style: TextStyle(color: config.parentalControlEnabled ? const Color(0xFFC026D3) : const Color(0xFF6B7280))),
                  onTap: () => context.push('/settings/parental'),
                ),
                _buildListTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => context.push('/privacy'),
                ),
                _buildListTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  onTap: () => context.push('/terms'),
                ),

                _buildSectionHeader('Storage'),
                _buildListTile(
                  icon: Icons.layers_clear,
                  title: 'Clear Image Cache',
                  subtitle: 'Frees up space used by cached images',
                  onTap: () => _showConfirmDialog(
                    context,
                    'Clear Cache',
                    'Are you sure you want to clear the image cache?',
                    () => context.read<SettingsBloc>().add(ClearImageCache()),
                  ),
                ),
                _buildListTile(
                  icon: Icons.history_toggle_off,
                  title: 'Clear Watch History',
                  onTap: () => _showConfirmDialog(
                    context,
                    'Clear History',
                    'Are you sure you want to clear your entire watch history? This cannot be undone.',
                    () => context.read<SettingsBloc>().add(ClearWatchHistory()),
                  ),
                ),
                _buildListTile(
                  icon: Icons.delete_sweep,
                  title: 'Clear All Downloads',
                  onTap: () => _showConfirmDialog(
                    context,
                    'Clear Downloads',
                    'Are you sure you want to delete all downloaded videos?',
                    () => context.read<SettingsBloc>().add(ClearAllDownloads()),
                  ),
                ),

                _buildSectionHeader('About'),
                _buildListTile(
                  icon: Icons.info_outline,
                  title: 'App Version',
                  trailing: Text('StreamPro $_appVersion', style: const TextStyle(color: Color(0xFF6B7280))),
                  onTap: () {},
                ),
                _buildListTile(
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  onTap: () => context.push('/help'),
                ),
                _buildListTile(
                  icon: Icons.business,
                  title: 'About StreamPro',
                  onTap: () => context.push('/about'),
                ),
                _buildListTile(
                  icon: Icons.star_rate_outlined,
                  title: 'Rate the App',
                  onTap: () {
                    // Placeholder for store link
                    launchUrl(Uri.parse('https://example.com/store'));
                  },
                ),
                _buildListTile(
                  icon: Icons.share_outlined,
                  title: 'Share App',
                  onTap: () {
                    Share.share('Check out StreamPro - The premium free video streaming app!');
                  },
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFC026D3),
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      leading: Icon(icon, color: const Color(0xFF9CA3AF)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(color: Color(0xFF6B7280), fontFamily: 'Poppins', fontSize: 12)) : null,
      trailing: trailing ?? const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
      onTap: onTap,
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      secondary: Icon(icon, color: const Color(0xFF9CA3AF)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
      value: value,
      onChanged: onChanged,
      activeThumbColor: const Color(0xFFC026D3),
      inactiveThumbColor: const Color(0xFF6B7280),
      inactiveTrackColor: const Color(0xFF242424),
    );
  }

  void _showConfirmDialog(BuildContext context, String title, String content, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: Text(content, style: const TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              onConfirm();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('$title completed', style: const TextStyle(fontFamily: 'Poppins')),
                backgroundColor: const Color(0xFF10B981),
              ));
            },
            child: const Text('Confirm', style: TextStyle(color: Color(0xFFEF4444), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
