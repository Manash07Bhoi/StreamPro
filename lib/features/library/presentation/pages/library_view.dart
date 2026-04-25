import 'package:flutter/material.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/discover/data/repositories/video_repository.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<VideoEntity> _history = [];
  List<VideoEntity> _bookmarks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final repo = getIt<VideoRepository>();
    final history = repo.getHistory();
    final bookmarks = repo.getBookmarks();
    if (mounted) {
      setState(() {
        _history = history;
        _bookmarks = bookmarks;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'History'),
            Tab(text: 'Bookmarks'),
            Tab(text: 'Downloads'),
            Tab(text: 'Playlists'),
            Tab(text: 'Liked'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildList(_history, 'No watch history yet.'),
              _buildList(_bookmarks, 'No bookmarks yet.'),
              const Center(child: Text('No downloads yet.')),
              const Center(child: Text('No playlists yet.')),
              const Center(child: Text('No liked videos yet.')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList(List<VideoEntity> videos, String emptyMessage) {
    if (videos.isEmpty) {
      return Center(child: Text(emptyMessage));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: PremiumVideoCard(video: videos[index]),
        );
      },
    );
  }
}
