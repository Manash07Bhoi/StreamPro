import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/playlist.dart';
import '../../data/repositories/playlist_repository.dart';

// Events
abstract class PlaylistEvent extends Equatable {}

class LoadPlaylists extends PlaylistEvent {
  @override
  List<Object> get props => [];
}

class CreatePlaylist extends PlaylistEvent {
  final String name;
  final String? description;
  final String color;

  CreatePlaylist({required this.name, this.description, required this.color});

  @override
  List<Object> get props => [name, description ?? '', color];
}

class UpdatePlaylist extends PlaylistEvent {
  final Playlist playlist;
  UpdatePlaylist(this.playlist);
  @override
  List<Object> get props => [playlist];
}

class DeletePlaylist extends PlaylistEvent {
  final String playlistId;
  DeletePlaylist(this.playlistId);
  @override
  List<Object> get props => [playlistId];
}

class AddVideoToPlaylist extends PlaylistEvent {
  final String playlistId;
  final String videoId;
  AddVideoToPlaylist(this.playlistId, this.videoId);
  @override
  List<Object> get props => [playlistId, videoId];
}

class RemoveVideoFromPlaylist extends PlaylistEvent {
  final String playlistId;
  final String videoId;
  RemoveVideoFromPlaylist(this.playlistId, this.videoId);
  @override
  List<Object> get props => [playlistId, videoId];
}

class ReorderPlaylistItems extends PlaylistEvent {
  final String playlistId;
  final int oldIndex;
  final int newIndex;
  ReorderPlaylistItems(this.playlistId, this.oldIndex, this.newIndex);
  @override
  List<Object> get props => [playlistId, oldIndex, newIndex];
}

// States
abstract class PlaylistState extends Equatable {}

class PlaylistInitial extends PlaylistState {
  @override
  List<Object> get props => [];
}

class PlaylistLoading extends PlaylistState {
  @override
  List<Object> get props => [];
}

class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;
  PlaylistLoaded(this.playlists);
  @override
  List<Object> get props => [playlists];
}

class PlaylistActionSuccess extends PlaylistState {
  final List<Playlist> playlists;
  final String message;
  PlaylistActionSuccess(this.playlists, this.message);
  @override
  List<Object> get props => [playlists, message];
}

class PlaylistError extends PlaylistState {
  final String message;
  PlaylistError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class PlaylistBloc extends Bloc<PlaylistEvent, PlaylistState> {
  final PlaylistRepository _repository;

  PlaylistBloc(this._repository) : super(PlaylistInitial()) {
    on<LoadPlaylists>((event, emit) async {
      emit(PlaylistLoading());
      try {
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to load playlists: $e'));
      }
    });

    on<CreatePlaylist>((event, emit) async {
      try {
        final currentPlaylists = _repository.getAllPlaylists();
        if (currentPlaylists.length >= 20) {
          emit(PlaylistError('Playlist limit reached (20/20)'));
          return;
        }

        if (event.name.trim().isEmpty) {
          emit(PlaylistError('Playlist name cannot be empty'));
          return;
        }

        await _repository.createPlaylist(event.name, description: event.description, color: event.color);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistActionSuccess(playlists, 'Playlist created'));
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to create playlist: $e'));
      }
    });

    on<UpdatePlaylist>((event, emit) async {
      try {
        await _repository.updatePlaylist(event.playlist);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistActionSuccess(playlists, 'Playlist updated'));
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to update playlist: $e'));
      }
    });

    on<DeletePlaylist>((event, emit) async {
      try {
        await _repository.deletePlaylist(event.playlistId);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistActionSuccess(playlists, 'Playlist deleted'));
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to delete playlist: $e'));
      }
    });

    on<AddVideoToPlaylist>((event, emit) async {
      try {
        await _repository.addVideoToPlaylist(event.playlistId, event.videoId);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistActionSuccess(playlists, 'Added to playlist'));
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to add to playlist: $e'));
      }
    });

    on<RemoveVideoFromPlaylist>((event, emit) async {
      try {
        await _repository.removeVideoFromPlaylist(event.playlistId, event.videoId);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistActionSuccess(playlists, 'Removed from playlist'));
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to remove from playlist: $e'));
      }
    });

    on<ReorderPlaylistItems>((event, emit) async {
      try {
        await _repository.reorderPlaylistItem(event.playlistId, event.oldIndex, event.newIndex);
        final playlists = _repository.getAllPlaylists();
        emit(PlaylistLoaded(playlists));
      } catch (e) {
        emit(PlaylistError('Failed to reorder playlist: $e'));
      }
    });
  }
}
