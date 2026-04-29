import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/video_entity.dart';
import '../../../discover/data/repositories/video_repository.dart';
import '../../../library/data/repositories/history_repository.dart';
import '../../../profile/data/repositories/profile_repository.dart';

// Events
abstract class HomeFeedEvent extends Equatable {}

class LoadHomeFeed extends HomeFeedEvent {
  @override
  List<Object> get props => [];
}

class RefreshHomeFeed extends HomeFeedEvent {
  @override
  List<Object> get props => [];
}

class ChangeSelectedCategory extends HomeFeedEvent {
  final String? category;
  ChangeSelectedCategory(this.category);
  @override
  List<Object> get props => [category ?? ''];
}

// States
abstract class HomeFeedState extends Equatable {}

class HomeFeedInitial extends HomeFeedState {
  @override
  List<Object> get props => [];
}

class HomeFeedLoading extends HomeFeedState {
  @override
  List<Object> get props => [];
}

class HomeFeedLoaded extends HomeFeedState {
  final List<VideoEntity> featuredVideos;
  final List<VideoEntity> continueWatching;
  final List<VideoEntity> newThisWeek;
  final List<VideoEntity> trendingNow;
  final List<VideoEntity> recommendedForYou;
  final List<VideoEntity> topRated;
  final List<String> allCategories;
  final String? selectedCategory;

  HomeFeedLoaded({
    required this.featuredVideos,
    required this.continueWatching,
    required this.newThisWeek,
    required this.trendingNow,
    required this.recommendedForYou,
    required this.topRated,
    required this.allCategories,
    this.selectedCategory,
  });

  @override
  List<Object> get props => [
        featuredVideos,
        continueWatching,
        newThisWeek,
        trendingNow,
        recommendedForYou,
        topRated,
        allCategories,
        selectedCategory ?? ''
      ];
}

class HomeFeedError extends HomeFeedState {
  final String message;
  HomeFeedError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class HomeFeedBloc extends Bloc<HomeFeedEvent, HomeFeedState> {
  final VideoRepository _videoRepo;
  final HistoryRepository _historyRepo;
  final ProfileRepository _profileRepo;

  HomeFeedBloc(this._videoRepo, this._historyRepo, this._profileRepo)
      : super(HomeFeedInitial()) {

    on<LoadHomeFeed>((event, emit) async {
      await _loadFeedData(emit);
    });

    on<RefreshHomeFeed>((event, emit) async {
      await _loadFeedData(emit);
    });

    on<ChangeSelectedCategory>((event, emit) async {
      if (state is HomeFeedLoaded) {
        final currentState = state as HomeFeedLoaded;
        emit(HomeFeedLoading());

        try {
          final allVideos = await _videoRepo.getAllVideos();
          List<VideoEntity> filteredRecommended;
          if (event.category != null && event.category!.isNotEmpty) {
            filteredRecommended = allVideos.where((v) => v.category == event.category).toList();
          } else {
            // Default recommended logic
            final profile = _profileRepo.getOrCreateProfile();
            filteredRecommended = allVideos.where((v) => profile.interests.contains(v.category)).toList();
            if (filteredRecommended.isEmpty) {
              filteredRecommended = allVideos.take(10).toList();
            }
          }

          emit(HomeFeedLoaded(
            featuredVideos: currentState.featuredVideos,
            continueWatching: currentState.continueWatching,
            newThisWeek: currentState.newThisWeek,
            trendingNow: currentState.trendingNow,
            recommendedForYou: filteredRecommended,
            topRated: currentState.topRated,
            allCategories: currentState.allCategories,
            selectedCategory: event.category,
          ));
        } catch (e) {
          emit(HomeFeedError('Failed to change category: $e'));
        }
      }
    });
  }

  Future<void> _loadFeedData(Emitter<HomeFeedState> emit) async {
    emit(HomeFeedLoading());
    try {
      final allVideos = await _videoRepo.getAllVideos();
      final historyEntries = _historyRepo.getHistory();
      final profile = _profileRepo.getOrCreateProfile();

      final featuredVideos = allVideos.where((v) => v.isFeatured).take(6).toList();

      final continueWatchingIds = historyEntries
          .where((e) => e.progressPercent > 0.0 && e.progressPercent < 0.9)
          .map((e) => e.videoId)
          .toList();
      final continueWatching = allVideos.where((v) => continueWatchingIds.contains(v.id)).toList();

      final newThisWeek = allVideos.where((v) => v.isNew).take(10).toList();
      final trendingNow = allVideos.where((v) => v.isTrending).take(10).toList();

      var recommendedForYou = allVideos.where((v) => profile.interests.contains(v.category)).toList();
      if (recommendedForYou.isEmpty) {
        recommendedForYou = allVideos.take(10).toList(); // Fallback if no interests
      }

      final topRated = List<VideoEntity>.from(allVideos)
        ..sort((a, b) => b.viewCount.compareTo(a.viewCount));

      final categories = allVideos.map((v) => v.category).toSet().toList()..sort();

      emit(HomeFeedLoaded(
        featuredVideos: featuredVideos,
        continueWatching: continueWatching,
        newThisWeek: newThisWeek,
        trendingNow: trendingNow,
        recommendedForYou: recommendedForYou,
        topRated: topRated.take(10).toList(),
        allCategories: categories,
        selectedCategory: null,
      ));
    } catch (e) {
      emit(HomeFeedError('Failed to load home feed: $e'));
    }
  }
}
