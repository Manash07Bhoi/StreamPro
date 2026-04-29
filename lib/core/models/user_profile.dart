import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 9)
class UserProfile extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String displayName;

  @HiveField(2)
  final String? avatarUrl;

  @HiveField(3)
  final String? customAvatarPath;

  @HiveField(4)
  final String createdAt;

  @HiveField(5)
  final String membershipType;

  @HiveField(6)
  final int totalLikes;

  @HiveField(7)
  final int totalWatchedVideos;

  @HiveField(8)
  final int totalWatchTimeSeconds;

  @HiveField(9)
  final String favoriteCategory;

  @HiveField(10)
  final List<String> interests;

  @HiveField(11)
  final String birthYear;

  @HiveField(12)
  final bool isAgeVerified;

  UserProfile({
    required this.id,
    required this.displayName,
    this.avatarUrl,
    this.customAvatarPath,
    required this.createdAt,
    required this.membershipType,
    required this.totalLikes,
    required this.totalWatchedVideos,
    required this.totalWatchTimeSeconds,
    required this.favoriteCategory,
    required this.interests,
    required this.birthYear,
    required this.isAgeVerified,
  });
}
