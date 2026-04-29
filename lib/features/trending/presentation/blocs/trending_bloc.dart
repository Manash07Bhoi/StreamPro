import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/video_entity.dart';
import '../../../discover/data/repositories/video_repository.dart';

// Events
abstract class TrendingEvent extends Equatable {}

class LoadTrendingToday extends TrendingEvent {
  @override
  List<Object> get props => [];
}

class LoadTrendingThisWeek extends TrendingEvent {
  @override
  List<Object> get props => [];
}

class RefreshTrending extends TrendingEvent {
  final bool isToday;
  RefreshTrending(this.isToday);
  @override
  List<Object> get props => [isToday];
}

// States
abstract class TrendingState extends Equatable {}

class TrendingInitial extends TrendingState {
  @override
  List<Object> get props => [];
}

class TrendingLoading extends TrendingState {
  @override
  List<Object> get props => [];
}

class TrendingLoaded extends TrendingState {
  final List<VideoEntity> videos;
  final bool isToday;
  TrendingLoaded({required this.videos, required this.isToday});
  @override
  List<Object> get props => [videos, isToday];
}

class TrendingError extends TrendingState {
  final String message;
  TrendingError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class TrendingBloc extends Bloc<TrendingEvent, TrendingState> {
  final VideoRepository _videoRepo;

  TrendingBloc(this._videoRepo) : super(TrendingInitial()) {
    on<LoadTrendingToday>((event, emit) async {
      await _loadTrending(emit, true);
    });

    on<LoadTrendingThisWeek>((event, emit) async {
      await _loadTrending(emit, false);
    });

    on<RefreshTrending>((event, emit) async {
      await _loadTrending(emit, event.isToday);
    });
  }

  Future<void> _loadTrending(Emitter<TrendingState> emit, bool isToday) async {
    emit(TrendingLoading());
    try {
      final allVideos = await _videoRepo.getAllVideos();
      // Simulating trending ranking logic
      final trending = allVideos.where((v) => v.isTrending).toList();
      if (isToday) {
        trending.sort((a, b) => b.viewCount.compareTo(a.viewCount)); // e.g. views
      } else {
        trending.sort((a, b) => b.likeCount.compareTo(a.likeCount)); // e.g. likes
      }

      emit(TrendingLoaded(videos: trending, isToday: isToday));
    } catch (e) {
      emit(TrendingError('Failed to load trending videos: $e'));
    }
  }
}
