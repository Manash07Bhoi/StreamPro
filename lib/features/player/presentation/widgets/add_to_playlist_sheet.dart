import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../library/presentation/blocs/playlist_bloc.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final VideoEntity video;

  const AddToPlaylistSheet({super.key, required this.video});

  static void show(BuildContext context, VideoEntity video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => BlocProvider.value(
        value: sl<PlaylistBloc>()..add(LoadPlaylists()),
        child: AddToPlaylistSheet(video: video),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF242424),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add to Playlist',
                    style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF9CA3AF)),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF242424), height: 1),

            // Playlists
            Expanded(
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  if (state is PlaylistLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
                  } else if (state is PlaylistLoaded || state is PlaylistActionSuccess) {
                    final playlists = state is PlaylistLoaded ? state.playlists : (state as PlaylistActionSuccess).playlists;

                    if (playlists.isEmpty) {
                      return const Center(
                        child: Text('No playlists found.', style: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        // Placeholder check. Real implementation needs repo method to check if video exists in playlist
                        final isAdded = false;

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: playlist.coverVideoId.isNotEmpty
                                  ? CachedNetworkImage(imageUrl: 'https://picsum.photos/seed/${playlist.coverVideoId}/640/360', fit: BoxFit.cover)
                                  : Container(color: const Color(0xFF242424), child: const Icon(Icons.playlist_play, color: Colors.white54)),
                            ),
                          ),
                          title: Text(playlist.name, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                          subtitle: Text('${playlist.videoCount} videos', style: const TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontSize: 12)),
                          trailing: isAdded ? const Icon(Icons.check, color: Color(0xFFC026D3)) : null,
                          onTap: () {
                            context.read<PlaylistBloc>().add(AddVideoToPlaylist(playlist.id, video.id));
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added to ${playlist.name}')));
                          },
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),

            // Footer
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () {
                     context.pop();
                     context.push('/playlists'); // Then user can create
                  },
                  icon: const Icon(Icons.add, color: Color(0xFFC026D3)),
                  label: const Text('Create New Playlist', style: TextStyle(color: Color(0xFFC026D3), fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
