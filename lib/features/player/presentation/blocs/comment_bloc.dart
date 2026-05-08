import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/comment.dart';
import '../../data/repositories/comment_repository.dart';

// Events
abstract class CommentEvent extends Equatable {}

class LoadComments extends CommentEvent {
  final String videoId;
  LoadComments(this.videoId);
  @override
  List<Object> get props => [videoId];
}

class PostComment extends CommentEvent {
  final String videoId;
  final String text;
  PostComment(this.videoId, this.text);
  @override
  List<Object> get props => [videoId, text];
}

class DeleteComment extends CommentEvent {
  final String commentId;
  DeleteComment(this.commentId);
  @override
  List<Object> get props => [commentId];
}

class LikeComment extends CommentEvent {
  final String commentId;
  LikeComment(this.commentId);
  @override
  List<Object> get props => [commentId];
}

// States
abstract class CommentState extends Equatable {}

class CommentInitial extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoading extends CommentState {
  @override
  List<Object> get props => [];
}

class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final bool isPosting;
  CommentLoaded(this.comments, {this.isPosting = false});
  @override
  List<Object> get props => [comments, isPosting];
}

class CommentPosting extends CommentState {
  final List<Comment> currentComments;
  CommentPosting(this.currentComments);
  @override
  List<Object> get props => [currentComments];
}

class CommentError extends CommentState {
  final String message;
  CommentError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final CommentRepository _repository;

  CommentBloc(this._repository) : super(CommentInitial()) {
    on<LoadComments>((event, emit) async {
      emit(CommentLoading());
      try {
        final comments = _repository.getCommentsForVideo(event.videoId);
        emit(CommentLoaded(comments));
      } catch (e) {
        emit(CommentError('Failed to load comments: $e'));
      }
    });

    on<PostComment>((event, emit) async {
      if (state is CommentLoaded) {
        final currentState = state as CommentLoaded;
        emit(CommentPosting(currentState.comments));
        try {
          // Validate
          if (event.text.trim().isEmpty) {
            emit(CommentError('Comment cannot be empty'));
            emit(CommentLoaded(currentState.comments));
            return;
          }

          String text = event.text.trim();
          if (text.length > 500) {
            text = text.substring(0, 500); // Enforce limit
          }

          await _repository.addUserComment(event.videoId, text);
          final updatedComments =
              _repository.getCommentsForVideo(event.videoId);
          emit(CommentLoaded(updatedComments));
        } catch (e) {
          emit(CommentError('Failed to post comment: $e'));
          emit(CommentLoaded(currentState.comments));
        }
      }
    });

    on<DeleteComment>((event, emit) async {
      if (state is CommentLoaded) {
        final currentState = state as CommentLoaded;
        try {
          await _repository.deleteUserComment(event.commentId);
          // Assuming videoId is known from the list, or we could pass it. We'll just filter out the list locally for MVP.
          final updatedComments = currentState.comments
              .where((c) => c.id != event.commentId)
              .toList();
          emit(CommentLoaded(updatedComments));
        } catch (e) {
          emit(CommentError('Failed to delete comment: $e'));
          emit(CommentLoaded(currentState.comments));
        }
      }
    });

    on<LikeComment>((event, emit) async {
      if (state is CommentLoaded) {
        // Simulation for MVP:
        // Final implementation would save this in DB.
        final currentState = state as CommentLoaded;
        final updatedList = currentState.comments.map((c) {
          if (c.id == event.commentId) {
            return Comment(
              id: c.id,
              videoId: c.videoId,
              authorName: c.authorName,
              authorAvatar: c.authorAvatar,
              text: c.text,
              postedAt: c.postedAt,
              likeCount: c.likeCount + 1,
              isUserComment: c.isUserComment,
              parentId: c.parentId,
            );
          }
          return c;
        }).toList();
        emit(CommentLoaded(updatedList));
      }
    });
  }
}
