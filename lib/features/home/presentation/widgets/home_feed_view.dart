import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../blocs/home_feed_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeFeedBloc>()..add(LoadHomeFeed()),
      child: const _HomeFeedContent(),
    );
  }
}

class _HomeFeedContent extends StatefulWidget {
  const _HomeFeedContent();

  @override
  State<_HomeFeedContent> createState() => _HomeFeedContentState();
}

class _HomeFeedContentState extends State<_HomeFeedContent> {
  int _currentHeroIndex = 0;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeFeedBloc>().add(RefreshHomeFeed());
        // Simple wait for refresh to complete visually
        await Future.delayed(const Duration(milliseconds: 800));
      },
      color: AppColors.colorPrimary,
      backgroundColor: AppColors.colorSurface2,
      child: BlocBuilder<HomeFeedBloc, HomeFeedState>(
        builder: (context, state) {
          if (state is HomeFeedLoading || state is HomeFeedInitial) {
            return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
          } else if (state is HomeFeedLoaded) {
            return CustomScrollView(
              slivers: [
                // Hero Carousel
                if (state.featuredVideos.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildHeroCarousel(state.featuredVideos),
                  ),

                // Continue Watching
                if (state.continueWatching.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildHorizontalSection(
                      context,
                      'Continue Watching',
                      state.continueWatching,
                      showProgress: true,
                    ),
                  ),

                // New This Week
                if (state.newThisWeek.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildHorizontalSection(
                      context,
                      'New This Week',
                      state.newThisWeek,
                      showNewBadge: true,
                    ),
                  ),

                // Category Chips
                if (state.allCategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildCategoryChips(context, state.allCategories, state.selectedCategory),
                  ),

                // Trending Now
                if (state.trendingNow.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildHorizontalSection(
                      context,
                      '🔥 Trending Now',
                      state.trendingNow,
                    ),
                  ),

                // Recommended For You
                if (state.recommendedForYou.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _buildHorizontalSection(
                      context,
                      'Recommended For You',
                      state.recommendedForYou,
                    ),
                  ),

                // Top Rated (Vertical List)
                if (state.topRated.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Top Rated', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                          TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppColors.colorPrimary, fontFamily: 'Poppins'))),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildTopRatedItem(context, state.topRated[index], index + 1);
                      },
                      childCount: state.topRated.length,
                    ),
                  ),
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            );
          } else if (state is HomeFeedError) {
             return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeroCarousel(List<VideoEntity> videos) {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 220,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            onPageChanged: (index, reason) {
              setState(() {
                _currentHeroIndex = index;
              });
            },
          ),
          items: videos.map((video) {
            return GestureDetector(
              onTap: () => context.push('/player', extra: video),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: video.thumbnailUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 640,
                    memCacheHeight: 360,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, AppColors.colorBackground.withValues(alpha:0.9)],
                        stops: const [0.3, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 24,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.colorPrimary.withValues(alpha:0.2),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(video.category, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: AppColors.colorPrimary)),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha:0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(video.duration, style: const TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          video.title,
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        Container(
                          height: 36,
                          width: 120,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Center(child: Text('Watch Now', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: videos.asMap().entries.map((entry) {
            return Container(
              width: _currentHeroIndex == entry.key ? 16.0 : 6.0,
              height: 6.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: _currentHeroIndex == entry.key ? AppColors.colorPrimary : AppColors.colorSurface3,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHorizontalSection(BuildContext context, String title, List<VideoEntity> videos, {bool showProgress = false, bool showNewBadge = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton(onPressed: () {}, child: const Text('See All', style: TextStyle(color: AppColors.colorPrimary, fontFamily: 'Poppins'))),
            ],
          ),
        ),
        SizedBox(
          height: 140, // Height for card
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            scrollDirection: Axis.horizontal,
            itemCount: videos.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: PremiumVideoCard(
                  video: videos[index],
                  width: 160,
                  height: 100, // Reduced height for horizontal list
                  showProgress: showProgress,
                  forceNewBadge: showNewBadge,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChips(BuildContext context, List<String> categories, String? selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final category = categories[index];
            final isSelected = category == selectedCategory;
            return FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (_) {
                 context.read<HomeFeedBloc>().add(ChangeSelectedCategory(isSelected ? null : category));
              },
              backgroundColor: AppColors.colorSurface2,
              selectedColor: AppColors.colorPrimary.withValues(alpha:0.2),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppColors.colorTextSecondary,
                fontFamily: 'Poppins',
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: isSelected ? AppColors.colorPrimary : Colors.transparent),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTopRatedItem(BuildContext context, VideoEntity video, int rank) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: SizedBox(
        width: 140,
        child: Row(
          children: [
            SizedBox(
              width: 30,
              child: Text(
                rank.toString(),
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.colorPrimary),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 100,
                height: 60,
                child: CachedNetworkImage(
                  imageUrl: video.thumbnailUrl,
                  fit: BoxFit.cover,
                  memCacheWidth: 320,
                  memCacheHeight: 180,
                ),
              ),
            ),
          ],
        ),
      ),
      title: Text(video.title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text('${video.viewCount} views', style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextSecondary)),
      onTap: () => context.push('/player', extra: video),
    );
  }
}
