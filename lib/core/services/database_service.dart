import 'package:hive_flutter/hive_flutter.dart';
import '../models/app_config.dart';
import '../models/video_entity.dart';
import '../models/watch_history_entry.dart';
import '../models/bookmark_entry.dart';
import '../models/download_record.dart';
import '../models/playlist.dart';
import '../models/playlist_item.dart';
import '../models/like_record.dart';
import '../models/comment.dart';
import '../models/user_profile.dart';
import '../models/app_notification.dart';
import '../models/search_history_entry.dart';

class DatabaseService {
  Future<void> init() async {
    await Hive.initFlutter();
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    Hive.registerAdapter(AppConfigAdapter());
    Hive.registerAdapter(VideoEntityAdapter());
    Hive.registerAdapter(WatchHistoryEntryAdapter());
    Hive.registerAdapter(BookmarkEntryAdapter());
    Hive.registerAdapter(DownloadRecordAdapter());
    Hive.registerAdapter(PlaylistAdapter());
    Hive.registerAdapter(PlaylistItemAdapter());
    Hive.registerAdapter(LikeRecordAdapter());
    Hive.registerAdapter(CommentAdapter());
    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(AppNotificationAdapter());
    Hive.registerAdapter(SearchHistoryEntryAdapter());
  }

  Future<void> _openBoxes() async {
    await Hive.openBox<AppConfig>('app_config_box');
    await Hive.openBox<VideoEntity>('videos_box');
    await Hive.openBox<WatchHistoryEntry>('history_box');
    await Hive.openBox<BookmarkEntry>('bookmarks_box');
    await Hive.openBox<DownloadRecord>('downloads_box');
    await Hive.openBox<Playlist>('playlists_box');
    await Hive.openBox<PlaylistItem>('playlist_items_box');
    await Hive.openBox<LikeRecord>('likes_box');
    await Hive.openBox<Comment>('comments_box');
    await Hive.openBox<UserProfile>('user_profile_box');
    await Hive.openBox<AppNotification>('notifications_box');
    await Hive.openBox<SearchHistoryEntry>('search_history_box');
  }

  Future<void> clearAll() async {
    await Hive.box<AppConfig>('app_config_box').clear();
    await Hive.box<VideoEntity>('videos_box').clear();
    await Hive.box<WatchHistoryEntry>('history_box').clear();
    await Hive.box<BookmarkEntry>('bookmarks_box').clear();
    await Hive.box<DownloadRecord>('downloads_box').clear();
    await Hive.box<Playlist>('playlists_box').clear();
    await Hive.box<PlaylistItem>('playlist_items_box').clear();
    await Hive.box<LikeRecord>('likes_box').clear();
    await Hive.box<Comment>('comments_box').clear();
    await Hive.box<UserProfile>('user_profile_box').clear();
    await Hive.box<AppNotification>('notifications_box').clear();
    await Hive.box<SearchHistoryEntry>('search_history_box').clear();
  }
}
