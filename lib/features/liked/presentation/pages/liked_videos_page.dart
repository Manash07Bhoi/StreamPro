import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/data/repositories/video_repository.dart';
import '../../../library/data/repositories/like_repository.dart';

class LikedVideosPage extends StatefulWidget {
  const LikedVideosPage({super.key});

  @override
  State<LikedVideosPage> createState() => _LikedVideosPageState();
}

class _LikedVideosPageState extends State<LikedVideosPage> {
  final _videoRepo = sl<VideoRepository>();
  final _likeRepo = sl<LikeRepository>();
  final PagingController<int, VideoEntity> _pagingController = PagingController(firstPageKey: 0);
  int _totalLikes = 0;

  @override
  void initState() {
    super.initState();
    _totalLikes = _likeRepo.getLikeCount();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Small delay to simulate fetch
      await Future.delayed(const Duration(milliseconds: 300));

      final likedRecords = _likeRepo.getLikedVideos();
      final allVideos = _videoRepo.getVideos();
      final videoMap = {for (var v in allVideos) v.id: v};

      final List<VideoEntity> likedVideos = likedRecords.map((r) => videoMap[r.videoId]).whereType<VideoEntity>().toList();

      const pageSize = 10;
      final start = pageKey * pageSize;

      if (start >= likedVideos.length) {
        _pagingController.appendLastPage([]);
        return;
      }

      final end = (start + pageSize > likedVideos.length) ? likedVideos.length : start + pageSize;
      final newItems = likedVideos.sublist(start, end);

      final isLastPage = newItems.length < pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Liked Videos', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
            Text('$_totalLikes videos', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextSecondary)),
          ],
        ),
      ),
      body: _totalLikes == 0
          ? _buildEmptyState()
          : PagedMasonryGridView<int, VideoEntity>.count(
              pagingController: _pagingController,
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              padding: const EdgeInsets.all(12),
              builderDelegate: PagedChildBuilderDelegate<VideoEntity>(
                itemBuilder: (context, item, index) => PremiumVideoCard(video: item, width: double.infinity, height: 200),
                firstPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary)),
                newPageProgressIndicatorBuilder: (_) => const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary)),
                noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
              ),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 80, color: AppColors.colorSurface3),
          const SizedBox(height: 16),
          const Text('No Liked Videos', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Double-tap a video or tap the heart to like it.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
        ],
      ),
    );
  }
}
