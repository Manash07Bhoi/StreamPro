import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/data/repositories/video_repository.dart';

class LibraryView extends StatefulWidget {
  const LibraryView({super.key});

  @override
  State<LibraryView> createState() => _LibraryViewState();
}

class _LibraryViewState extends State<LibraryView> {
  final _repository = getIt<VideoRepository>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Watch History'),
              Tab(text: 'Bookmarks'),
            ],
            indicatorColor: Color(0xFFC026D3),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildList(_repository.getHistory()),
                _buildList(_repository.getBookmarks()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(Future<List<VideoEntity>> future) {
    return FutureBuilder<List<VideoEntity>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Failed to load.'));
        }
        final videos = snapshot.data ?? [];
        if (videos.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.video_library_outlined,
                    size: 80, color: Colors.white24),
                SizedBox(height: 16),
                Text(
                  'No videos found here yet.',
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
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
