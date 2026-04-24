import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/presentation/blocs/video_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                context.read<VideoListBloc>().add(SearchVideosEvent(value));
              } else {
                context.read<VideoListBloc>().add(LoadVideosEvent());
              }
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<VideoListBloc, VideoListState>(
            builder: (context, state) {
              if (state is VideoListLoaded) {
                if (state.videos.isEmpty) {
                  return const Center(child: Text('No videos found.'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.videos.length,
                  itemBuilder: (context, index) {
                    return PremiumVideoCard(
                      video: state.videos[index],
                      width: double.infinity,
                      height: double.infinity,
                    );
                  },
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
