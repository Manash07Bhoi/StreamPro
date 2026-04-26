import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../core/models/video_entity.dart';
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
                _buildRankedList(
                    context.read<VideoListBloc>().trendingDailyController),
                _buildRankedList(
                    context.read<VideoListBloc>().trendingWeeklyController),
                _buildRankedList(
                    context.read<VideoListBloc>().trendingAllTimeController),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRankedList(PagingController<int, VideoEntity> pagingController) {
    return Builder(builder: (context) {
      return PagedListView<int, VideoEntity>(
        padding: const EdgeInsets.all(16),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<VideoEntity>(
          itemBuilder: (context, video, index) {
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
                    video: video,
                    height: 120,
                  ),
                ),
              ],
            );
          },
          firstPageProgressIndicatorBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
          newPageProgressIndicatorBuilder: (_) =>
              const Center(child: CircularProgressIndicator()),
        ),
      );
    });
  }
}
