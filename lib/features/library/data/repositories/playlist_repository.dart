import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/playlist.dart';
import '../../../../core/models/playlist_item.dart';
import 'package:uuid/uuid.dart';

class PlaylistRepository {
  static const String playlistsBoxName = 'playlists_box';
  static const String playlistItemsBoxName = 'playlist_items_box';

  Future<Playlist> createPlaylist(String name,
      {String? description, String color = '#C026D3'}) async {
    final box = Hive.box<Playlist>(playlistsBoxName);

    final newPlaylist = Playlist(
      id: const Uuid().v4(),
      name: name,
      description: description,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
      coverVideoId: '',
      videoCount: 0,
      isPublic: false,
      color: color,
    );

    await box.put(newPlaylist.id, newPlaylist);
    return newPlaylist;
  }

  Future<void> updatePlaylist(Playlist playlist) async {
    final box = Hive.box<Playlist>(playlistsBoxName);
    final updated = Playlist(
      id: playlist.id,
      name: playlist.name,
      description: playlist.description,
      createdAt: playlist.createdAt,
      updatedAt: DateTime.now().toIso8601String(),
      coverVideoId: playlist.coverVideoId,
      videoCount: playlist.videoCount,
      isPublic: playlist.isPublic,
      color: playlist.color,
    );
    await box.put(updated.id, updated);
  }

  Future<void> deletePlaylist(String playlistId) async {
    final box = Hive.box<Playlist>(playlistsBoxName);
    await box.delete(playlistId);

    // Delete associated items
    final itemsBox = Hive.box<PlaylistItem>(playlistItemsBoxName);
    final itemsToDelete =
        itemsBox.values.where((item) => item.playlistId == playlistId).toList();
    for (var item in itemsToDelete) {
      await itemsBox.delete(item.id);
    }
  }

  List<Playlist> getAllPlaylists() {
    final box = Hive.box<Playlist>(playlistsBoxName);
    return box.values.toList()
      ..sort((a, b) =>
          DateTime.parse(b.updatedAt).compareTo(DateTime.parse(a.updatedAt)));
  }

  Playlist? getPlaylist(String playlistId) {
    final box = Hive.box<Playlist>(playlistsBoxName);
    return box.get(playlistId);
  }

  Future<void> addVideoToPlaylist(String playlistId, String videoId) async {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);

    if (isVideoInPlaylist(playlistId, videoId)) {
      return;
    }

    final items = getPlaylistItems(playlistId);
    final newPosition = items.length;

    final newItem = PlaylistItem(
      id: const Uuid().v4(),
      playlistId: playlistId,
      videoId: videoId,
      position: newPosition,
      addedAt: DateTime.now().toIso8601String(),
    );

    await box.put(newItem.id, newItem);

    // Update playlist denormalized data
    final playlistBox = Hive.box<Playlist>(playlistsBoxName);
    final playlist = playlistBox.get(playlistId);
    if (playlist != null) {
      final updated = Playlist(
        id: playlist.id,
        name: playlist.name,
        description: playlist.description,
        createdAt: playlist.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        coverVideoId:
            playlist.coverVideoId.isEmpty ? videoId : playlist.coverVideoId,
        videoCount: playlist.videoCount + 1,
        isPublic: playlist.isPublic,
        color: playlist.color,
      );
      await playlistBox.put(updated.id, updated);
    }
  }

  Future<void> removeVideoFromPlaylist(
      String playlistId, String videoId) async {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);

    PlaylistItem? itemToRemove;
    try {
      itemToRemove = box.values.firstWhere(
          (e) => e.playlistId == playlistId && e.videoId == videoId);
    } catch (e) {
      itemToRemove = null;
    }

    if (itemToRemove != null) {
      await box.delete(itemToRemove.id);

      // Reorder remaining items
      final items = getPlaylistItems(playlistId);
      for (int i = 0; i < items.length; i++) {
        if (items[i].position != i) {
          final updated = PlaylistItem(
            id: items[i].id,
            playlistId: items[i].playlistId,
            videoId: items[i].videoId,
            position: i,
            addedAt: items[i].addedAt,
          );
          await box.put(updated.id, updated);
        }
      }

      // Update playlist denormalized data
      final playlistBox = Hive.box<Playlist>(playlistsBoxName);
      final playlist = playlistBox.get(playlistId);
      if (playlist != null) {
        final newCoverVideoId = items.isNotEmpty ? items.first.videoId : '';
        final updated = Playlist(
          id: playlist.id,
          name: playlist.name,
          description: playlist.description,
          createdAt: playlist.createdAt,
          updatedAt: DateTime.now().toIso8601String(),
          coverVideoId: newCoverVideoId,
          videoCount: items.length,
          isPublic: playlist.isPublic,
          color: playlist.color,
        );
        await playlistBox.put(updated.id, updated);
      }
    }
  }

  Future<void> reorderPlaylistItem(
      String playlistId, int oldIndex, int newIndex) async {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);
    final items = getPlaylistItems(playlistId);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = items.removeAt(oldIndex);
    items.insert(newIndex, item);

    for (int i = 0; i < items.length; i++) {
      if (items[i].position != i) {
        final updated = PlaylistItem(
          id: items[i].id,
          playlistId: items[i].playlistId,
          videoId: items[i].videoId,
          position: i,
          addedAt: items[i].addedAt,
        );
        await box.put(updated.id, updated);
      }
    }

    // Update cover video if needed
    final playlistBox = Hive.box<Playlist>(playlistsBoxName);
    final playlist = playlistBox.get(playlistId);
    if (playlist != null &&
        items.isNotEmpty &&
        playlist.coverVideoId != items.first.videoId) {
      final updated = Playlist(
        id: playlist.id,
        name: playlist.name,
        description: playlist.description,
        createdAt: playlist.createdAt,
        updatedAt: DateTime.now().toIso8601String(),
        coverVideoId: items.first.videoId,
        videoCount: playlist.videoCount,
        isPublic: playlist.isPublic,
        color: playlist.color,
      );
      await playlistBox.put(updated.id, updated);
    }
  }

  List<PlaylistItem> getPlaylistItems(String playlistId) {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);
    return box.values.where((item) => item.playlistId == playlistId).toList()
      ..sort((a, b) => a.position.compareTo(b.position));
  }

  bool isVideoInPlaylist(String playlistId, String videoId) {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);
    try {
      box.values.firstWhere(
          (e) => e.playlistId == playlistId && e.videoId == videoId);
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Playlist> getPlaylistsContainingVideo(String videoId) {
    final box = Hive.box<PlaylistItem>(playlistItemsBoxName);
    final playlistIds = box.values
        .where((item) => item.videoId == videoId)
        .map((item) => item.playlistId)
        .toSet();

    final playlistBox = Hive.box<Playlist>(playlistsBoxName);
    return playlistBox.values.where((p) => playlistIds.contains(p.id)).toList();
  }
}
