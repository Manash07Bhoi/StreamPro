import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/presentation/blocs/video_list_bloc.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search premium videos...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              context.read<VideoListBloc>().add(SearchVideosEvent(value));
            },
          ),
        ),
        Expanded(
          child: PagedMasonryGridView<int, VideoEntity>.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            pagingController:
                context.read<VideoListBloc>().searchPagingController,
            builderDelegate: PagedChildBuilderDelegate<VideoEntity>(
              itemBuilder: (context, video, index) {
                // Staggered heights
                final double height = (index % 3 == 0) ? 220 : 160;
                return PremiumVideoCard(
                  video: video,
                  width: double.infinity,
                  height: height,
                );
              },
              firstPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator()),
              newPageProgressIndicatorBuilder: (_) =>
                  const Center(child: CircularProgressIndicator()),
              noItemsFoundIndicatorBuilder: (_) => const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: Colors.white24),
                    SizedBox(height: 16),
                    Text('No premium videos found.',
                        style: TextStyle(color: Colors.white54, fontSize: 18)),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
