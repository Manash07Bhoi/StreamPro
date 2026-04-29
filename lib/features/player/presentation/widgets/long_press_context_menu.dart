import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/di/injection.dart';
import '../../../library/data/repositories/bookmark_repository.dart';
import '../../../library/data/repositories/like_repository.dart';
import 'add_to_playlist_sheet.dart';

class LongPressContextMenu extends StatefulWidget {
  final VideoEntity video;

  const LongPressContextMenu({super.key, required this.video});

  static void show(BuildContext context, VideoEntity video) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => LongPressContextMenu(video: video),
    );
  }

  @override
  State<LongPressContextMenu> createState() => _LongPressContextMenuState();
}

class _LongPressContextMenuState extends State<LongPressContextMenu> {
  bool _isBookmarked = false;
  String _reaction = 'none';
  bool _isDownloaded = false; // Mock state

  @override
  void initState() {
    super.initState();
    _loadState();
  }

  void _loadState() {
    setState(() {
      _isBookmarked = sl<BookmarkRepository>().isBookmarked(widget.video.id);
      _reaction = sl<LikeRepository>().getReaction(widget.video.id);
      // Mocking download check
      _isDownloaded = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: widget.video.thumbnailUrl,
                    width: 60,
                    height: 40,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.video.title,
                        style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
                        child: Text(widget.video.duration, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 10)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF242424)),

          // Menu Items
          _buildMenuItem(
            icon: Icons.play_arrow,
            title: 'Watch Now',
            onTap: () {
              context.pop();
              context.push('/player', extra: widget.video);
            },
          ),
          _buildMenuItem(
            icon: Icons.playlist_add,
            title: 'Add to Playlist',
            onTap: () {
              context.pop();
              AddToPlaylistSheet.show(context, widget.video);
            },
          ),
          _buildMenuItem(
            icon: _isDownloaded ? Icons.download_done : Icons.download,
            title: _isDownloaded ? 'Downloaded' : 'Download',
            onTap: () {
              // Initiate download logic
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Download started')));
              context.pop();
            },
          ),
          _buildMenuItem(
            icon: _reaction == 'like' ? Icons.favorite : Icons.favorite_border,
            title: _reaction == 'like' ? 'Unlike' : 'Like',
            iconColor: _reaction == 'like' ? const Color(0xFFC026D3) : Colors.white,
            onTap: () async {
              final repo = sl<LikeRepository>();
              await repo.setReaction(widget.video.id, _reaction == 'like' ? 'none' : 'like');
              setState(() => _reaction = _reaction == 'like' ? 'none' : 'like');
            },
          ),
          _buildMenuItem(
            icon: _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            title: _isBookmarked ? 'Remove Bookmark' : 'Bookmark',
            iconColor: _isBookmarked ? const Color(0xFFC026D3) : Colors.white,
            onTap: () async {
              final repo = sl<BookmarkRepository>();
              if (_isBookmarked) {
                await repo.removeBookmark(widget.video.id);
              } else {
                await repo.addBookmark(widget.video.id);
              }
              setState(() => _isBookmarked = !_isBookmarked);
            },
          ),
          _buildMenuItem(
            icon: Icons.share,
            title: 'Share',
            onTap: () {
              Share.share('Check out ${widget.video.title} on StreamPro!');
              context.pop();
            },
          ),
          _buildMenuItem(
            icon: Icons.not_interested,
            title: 'Not Interested',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Video removed from feed')));
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({required IconData icon, required String title, required VoidCallback onTap, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.white),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14)),
      onTap: onTap,
    );
  }
}
