import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../../core/widgets/shimmer_loading_card.dart';
import '../../../../core/routes/app_router.dart';
import '../../../discover/presentation/blocs/video_list_bloc.dart';

class HomeFeedView extends StatelessWidget {
  const HomeFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VideoListBloc, VideoListState>(
      builder: (context, state) {
        if (state is VideoListLoading || state is VideoListInitial) {
           return ListView.builder(
             itemCount: 3,
             itemBuilder: (context, index) => const ShimmerVideoCard(),
           );
        } else if (state is VideoListLoaded) {
           final featured = state.videos.where((v) => v.isFeatured).take(6).toList();
           final newVideos = state.videos.where((v) => v.isNew).toList();
           final trending = state.videos.where((v) => v.isTrending).toList();

           return CustomScrollView(
             slivers: [
               SliverToBoxAdapter(
                 child: CarouselSlider(
                   options: CarouselOptions(
                     height: 220.0,
                     autoPlay: true,
                     viewportFraction: 1.0,
                   ),
                   items: featured.map((video) {
                     return Builder(
                       builder: (BuildContext context) {
                         return GestureDetector(
                           onTap: () => context.push(AppRoutes.player, extra: video),
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
                                     colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                   )
                                 ),
                               ),
                               Positioned(
                                 bottom: 16,
                                 left: 16,
                                 right: 16,
                                 child: Column(
                                   crossAxisAlignment: CrossAxisAlignment.start,
                                   children: [
                                     Chip(label: Text(video.category, style: const TextStyle(fontSize: 10)), backgroundColor: Theme.of(context).primaryColor),
                                     Text(video.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white)),
                                   ],
                                 ),
                               )
                             ],
                           ),
                         );
                       },
                     );
                   }).toList(),
                 ),
               ),
               _buildSectionHeader(context, 'New This Week', () => context.push('/category/New')),
               SliverToBoxAdapter(
                 child: SizedBox(
                   height: 140,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal,
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     itemCount: newVideos.length,
                     itemBuilder: (context, index) {
                       return SizedBox(
                         width: 200,
                         child: Padding(
                           padding: const EdgeInsets.only(right: 16),
                           child: PremiumVideoCard(video: newVideos[index]),
                         ),
                       );
                     },
                   ),
                 ),
               ),
               _buildSectionHeader(context, 'Trending Now', () => {}),
               SliverToBoxAdapter(
                 child: SizedBox(
                   height: 140,
                   child: ListView.builder(
                     scrollDirection: Axis.horizontal,
                     padding: const EdgeInsets.symmetric(horizontal: 16),
                     itemCount: trending.length,
                     itemBuilder: (context, index) {
                       return SizedBox(
                         width: 200,
                         child: Padding(
                           padding: const EdgeInsets.only(right: 16),
                           child: PremiumVideoCard(video: trending[index]),
                         ),
                       );
                     },
                   ),
                 ),
               ),
               const SliverToBoxAdapter(child: SizedBox(height: 32)),
             ],
           );
        } else if (state is VideoListError) {
           return Center(child: Text(state.message));
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, VoidCallback onSeeAll) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            TextButton(
              onPressed: onSeeAll,
              child: const Text('See All'),
            ),
          ],
        ),
      ),
    );
  }
}
