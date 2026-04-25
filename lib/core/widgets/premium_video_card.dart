import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../models/video_entity.dart';
import '../routes/app_router.dart';
import '../di/injection.dart';
import '../../features/discover/data/repositories/video_repository.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class PremiumVideoCard extends StatefulWidget {
  final VideoEntity video;

  const PremiumVideoCard({super.key, required this.video});

  @override
  State<PremiumVideoCard> createState() => _PremiumVideoCardState();
}

class _PremiumVideoCardState extends State<PremiumVideoCard> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  void _checkBookmark() {
    final repo = getIt<VideoRepository>();
    setState(() {
      _isBookmarked = repo.isBookmarked(widget.video.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Haptics.vibrate(HapticsType.selection);
        context.push(AppRoutes.player, extra: widget.video);
      },
      onLongPress: () {
        Haptics.vibrate(HapticsType.heavy);
        // Show Context Menu Placeholder
        showModalBottomSheet(
          context: context,
          builder: (_) => SafeArea(
            child: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                  ListTile(
                     leading: const Icon(Icons.play_arrow),
                     title: const Text('Watch Now'),
                     onTap: () {
                        Navigator.pop(context);
                        context.push(AppRoutes.player, extra: widget.video);
                     }
                  ),
                  ListTile(
                     leading: const Icon(Icons.playlist_add),
                     title: const Text('Add to Playlist'),
                     onTap: () => Navigator.pop(context),
                  )
               ]
            )
          )
        );
      },
      onDoubleTap: () {
        Haptics.vibrate(HapticsType.medium);
        // Like gesture
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 12,
              offset: Offset(0,4),
            )
          ]
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.video.thumbnailUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 320,
                    memCacheHeight: 180,
                  ),
                  if (widget.video.isNew)
                    Positioned(
                       top: 8, left: 8,
                       child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                             color: Theme.of(context).primaryColor,
                             borderRadius: BorderRadius.circular(12)
                          ),
                          child: const Text('NEW', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                       )
                    ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.8),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.video.duration,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                       height: 3,
                       color: Colors.transparent, // Placeholder for progress bar if history > 0
                    )
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(widget.video.channelAvatar),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${widget.video.channelName} • ${widget.video.viewCount ~/ 1000}K views',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                     padding: EdgeInsets.zero,
                     constraints: const BoxConstraints(),
                     icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border, size: 20),
                     onPressed: () async {
                        Haptics.vibrate(HapticsType.selection);
                        await getIt<VideoRepository>().toggleBookmark(widget.video.id);
                        _checkBookmark();
                     },
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
