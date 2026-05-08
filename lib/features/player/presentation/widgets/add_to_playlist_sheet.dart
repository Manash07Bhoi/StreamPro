import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../library/presentation/blocs/playlist_bloc.dart';
import '../../../library/data/repositories/playlist_repository.dart';

class AddToPlaylistSheet extends StatelessWidget {
  final VideoEntity video;

  const AddToPlaylistSheet({super.key, required this.video});

  static void show(BuildContext context, VideoEntity video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.colorSurface2,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
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
                  color: AppColors.colorSurface3,
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
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close,
                        color: AppColors.colorTextSecondary),
                    onPressed: () => context.pop(),
                  ),
                ],
              ),
            ),
            const Divider(color: AppColors.colorSurface3, height: 1),

            // Playlists
            Expanded(
              child: BlocBuilder<PlaylistBloc, PlaylistState>(
                builder: (context, state) {
                  if (state is PlaylistLoading) {
                    return const Center(
                        child: CircularProgressIndicator(
                            color: AppColors.colorPrimary));
                  } else if (state is PlaylistLoaded ||
                      state is PlaylistActionSuccess) {
                    final playlists = state is PlaylistLoaded
                        ? state.playlists
                        : (state as PlaylistActionSuccess).playlists;

                    if (playlists.isEmpty) {
                      return const Center(
                        child: Text('No playlists found.',
                            style: TextStyle(
                                color: AppColors.colorTextSecondary,
                                fontFamily: 'Poppins')),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      itemCount: playlists.length,
                      itemBuilder: (context, index) {
                        final playlist = playlists[index];
                        final items = context.read<PlaylistRepository>().getPlaylistItems(playlist.id);
                        final isAdded = items.any((item) => item.videoId == video.id);

                        return ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: playlist.coverVideoId.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl:
                                          'https://picsum.photos/seed/${playlist.coverVideoId}/640/360',
                                      fit: BoxFit.cover)
                                  : Container(
                                      color: AppColors.colorSurface3,
                                      child: const Icon(Icons.playlist_play,
                                          color: Colors.white54)),
                            ),
                          ),
                          title: Text(playlist.name,
                              style: const TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins')),
                          subtitle: Text('${playlist.videoCount} videos',
                              style: const TextStyle(
                                  color: AppColors.colorTextSecondary,
                                  fontFamily: 'Poppins',
                                  fontSize: 12)),
                          trailing: isAdded
                              ? const Icon(Icons.check,
                                  color: AppColors.colorPrimary)
                              : null,
                          onTap: () {
                            context
                                .read<PlaylistBloc>()
                                .add(AddVideoToPlaylist(playlist.id, video.id));
                            context.pop();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Added to ${playlist.name}')));
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
                  icon: const Icon(Icons.add, color: AppColors.colorPrimary),
                  label: const Text('Create New Playlist',
                      style: TextStyle(
                          color: AppColors.colorPrimary,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
