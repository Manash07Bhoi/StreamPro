import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:streampro/features/home/presentation/blocs/home_feed_bloc.dart';
import 'package:streampro/features/discover/data/repositories/video_repository.dart';
import 'package:streampro/features/library/data/repositories/history_repository.dart';
import 'package:streampro/features/profile/data/repositories/profile_repository.dart';
import 'package:streampro/core/models/video_entity.dart';
import 'package:streampro/core/models/watch_history_entry.dart';
import 'package:streampro/core/models/user_profile.dart';

class MockVideoRepository extends Mock implements VideoRepository {}
class MockHistoryRepository extends Mock implements HistoryRepository {}
class MockProfileRepository extends Mock implements ProfileRepository {}

void main() {
  late HomeFeedBloc bloc;
  late MockVideoRepository mockVideoRepo;
  late MockHistoryRepository mockHistoryRepo;
  late MockProfileRepository mockProfileRepo;

  final testVideoFeatured = VideoEntity(
    id: '1', title: 'Featured Video', thumbnailUrl: '', duration: '',
    durationSeconds: 100, embedCode: '', category: 'Action', description: '',
    channelName: '', channelAvatar: '', viewCount: 0, likeCount: 0,
    dislikeCount: 0, uploadedAt: '', tags: [], isNew: true, isTrending: false,
    isHD: true, isFeatured: true, contentRating: 'PG', requiresAgeVerification: false,
    subtitleUrl: '', relatedVideoIds: [], playlistPreviewUrl: '',
    commentCount: 0, isDownloadable: true,
  );

  final testVideoNormal = VideoEntity(
    id: '2', title: 'Normal Video', thumbnailUrl: '', duration: '',
    durationSeconds: 100, embedCode: '', category: 'Comedy', description: '',
    channelName: '', channelAvatar: '', viewCount: 0, likeCount: 0,
    dislikeCount: 0, uploadedAt: '', tags: [], isNew: true, isTrending: false,
    isHD: true, isFeatured: false, contentRating: 'PG', requiresAgeVerification: false,
    subtitleUrl: '', relatedVideoIds: [], playlistPreviewUrl: '',
    commentCount: 0, isDownloadable: true,
  );

  final testProfile = UserProfile(
    id: 'u1', displayName: 'User', createdAt: '', membershipType: 'free',
    totalLikes: 0, totalWatchedVideos: 0, totalWatchTimeSeconds: 0,
    favoriteCategory: 'Action', interests: [], birthYear: '2000', isAgeVerified: true,
  );

  final testHistoryEntry = WatchHistoryEntry(
    id: 'h1', videoId: '2', watchedAt: '',
    watchedDurationSeconds: 50, progressPercent: 0.5,
    isCompleted: false, watchCount: 1,
  );

  setUp(() {
    mockVideoRepo = MockVideoRepository();
    mockHistoryRepo = MockHistoryRepository();
    mockProfileRepo = MockProfileRepository();
    bloc = HomeFeedBloc(mockVideoRepo, mockHistoryRepo, mockProfileRepo);
  });

  tearDown(() {
    bloc.close();
  });

  blocTest<HomeFeedBloc, HomeFeedState>(
    'emits Loading then Loaded when LoadHomeFeed is added and videos exist',
    build: () {
      when(() => mockVideoRepo.getAllVideos()).thenAnswer((_) async => [testVideoFeatured, testVideoNormal]);
      when(() => mockProfileRepo.getOrCreateProfile()).thenReturn(testProfile);
      when(() => mockHistoryRepo.getHistory(limit: any(named: 'limit'))).thenReturn([]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadHomeFeed()),
    expect: () => [
      isA<HomeFeedLoading>(),
      isA<HomeFeedLoaded>(),
    ],
  );

  blocTest<HomeFeedBloc, HomeFeedState>(
    'emits Loading then Error when repository throws',
    build: () {
      when(() => mockVideoRepo.getAllVideos()).thenThrow(Exception('DB Error'));
      when(() => mockProfileRepo.getOrCreateProfile()).thenReturn(testProfile);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadHomeFeed()),
    expect: () => [
      isA<HomeFeedLoading>(),
      isA<HomeFeedError>(),
    ],
  );

  blocTest<HomeFeedBloc, HomeFeedState>(
    'featuredVideos only contains isFeatured true videos',
    build: () {
      when(() => mockVideoRepo.getAllVideos()).thenAnswer((_) async => [testVideoFeatured, testVideoNormal]);
      when(() => mockProfileRepo.getOrCreateProfile()).thenReturn(testProfile);
      when(() => mockHistoryRepo.getHistory(limit: any(named: 'limit'))).thenReturn([]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadHomeFeed()),
    verify: (bloc) {
      final state = bloc.state as HomeFeedLoaded;
      expect(state.featuredVideos.length, 1);
      expect(state.featuredVideos.first.isFeatured, isTrue);
    },
  );

  blocTest<HomeFeedBloc, HomeFeedState>(
    'continueWatching only contains progress between 0.0 and 0.9',
    build: () {
      when(() => mockVideoRepo.getAllVideos()).thenAnswer((_) async => [testVideoFeatured, testVideoNormal]);
      when(() => mockProfileRepo.getOrCreateProfile()).thenReturn(testProfile);
      when(() => mockHistoryRepo.getHistory(limit: any(named: 'limit'))).thenReturn([testHistoryEntry]);
      return bloc;
    },
    act: (bloc) => bloc.add(LoadHomeFeed()),
    verify: (bloc) {
      final state = bloc.state as HomeFeedLoaded;
      expect(state.continueWatching.length, 1);
      expect(state.continueWatching.first.id, '2'); // The video with history
    },
  );
}
