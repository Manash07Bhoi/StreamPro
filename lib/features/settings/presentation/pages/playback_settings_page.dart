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
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Playback Settings', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          final config = sl<SettingsBloc>().state is SettingsLoaded
              ? (sl<SettingsBloc>().state as SettingsLoaded).config
              : (sl<SettingsBloc>().state is SettingsActionSuccess ? (sl<SettingsBloc>().state as SettingsActionSuccess).config : null);

          if (config == null) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
          }

          return ListView(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Default Video Quality', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                trailing: DropdownButton<String>(
                  value: config.videoQuality,
                  dropdownColor: const Color(0xFF1A1A1A),
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF9CA3AF)),
                  style: const TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins'),
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
                subtitle: const Text('Play videos automatically when opened', style: TextStyle(color: Color(0xFF6B7280), fontFamily: 'Poppins', fontSize: 12)),
                value: config.autoPlayEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleAutoPlay()),
                activeThumbColor: const Color(0xFFC026D3),
                inactiveThumbColor: const Color(0xFF6B7280),
                inactiveTrackColor: const Color(0xFF242424),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Auto-Play Next Video', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.autoPlayNextEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleAutoPlayNext()),
                activeThumbColor: const Color(0xFFC026D3),
                inactiveThumbColor: const Color(0xFF6B7280),
                inactiveTrackColor: const Color(0xFF242424),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Loop Video', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.loopVideoEnabled,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleLoopVideo()),
                activeThumbColor: const Color(0xFFC026D3),
                inactiveThumbColor: const Color(0xFF6B7280),
                inactiveTrackColor: const Color(0xFF242424),
              ),
              SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                title: const Text('Show Subtitles', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 16)),
                value: config.showSubtitles,
                onChanged: (val) => context.read<SettingsBloc>().add(ToggleSubtitles()),
                activeThumbColor: const Color(0xFFC026D3),
                inactiveThumbColor: const Color(0xFF6B7280),
                inactiveTrackColor: const Color(0xFF242424),
              ),
            ],
          );
        },
      ),
    );
  }
}
