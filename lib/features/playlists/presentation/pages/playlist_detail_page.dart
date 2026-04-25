import 'package:flutter/material.dart';

class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;
  const PlaylistDetailPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playlist Detail')),
      body: Center(child: Text('Playlist $playlistId Placeholder')),
    );
  }
}
