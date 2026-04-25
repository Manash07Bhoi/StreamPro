import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/settings_bloc.dart';

class PlaybackSettingsPage extends StatelessWidget {
  const PlaybackSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playback Settings')),
      body: BlocBuilder<SettingsBloc, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoaded || state is SettingsActionSuccess) {
            final config = state is SettingsLoaded ? state.config : (state as SettingsActionSuccess).config;
            return ListView(
              children: [
                ListTile(
                  title: const Text('Default Video Quality'),
                  trailing: DropdownButton<String>(
                    value: config.videoQuality,
                    items: ['auto', '1080p', '720p', '480p', '360p']
                        .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) context.read<SettingsBloc>().add(UpdateVideoQuality(val));
                    },
                  ),
                ),
                SwitchListTile(
                  title: const Text('Auto-Play Videos'),
                  value: config.autoPlayEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleAutoPlay()),
                ),
                SwitchListTile(
                  title: const Text('Auto-Play Next Video'),
                  value: config.autoPlayNextEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleAutoPlayNext()),
                ),
                SwitchListTile(
                  title: const Text('Loop Video'),
                  value: config.loopVideoEnabled,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleLoopVideo()),
                ),
                SwitchListTile(
                  title: const Text('Show Subtitles'),
                  value: config.showSubtitles,
                  onChanged: (_) => context.read<SettingsBloc>().add(ToggleSubtitles()),
                ),
              ],
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
