import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 9)
class UserProfile extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String displayName;
  @HiveField(2) String? avatarUrl;
  @HiveField(3) String? customAvatarPath;
  @HiveField(4) String createdAt;
  @HiveField(5) String membershipType;
  @HiveField(6) int totalLikes;
  @HiveField(7) int totalWatchedVideos;
  @HiveField(8) int totalWatchTimeSeconds;
  @HiveField(9) String favoriteCategory;
  @HiveField(10) List<String> interests;
  @HiveField(11) String birthYear;
  @HiveField(12) bool isAgeVerified;

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
