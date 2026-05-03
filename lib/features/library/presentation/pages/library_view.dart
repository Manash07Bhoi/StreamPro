import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/data/repositories/video_repository.dart';
import '../../data/repositories/history_repository.dart';
import '../../data/repositories/bookmark_repository.dart';
import '../blocs/playlist_bloc.dart';
import '../blocs/download_bloc.dart';
import '../blocs/like_bloc.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<PlaylistBloc>()..add(LoadPlaylists())),
        BlocProvider(create: (_) => sl<DownloadBloc>()..add(LoadDownloads())),
        BlocProvider(create: (_) => sl<LikeBloc>()..add(LoadAllLikes())),
      ],
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: 'History'),
              Tab(text: 'Bookmarks'),
              Tab(text: 'Downloads'),
              Tab(text: 'Playlists'),
              Tab(text: 'Liked'),
            ],
            indicatorColor: AppColors.colorPrimary,
            labelColor: AppColors.colorPrimary,
            unselectedLabelColor: AppColors.colorTextSecondary,
            labelStyle: const TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontFamily: 'Poppins'),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _HistoryTab(),
                _BookmarksTab(),
                _DownloadsTab(),
                _PlaylistsTab(),
                _LikedTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryTab extends StatefulWidget {
  @override
  State<_HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<_HistoryTab> {
  final _historyRepo = sl<HistoryRepository>();
  final _videoRepo = sl<VideoRepository>();
  final PagingController<int, VideoEntity> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final historyRecords = _historyRepo.getHistory();
      final allVideos = _videoRepo.getVideos();
      final videoMap = {for (var v in allVideos) v.id: v};

      final List<VideoEntity> historyVideos = historyRecords.map((r) => videoMap[r.videoId]).whereType<VideoEntity>().toList();

      const pageSize = 10;
      final start = pageKey * pageSize;

      if (start >= historyVideos.length) {
        _pagingController.appendLastPage([]);
        return;
      }

      final end = (start + pageSize > historyVideos.length) ? historyVideos.length : start + pageSize;
      final newItems = historyVideos.sublist(start, end);

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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  // Trigger clear logic here
                  _historyRepo.clearAllHistory();
                  _pagingController.refresh();
                },
                child: const Text('Clear All History', style: TextStyle(color: AppColors.colorPrimary, fontFamily: 'Poppins')),
              ),
            ],
          ),
        ),
        Expanded(
          child: PagedListView<int, VideoEntity>(
            pagingController: _pagingController,
            padding: const EdgeInsets.all(16),
            builderDelegate: PagedChildBuilderDelegate<VideoEntity>(
              itemBuilder: (context, item, index) {
                final record = _historyRepo.getHistoryEntry(item.id);
                return Slidable(
                  key: Key(item.id),
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          await _historyRepo.removeFromHistory(item.id);
                          _pagingController.refresh();
                        },
                        backgroundColor: AppColors.colorError,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 120,
                        height: 68,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: item.thumbnailUrl,
                              fit: BoxFit.cover,
                            ),
                            if (record != null && record.progressPercent > 0)
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: LinearProgressIndicator(
                                  value: record.progressPercent,
                                  backgroundColor: Colors.black54,
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
                                  minHeight: 3,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    title: Text(item.title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    subtitle: Text(record != null ? 'Watched ${DateTime.now().difference(DateTime.parse(record.watchedAt)).inDays}d ago' : '', style: const TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins', fontSize: 12)),
                    onTap: () => context.push('/player', extra: item),
                  ),
                );
              },
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.history, size: 80, color: AppColors.colorSurface3),
                    SizedBox(height: 16),
                    Text('Nothing Here Yet', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Videos you watch will appear in your history.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BookmarksTab extends StatefulWidget {
  @override
  State<_BookmarksTab> createState() => _BookmarksTabState();
}

class _BookmarksTabState extends State<_BookmarksTab> {
  final _bookmarkRepo = sl<BookmarkRepository>();
  final _videoRepo = sl<VideoRepository>();

  @override
  Widget build(BuildContext context) {
    // Basic FutureBuilder for MVP, fully enhanced would use BLoC
    return FutureBuilder<List<VideoEntity>>(
      future: Future.sync(() {
        final entries = _bookmarkRepo.getBookmarks();
        final videos = _videoRepo.getVideos();
        final videoMap = {for (var v in videos) v.id: v};
        return entries.map((e) => videoMap[e.videoId]).whereType<VideoEntity>().toList();
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
        }
        final videos = snapshot.data ?? [];
        if (videos.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bookmark_border, size: 80, color: AppColors.colorSurface3),
                SizedBox(height: 16),
                Text('No Bookmarks Yet', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                SizedBox(height: 8),
                Text('Tap the bookmark icon on any video to save it.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
              ],
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.5,
          ),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            return PremiumVideoCard(
              video: videos[index],
              width: double.infinity,
              height: 200,
            );
          },
        );
      },
    );
  }
}

class _DownloadsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DownloadBloc, DownloadState>(
      builder: (context, state) {
        if (state is DownloadLoaded) {
          if (state.downloads.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.download_for_offline, size: 80, color: AppColors.colorSurface3),
                  SizedBox(height: 16),
                  Text('No Downloads', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Download videos to watch them offline.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.downloads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final record = state.downloads[index];
              return ListTile(
                tileColor: AppColors.colorSurface2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                leading: const Icon(Icons.video_file, color: AppColors.colorPrimary, size: 40),
                title: Text('Video ${record.videoId}', style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                subtitle: Text('${record.status.toUpperCase()} • ${record.quality}', style: const TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins', fontSize: 12)),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
      },
    );
  }
}

class _PlaylistsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlaylistBloc, PlaylistState>(
      builder: (context, state) {
        if (state is PlaylistLoaded || state is PlaylistActionSuccess) {
          final playlists = (state is PlaylistLoaded) ? state.playlists : (state as PlaylistActionSuccess).playlists;
          if (playlists.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.featured_play_list_outlined, size: 80, color: AppColors.colorSurface3),
                  SizedBox(height: 16),
                  Text('No Playlists', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Create a playlist to organize your favorites.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlists[index];
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.colorSurface2,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.playlist_play, size: 48, color: AppColors.colorPrimary),
                    const SizedBox(height: 8),
                    Text(playlist.name, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
                    Text('${playlist.videoCount} videos', style: const TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins', fontSize: 12)),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
      },
    );
  }
}

class _LikedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LikeBloc, LikeState>(
      builder: (context, state) {
        if (state is LikeLoaded) {
          final likedIds = state.reactions.entries.where((e) => e.value == 'like').map((e) => e.key).toList();
          if (likedIds.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 80, color: AppColors.colorSurface3),
                  SizedBox(height: 16),
                  Text('No Liked Videos', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                  SizedBox(height: 8),
                  Text('Double-tap a video or tap the heart to like it.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                ],
              ),
            );
          }
          final videoRepo = sl<VideoRepository>();
          final allVideos = videoRepo.getVideos();
          final videos = allVideos.where((v) => likedIds.contains(v.id)).toList();

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return PremiumVideoCard(
                video: videos[index],
                width: double.infinity,
                height: 200,
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
      },
    );
  }
}
