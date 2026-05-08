import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/like_repository.dart';

// Events
abstract class LikeEvent extends Equatable {}

class LoadReaction extends LikeEvent {
  final String videoId;
  LoadReaction(this.videoId);
  @override
  List<Object> get props => [videoId];
}

class SetReaction extends LikeEvent {
  final String videoId;
  final String reaction;
  SetReaction(this.videoId, this.reaction);
  @override
  List<Object> get props => [videoId, reaction];
}

class LoadAllLikes extends LikeEvent {
  @override
  List<Object> get props => [];
}

// States
abstract class LikeState extends Equatable {}

class LikeInitial extends LikeState {
  @override
  List<Object> get props => [];
}

class LikeLoaded extends LikeState {
  final Map<String, String> reactions;
  LikeLoaded(this.reactions);
  @override
  List<Object> get props => [reactions];
}

class LikeError extends LikeState {
  final String message;
  LikeError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class LikeBloc extends Bloc<LikeEvent, LikeState> {
  final LikeRepository _repository;

  LikeBloc(this._repository) : super(LikeInitial()) {
    on<LoadReaction>((event, emit) async {
      try {
        final reaction = _repository.getReaction(event.videoId);
        final currentReactions = state is LikeLoaded
            ? Map<String, String>.from((state as LikeLoaded).reactions)
            : <String, String>{};
        currentReactions[event.videoId] = reaction;
        emit(LikeLoaded(currentReactions));
      } catch (e) {
        emit(LikeError('Failed to load reaction: $e'));
      }
    });

    on<SetReaction>((event, emit) async {
      try {
        await _repository.setReaction(event.videoId, event.reaction);
        final currentReactions = state is LikeLoaded
            ? Map<String, String>.from((state as LikeLoaded).reactions)
            : <String, String>{};
        currentReactions[event.videoId] = event.reaction;
        emit(LikeLoaded(currentReactions));
      } catch (e) {
        emit(LikeError('Failed to set reaction: $e'));
      }
    });

    on<LoadAllLikes>((event, emit) async {
      try {
        final likes = _repository.getLikedVideos();
        final currentReactions = <String, String>{};
        for (var like in likes) {
          currentReactions[like.videoId] = like.reaction;
        }
        emit(LikeLoaded(currentReactions));
      } catch (e) {
        emit(LikeError('Failed to load likes: $e'));
      }
    });
  }
}
