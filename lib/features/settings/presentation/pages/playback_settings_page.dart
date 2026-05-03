import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../blocs/settings_bloc.dart';
import 'package:go_router/go_router.dart';

class PlaybackSettingsPage extends StatelessWidget {
  const PlaybackSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('Playback Settings', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final config = sl<SettingsBloc>().state is SettingsLoaded
              ? (sl<SettingsBloc>().state as SettingsLoaded).config
              : (sl<SettingsBloc>().state is SettingsActionSuccess ? (sl<SettingsBloc>().state as SettingsActionSuccess).config : null);

          if (config == null) {
            return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Default Video Quality', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                trailing: DropdownButton<String>(
                  value: config.videoQuality,
                  dropdownColor: AppColors.colorSurface2,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.colorTextSecondary),
                  style: const TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins'),
                  items: ['auto', '1080p', '720p', '480p', '360p']
                      .map((q) => DropdownMenuItem(
                            value: q,
                            child: Text(q == 'auto' ? 'Auto' : q),
                          ))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) {
                      context.read<SettingsBloc>().add(UpdateVideoQuality(val));
                    }
                  },
                ),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Auto-Play Videos', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                subtitle: const Text('Play videos automatically when opened', style: TextStyle(color: AppColors.colorTextMuted, fontFamily: 'Poppins', fontSize: 12)),
                value: config.autoPlayEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleAutoPlay()),
                activeThumbColor: AppColors.colorPrimary,
                inactiveThumbColor: AppColors.colorTextMuted,
                inactiveTrackColor: AppColors.colorSurface3,
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Auto-Play Next Video', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.autoPlayNextEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleAutoPlayNext()),
                activeThumbColor: AppColors.colorPrimary,
                inactiveThumbColor: AppColors.colorTextMuted,
                inactiveTrackColor: AppColors.colorSurface3,
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Loop Video', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.loopVideoEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleLoopVideo()),
                activeThumbColor: AppColors.colorPrimary,
                inactiveThumbColor: AppColors.colorTextMuted,
                inactiveTrackColor: AppColors.colorSurface3,
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Show Subtitles', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.showSubtitles,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleSubtitles()),
                activeThumbColor: AppColors.colorPrimary,
                inactiveThumbColor: AppColors.colorTextMuted,
                inactiveTrackColor: AppColors.colorSurface3,
              ),
            ],
          );
        },
      ),
    );
  }
}
