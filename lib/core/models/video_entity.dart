import 'package:hive/hive.dart';

part 'video_entity.g.dart';

@HiveType(typeId: 1)
class VideoEntity extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String thumbnailUrl;

  @HiveField(3)
  final String duration;

  @HiveField(4)
  final int durationSeconds;

  @HiveField(5)
  final String embedCode;

  @HiveField(6)
  final String category;

  @HiveField(7)
  final String description;

  @HiveField(8)
  final String channelName;

  @HiveField(9)
  final String channelAvatar;

  @HiveField(10)
  final int viewCount;

  @HiveField(11)
  final int likeCount;

  @HiveField(12)
  final int dislikeCount;

  @HiveField(13)
  final String uploadedAt;

  @HiveField(14)
  final List<String> tags;

  @HiveField(15)
  final bool isNew;

  @HiveField(16)
  final bool isTrending;

  @HiveField(17)
  final bool isHD;

  @HiveField(18)
  final bool isFeatured;

  @HiveField(19)
  final String contentRating;

  @HiveField(20)
  final bool requiresAgeVerification;

  @HiveField(21)
  final String subtitleUrl;

  @HiveField(22)
  final List<String> relatedVideoIds;

  @HiveField(23)
  final String playlistPreviewUrl;

  @HiveField(24)
  final int commentCount;

  @HiveField(25)
  final bool isDownloadable;

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
