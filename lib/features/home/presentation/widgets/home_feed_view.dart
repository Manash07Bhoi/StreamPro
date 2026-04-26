import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../../core/widgets/shimmer_loading_card.dart';
import '../../../discover/presentation/blocs/video_list_bloc.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoListBloc, VideoListState>(
      builder: (context, state) {
        if (state is VideoListLoading || state is VideoListInitial) {
          return const _HomeShimmer();
        } else if (state is VideoListError) {
          return Center(child: Text(state.message));
        } else if (state is VideoListLoaded) {
          final trending = state.trending;
          final recommended = state.recommended;
          final fresh = state.videos.take(5).toList(); // Demo

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Carousel
                if (trending.isNotEmpty)
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 250.0,
                      autoPlay: true,
                      enlargeCenterPage: true,
                      viewportFraction: 0.9,
                      aspectRatio: 16 / 9,
                      initialPage: 0,
                    ),
                    items: trending.take(5).map((video) {
                      return PremiumVideoCard(
                        video: video,
                        width: double.infinity,
                        height: 250,
                      );
                    }).toList(),
                  ),

                const SizedBox(height: 24),
                _buildSectionTitle('Trending Now'),
                _buildHorizontalList(trending),

                const SizedBox(height: 24),
                _buildSectionTitle('Recommended For You'),
                _buildHorizontalList(recommended),

                const SizedBox(height: 24),
                _buildSectionTitle('Fresh Releases'),
                _buildHorizontalList(fresh),

                const SizedBox(height: 40),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List videos) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: videos.length,
        itemBuilder: (context, index) {
          return PremiumVideoCard(video: videos[index]);
        },
      ),
    );
  }
}

class _HomeShimmer extends StatelessWidget {
  const _HomeShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Center(
            child: ShimmerLoadingCard(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 250,
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: SizedBox(
              height: 20,
              width: 150,
              child: ShimmerLoadingCard(width: 150, height: 20),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 180,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) => const ShimmerLoadingCard(),
            ),
          ),
        ],
      ),
    );
  }
}
