import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../core/models/video_entity.dart';
import '../../data/repositories/video_repository.dart';

// Events
abstract class VideoListEvent {}

class LoadVideosEvent extends VideoListEvent {}

class SearchVideosEvent extends VideoListEvent {
  final String query;
  SearchVideosEvent(this.query);
}

// States
abstract class VideoListState {}

class VideoListInitial extends VideoListState {}

class VideoListLoading extends VideoListState {}

class VideoListLoaded extends VideoListState {
  final List<VideoEntity> videos;
  final List<VideoEntity> trending;
  final List<VideoEntity> recommended;
  VideoListLoaded(
      {required this.videos,
      required this.trending,
      required this.recommended});
}

class VideoListError extends VideoListState {
  final String message;
  VideoListError(this.message);
}

// BLoC
class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository repository;

  // Paging Controllers
  final PagingController<int, VideoEntity> trendingDailyController =
      PagingController<int, VideoEntity>(firstPageKey: 0);
  final PagingController<int, VideoEntity> trendingWeeklyController =
      PagingController<int, VideoEntity>(firstPageKey: 0);
  final PagingController<int, VideoEntity> trendingAllTimeController =
      PagingController<int, VideoEntity>(firstPageKey: 0);

  final PagingController<int, VideoEntity> searchPagingController =
      PagingController<int, VideoEntity>(firstPageKey: 0);

  static const _pageSize = 10;
  Timer? _debounce;
  String _currentQuery = '';

  VideoListBloc(this.repository) : super(VideoListInitial()) {
    trendingDailyController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, trendingDailyController);
    });
    trendingWeeklyController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, trendingWeeklyController);
    });
    trendingAllTimeController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey, trendingAllTimeController);
    });

    searchPagingController.addPageRequestListener((pageKey) {
      if (_currentQuery.isNotEmpty) {
        _fetchSearchPage(pageKey, _currentQuery);
      }
    });

    on<LoadVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        await repository.initializeSeedData();

        // For Home tab carousel and horizontal lists we load a small chunk via getPaginatedVideos
        // Avoid bulk loading everything.
        final chunk1 = await repository.getPaginatedVideos(0, 10);
        final chunk2 = await repository.getPaginatedVideos(1, 10);
        final chunk3 = await repository.getPaginatedVideos(2, 5);

        emit(VideoListLoaded(
            videos: chunk3, trending: chunk1, recommended: chunk2));
      } catch (e) {
        emit(VideoListError('Failed to load videos.'));
      }
    });

    on<SearchVideosEvent>((event, emit) {
      _currentQuery = event.query;

      if (_debounce?.isActive ?? false) _debounce?.cancel();
      _debounce = Timer(const Duration(milliseconds: 500), () {
        searchPagingController.refresh();
      });
    });
  }

  Future<void> _fetchPage(
      int pageKey, PagingController<int, VideoEntity> controller) async {
    try {
      // Add slight delay to simulate network request and show shimmer
      await Future.delayed(const Duration(milliseconds: 500));
      final newItems = await repository.getPaginatedVideos(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        controller.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        controller.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      controller.error = error;
    }
  }

  Future<void> _fetchSearchPage(int pageKey, String query) async {
    try {
      // Very basic local search pagination simulation
      final allResults = await repository.searchVideos(query);
      final start = pageKey * _pageSize;
      if (start >= allResults.length) {
        searchPagingController.appendLastPage([]);
        return;
      }

      final end = (start + _pageSize > allResults.length)
          ? allResults.length
          : start + _pageSize;
      final newItems = allResults.sublist(start, end);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        searchPagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        searchPagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      searchPagingController.error = error;
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    trendingDailyController.dispose();
    trendingWeeklyController.dispose();
    trendingAllTimeController.dispose();
    searchPagingController.dispose();
    return super.close();
  }
}
