import 'package:flutter/material.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/discover/data/repositories/video_repository.dart';

class CategoryFeedPage extends StatefulWidget {
  final String categoryName;

  const CategoryFeedPage({super.key, required this.categoryName});

  @override
  State<CategoryFeedPage> createState() => _CategoryFeedPageState();
}

class _CategoryFeedPageState extends State<CategoryFeedPage> {
  List<VideoEntity> _videos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadVideos();
  }

  Future<void> _loadVideos() async {
    final repo = getIt<VideoRepository>();
    final videos = repo.getVideosByCategory(widget.categoryName);
    if (mounted) {
      setState(() {
        _videos = videos;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _videos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: PremiumVideoCard(video: _videos[index]),
              );
            },
          ),
    );
  }
}
