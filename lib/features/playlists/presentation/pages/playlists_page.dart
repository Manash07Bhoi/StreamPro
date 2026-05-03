import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../../../library/presentation/blocs/playlist_bloc.dart';
import '../../../../core/models/playlist.dart';

class PlaylistsPage extends StatelessWidget {
  const PlaylistsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<PlaylistBloc>()..add(LoadPlaylists()),
      child: const _PlaylistsPageContent(),
    );
  }
}

class _PlaylistsPageContent extends StatelessWidget {
  const _PlaylistsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('My Playlists', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreatePlaylistSheet(context),
          ),
        ],
      ),
      body: BlocBuilder<PlaylistBloc, PlaylistState>(
        builder: (context, state) {
          if (state is PlaylistLoading || state is PlaylistInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
          } else if (state is PlaylistLoaded || state is PlaylistActionSuccess) {
            final playlists = (state is PlaylistLoaded) ? state.playlists : (state as PlaylistActionSuccess).playlists;

            if (playlists.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.featured_play_list_outlined, size: 80, color: AppColors.colorSurface3),
                    const SizedBox(height: 16),
                    const Text('No Playlists', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                    const SizedBox(height: 8),
                    const Text('Create a playlist to organize your favorites.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => _showCreatePlaylistSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.colorSurface2,
                        side: const BorderSide(color: AppColors.colorPrimary),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: const Text('Create Playlist', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemCount: playlists.length,
              itemBuilder: (context, index) {
                return _buildPlaylistCard(context, playlists[index]);
              },
            );
          } else if (state is PlaylistError) {
             return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlaylistCard(BuildContext context, Playlist playlist) {
    Color accentColor = _parseColor(playlist.color);

    return GestureDetector(
      onTap: () => context.push('/playlists/${playlist.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: accentColor, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    playlist.coverVideoId.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: 'https://picsum.photos/seed/${playlist.coverVideoId}/640/360',
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const ColoredBox(color: AppColors.colorSurface3),
                            errorWidget: (context, url, error) => const ColoredBox(color: AppColors.colorSurface3),
                          )
                        : Container(
                            color: AppColors.colorSurface3,
                            child: const Center(child: Icon(Icons.music_video, color: AppColors.colorTextMuted, size: 40)),
                          ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black.withValues(alpha:0.8), Colors.transparent],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.videoCount} videos',
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreatePlaylistSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.colorSurface2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(bottomSheetContext).viewInsets.bottom),
        child: BlocProvider.value(
          value: BlocProvider.of<PlaylistBloc>(context),
          child: const _CreatePlaylistSheet(),
        ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse(hexColor, radix: 16));
  }
}

class _CreatePlaylistSheet extends StatefulWidget {
  const _CreatePlaylistSheet();

  @override
  State<_CreatePlaylistSheet> createState() => _CreatePlaylistSheetState();
}

class _CreatePlaylistSheetState extends State<_CreatePlaylistSheet> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  String _selectedColor = '#C026D3';

  final List<String> _colors = [
    '#C026D3', '#DB2777', '#3B82F6', '#10B981', '#F59E0B', '#EF4444'
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('New Playlist', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ],
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
            maxLength: 50,
            decoration: InputDecoration(
              labelText: 'Playlist Name',
              labelStyle: const TextStyle(color: AppColors.colorTextSecondary),
              filled: true,
              fillColor: AppColors.colorSurface3,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.colorPrimary)),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descController,
            style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
            maxLength: 200,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Description (Optional)',
              labelStyle: const TextStyle(color: AppColors.colorTextSecondary),
              filled: true,
              fillColor: AppColors.colorSurface3,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.colorPrimary)),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Accent Color', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _colors.map((hex) {
              Color c = Color(int.parse(hex.replaceFirst('#', 'FF'), radix: 16));
              bool isSelected = _selectedColor == hex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = hex;
                  });
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
                  ),
                  child: isSelected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (_nameController.text.trim().isEmpty) return;
                context.read<PlaylistBloc>().add(CreatePlaylist(
                  name: _nameController.text.trim(),
                  description: _descController.text.trim(),
                  color: _selectedColor,
                ));
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Text('Create', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
