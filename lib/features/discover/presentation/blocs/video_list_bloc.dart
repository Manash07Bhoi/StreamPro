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
  final PagingController<int, VideoEntity> pagingController =
      PagingController<int, VideoEntity>(firstPageKey: 0);
  final PagingController<int, VideoEntity> searchPagingController =
      PagingController<int, VideoEntity>(firstPageKey: 0);

  static const _pageSize = 10;
  Timer? _debounce;
  String _currentQuery = '';

  VideoListBloc(this.repository) : super(VideoListInitial()) {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });

    searchPagingController.addPageRequestListener((pageKey) {
      if (_currentQuery.isNotEmpty) {
        _fetchSearchPage(pageKey, _currentQuery);
      }
    });

    on<LoadVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        await repository.initSampleData();

        // For Home tab carousel and horizontal lists we still load an initial chunk
        final allVideos = await repository.getAllVideos();
        final trending = allVideos.take(10).toList();
        final recommended = allVideos.skip(10).take(10).toList();

        emit(VideoListLoaded(
            videos: allVideos.take(5).toList(),
            trending: trending,
            recommended: recommended));
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

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await repository.getVideosPaged(pageKey, _pageSize);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
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
    pagingController.dispose();
    searchPagingController.dispose();
    return super.close();
  }
}
