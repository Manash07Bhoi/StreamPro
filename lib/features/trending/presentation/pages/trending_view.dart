import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../blocs/trending_bloc.dart';
import '../../../library/data/repositories/bookmark_repository.dart';
import 'package:flutter/services.dart';

class TrendingView extends StatelessWidget {
  const TrendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<TrendingBloc>()..add(LoadTrendingToday()),
      child: const _TrendingViewContent(),
    );
  }
}

class _TrendingViewContent extends StatefulWidget {
  const _TrendingViewContent();

  @override
  State<_TrendingViewContent> createState() => _TrendingViewContentState();
}

class _TrendingViewContentState extends State<_TrendingViewContent> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          context.read<TrendingBloc>().add(LoadTrendingToday());
        } else {
          context.read<TrendingBloc>().add(LoadTrendingThisWeek());
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
          ],
          indicatorColor: const Color(0xFFC026D3),
          labelColor: const Color(0xFFC026D3),
          unselectedLabelColor: const Color(0xFF9CA3AF),
          labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildTrendingList(true),
              _buildTrendingList(false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingList(bool isToday) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TrendingBloc>().add(RefreshTrending(isToday));
        await Future.delayed(const Duration(milliseconds: 800));
      },
      color: const Color(0xFFC026D3),
      backgroundColor: const Color(0xFF1A1A1A),
      child: BlocBuilder<TrendingBloc, TrendingState>(
        builder: (context, state) {
          if (state is TrendingLoading || state is TrendingInitial) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
          } else if (state is TrendingLoaded) {
            // Ensure we are rendering the state corresponding to the active tab if they got out of sync, though listener should handle it
            if (state.isToday != isToday) {
               return const Center(child: CircularProgressIndicator(color: Color(0xFFC026D3)));
            }

            final videos = state.videos;
            if (videos.isEmpty) {
               return const Center(child: Text('No trending videos found.', style: TextStyle(color: Colors.white)));
            }

            return ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 16),
              itemCount: videos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _TrendingRowItem(video: videos[index], rank: index + 1);
              },
            );
          } else if (state is TrendingError) {
             return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _TrendingRowItem extends StatefulWidget {
  final VideoEntity video;
  final int rank;

  const _TrendingRowItem({required this.video, required this.rank});

  @override
  State<_TrendingRowItem> createState() => _TrendingRowItemState();
}

class _TrendingRowItemState extends State<_TrendingRowItem> {
  bool _isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _checkBookmark();
  }

  Future<void> _checkBookmark() async {
    final repo = sl<BookmarkRepository>();
    final isBookmarked = repo.isBookmarked(widget.video.id);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
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
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/player', extra: widget.video),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            SizedBox(
              width: 48,
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFC026D3), Color(0xFFDB2777)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  widget.rank.toString(),
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 80,
                height: 52,
                child: CachedNetworkImage(
                  imageUrl: widget.video.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 160,
                  memCacheHeight: 104,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.video.title,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.remove_red_eye_outlined, size: 12, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        _formatViewCount(widget.video.viewCount),
                        style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF9CA3AF)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF242424),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.video.duration,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: _isBookmarked ? const Color(0xFFC026D3) : const Color(0xFF9CA3AF),
              ),
              onPressed: _toggleBookmark,
            ),
          ],
        ),
      ),
    );
  }

  String _formatViewCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K';
    return count.toString();
  }
}
