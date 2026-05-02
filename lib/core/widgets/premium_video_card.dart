import '../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../models/video_entity.dart';
import '../../core/di/injection.dart';
import '../../features/library/data/repositories/bookmark_repository.dart';
import '../../features/library/data/repositories/history_repository.dart';

class PremiumVideoCard extends StatefulWidget {
  final VideoEntity video;
  final double width;
  final double height;
  final bool showProgress;
  final bool forceNewBadge;

  const PremiumVideoCard({
    super.key,
    required this.video,
    this.width = 280,
    this.height = 160,
    this.showProgress = false,
    this.forceNewBadge = false,
  });

  @override
  State<PremiumVideoCard> createState() => _PremiumVideoCardState();
}

class _PremiumVideoCardState extends State<PremiumVideoCard> with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  bool _isBookmarked = false;
  double _progressPercent = 0.0;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeOut),
    );

    _loadData();
  }

  Future<void> _loadData() async {
    final bookmarkRepo = sl<BookmarkRepository>();
    final historyRepo = sl<HistoryRepository>();

    final isBookmarked = bookmarkRepo.isBookmarked(widget.video.id);
    final historyEntry = historyRepo.getHistoryEntry(widget.video.id);

    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
        if (historyEntry != null) {
          _progressPercent = historyEntry.progressPercent;
          _isCompleted = historyEntry.isCompleted;
        }
      });
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _scaleController.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _scaleController.reverse();
    HapticFeedback.selectionClick();
    context.push('/player', extra: widget.video);
  }

  void _onTapCancel() {
    _scaleController.reverse();
  }

  void _onDoubleTap() {
    HapticFeedback.mediumImpact();
    // Quick Like
    // In a real app we would call LikeBloc, but since we haven't implemented it fully, we'll just show animation
    // sl<LikeBloc>().add(SetReaction(widget.video.id, 'like'));
    _showFloatingHeart();
  }

  void _onLongPress() {
    HapticFeedback.heavyImpact();
    // Show context menu (placeholder for now, will implement in Sprint 4)
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Long press context menu for ${widget.video.title}')));
  }

  void _showFloatingHeart() {
    // Basic double tap heart animation overlay
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy,
        width: size.width,
        height: size.height,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.5, end: 1.2),
          duration: const Duration(milliseconds: 350),
          curve: Curves.elasticOut,
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Opacity(
                opacity: scale > 1.0 ? 1.0 - (scale - 1.0) * 5 : 1.0,
                child: const Icon(Icons.favorite, color: Colors.white, size: 64),
              ),
            );
          },
          onEnd: () => entry.remove(),
        ),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final showNew = widget.forceNewBadge || widget.video.isNew;
    final showHD = widget.video.isHD;
    final rating = widget.video.contentRating;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onDoubleTap: _onDoubleTap,
      onLongPress: _onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: RepaintBoundary(
          child: Container(
            width: widget.width,
            height: widget.height,
            margin: const EdgeInsets.only(right: 16, bottom: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha:0.5),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Thumbnail
                  Hero(
                    tag: 'video_thumb_${widget.video.id}',
                    child: CachedNetworkImage(
                      imageUrl: widget.video.thumbnailUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 320,
                      memCacheHeight: 180,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: AppColors.colorSurface2,
                        highlightColor: AppColors.colorSurface3,
                        child: Container(color: Colors.black),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),

                  // Completed Overlay
                  if (_isCompleted)
                    Container(
                      color: Colors.black.withValues(alpha:0.6),
                      child: const Center(
                        child: Icon(Icons.check_circle, color: Colors.white, size: 48),
                      ),
                    ),

                  // Glassmorphic Gradient Overlay at bottom
                  if (!_isCompleted)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      height: widget.height * 0.6,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha:0.9),
                            ],
                          ),
                        ),
                      ),
                    ),

                  // Badges Top Left
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Row(
                      children: [
                        if (showNew)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('NEW', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        if (widget.video.requiresAgeVerification)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.colorSurface2,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.colorError),
                            ),
                            child: Text(rating, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white)),
                          ),
                      ],
                    ),
                  ),

                  // Badges Top Right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Row(
                      children: [
                        if (showHD)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.colorSurface2,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: AppColors.colorWarning),
                            ),
                            child: const Text('HD', style: TextStyle(fontFamily: 'Poppins', fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.colorWarning)),
                          ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha:0.6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(widget.video.duration, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  // Title, Category, and Bottom Actions
                  if (!_isCompleted)
                    Positioned(
                      bottom: widget.showProgress && _progressPercent > 0.0 ? 8 : 12,
                      left: 12,
                      right: 12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.video.channelName,
                                  style: const TextStyle(fontFamily: 'Poppins', color: AppColors.colorTextSecondary, fontSize: 10),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  widget.video.title,
                                  style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '${_formatViewCount(widget.video.viewCount)} • ${widget.video.category}',
                                  style: const TextStyle(fontFamily: 'Poppins', color: AppColors.colorTextMuted, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          // Bookmark and Like indicators
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  final repo = sl<BookmarkRepository>();
                                  if (_isBookmarked) {
                                    await repo.removeBookmark(widget.video.id);
                                  } else {
                                    await repo.addBookmark(widget.video.id);
                                  }
                                  setState(() {
                                    _isBookmarked = !_isBookmarked;
                                  });
                                  HapticFeedback.selectionClick();
                                },
                                child: Icon(
                                  _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                                  color: _isBookmarked ? AppColors.colorPrimary : Colors.white,
                                  size: 20,
                                ),
                              ),
                              // Like icon would go here (e.g. if we fetched like status)
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Progress Bar overlay
                  if (widget.showProgress && _progressPercent > 0.0 && !_isCompleted)
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return Stack(
                            children: [
                              Container(height: 3, color: AppColors.colorSurface3),
                              Container(
                                height: 3,
                                width: constraints.maxWidth * _progressPercent,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]),
                                ),
                              ),
                            ],
                          );
                        }
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M views';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K views';
    return '$count views';
  }
}
