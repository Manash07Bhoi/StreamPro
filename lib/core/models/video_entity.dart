import 'package:hive/hive.dart';

part 'video_entity.g.dart';

@HiveType(typeId: 1)
class VideoEntity extends HiveObject {
  @HiveField(0) String id;               // UUID v4
  @HiveField(1) String title;
  @HiveField(2) String thumbnailUrl;
  @HiveField(3) String duration;         // e.g. "12:34"
  @HiveField(4) int durationSeconds;     // e.g. 754
  @HiveField(5) String embedCode;        // Full iframe HTML string
  @HiveField(6) String category;         // e.g. 'Action'
  @HiveField(7) String description;      // 1-3 sentence video description
  @HiveField(8) String channelName;      // e.g. "StreamPro Originals"
  @HiveField(9) String channelAvatar;    // URL for channel avatar image
  @HiveField(10) int viewCount;          // Simulated view count
  @HiveField(11) int likeCount;          // Simulated like count
  @HiveField(12) int dislikeCount;       // Simulated dislike count
  @HiveField(13) String uploadedAt;      // ISO8601 DateTime string
  @HiveField(14) List<String> tags;      // ['4K', 'HDR', 'New']
  @HiveField(15) bool isNew;             // Badge flag
  @HiveField(16) bool isTrending;        // Shows in trending feed
  @HiveField(17) bool isHD;             // Quality indicator badge
  @HiveField(18) bool isFeatured;        // Shows in hero carousel
  @HiveField(19) String contentRating;   // 'G' | 'PG' | 'PG-13' | 'R' | 'NC-17'
  @HiveField(20) bool requiresAgeVerification; // true if R or NC-17
  @HiveField(21) String subtitleUrl;     // Empty string if none available
  @HiveField(22) List<String> relatedVideoIds;
  @HiveField(23) String playlistPreviewUrl;
  @HiveField(24) int commentCount;
  @HiveField(25) bool isDownloadable;

  VideoEntity({
    required this.id,
    required this.title,
    required this.thumbnailUrl,
    required this.duration,
    required this.durationSeconds,
    required this.embedCode,
    required this.category,
    required this.description,
    required this.channelName,
    required this.channelAvatar,
    required this.viewCount,
    required this.likeCount,
    required this.dislikeCount,
    required this.uploadedAt,
    required this.tags,
    required this.isNew,
    required this.isTrending,
    required this.isHD,
    required this.isFeatured,
    required this.contentRating,
    required this.requiresAgeVerification,
    required this.subtitleUrl,
    required this.relatedVideoIds,
    required this.playlistPreviewUrl,
    required this.commentCount,
    required this.isDownloadable,
  });
}
