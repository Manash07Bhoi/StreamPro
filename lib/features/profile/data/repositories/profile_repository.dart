import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/models/user_profile.dart';

class ProfileRepository {
  final Box<UserProfile> _box = Hive.box<UserProfile>('user_profile_box');
  final _uuid = const Uuid();

  Future<void> initializeProfileIfNeeded() async {
    if (_box.isNotEmpty) return;

    final profile = UserProfile(
      id: _uuid.v4(),
      displayName: 'Guest User',
      createdAt: DateTime.now().toIso8601String(),
      membershipType: 'free',
      totalLikes: 0,
      totalWatchedVideos: 0,
      totalWatchTimeSeconds: 0,
      favoriteCategory: '',
      interests: [],
      birthYear: '',
      isAgeVerified: false,
    );

    await _box.put(profile.id, profile);
  }
}
