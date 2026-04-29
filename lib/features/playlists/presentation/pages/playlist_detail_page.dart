import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/di/injection.dart';
import '../../../library/presentation/blocs/playlist_bloc.dart';
import '../../../../core/models/playlist.dart';
import '../../../../core/models/playlist_item.dart';
import '../../../library/data/repositories/playlist_repository.dart';
import '../../../discover/data/repositories/video_repository.dart';

class PlaylistDetailPage extends StatelessWidget {
  final String playlistId;

  const PlaylistDetailPage({super.key, required this.playlistId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<PlaylistBloc>(),
      child: _PlaylistDetailContent(playlistId: playlistId),
    );
  }
}

class _PlaylistDetailContent extends StatefulWidget {
  final String playlistId;
  const _PlaylistDetailContent({required this.playlistId});

  @override
  State<_PlaylistDetailContent> createState() => _PlaylistDetailContentState();
}

class _PlaylistDetailContentState extends State<_PlaylistDetailContent> {
  Playlist? playlist;
  List<PlaylistItem> items = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    final repo = sl<PlaylistRepository>();
    setState(() {
      playlist = repo.getPlaylist(widget.playlistId);
      items = repo.getPlaylistItems(widget.playlistId);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (playlist == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(backgroundColor: const Color(0xFF0A0A0A)),
        body: const Center(child: Text('Playlist not found', style: TextStyle(color: Colors.white))),
      );
    }

    return BlocListener<PlaylistBloc, PlaylistState>(
      listener: (context, state) {
        if (state is PlaylistLoaded || state is PlaylistActionSuccess) {
          _loadData();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0A0A0A),
          title: Text(playlist!.name, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16)),
          actions: [
            IconButton(icon: const Icon(Icons.edit), onPressed: () {}), // Edit playlist not implemented
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'delete') {
                  context.read<PlaylistBloc>().add(DeletePlaylist(playlist!.id));
                  context.pop();
                }
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'rename', child: Text('Rename')),
                const PopupMenuItem(value: 'share', child: Text('Share')),
                const PopupMenuItem(value: 'delete', child: Text('Delete Playlist', style: TextStyle(color: Colors.red))),
              ],
            ),
          ],
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeader(),
            ),
            SliverFillRemaining(
              child: items.isEmpty
                  ? const Center(child: Text('No videos in this playlist', style: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins')))
                  : ReorderableListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: items.length,
                      onReorder: (oldIndex, newIndex) {
                        context.read<PlaylistBloc>().add(ReorderPlaylistItems(playlist!.id, oldIndex, newIndex));
                      },
                      itemBuilder: (context, index) {
                        return _buildPlaylistItem(context, items[index], index);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: playlist!.coverVideoId.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: 'https://picsum.photos/seed/${playlist!.coverVideoId}/640/360',
                      fit: BoxFit.cover,
                    )
                  : Container(color: const Color(0xFF242424)),
            ),
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [const Color(0xFF0A0A0A), Colors.transparent],
                  stops: const [0.0, 0.8],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    playlist!.name,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  if (playlist!.description != null && playlist!.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      playlist!.description!,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF)),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text('${playlist!.videoCount} videos', style: const TextStyle(fontFamily: 'Poppins', color: Color(0xFF6B7280))),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [Color(0xFFC026D3), Color(0xFFDB2777)]),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.play_arrow, color: Colors.white),
                            label: const Text('Play All', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A1A1A),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: const Color(0xFFC026D3)),
                          ),
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.shuffle, color: Colors.white),
                            label: const Text('Shuffle', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPlaylistItem(BuildContext context, PlaylistItem item, int index) {
    // In real app, fetch video details using VideoRepository
    final videoRepo = sl<VideoRepository>();
    final videos = videoRepo.getVideos();
    final video = videos.firstWhere((v) => v.id == item.videoId, orElse: () => videos.first);

    return Slidable(
      key: Key(item.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<PlaylistBloc>().add(RemoveVideoFromPlaylist(playlist!.id, item.videoId));
            },
            backgroundColor: const Color(0xFFEF4444),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Remove',
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 100,
            height: 60,
            child: CachedNetworkImage(
              imageUrl: 'https://picsum.photos/seed/${item.videoId}/640/360',
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(video.title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(video.duration, style: const TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontSize: 12)),
        trailing: const ReorderableDragStartListener(
          index: 0, // Ignored by builder but required by widget
          child: Icon(Icons.drag_handle, color: Color(0xFF6B7280)),
        ),
        onTap: () {
          context.push('/player', extra: video);
        },
      ),
    );
  }
}
