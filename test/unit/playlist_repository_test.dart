import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:streampro/core/models/playlist.dart';
import 'package:streampro/core/models/playlist_item.dart';
import 'package:streampro/features/library/data/repositories/playlist_repository.dart';
import 'dart:io';

void main() {
  late PlaylistRepository repository;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(PlaylistAdapter());
    }
    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(PlaylistItemAdapter());
    }
    await Hive.openBox<Playlist>('playlists_box');
    await Hive.openBox<PlaylistItem>('playlist_items_box');
    repository = PlaylistRepository();
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  group('PlaylistRepository', () {
    test('createPlaylist generates a UUID id', () async {
      final playlist = await repository.createPlaylist('My List');
      expect(playlist.id, isNotEmpty);
      expect(playlist.name, 'My List');
      expect(playlist.id.length, greaterThan(10)); // simple check for UUID length
    });

    test('deletePlaylist also removes all its PlaylistItems', () async {
      final playlist = await repository.createPlaylist('My List');
      await repository.addVideoToPlaylist(playlist.id, 'vid_1');
      await repository.addVideoToPlaylist(playlist.id, 'vid_2');

      var items = repository.getPlaylistItems(playlist.id);
      expect(items.length, 2);

      await repository.deletePlaylist(playlist.id);

      items = repository.getPlaylistItems(playlist.id);
      expect(items.length, 0);

      final deletedPlaylist = repository.getPlaylist(playlist.id);
      expect(deletedPlaylist, isNull);
    });
  });
}
