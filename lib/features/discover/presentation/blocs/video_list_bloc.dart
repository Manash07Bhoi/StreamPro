import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/video_repository.dart';
import '../../../../core/models/video_entity.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class VideoListEvent extends Equatable {
  const VideoListEvent();

  @override
  List<Object?> get props => [];
}

class LoadVideosEvent extends VideoListEvent {}

class SearchVideosEvent extends VideoListEvent {
  final String query;
  const SearchVideosEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class LoadMoreVideosEvent extends VideoListEvent {}

// States
abstract class VideoListState extends Equatable {
  const VideoListState();

  @override
  List<Object?> get props => [];
}

class VideoListInitial extends VideoListState {}

class VideoListLoading extends VideoListState {}

class VideoListLoaded extends VideoListState {
  final List<VideoEntity> videos;
  final bool hasReachedMax;

  const VideoListLoaded(this.videos, {this.hasReachedMax = false});

  VideoListLoaded copyWith({
    List<VideoEntity>? videos,
    bool? hasReachedMax,
  }) {
    return VideoListLoaded(
      videos ?? this.videos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [videos, hasReachedMax];
}

class VideoListError extends VideoListState {
  final String message;

  const VideoListError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLoC
class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository _repository;
  static const int _limit = 10;
  int _offset = 0;
  bool _isSearching = false;

  VideoListBloc(this._repository) : super(VideoListInitial()) {
    on<LoadVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        await _repository.initializeSeedData();
        _isSearching = false;
        _offset = 0;
        final videos = _repository.getPaginatedVideos(limit: _limit, offset: _offset);
        _offset += videos.length;
        emit(VideoListLoaded(videos, hasReachedMax: videos.length < _limit));
      } catch (e) {
        emit(VideoListError(e.toString()));
      }
    });

    on<LoadMoreVideosEvent>((event, emit) async {
      if (state is VideoListLoaded && _isSearching == false) {
        final currentState = state as VideoListLoaded;
        if (currentState.hasReachedMax) return;

        try {
          final newVideos = _repository.getPaginatedVideos(limit: _limit, offset: _offset);
          if (newVideos.isEmpty) {
            emit(currentState.copyWith(hasReachedMax: true));
          } else {
            _offset += newVideos.length;
            emit(VideoListLoaded(
              currentState.videos + newVideos,
              hasReachedMax: newVideos.length < _limit,
            ));
          }
        } catch (e) {
          emit(VideoListError(e.toString()));
        }
      }
    });

    on<SearchVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        if (event.query.isEmpty) {
          _isSearching = false;
          _offset = 0;
          final videos = _repository.getPaginatedVideos(limit: _limit, offset: _offset);
          _offset += videos.length;
          emit(VideoListLoaded(videos, hasReachedMax: videos.length < _limit));
        } else {
          _isSearching = true;
          final searchResults = _repository.searchVideos(event.query);
          emit(VideoListLoaded(searchResults, hasReachedMax: true));
        }
      } catch (e) {
        emit(VideoListError(e.toString()));
      }
    });
  }
}
