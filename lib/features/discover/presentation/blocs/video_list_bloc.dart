import 'package:flutter_bloc/flutter_bloc.dart';
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
  VideoListLoaded({required this.videos, required this.trending, required this.recommended});
}
class VideoListError extends VideoListState {
  final String message;
  VideoListError(this.message);
}

// BLoC
class VideoListBloc extends Bloc<VideoListEvent, VideoListState> {
  final VideoRepository repository;

  VideoListBloc(this.repository) : super(VideoListInitial()) {
    on<LoadVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        await repository.initSampleData();
        final allVideos = await repository.getAllVideos();
        // simulate a small delay to show shimmer/loaders
        await Future.delayed(const Duration(milliseconds: 800));

        // Split data arbitrarily for demo
        final trending = allVideos.take(10).toList();
        final recommended = allVideos.skip(10).take(10).toList();

        emit(VideoListLoaded(videos: allVideos, trending: trending, recommended: recommended));
      } catch (e) {
        emit(VideoListError('Failed to load videos.'));
      }
    });

    on<SearchVideosEvent>((event, emit) async {
      emit(VideoListLoading());
      try {
        final searchResults = await repository.searchVideos(event.query);
        emit(VideoListLoaded(videos: searchResults, trending: [], recommended: []));
      } catch (e) {
        emit(VideoListError('Search failed.'));
      }
    });
  }
}
