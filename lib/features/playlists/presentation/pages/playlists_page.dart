import 'package:flutter/material.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Playlists')),
      body: const Center(child: Text('Playlists Placeholder')),
    );
  }
}
