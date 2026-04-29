import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/user_profile.dart';
import 'package:uuid/uuid.dart';

class ProfileRepository {
  static const String userProfileBoxName = 'user_profile_box';

  UserProfile getOrCreateProfile() {
    final box = Hive.box<UserProfile>(userProfileBoxName);
    if (box.isNotEmpty) {
      return box.values.first;
    }

    final newProfile = UserProfile(
      id: const Uuid().v4(),
      displayName: 'Guest User',
      createdAt: DateTime.now().toIso8601String(),
      membershipType: 'free',
      totalLikes: 0,
      totalWatchedVideos: 0,
      totalWatchTimeSeconds: 0,
      favoriteCategory: 'Unknown',
      interests: [],
      birthYear: '',
      isAgeVerified: false,
    );
    box.put(newProfile.id, newProfile);
    return newProfile;
  }

  Future<void> updateProfile(UserProfile profile) async {
    final box = Hive.box<UserProfile>(userProfileBoxName);
    await box.put(profile.id, profile);
  }

  Future<void> updateDisplayName(String name) async {
    final profile = getOrCreateProfile();
    final updated = UserProfile(
      id: profile.id,
      displayName: name,
      avatarUrl: profile.avatarUrl,
      customAvatarPath: profile.customAvatarPath,
      createdAt: profile.createdAt,
      membershipType: profile.membershipType,
      totalLikes: profile.totalLikes,
      totalWatchedVideos: profile.totalWatchedVideos,
      totalWatchTimeSeconds: profile.totalWatchTimeSeconds,
      favoriteCategory: profile.favoriteCategory,
      interests: profile.interests,
      birthYear: profile.birthYear,
      isAgeVerified: profile.isAgeVerified,
    );
    await updateProfile(updated);
  }

  Future<void> updateAvatar(String? url) async {
    final profile = getOrCreateProfile();
    final updated = UserProfile(
      id: profile.id,
      displayName: profile.displayName,
      avatarUrl: url,
      customAvatarPath: profile.customAvatarPath,
      createdAt: profile.createdAt,
      membershipType: profile.membershipType,
      totalLikes: profile.totalLikes,
      totalWatchedVideos: profile.totalWatchedVideos,
      totalWatchTimeSeconds: profile.totalWatchTimeSeconds,
      favoriteCategory: profile.favoriteCategory,
      interests: profile.interests,
      birthYear: profile.birthYear,
      isAgeVerified: profile.isAgeVerified,
    );
    await updateProfile(updated);
  }

  Future<void> syncStats() async {
    // This will be called by ProfileBloc to recompute stats from other boxes.
    // The actual cross-box querying logic can be placed here or orchestrated by the BLoC.
    // For now, it's a placeholder.
  }
}
