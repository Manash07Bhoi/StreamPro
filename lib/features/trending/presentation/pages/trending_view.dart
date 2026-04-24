import 'package:flutter/material.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/presentation/blocs/video_list_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TrendingView extends StatelessWidget {
  const TrendingView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'This Week'),
              Tab(text: 'All Time'),
            ],
            indicatorColor: Color(0xFFDB2777),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildRankedList(),
                _buildRankedList(),
                _buildRankedList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankedList() {
    return BlocBuilder<VideoListBloc, VideoListState>(
      builder: (context, state) {
        if (state is VideoListLoaded) {
          final rankedVideos = state.trending;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rankedVideos.length,
            itemBuilder: (context, index) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PremiumVideoCard(
                      video: rankedVideos[index],
                      height: 120,
                    ),
                  ),
                ],
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
