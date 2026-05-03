# StreamPro — Production Debugging, Testing & Deployment PRD
## Version 3.0 | End-to-End Quality Assurance & Production Release Specification

---

> **Document Purpose:** This PRD is the complete specification for taking StreamPro from its current implemented state to a fully debugged, tested, security-hardened, performance-optimized, and published production application. It covers every screen, feature, navigation flow, UI element, business logic path, error condition, and deployment step. Every instruction is written for direct implementation by an AI coding agent without clarification.

---

## TABLE OF CONTENTS

1. Executive Summary & Current State Assessment
2. End-to-End Testing Strategy
3. Frontend Debug Audit — All 32 Screens
4. Navigation & Routing Debug Audit
5. Business Logic & BLoC Debug Audit
6. Local Database Debug Audit
7. Video Player Debug Audit
8. Gesture System Debug Audit
9. UI/UX Completeness Audit — Non-Functional Elements
10. Mock Data & Placeholder Elimination
11. Missing Screens, Features & Gaps
12. Frontend Performance Optimization
13. Security Hardening
14. Accessibility & Compliance Fixes
15. Production Build Configuration
16. App Store Deployment Checklist
17. Implementation Sprint Plan

---

## 1. EXECUTIVE SUMMARY & CURRENT STATE ASSESSMENT

### 1.1 Scope

StreamPro is a Flutter application (Android + iOS) using Clean Architecture, BLoC state management, Hive local database, and InAppWebView for video playback. There is no backend server — all data is local. "Backend" in this document refers to: the Hive database layer, platform channels (Brightness, Volume, PiP), local notification scheduling, connectivity monitoring, and any future API integration points that must be stubbed correctly for production.

### 1.2 Known Risk Areas

Based on the implementation history, the following areas carry the highest risk of production bugs:

- **WebView lifecycle:** Memory leaks from undisposed controllers, brightness not restored on navigation.
- **Hive data integrity:** Missing @HiveField entries causing silent null reads, box corruption on upgrade.
- **GoRouter redirect loops:** Incorrect guard logic causing infinite redirects between splash, age gate, and home.
- **BLoC state leaks:** Singleton BLoCs holding stale state after data mutations in other features.
- **Platform channel failures:** Silent `MissingPluginException` on iOS/Android from channel name mismatches.
- **Asset loading failures:** Missing Lottie files causing blank empty states instead of PNG fallback rendering.
- **Gesture conflicts:** Competing GestureDetectors in the player overlay causing missed or double-fired events.
- **Build artifact pollution:** Generated files committed to git causing diff noise and potential stale code.

---

## 2. END-TO-END TESTING STRATEGY

### 2.1 Test Execution Order

Run all tests in this exact sequence. Never skip a level.

```
Level 1: Static Analysis
  → flutter analyze (must return 0 issues)
  → dart analyze (must return 0 issues)

Level 2: Unit Tests
  → flutter test --timeout 60s test/unit/

Level 3: Widget Tests
  → flutter test --timeout 60s test/widget/

Level 4: Integration Tests (requires connected device)
  → flutter test integration_test/ --timeout 300s

Level 5: Manual Device Testing (Android physical device)
  → Full flow walkthrough per Section 3

Level 6: Manual Device Testing (iOS physical device or simulator)
  → Full flow walkthrough per Section 3

Level 7: Release Build Verification
  → flutter build appbundle --release
  → flutter build ipa --release
```

### 2.2 Required Test Files

Create or verify every file below exists in `test/` with full implementations.

```
test/
├── unit/
│   ├── repositories/
│   │   ├── video_repository_test.dart        (10 test cases)
│   │   ├── history_repository_test.dart      (4 test cases)
│   │   ├── playlist_repository_test.dart     (4 test cases)
│   │   ├── bookmark_repository_test.dart     (3 test cases)
│   │   ├── download_repository_test.dart     (4 test cases)
│   │   ├── like_repository_test.dart         (3 test cases)
│   │   ├── comment_repository_test.dart      (3 test cases)
│   │   ├── app_config_repository_test.dart   (4 test cases)
│   │   └── profile_repository_test.dart      (3 test cases)
│   └── blocs/
│       ├── home_feed_bloc_test.dart           (6 test cases)
│       ├── search_bloc_test.dart              (8 test cases)
│       ├── settings_bloc_test.dart            (6 test cases)
│       ├── player_bloc_test.dart              (8 test cases)
│       ├── playlist_bloc_test.dart            (5 test cases)
│       ├── download_bloc_test.dart            (4 test cases)
│       ├── like_bloc_test.dart                (3 test cases)
│       └── connectivity_bloc_test.dart        (3 test cases)
├── widget/
│   ├── premium_video_card_test.dart           (10 test cases)
│   ├── shimmer_loading_card_test.dart         (4 test cases)
│   ├── empty_state_widget_test.dart           (8 test cases)
│   ├── error_state_widget_test.dart           (3 test cases)
│   └── gradient_button_test.dart             (4 test cases)
└── integration_test/
    ├── first_launch_flow_test.dart
    ├── video_playback_flow_test.dart
    ├── playlist_creation_flow_test.dart
    ├── settings_clear_history_test.dart
    └── offline_connectivity_test.dart
```

### 2.3 Complete Unit Test Specifications

#### `video_repository_test.dart` — All 10 Cases
```dart
test('initializeSeedData creates exactly 60 videos');
test('getVideosByCategory returns only videos matching that category');
test('searchVideos returns results for partial title match');
test('searchVideos excludes requiresAgeVerification videos when isAgeVerified is false');
test('getPaginatedVideos returns correct page size of 10 by default');
test('getRelatedVideos returns videos from the same category');
test('initializeSeedData sets isFeatured true on exactly 6 videos');
test('initializeSeedData sets relatedVideoIds with 4-5 entries per video');
test('each video has a unique id (UUID v4 format)');
test('category distribution is exact: Action=10,Comedy=8,Drama=8,Doc=7,Music=7,Sports=6,Tech=7,Travel=7');
```

#### `history_repository_test.dart` — All 4 Cases
```dart
test('addOrUpdateHistory creates new entry if video not in history');
test('addOrUpdateHistory updates existing entry and increments watchCount');
test('clearAllHistory empties the history box');
test('getHistory returns at most limit number of entries ordered by watchedAt desc');
```

#### `playlist_repository_test.dart` — All 4 Cases
```dart
test('createPlaylist generates a UUID v4 id');
test('addVideoToPlaylist increments Playlist.videoCount in Hive');
test('reorderPlaylistItems updates all position fields correctly in sequence 0,1,2...');
test('deletePlaylist removes the playlist AND all its PlaylistItems from playlist_items_box');
```

#### `home_feed_bloc_test.dart` — All 6 Cases
```dart
blocTest('emits [Loading, Loaded] when LoadHomeFeed succeeds');
blocTest('emits [Loading, Error] when VideoRepository throws');
blocTest('Loaded.featuredVideos contains only isFeatured==true videos');
blocTest('Loaded.continueWatching contains only videos with progress 0.0 < p < 0.9');
blocTest('Loaded.trendingNow contains only isTrending==true videos');
blocTest('Loaded.recommendedForYou filters by UserProfile.interests');
```

#### `search_bloc_test.dart` — All 8 Cases
```dart
blocTest('emits [Loading, ResultsLoaded] when query matches videos');
blocTest('emits [Loading, Empty] when query matches no videos');
blocTest('debounces rapid SearchQueryChanged events — only fires after 350ms');
blocTest('SearchSubmitted saves query to search_history_box');
blocTest('SearchFiltersApplied filters by duration correctly');
blocTest('SearchFiltersApplied filters by category correctly');
blocTest('SearchCleared returns to SearchIdle with recent searches');
blocTest('UndoSearchHistoryRemoval restores the last removed entry');
```

#### `settings_bloc_test.dart` — All 6 Cases
```dart
blocTest('LoadSettings emits SettingsLoaded with correct AppConfig defaults');
blocTest('ToggleAutoPlay inverts autoPlayEnabled and persists to Hive');
blocTest('ClearWatchHistory calls historyRepository.clearAllHistory()');
blocTest('EnableParentalControl saves PIN hash and sets parentalControlEnabled=true');
blocTest('DisableParentalControl with wrong PIN emits ParentalPinError');
blocTest('DisableParentalControl with correct PIN sets parentalControlEnabled=false');
```

#### `player_bloc_test.dart` — All 8 Cases
```dart
blocTest('InitializePlayer emits PlayerReady with correct video');
blocTest('TogglePlayPause flips isPlaying in PlayerReady');
blocTest('SetBrightness clamps value to [0.05, 1.0]');
blocTest('SetVolume clamps value to [0.0, 1.0]');
blocTest('SeekDelta adds delta to currentSeconds clamped to [0, totalSeconds]');
blocTest('ToggleFitMode flips isFillMode');
blocTest('HideControls sets isControlsVisible to false');
blocTest('PlayerCompleted sets progressPercent to 1.0 and isCompleted=true in history');
```

#### `premium_video_card_test.dart` — All 10 Cases
```dart
testWidgets('renders video title text');
testWidgets('renders thumbnail via CachedNetworkImage');
testWidgets('shows progress bar when progressPercent is 0.0 < p < 0.9');
testWidgets('shows completed overlay when progressPercent >= 0.9');
testWidgets('shows NEW badge when isNew is true');
testWidgets('shows HD badge when isHD is true');
testWidgets('bookmark icon is filled when isBookmarked is true');
testWidgets('onTap callback fires on single tap');
testWidgets('onLongPress callback fires on long press');
testWidgets('onDoubleTap callback fires on double tap');
```

### 2.4 Integration Test Specifications

#### `first_launch_flow_test.dart`
```dart
// Steps:
// 1. Clear all Hive boxes
// 2. Launch app
// 3. Expect SplashPage renders
// 4. Expect AgeGatePage pushes automatically
// 5. Attempt back press — expect app does NOT navigate back
// 6. Scroll year picker to age 25
// 7. Tap 'Confirm My Age'
// 8. Expect OnboardingPage renders (page 1)
// 9. Swipe to page 3
// 10. Tap 3 interest chips
// 11. Tap 'Get Started'
// 12. Expect HomePage renders with HomeFeed tab active
// 13. Force-kill and relaunch
// 14. Expect HomePage renders directly (no age gate)
```

#### `video_playback_flow_test.dart`
```dart
// Steps:
// 1. Start on HomePage
// 2. Find first PremiumVideoCard
// 3. Tap it
// 4. Expect VideoPlayerPage renders
// 5. Expect player controls visible
// 6. Wait 4 seconds
// 7. Expect controls auto-hidden
// 8. Tap screen
// 9. Expect controls visible again
// 10. Tap back button
// 11. Expect return to HomePage
// 12. Verify WatchHistoryEntry exists in history_box for the video
```

#### `playlist_creation_flow_test.dart`
```dart
// Steps:
// 1. Navigate to Library tab → Playlists
// 2. Expect EmptyStateWidget with playlists type
// 3. Tap FAB or '+' button
// 4. Expect Create Playlist sheet opens
// 5. Enter name 'Test Playlist'
// 6. Select first color chip
// 7. Tap 'Create'
// 8. Expect playlist card appears
// 9. Long-press any video card on Home
// 10. Tap 'Add to Playlist'
// 11. Select 'Test Playlist'
// 12. Expect success snackbar
// 13. Navigate to playlist
// 14. Expect video appears in list
// 15. Swipe video item left
// 16. Expect delete action reveals
// 17. Tap delete
// 18. Expect video removed
```

---

## 3. FRONTEND DEBUG AUDIT — ALL 32 SCREENS

For each screen, the agent must open the file, run it on a device, and verify every item listed. Fix every failure immediately.

---

### 3.1 SplashPage (`lib/features/home/presentation/pages/splash_page.dart`)

**Debug checklist:**
- [ ] Background is exactly `Color(0xFF0A0A0A)` — not black87, not Colors.black.
- [ ] Rotating gradient ring animation plays at 2-second duration, loops indefinitely.
- [ ] `_rotationController` is disposed in `dispose()` — verify with Flutter DevTools memory tab.
- [ ] Logo image loads from `assets/images/splash_icon.png` — no 404 asset error in debug console.
- [ ] Wordmark loads from `assets/images/splash_logo.png` — no 404 error.
- [ ] Routing fires after exactly 1800ms — not sooner, not later.
- [ ] Routing logic priority is correct: `hasAcceptedTerms==false` → `/age-gate` first, `isFirstLaunch==true` → `/onboarding` second, else → `/home`.
- [ ] No `setState` called after `dispose` error in console.
- [ ] `SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)` is called on entry and `SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge)` is restored on exit.

**Common bug:** Timer in initState not cancelled if widget disposes before 1800ms (e.g., hot restart). Fix:
```dart
Timer? _timer;

@override
void initState() {
  super.initState();
  _rotationController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  _timer = Timer(const Duration(milliseconds: 1800), _navigate);
}

@override
void dispose() {
  _timer?.cancel();
  _rotationController.dispose();
  super.dispose();
}
```

---

### 3.2 AgeGatePage (`lib/features/age_gate/presentation/pages/age_gate_page.dart`)

**Debug checklist:**
- [ ] `PopScope(canPop: false)` wraps the entire Scaffold — back button completely blocked.
- [ ] Year picker scrolls from `DateTime.now().year - 100` to `DateTime.now().year`.
- [ ] Year picker uses `FixedExtentScrollController` with `ListWheelScrollView` — snap physics enabled.
- [ ] Age calculation updates live as user scrolls — not only on scroll end.
- [ ] "You are X years old" label updates reactively using `setState`.
- [ ] "Confirm My Age" button is disabled (gray, non-tappable) until a year is selected.
- [ ] Age < 13 → dialog with SystemNavigator.pop() — NOT Navigator.pop() or snackbar.
- [ ] Age 13–17 → `AppConfig.hasAcceptedAgeGate=true`, `UserProfile.isAgeVerified=false`.
- [ ] Age 18+ → `AppConfig.hasAcceptedAgeGate=true`, `UserProfile.isAgeVerified=true`.
- [ ] Terms link pushes `/terms` without popping the age gate (use `context.push()` not `context.go()`).
- [ ] Privacy link pushes `/privacy` without popping the age gate.
- [ ] Both legal screens show the "I Accept" bottom bar when opened from this flow.
- [ ] After both accepted and age confirmed, routes to `/onboarding` if `isFirstLaunch==true`.

**Critical bug to check:** If `AppConfigRepository.getConfig()` returns null on first launch instead of a default `AppConfig`, the age gate will throw a null pointer. Verify:
```dart
AppConfig getConfig() {
  return _box.get('config') ?? AppConfig.defaults();
}
```
`AppConfig.defaults()` must be a factory constructor returning all default field values.

---

### 3.3 OnboardingPage (`lib/features/onboarding/presentation/pages/onboarding_page.dart`)

**Debug checklist:**
- [ ] PageView has exactly 3 pages — no more, no fewer.
- [ ] Page indicator dots update correctly on each page transition.
- [ ] "Skip" button visible on pages 1 and 2 — routes directly to `/home`, sets `isFirstLaunch=false`.
- [ ] Page 1 shows `onboarding_stream.png` at 240dp height.
- [ ] Page 2 shows `onboarding_library.png` at 240dp height.
- [ ] Page 3 shows exactly 15 interest chips with emoji prefixes.
- [ ] Interest chips use `FilterChip` — selected state has gradient border, unselected has `colorSurface3` background.
- [ ] "Get Started" button disabled until 3+ chips selected.
- [ ] On confirm: writes to `UserProfile.interests`, sets `AppConfig.isFirstLaunch=false`, routes to `/home`.
- [ ] Images load without overflow on small screen sizes (test on 5" device or iPhone SE).
- [ ] No `RenderFlex overflowed` errors in console.

---

### 3.4 TermsPage & PrivacyPolicyPage

**Debug checklist:**
- [ ] "I Accept" bottom bar ONLY shows when `showAcceptBar: true` is passed as a parameter — not when opened from Settings.
- [ ] "I Accept" tap sets the correct `AppConfig` field and calls `context.pop()`.
- [ ] Text is scrollable on all device sizes — no content clipped at bottom.
- [ ] "Last Updated" date is present and correctly formatted.
- [ ] All section headings are in `textTitleLarge`.
- [ ] Body text is in `textBodyMedium` with 1.6 line height.
- [ ] Back button works correctly when `showAcceptBar: false`.

---

### 3.5 HomePage (`lib/features/home/presentation/pages/home_page.dart`)

**Debug checklist:**
- [ ] `IndexedStack` preserves scroll position when switching tabs — scroll down on Home, switch to Discover, switch back — should still be scrolled.
- [ ] AppBar is transparent with `BackdropFilter` blur — not a solid color.
- [ ] AppBar title shows "StreamPro" wordmark image only on Tab 0 — other tabs show their tab name.
- [ ] Notification bell shows red dot badge when `unreadCount > 0`.
- [ ] VPN icon shows green dot when connected, gray when disconnected.
- [ ] Hamburger icon opens Drawer.
- [ ] BottomNavigationBar selected item uses gradient via `ShaderMask`.
- [ ] Tab switching with horizontal body swipe works (Gesture #5).
- [ ] `MainDrawer` opens and all navigation links work.
- [ ] No bottom overflow on devices with tall navigation bars (iPhone 14+ with home indicator).

**Non-functional elements to fix:**
- VPN icon tap → must navigate to `/vpn` (verify `context.push(AppRoutes.vpn)` is wired).
- Bell icon tap → must navigate to `/notifications`.
- Search icon (non-Discover tabs) → must switch to tab index 1 AND focus the search TextField.

---

### 3.6 HomeFeedView (Tab 0)

**Debug checklist:**
- [ ] `BlocBuilder<HomeFeedBloc, HomeFeedState>` handles all 4 states.
- [ ] Loading state shows `ShimmerCarouselItem` (full-width, 220dp) + 3 `ShimmerVideoCard` rows.
- [ ] Error state shows `ErrorStateWidget` with retry that re-dispatches `LoadHomeFeed()`.
- [ ] Hero carousel auto-advances every 5 seconds — verify with a 6-second wait.
- [ ] Carousel dots update correctly.
- [ ] "Continue Watching" section ONLY appears if history has entries with `0.0 < progressPercent < 0.9`.
- [ ] "Continue Watching" cards show the gradient progress bar at the bottom.
- [ ] Category chips are horizontally scrollable — no wrapping.
- [ ] Category chip tap navigates to `/category/:name`.
- [ ] "See All" on each section navigates to the correct destination.
- [ ] Pull-to-refresh works and shows branded `RefreshIndicator` in `colorPrimary`.
- [ ] `CustomScrollView` with `SliverList` — no `NestedScrollView` conflicts.
- [ ] No `setState() called after dispose()` when navigating away during load.

---

### 3.7 DiscoverView (Tab 1)

**Debug checklist:**
- [ ] `SearchIdle` state: shows recent searches section + "Browse by Category" grid.
- [ ] `SearchLoading` state: shows `ShimmerVideoCard` grid (6 cards for 2-column layout).
- [ ] `SearchResultsLoaded` state: shows paged video grid.
- [ ] `SearchEmpty` state: shows `EmptyStateWidget(EmptyStateType.search)`.
- [ ] `SearchError` state: shows `ErrorStateWidget` with retry.
- [ ] Search field debounce is exactly 350ms — rapid typing should not fire multiple requests.
- [ ] Clear button (X) appears when text is non-empty — clears field and returns to `SearchIdle`.
- [ ] Submit (keyboard action) saves to `search_history_box`.
- [ ] Recent search chips are tappable and populate the search field.
- [ ] Recent search chips have an X to delete — deletion fires `RemoveSearchHistoryEntry`.
- [ ] Filter icon shows a badge with active filter count when filters are applied.
- [ ] Filter bottom sheet opens, applies filters, and dismisses with 350ms animation.
- [ ] "Active filter" chips appear below search bar and are individually dismissible.
- [ ] Pull-to-refresh works when results are showing.
- [ ] Grid pinch-to-zoom changes column count (3→2→1) with AnimatedSwitcher.

---

### 3.8 TrendingView (Tab 2)

**Debug checklist:**
- [ ] Two sub-tabs: "Today" and "This Week" — both functional.
- [ ] Tab switch re-triggers `TrendingBloc` event with the correct period.
- [ ] Loading state shows 5 `ShimmerListTile` rows.
- [ ] Loaded state shows ranked list with rank number in gradient text.
- [ ] Rank numbers are 1–10, gradient-colored, left-aligned in 48dp wide column.
- [ ] Thumbnail is 80×52dp with `radiusSM` (8dp).
- [ ] View count formatted correctly (e.g., "1.2M views").
- [ ] Bookmark icon on each row toggles and persists.
- [ ] Pull-to-refresh works.
- [ ] Empty state handled if no trending videos exist.

---

### 3.9 LibraryView (Tab 3)

**Debug checklist — all 5 sub-tabs:**

**History:**
- [ ] Loading → `ShimmerListTile` × 5.
- [ ] Empty → `EmptyStateWidget(EmptyStateType.history)`.
- [ ] Loaded → chronological list with progress bar overlay on thumbnails.
- [ ] "X ago" timestamp uses `timeago` package.
- [ ] Swipe left reveals red delete action via `flutter_slidable`.
- [ ] Delete action removes entry from `history_box` and updates list.
- [ ] "Clear All History" button opens confirmation dialog before clearing.
- [ ] After clearing, `EmptyStateWidget` appears immediately.

**Bookmarks:**
- [ ] Loading → shimmer grid.
- [ ] Empty → `EmptyStateWidget(EmptyStateType.bookmarks)`.
- [ ] Loaded → `MasonryGridView` 2-column.
- [ ] Long-press on bookmark card → `LongPressContextMenu` opens.
- [ ] "Remove Bookmark" in context menu removes from `bookmarks_box` immediately.

**Downloads:**
- [ ] Storage summary card shows total bytes used, formatted by `DateFormatter.formatFileSize()`.
- [ ] Progress bar on summary card animates as downloads complete.
- [ ] Each download item shows correct status badge color.
- [ ] Downloading items show animated progress bar (not static).
- [ ] Completed items show expiry countdown "Expires in X days".
- [ ] Swipe-to-delete removes from `downloads_box`.
- [ ] FAB navigates back to home screen.
- [ ] Empty → `EmptyStateWidget(EmptyStateType.downloads)`.

**Playlists:**
- [ ] Empty → `EmptyStateWidget(EmptyStateType.playlists)`.
- [ ] Grid shows playlist cover thumbnail from first video in playlist.
- [ ] User-selected accent color appears as border on playlist card.
- [ ] "+" FAB opens Create Playlist bottom sheet.
- [ ] Create sheet validates: name required, max 50 chars, max 20 playlists.
- [ ] Color picker has exactly 6 preset colors as tappable circles.
- [ ] New playlist immediately appears in grid after creation.

**Liked:**
- [ ] Empty → `EmptyStateWidget(EmptyStateType.liked)`.
- [ ] Grid shows only videos where `LikeRecord.reaction == 'like'`.
- [ ] Unliking a video from the player or card removes it from this grid.

---

### 3.10 VideoPlayerPage (`lib/features/player/presentation/pages/video_player_page.dart`)

**Debug checklist:**
- [ ] System UI hidden: `SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky)` called on init.
- [ ] `WakelockPlus.enable()` called on init — screen does not sleep during playback.
- [ ] `InAppWebView` fills the entire screen — no black bars, no white borders.
- [ ] Controls overlay auto-hides after 3 seconds — verified with stopwatch.
- [ ] Controls reappear on any screen tap.
- [ ] Auto-hide timer resets on any interaction — not just taps.
- [ ] Top bar shows: back button (gradient circle), video title (truncated), cast icon, share icon.
- [ ] Center shows: Previous, Play/Pause (large), Next — all tappable.
- [ ] Bottom bar shows: current time, progress bar, total time, quality selector, subtitles toggle, fullscreen toggle.
- [ ] Progress bar is custom `VideoProgressBar` (`CustomPainter`) — not a default `Slider`.
- [ ] Share icon fires `share_plus` with video title and a placeholder URL.
- [ ] Cast icon navigates to `/cast`.
- [ ] Back button pops route and restores system UI.
- [ ] Related videos sheet (swipe-up) shows correct related videos from `relatedVideoIds`.
- [ ] Comments sheet tab shows comments from `comments_box`.
- [ ] "Add Comment" field is keyboard-aware.
- [ ] `dispose()` cancels ALL timers, restores brightness, disables wakelock, resets orientation, resets system UI mode.
- [ ] No memory leak: open player 5 times and navigate back — DevTools memory graph must not stair-step up.

**Dispose method — must contain ALL of these:**
```dart
@override
void dispose() {
  _autoHideTimer?.cancel();
  _progressTimer?.cancel();
  _webViewController?.stopLoading();
  _rotationController?.dispose();
  _brightnessChannel.restoreSystemBrightness();
  WakelockPlus.disable();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  super.dispose();
}
```

---

### 3.11 VPN Status Screen

**Debug checklist:**
- [ ] Connection status reads from `VpnBloc` state — not hardcoded.
- [ ] Shield illustration switches between `vpn_connected.png` and `vpn_connecting.png` with `AnimatedSwitcher`.
- [ ] "Auto-Connect" toggle is wired to `AppConfig.isVpnEnabled`.
- [ ] Country list shows all 20 countries from Appendix C with correct flag emojis and ping values.
- [ ] Tapping a country fires `VpnBloc.ConnectToCountryEvent`.
- [ ] Currently selected country has gradient left border.
- [ ] Ping badge is visible on each country row.
- [ ] 3 info cards (IP Protection, No Logs, 256-bit) are present and styled.

---

### 3.12 Profile Screen & Edit Profile

**Debug checklist:**
- [ ] `ProfileBloc.add(SyncProfileStats())` called in `initState` — not in `build()`.
- [ ] Stats row shows correct values from Hive (watched count, total watch time, liked count).
- [ ] Watch time formatted as "Xh Ym" using `DateFormatter.formatWatchTime()`.
- [ ] Avatar shows initials gradient circle when no custom avatar set.
- [ ] "Edit" icon in AppBar navigates to `/profile/edit`.
- [ ] Edit Profile form: name field validates non-empty, max 30 chars.
- [ ] Edit Profile interest chips: pre-selected with current `UserProfile.interests`.
- [ ] "Save" writes to Hive and pops back — profile screen reflects new values immediately.
- [ ] Image picker integration: tapping avatar opens photo library.

---

### 3.13 Settings Screen

**Debug checklist — every item must be functional:**
- [ ] "Playback Settings" → navigates to `/settings/playback`.
- [ ] "Parental Controls" → navigates to `/settings/parental`.
- [ ] "Privacy Policy" → pushes `/privacy` without accept bar.
- [ ] "Terms of Service" → pushes `/terms` without accept bar.
- [ ] "Clear Watch History" → confirmation dialog → `HistoryRepository.clearAllHistory()` → snackbar "History cleared".
- [ ] "Clear Image Cache" → `DefaultCacheManager().emptyCache()` (from `flutter_cache_manager`) — not a no-op.
- [ ] "Clear All Downloads" → confirmation dialog → `DownloadRepository.clearAllDownloads()`.
- [ ] "App Version" → reads from `PackageInfo.fromPlatform()` — not hardcoded string.
- [ ] "Rate the App" → `launchUrl(Uri.parse('market://details?id=com.streampro.app'))` on Android, App Store URL on iOS.
- [ ] "Share App" → `Share.share('Check out StreamPro! [URL]')`.
- [ ] "Help & FAQ" → navigates to `/help`.
- [ ] "About StreamPro" → navigates to `/about`.

---

### 3.14 Playback Settings Screen

**Debug checklist:**
- [ ] All 6 items read their initial value from `AppConfig` via `SettingsBloc`.
- [ ] Every toggle write is immediately persisted to Hive — verify by killing and relaunching app.
- [ ] Quality dropdown: options are exactly Auto, 1080p, 720p, 480p, 360p.
- [ ] "Keep Screen On" toggle calls `WakelockPlus.enable()`/`disable()` immediately.

---

### 3.15 Parental Control Screen

**Debug checklist:**
- [ ] Three states render correctly: Disabled, Setup (entering PIN), Enabled.
- [ ] PIN number pad has digits 0–9 plus backspace — all tappable, 48×48dp minimum touch target.
- [ ] 4 dot indicators fill as PIN is entered.
- [ ] "Confirm PIN" step re-shows the number pad with new instructions.
- [ ] PIN mismatch: dots shake animation (translate x ±4dp, 3 cycles, 400ms) + `HeavyImpact` haptic + "Incorrect PIN" label.
- [ ] PIN match: saves to `AppConfig.parentalPin`, sets `parentalControlEnabled=true`, transitions to Enabled state.
- [ ] 3 wrong attempts during disable flow → 30-second lockout with visible countdown timer.
- [ ] "Disable Parental Controls" in Enabled state requires correct PIN entry.
- [ ] R-rated video playback intercepted when `parentalControlEnabled==true`: PIN dialog appears before player opens.

---

### 3.16 Notification Center Screen

**Debug checklist:**
- [ ] Loading → `ShimmerNotificationItem` × 5.
- [ ] Empty → `EmptyStateWidget(EmptyStateType.notifications)`.
- [ ] Loaded → notification cards ordered by `createdAt` descending.
- [ ] Unread notifications have elevated `colorSurface2` background.
- [ ] Read notifications have `colorSurface` background.
- [ ] Unread blue dot visible on right side of unread items.
- [ ] Tap marks as read and navigates to `actionRoute` if set.
- [ ] Swipe-to-delete works.
- [ ] "Mark All Read" action in AppBar marks all and removes all blue dots.
- [ ] AppBar bell badge count updates to 0 after "Mark All Read".

---

### 3.17 Downloads Screen

**Debug checklist:**
- [ ] Storage summary progress bar is not static — it reflects actual `getTotalStorageUsedBytes()`.
- [ ] Downloading items: progress bar animates (not frozen at 0% or 100%).
- [ ] Status badge uses `StatusBadge` widget with correct color per status:
  - `queued` → gray
  - `downloading` → amber
  - `completed` → green
  - `failed` → red
  - `paused` → gray with pause icon
- [ ] Completed items: "Expires in X days" visible in `colorWarning`.
- [ ] Swipe-to-delete removes from `downloads_box` and `DownloadBloc` emits updated list.
- [ ] Download simulation completes (reaches 100%) within 20 seconds — verify timer fires correctly.
- [ ] Local notification fires on completion.
- [ ] "Download New Videos" FAB navigates to home.

---

### 3.18 Playlists Screen & Detail

**Debug checklist:**
- [ ] Playlist cover thumbnail loads from the first video's `thumbnailUrl` in the playlist.
- [ ] Cover updates when first video changes (reorder or add).
- [ ] Video count badge on card matches actual `PlaylistItem` count in Hive.
- [ ] Tapping playlist card navigates to `/playlists/:id` with correct playlist ID.
- [ ] PlaylistDetailPage header: cover image, name, description, video count.
- [ ] "Play All" button: plays the first video, then autoplay triggers next (if `autoPlayNextEnabled`).
- [ ] "Shuffle" button: randomizes order and plays first.
- [ ] `ReorderableListView`: drag handle visible and functional on every item.
- [ ] After drag: `PlaylistItem.position` values are updated in `playlist_items_box` in Hive.
- [ ] Swipe-to-delete removes item and updates `Playlist.videoCount`.
- [ ] 3-dot menu: Rename (opens bottom sheet), Delete Playlist (confirmation dialog), Share.
- [ ] Delete playlist: removes playlist AND all its PlaylistItems — verify both boxes.

---

### 3.19 Liked Videos Screen

**Debug checklist:**
- [ ] Grid only shows videos where `LikeRecord.reaction == 'like'`.
- [ ] Unliking from player or card causes real-time removal from this screen's grid.
- [ ] `LikeBloc` is not a factory for this screen — it should be the singleton instance.
- [ ] Video count in AppBar subtitle updates when videos are liked/unliked.

---

### 3.20 Category Grid & Category Feed

**Debug checklist:**
- [ ] Category grid shows exactly 8 cards in 2-column layout.
- [ ] Each card uses the correct gradient colors from `categoryMetaMap`.
- [ ] Background icon (large, 12% opacity) positioned at bottom-right of each card.
- [ ] Foreground icon (36×36, white) visible at top-left.
- [ ] Video count badge shows correct count from `VideoRepository.getVideosByCategory()`.
- [ ] Tap navigates to `/category/:name` with correct category name.
- [ ] Category Feed shows 5 sub-tab filter chips: All, New, Most Viewed, Shortest, Longest.
- [ ] Each filter chip re-queries and updates the grid.
- [ ] Filter icon in AppBar opens `AdvancedSearchFilterSheet`.
- [ ] Infinite scroll pagination works — loads more videos on scroll to bottom.
- [ ] `EndOfListWidget` appears when all videos are loaded.

---

### 3.21 Help & FAQ Screen

**Debug checklist:**
- [ ] Exactly 4 category groups present: Getting Started, Playback, Library, Privacy.
- [ ] All 10 Q&A pairs from PRD Appendix D present as `ExpansionTile` widgets.
- [ ] "Contact Us" footer link fires `launchUrl(Uri.parse('mailto:support@streampro.app'))`.
- [ ] ExpansionTile animation is smooth — no jank on expand/collapse.
- [ ] Body text uses `textBodyMedium` in `colorTextSecondary`.

---

### 3.22 About Screen

**Debug checklist:**
- [ ] App version reads from `PackageInfo.fromPlatform().version` — NOT hardcoded.
- [ ] Build number reads from `PackageInfo.fromPlatform().buildNumber`.
- [ ] "Open Source Licenses" → `showLicensePage(context: context)`.
- [ ] "Rate the App" → platform-specific store URL.
- [ ] "Share App" → `Share.share()`.
- [ ] "Made with ♥ using Flutter" credit at bottom.

---

### 3.23 Cast Screen

**Debug checklist:**
- [ ] Shows exactly 3 simulated devices: "Living Room TV", "Bedroom Display", "Kitchen Screen".
- [ ] Each device has cast icon, name, and signal strength bars.
- [ ] Tapping a device shows "Cast Started — Streaming to [Device Name]" snackbar.
- [ ] "Chromecast and AirPlay support coming soon" note visible at bottom.
- [ ] No loading state needed — devices appear immediately.

---

### 3.24 Offline Screen (ConnectivityOverlay)

**Debug checklist:**
- [ ] `ConnectivityOverlay` wraps entire app in `MaterialApp.router` builder.
- [ ] `ConnectivityBloc` stream reacts within 1 second of network change.
- [ ] Overlay appears over EVERY screen — not just home.
- [ ] "Try Again" button re-checks connectivity — does not just dismiss.
- [ ] When connectivity restored: overlay fades out (200ms), "Back Online ✓" green snackbar appears.
- [ ] Snackbar duration is exactly 2 seconds.
- [ ] Overlay uses `OverlayEntry` — not a separate route push.

---

## 4. NAVIGATION & ROUTING DEBUG AUDIT

### 4.1 GoRouter Configuration Verification

Open `lib/core/routes/app_router.dart` and verify:

**Redirect guard logic — must follow this exact order:**
```dart
redirect: (context, state) {
  final config = sl<AppConfigRepository>().getConfig();
  final location = state.matchedLocation;

  final isOnLegalFlow = location == AppRoutes.ageGate ||
      location == AppRoutes.terms ||
      location == AppRoutes.privacy ||
      location == AppRoutes.splash;

  // Gate 1: Legal acceptance
  if (!config.hasAcceptedTerms && !isOnLegalFlow) {
    return AppRoutes.ageGate;
  }

  // Gate 2: Onboarding
  if (config.hasAcceptedTerms && config.isFirstLaunch &&
      location != AppRoutes.onboarding && !isOnLegalFlow) {
    return AppRoutes.onboarding;
  }

  return null; // No redirect needed
},
```

**Verify no redirect loops exist:**
- `/age-gate` must NOT redirect to itself.
- `/terms` must NOT redirect to `/age-gate` (it is in the legal flow exclusion list).
- `/onboarding` must NOT redirect to `/age-gate` after terms are accepted.

**Verify all 32 routes are registered:**
Run this terminal command and confirm all route paths are present:
```bash
grep -n "GoRoute(path:" lib/core/routes/app_router.dart | wc -l
```
Count must be at least 22 (some screens are modals, not routes).

**Verify `/player` receives `VideoEntity` correctly:**
```dart
GoRoute(
  path: AppRoutes.player,
  pageBuilder: (context, state) {
    final video = state.extra as VideoEntity?;
    if (video == null) return _errorPage(state); // graceful fallback
    return _fadeTransition(state, VideoPlayerPage(video: video));
  },
),
```

**Verify no screen uses `Navigator.of(context).push()` or `pushNamed()`:**
```bash
grep -rn "Navigator.of" lib/features/ | grep -v "_test.dart"
grep -rn "pushNamed" lib/features/ | grep -v "_test.dart"
grep -rn "pushReplacementNamed" lib/features/ | grep -v "_test.dart"
```
All three commands must return zero results.

### 4.2 Navigation Flow Verification

Test every navigation path manually:

| From | Action | Expected Destination |
|---|---|---|
| SplashPage | Auto (fresh install) | AgeGatePage |
| SplashPage | Auto (returning user) | HomePage |
| AgeGatePage | Confirm age | OnboardingPage |
| OnboardingPage | Get Started | HomePage |
| HomePage Drawer | Profile | ProfilePage |
| HomePage Drawer | Playlists | PlaylistsPage |
| HomePage Drawer | Downloads | DownloadsPage |
| HomePage Drawer | Liked Videos | LikedVideosPage |
| HomePage Drawer | VPN Status | VpnStatusScreen |
| HomePage Drawer | Settings | SettingsPage |
| HomePage Drawer | Help & FAQ | HelpFaqPage |
| HomePage Drawer | About | AboutPage |
| HomePage Drawer | Privacy Policy | PrivacyPolicyPage (no accept bar) |
| HomePage Drawer | Terms of Service | TermsPage (no accept bar) |
| HomePage AppBar | Bell icon | NotificationsPage |
| HomePage AppBar | VPN icon | VpnStatusScreen |
| HomeFeedView | Video card tap | VideoPlayerPage |
| HomeFeedView | Category chip | CategoryFeedPage |
| HomeFeedView | "See All" Trending | Trending Tab |
| VideoPlayerPage | Back | Previous screen |
| VideoPlayerPage | Cast icon | CastPage |
| SettingsPage | Playback Settings | PlaybackSettingsPage |
| SettingsPage | Parental Controls | ParentalControlPage |
| ProfilePage | Edit icon | EditProfilePage |
| PlaylistsPage | Playlist card | PlaylistDetailPage |

---

## 5. BUSINESS LOGIC & BLOC DEBUG AUDIT

### 5.1 BLoC Registration Audit

Open `lib/core/di/injection.dart`. Verify EVERY BLoC is registered with the correct scope:

**Singletons (global state — one instance for app lifetime):**
```dart
sl.registerLazySingleton<VpnBloc>(() => VpnBloc(sl()));
sl.registerLazySingleton<NotificationBloc>(() => NotificationBloc(sl()));
sl.registerLazySingleton<SettingsBloc>(() => SettingsBloc(sl()));
sl.registerLazySingleton<ProfileBloc>(() => ProfileBloc(sl()));
sl.registerLazySingleton<ConnectivityBloc>(() => ConnectivityBloc(sl()));
sl.registerLazySingleton<PipBloc>(() => PipBloc());
sl.registerLazySingleton<LikeBloc>(() => LikeBloc(sl()));
```

**Factories (new instance per screen):**
```dart
sl.registerFactory<VideoListBloc>(() => VideoListBloc(sl()));
sl.registerFactory<HomeFeedBloc>(() => HomeFeedBloc(sl(), sl()));
sl.registerFactory<SearchBloc>(() => SearchBloc(sl(), sl()));
sl.registerFactory<TrendingBloc>(() => TrendingBloc(sl()));
sl.registerFactory<PlayerBloc>(() => PlayerBloc(sl(), sl(), sl()));
sl.registerFactory<PlaylistBloc>(() => PlaylistBloc(sl()));
sl.registerFactory<DownloadBloc>(() => DownloadBloc(sl(), sl()));
sl.registerFactory<CommentBloc>(() => CommentBloc(sl()));
sl.registerFactory<FilterBloc>(() => FilterBloc());
```

**Critical:** `LikeBloc` must be a singleton because liked state must be consistent across the card grid, player, and liked videos screen simultaneously. If it is a factory, liking from the player won't update the card grid.

### 5.2 BLoC Close Audit

Every `BlocProvider` that creates a factory BLoC must have the BLoC closed when the route is popped. Verify:
```dart
// Correct pattern for screen-scoped BLoC:
BlocProvider(
  create: (_) => sl<PlaylistBloc>()..add(LoadPlaylists()),
  child: const PlaylistsPage(),
)
// BlocProvider automatically calls bloc.close() when the widget tree removes it.
// Verify the BLoC is NOT closed manually in dispose() as well — double-close causes errors.
```

### 5.3 State Mutation Safety

Every repository write must be followed by a BLoC state update. Audit these specific patterns:

**After `BookmarkRepository.addBookmark()`:**
- `LikeBloc` should NOT need to update (different box).
- The `PremiumVideoCard` uses `BlocBuilder<LikeBloc>` for like state and `StreamBuilder` or a separate `BookmarkBloc` for bookmark state. If bookmark state is managed locally in the card's `StatefulWidget`, it will not update in other instances of the same card. Fix: use a global bookmark state similar to `LikeBloc`.

**Add `BookmarkBloc` as a singleton:**
```dart
sl.registerLazySingleton<BookmarkBloc>(() => BookmarkBloc(sl()));
```

**After `HistoryRepository.addOrUpdateHistory()`:**
- `HomeFeedBloc` must reload `continueWatching` section — but only when returning to home, not in real-time (to avoid performance issues).
- Use `BlocListener` on `PlayerBloc` in `HomePage` to trigger `HomeFeedBloc.add(RefreshHomeFeed())` when player state changes to completed.

### 5.4 Error Handling in BLoC Handlers

Every `on<Event>()` handler must wrap its async work in try-catch:
```dart
on<LoadHomeFeed>((event, emit) async {
  emit(HomeFeedLoading());
  try {
    final featured = await _videoRepo.getFeaturedVideos();
    // ... other calls
    emit(HomeFeedLoaded(featured: featured, ...));
  } catch (e, stackTrace) {
    debugPrint('HomeFeedBloc error: $e\n$stackTrace');
    emit(HomeFeedError(e.toString()));
  }
});
```

Run this check to find handlers without try-catch:
```bash
grep -A 5 "on<" lib/features/ -r | grep -B 3 "emit(" | grep -v "try"
```
Every handler found must be wrapped.

---

## 6. LOCAL DATABASE DEBUG AUDIT

### 6.1 Hive Box Initialization Audit

Verify `main.dart` opens boxes in exactly this order before `runApp()`:
```dart
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
```

### 6.2 Data Integrity Verification Script

Add this debug-only verification to `VideoRepository.initializeSeedData()`:
```dart
Future<void> initializeSeedData() async {
  if (_box.isNotEmpty) return; // Already seeded

  final videos = _buildSeedVideos(); // Your 60-video builder

  assert(videos.length == 60, 'Must be exactly 60 videos, got ${videos.length}');

  final categories = videos.map((v) => v.category).toSet();
  assert(categories.length == 8, 'Must have exactly 8 categories');

  final categoryCount = <String, int>{};
  for (final v in videos) categoryCount[v.category] = (categoryCount[v.category] ?? 0) + 1;
  assert(categoryCount['Action'] == 10);
  assert(categoryCount['Comedy'] == 8);
  assert(categoryCount['Drama'] == 8);
  assert(categoryCount['Documentary'] == 7);
  assert(categoryCount['Music'] == 7);
  assert(categoryCount['Sports'] == 6);
  assert(categoryCount['Technology'] == 7);
  assert(categoryCount['Travel'] == 7);

  final featuredCount = videos.where((v) => v.isFeatured).length;
  assert(featuredCount == 6, 'Must have exactly 6 featured videos, got $featuredCount');

  for (final v in videos) {
    assert(v.relatedVideoIds.length >= 4 && v.relatedVideoIds.length <= 5,
        'Video ${v.id} has ${v.relatedVideoIds.length} related videos, must be 4-5');
    assert(v.durationSeconds > 0, 'Video ${v.id} has zero durationSeconds');
    assert(v.thumbnailUrl.contains('picsum.photos'), 'Video ${v.id} has wrong thumbnail URL pattern');
  }

  await compute(_writeVideos, {'box': _box, 'videos': videos});
}
```

### 6.3 Hive Migration Safety

When the app upgrades from version 1.0 to a future version, existing Hive boxes may have fewer fields than the new entity schema. Add migration protection:
```dart
// In AppConfigRepository.getConfig():
AppConfig getConfig() {
  final config = _box.get('config');
  if (config == null) {
    final defaults = AppConfig.defaults();
    _box.put('config', defaults);
    return defaults;
  }
  return config;
}
```

Every `@HiveField` added in a future version must have a default value in the entity class. Hive does not throw on missing fields — it returns null silently, causing NullPointerExceptions in the app.

### 6.4 Box Compaction

Add this to `DatabaseService.init()` to prevent growing box file sizes:
```dart
Future<void> compact() async {
  final boxes = [
    Hive.box<WatchHistoryEntry>('history_box'),
    Hive.box<Comment>('comments_box'),
    Hive.box<AppNotification>('notifications_box'),
    Hive.box<SearchHistoryEntry>('search_history_box'),
  ];
  for (final box in boxes) {
    if (box.length > 100) await box.compact();
  }
}
```

Call `compact()` at the end of `DatabaseService.init()`.

---

## 7. VIDEO PLAYER DEBUG AUDIT

### 7.1 WebView Initialization

```dart
InAppWebView(
  initialSettings: InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,  // Allow autoplay
    allowsInlineMediaPlayback: true,           // iOS: play in page
    allowsAirPlayForMediaPlayback: false,      // Disable AirPlay (use Cast instead)
    useShouldOverrideUrlLoading: true,         // Intercept URL navigation
    javaScriptEnabled: true,
    transparentBackground: true,
    disableContextMenu: true,                  // Prevent right-click/long-press menu
    supportZoom: false,                        // Disable pinch-zoom on WebView itself
    builtInZoomControls: false,
  ),
  onWebViewCreated: (controller) {
    _webViewController = controller;
  },
  onReceivedError: (controller, request, error) {
    context.read<PlayerBloc>().add(PlayerError(error.description));
  },
  shouldOverrideUrlLoading: (controller, action) async {
    // Prevent navigation away from the video page
    return NavigationActionPolicy.CANCEL;
  },
)
```

### 7.2 JavaScript Injection Safety

All JavaScript injections must use `evaluateJavascript()` with error handling:
```dart
Future<void> _injectJS(String script) async {
  try {
    await _webViewController?.evaluateJavascript(source: script);
  } catch (e) {
    debugPrint('JS injection error: $e');
  }
}

// Usage:
await _injectJS("document.querySelector('video')?.play()");
await _injectJS("if(document.querySelector('video')) document.querySelector('video').playbackRate = 2.0");
```

Never use bare `document.querySelector('video').play()` without null-checking — the video element may not exist yet if the page hasn't fully loaded.

### 7.3 Gesture Zone Validation

The three-zone split must be pixel-precise. Add this validation in the gesture detector widget:
```dart
// In PlayerGestureDetector widget:
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      final totalWidth = constraints.maxWidth;
      final leftZoneEnd = totalWidth * 0.40;    // 40%
      final rightZoneStart = totalWidth * 0.60;  // 60%

      return GestureDetector(
        onVerticalDragUpdate: (details) {
          final x = details.localPosition.dx;
          if (x < leftZoneEnd) {
            _handleBrightnessGesture(details);
          } else if (x > rightZoneStart) {
            _handleVolumeGesture(details);
          }
          // Center zone: no vertical drag action
        },
        onHorizontalDragUpdate: (details) {
          final x = details.localPosition.dx;
          if (x >= leftZoneEnd && x <= rightZoneStart) {
            _handleSeekScrub(details);
          }
        },
        // ... other gesture handlers
      );
    },
  );
}
```

### 7.4 Platform Channel Error Recovery

Both platform channels must have fallback behavior when the native side is unavailable:

```dart
// BrightnessChannel fallback:
Future<void> setBrightness(double brightness) async {
  try {
    await _channel.invokeMethod('setBrightness', {'brightness': brightness.clamp(0.05, 1.0)});
  } on MissingPluginException {
    // Use overlay simulation on platforms where channel isn't registered
    _useOverlayBrightness = true;
  } on PlatformException catch (e) {
    debugPrint('Brightness error: ${e.message}');
  }
}
```

If `_useOverlayBrightness == true`, the brightness HUD must still appear and the visual feedback must still work — just use a dark overlay `Container` with opacity instead of actual screen brightness change.

---

## 8. GESTURE SYSTEM DEBUG AUDIT

### 8.1 Gesture Conflict Resolution

Flutter's gesture arena causes conflicts when multiple `GestureDetector` widgets are nested. Audit:

- `PremiumVideoCard` has `onTap`, `onDoubleTap`, `onLongPress` — these conflict with the card's `InkWell`. Use `GestureDetector` (not `InkWell`) when custom gesture handlers are needed.
- The bottom sheets' `DraggableScrollableSheet` drag gesture conflicts with the player's swipe-up gesture. Solution: use `HitTestBehavior.opaque` on the player gesture detector only when the sheet is fully collapsed.
- Horizontal tab swipe gesture on `HomePage` conflicts with `ListView` horizontal scroll in `HomeFeedView`. Solution: only activate the tab swipe when the drag is clearly horizontal (dx > 3 × dy after 20dp of travel) AND the dragged widget is not a scrollable list.

### 8.2 Haptic Feedback Audit

Every gesture must fire the correct haptic. Run this grep and verify:
```bash
grep -rn "HapticFeedback" lib/features/ | wc -l
```

Expected minimum count: 20 (10 global gestures + 10 player gestures).

If count is below 20, find the missing haptics by checking each gesture handler file.

### 8.3 Shake Gesture Reliability

The `sensors_plus` accelerometer implementation must filter out false positives:
```dart
class ShakeDetector {
  static const double _threshold = 25.0;
  static const int _minInterval = 500; // ms between shakes

  DateTime? _lastShake;
  int _shakeCount = 0;

  void onAccelerometerEvent(AccelerometerEvent event) {
    final magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    if (magnitude > _threshold) {
      final now = DateTime.now();
      if (_lastShake == null ||
          now.difference(_lastShake!).inMilliseconds > _minInterval) {
        _shakeCount = 1;
        _lastShake = now;
      } else if (now.difference(_lastShake!).inMilliseconds < _minInterval) {
        _shakeCount++;
        if (_shakeCount >= 2) {
          _shakeCount = 0;
          onShakeDetected();
        }
      }
    }
  }
}
```

The `sensors_plus` subscription must be cancelled in `dispose()` to prevent battery drain.

---

## 9. UI/UX COMPLETENESS — NON-FUNCTIONAL ELEMENTS

### 9.1 Complete Audit of All Buttons and Interactive Elements

Run this search across all feature files:
```bash
grep -rn "onTap: null\|onPressed: null\|onTap: () {}\|onPressed: () {}" lib/features/
grep -rn "// TODO\|Coming Soon\|Not implemented\|placeholder" lib/features/
```

Zero results are acceptable. Any result must be fixed.

### 9.2 Non-Functional Elements Checklist

Verify these specific elements are all wired:

**PremiumVideoCard:**
- [ ] Share icon in long-press context menu fires `share_plus`.
- [ ] "Not Interested" in context menu adds videoId to a local exclusion list and removes card from current feed.
- [ ] Download in context menu triggers `DownloadBloc.add(StartDownload(video, quality))`.
- [ ] "Downloaded" (if already downloaded) tap → navigate to `/downloads`.

**VideoPlayerPage:**
- [ ] Quality selector dropdown changes the embed code quality parameter.
- [ ] Subtitles toggle shows/hides subtitle track if `VideoEntity.subtitleUrl` is non-empty.
- [ ] Previous button navigates to the previous related video.
- [ ] Next button navigates to the next related video.
- [ ] Fullscreen toggle changes orientation to landscape.

**LibraryView:**
- [ ] "Clear All History" button opens confirmation dialog (not immediate action).
- [ ] Each History item tap navigates to the player.
- [ ] Each Bookmark item tap navigates to the player.

**MainDrawer:**
- [ ] All 9 navigation items navigate to their correct routes.
- [ ] Active item has gradient left border.
- [ ] Drawer closes after navigation (not left open behind the new screen).

**SearchView:**
- [ ] "Browse by Category" grid in idle state taps navigate to category.
- [ ] Trending search chips (static) pre-populate the search field.
- [ ] Microphone icon shows "Voice search coming soon" snackbar.

### 9.3 Missing Features to Implement Now

The following features are specified in the PRD but commonly missed in implementation:

**Feature: Not Interested**
Create `NotInterestedService` in `core/services/not_interested_service.dart`:
```dart
class NotInterestedService {
  static const _key = 'not_interested_ids';
  final Box<AppConfig> _box;

  Set<String> getNotInterestedIds() {
    final stored = Hive.box('not_interested_box').get(_key);
    return stored != null ? Set<String>.from(stored) : {};
  }

  Future<void> markNotInterested(String videoId) async {
    final current = getNotInterestedIds();
    current.add(videoId);
    await Hive.box('not_interested_box').put(_key, current.toList());
  }
}
```

Add `not_interested_box` to the Hive initialization list. Filter this set in `VideoRepository.getPaginatedVideos()`.

**Feature: Auto-Play Next Video**
In `PlayerBloc`, when `UpdateProgress` reaches `progressPercent >= 0.95` AND `AppConfig.autoPlayNextEnabled == true`:
```dart
if (state is PlayerReady && event.currentSeconds / state.totalSeconds >= 0.95) {
  if (_appConfigRepo.getConfig().autoPlayNextEnabled) {
    final related = await _videoRepo.getRelatedVideos(state.video.id);
    if (related.isNotEmpty) {
      emit(PlayerReady(video: related.first, isPlaying: true, ...));
    }
  }
}
```

**Feature: Video Resume**
When navigating to the player, check `HistoryRepository.getHistoryEntry(videoId)`. If entry exists and `progressPercent > 0.05`, inject a seek JavaScript command after the WebView loads:
```dart
onLoadStop: (controller, url) async {
  final entry = _historyRepo.getHistoryEntry(widget.video.id);
  if (entry != null && entry.watchedDurationSeconds > 30) {
    await Future.delayed(const Duration(seconds: 1));
    await _injectJS(
      "var v = document.querySelector('video'); if(v) v.currentTime = ${entry.watchedDurationSeconds};"
    );
  }
},
```

**Feature: Notification Triggers**
Implement all 4 trigger-based notifications from PRD Feature 7 in `NotificationService`:
```dart
class NotificationTriggerService {
  // Trigger 1: First launch
  Future<void> onFirstLaunch() async {
    await _addNotification(AppNotification(
      type: 'system',
      title: 'Welcome to StreamPro!',
      body: 'Start exploring thousands of free videos.',
    ));
  }

  // Trigger 2: After watching 5 videos
  Future<void> onVideoWatched(int totalWatched) async {
    if (totalWatched == 5) {
      await _addNotification(AppNotification(
        type: 'trending',
        title: '🔥 You\'re on a roll!',
        body: 'Check out today\'s trending videos.',
        actionRoute: '/home',
      ));
    }
  }

  // Trigger 3: After creating first playlist
  Future<void> onPlaylistCreated() async {
    await _addNotification(AppNotification(
      type: 'system',
      title: 'Playlist created!',
      body: 'Keep adding your favorites.',
      actionRoute: '/playlists',
    ));
  }

  // Trigger 4: App resume after 24+ hours
  Future<void> onAppResume(DateTime lastOpenedAt) async {
    final hoursSinceOpen = DateTime.now().difference(lastOpenedAt).inHours;
    if (hoursSinceOpen >= 24) {
      await _addNotification(AppNotification(
        type: 'new_video',
        title: 'New videos added this week.',
        body: 'Don\'t miss out!',
        actionRoute: '/home',
      ));
    }
  }
}
```

Call these triggers at the appropriate points: trigger 1 in `OnboardingPage.onGetStarted()`, trigger 2 in `HistoryRepository.addOrUpdateHistory()` (check total count), trigger 3 in `PlaylistRepository.createPlaylist()`, trigger 4 in `AppLifecycleObserver` when `AppLifecycleState.resumed` fires.

---

## 10. MOCK DATA & PLACEHOLDER ELIMINATION

### 10.1 Complete Audit of All Fake/Mock/Placeholder Data

Run these searches and fix every result:

```bash
# Find hardcoded version strings
grep -rn '"1.0.0"\|"1.0"\|"Build 1"' lib/ | grep -v "_test.dart"

# Find TODO and placeholder text
grep -rn "TODO\|FIXME\|placeholder\|dummy\|fake\|mock\|test data" lib/ | grep -v "_test.dart"

# Find Lorem ipsum
grep -rn "Lorem\|lorem" lib/

# Find hardcoded names that should be dynamic
grep -rn '"John Doe"\|"Jane Doe"\|"User"\|"Username"' lib/ | grep -v "_test.dart"

# Find hardcoded email addresses
grep -rn '@example.com\|@test.com' lib/ | grep -v "_test.dart"

# Find static notification counts
grep -rn "unreadCount: [0-9]" lib/ | grep -v "_test.dart"
```

### 10.2 Items to Replace

| Mock Item | Replace With |
|---|---|
| Hardcoded version "1.0.0" | `PackageInfo.fromPlatform().version` |
| Static "3 notifications" badge | `NotificationBloc.unreadCount` |
| Hardcoded "2.4 GB used" in Downloads | `DownloadRepository.getTotalStorageUsedBytes()` |
| Static "1,234 views" on videos | `VideoEntity.viewCount` formatted by `DateFormatter.formatViewCount()` |
| Hardcoded "John Doe" profile name | `UserProfile.displayName` |
| Static timestamp "2 hours ago" | `timeago.format(DateTime.parse(entry.watchedAt))` |
| Hardcoded "Support@streampro.app" | Configurable constant in `AppConstants` |
| Static download speed "1.2 MB/s" | `DownloadSimulationService` randomized value |
| Empty `relatedVideoIds: []` | Populated with same-category video IDs from seed data |
| Placeholder channel avatars | `picsum.photos/seed/{channelIndex}/100/100` |

### 10.3 Production Constants File

Create `lib/core/constants/app_constants.dart`:
```dart
class AppConstants {
  // App Identity
  static const String appName = 'StreamPro';
  static const String bundleId = 'com.streampro.app';
  static const String supportEmail = 'support@streampro.app';

  // Store URLs
  static const String playStoreUrl =
      'market://details?id=com.streampro.app';
  static const String appStoreUrl =
      'https://apps.apple.com/app/streampro/id000000000'; // Update with real ID

  // Sharing
  static const String shareBaseUrl = 'https://streampro.app/watch/';
  static const String shareMessage =
      'Check out StreamPro — Premium free video streaming!';

  // Content
  static const int maxPlaylistCount = 20;
  static const int maxCommentLength = 500;
  static const int maxDisplayNameLength = 30;
  static const int maxPlaylistNameLength = 50;
  static const int minInterestSelection = 3;
  static const int maxSearchHistoryEntries = 10;
  static const int downloadExpiryDays = 30;
  static const int parentalPinLength = 4;
  static const int parentalMaxAttempts = 3;
  static const int parentalLockoutSeconds = 30;

  // Simulation
  static const double downloadMinSpeedMBps = 0.8;
  static const double downloadMaxSpeedMBps = 2.5;
  static const double downloadProgressPerSecond = 0.05;
  static const int maxConcurrentDownloads = 2;

  // Timings
  static const int controlsAutoHideSeconds = 3;
  static const int splashDurationMs = 1800;
  static const int searchDebouncMs = 350;
  static const int carouselAutoAdvanceSeconds = 5;
  static const int snackbarDurationMs = 2000;
  static const int backOnlineSnackbarMs = 2000;
}
```

Replace every hardcoded constant in the codebase with a reference to `AppConstants`.

---

## 11. MISSING SCREENS, FEATURES & GAPS

### 11.1 404 / Not Found Screen

Create `lib/core/pages/not_found_page.dart`:
```dart
class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off_rounded, size: 80, color: Colors.white24),
            const SizedBox(height: 24),
            Text('Page Not Found', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 12),
            Text('The page you are looking for does not exist.',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 32),
            GradientButton(label: 'Go Home', onPressed: () => context.go(AppRoutes.home)),
          ],
        ),
      ),
    );
  }
}
```

Register in GoRouter:
```dart
errorBuilder: (context, state) => const NotFoundPage(),
```

### 11.2 App Lifecycle Observer

Create `lib/core/services/app_lifecycle_service.dart`:
```dart
class AppLifecycleService with WidgetsBindingObserver {
  final AppConfigRepository _configRepo;
  final NotificationTriggerService _notificationService;

  void init() => WidgetsBinding.instance.addObserver(this);
  void dispose() => WidgetsBinding.instance.removeObserver(this);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _configRepo.saveLastOpenedAt(DateTime.now().toIso8601String());
    }
    if (state == AppLifecycleState.resumed) {
      final lastOpened = _configRepo.getConfig().lastOpenedAt;
      if (lastOpened != null) {
        _notificationService.onAppResume(DateTime.parse(lastOpened));
      }
    }
  }
}
```

Add `lastOpenedAt` field to `AppConfig` if missing. Register `AppLifecycleService` as a singleton in injection and call `init()` in `StreamProApp.initState()`.

### 11.3 Search Voice Input (Proper Stub)

The microphone icon in `DiscoverView` must show an actionable stub — not a broken feature:
```dart
IconButton(
  tooltip: 'Voice search',
  icon: const Icon(Icons.mic_rounded, color: AppColors.textMuted),
  onPressed: () {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Voice search coming soon'),
        backgroundColor: AppColors.surface2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  },
)
```

### 11.4 Video Quality Selector (In Player)

The quality selector in the player bottom bar must be functional:
```dart
// QualitySelector widget:
class QualitySelector extends StatelessWidget {
  final String currentQuality;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showQualitySheet(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(currentQuality, style: AppTextStyles.labelSmall),
      ),
    );
  }

  void _showQualitySheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['Auto', '1080p', '720p', '480p', '360p'].map((q) {
          return ListTile(
            title: Text(q),
            trailing: q == currentQuality
                ? const Icon(Icons.check, color: AppColors.primary)
                : null,
            onTap: () {
              onChanged(q);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
```

---

## 12. FRONTEND PERFORMANCE OPTIMIZATION

### 12.1 Image Loading Optimization

Every `CachedNetworkImage` in a list or grid must have explicit memory cache constraints:
```dart
CachedNetworkImage(
  imageUrl: video.thumbnailUrl,
  memCacheWidth: 320,
  memCacheHeight: 180,
  maxWidthDiskCache: 640,
  maxHeightDiskCache: 360,
  fit: BoxFit.cover,
  placeholder: (_, __) => Container(color: AppColors.surface3),
  errorWidget: (_, __, ___) => Container(
    color: AppColors.surface3,
    child: const Icon(Icons.broken_image_rounded, color: AppColors.textMuted),
  ),
)
```

### 12.2 List Performance

Every `ListView.builder` and `GridView.builder` must have:
```dart
ListView.builder(
  itemCount: videos.length,
  addRepaintBoundaries: true,   // Default true — verify not overridden
  addAutomaticKeepAlives: false, // Set false for non-visible items
  itemExtent: 96.0,             // Set if item height is fixed (improves scroll performance)
  itemBuilder: (_, index) => RepaintBoundary(
    child: PremiumVideoCard(video: videos[index]),
  ),
)
```

### 12.3 BLoC Rebuild Minimization

Use `BlocSelector` instead of `BlocBuilder` when only a subset of state is needed:
```dart
// Instead of rebuilding the entire header on every state change:
BlocSelector<PlayerBloc, PlayerState, bool>(
  selector: (state) => state is PlayerReady ? state.isControlsVisible : false,
  builder: (context, isVisible) => AnimatedOpacity(
    opacity: isVisible ? 1.0 : 0.0,
    duration: AnimationConstants.fast,
    child: const PlayerTopBar(),
  ),
)
```

### 12.4 Shimmer Performance

Never nest `Shimmer.fromColors` inside `AnimatedSwitcher` with rapid state changes. Add a minimum display duration:
```dart
// In every screen's BlocBuilder:
if (state is Loading && _minShimmerShown) {
  // Switch from shimmer to content only after shimmer has shown for at least 300ms
  return content;
}
```

### 12.5 WebView Performance

Add these to `InAppWebViewSettings`:
```dart
InAppWebViewSettings(
  cacheEnabled: true,
  cacheMode: CacheMode.LOAD_DEFAULT,
  hardwareAcceleration: true,
  supportZoom: false,
  builtInZoomControls: false,
  displayZoomControls: false,
)
```

---

## 13. SECURITY HARDENING

### 13.1 Parental PIN Storage

The parental PIN must NEVER be stored in plain text in Hive. Hash it:
```dart
import 'dart:convert';
import 'package:crypto/crypto.dart';

String _hashPin(String pin) {
  final bytes = utf8.encode(pin + 'streampro_salt_2026');
  return sha256.convert(bytes).toString();
}

// Store:
await _configRepo.updateField('parentalPin', _hashPin(pin));

// Verify:
bool verifyPin(String input) {
  return _configRepo.getConfig().parentalPin == _hashPin(input);
}
```

Add `crypto` to `pubspec.yaml` dependencies.

### 13.2 Age Gate Bypass Prevention

The `GoRouter` redirect guard must run on EVERY navigation event, not just on app start:
```dart
// Verify the redirect function is not async and accesses cached config:
redirect: (context, state) {
  // MUST use synchronous access to AppConfig
  // Do NOT use async/await here — it causes redirect race conditions
  final config = sl<AppConfigRepository>().getConfig(); // synchronous Hive read
  // ...
}
```

### 13.3 WebView Security

Add JavaScript message handler to prevent iframe breakout:
```dart
onCreateWindow: (controller, createWindowAction) async {
  // Block all popup windows
  return false;
},
shouldOverrideUrlLoading: (controller, action) async {
  final url = action.request.url?.toString() ?? '';
  // Only allow YouTube and Vimeo embed domains
  if (url.contains('youtube.com') || url.contains('youtu.be') ||
      url.contains('vimeo.com')) {
    return NavigationActionPolicy.ALLOW;
  }
  return NavigationActionPolicy.CANCEL;
},
```

### 13.4 Hive Security

Sensitive fields (parental PIN hash, age verification status) should use `flutter_secure_storage` instead of plain Hive for storage on iOS (Keychain) and Android (EncryptedSharedPreferences):

```dart
// For AppConfig fields: parentalPin, isAgeVerified, birthYear
// Move these three fields out of Hive and into SecureStorage:
class SecureConfigService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Future<void> setParentalPin(String hashedPin) async =>
      _storage.write(key: 'parental_pin', value: hashedPin);

  Future<String?> getParentalPin() async =>
      _storage.read(key: 'parental_pin');

  Future<void> setIsAgeVerified(bool verified) async =>
      _storage.write(key: 'age_verified', value: verified.toString());

  Future<bool> getIsAgeVerified() async =>
      (await _storage.read(key: 'age_verified')) == 'true';
}
```

### 13.5 Network Traffic

Add `flutter_certificate_pinner` or configure `NetworkSecurityConfig` on Android to pin certificates for any production API calls. For the current local-only app, ensure:
```xml
<!-- android/app/src/main/res/xml/network_security_config.xml -->
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="false">
        <!-- Allow only HTTPS for production -->
        <domain includeSubdomains="true">streampro.app</domain>
    </domain-config>
    <domain-config cleartextTrafficPermitted="true">
        <!-- YouTube embeds may use HTTP -->
        <domain includeSubdomains="true">youtube.com</domain>
        <domain includeSubdomains="true">youtu.be</domain>
    </domain-config>
</network-security-config>
```

---

## 14. ACCESSIBILITY & COMPLIANCE FIXES

### 14.1 Semantic Labels Audit

Run this check — every interactive element without a label fails App Store review:
```bash
grep -rn "IconButton\|GestureDetector" lib/features/ | wc -l
grep -rn "tooltip:" lib/features/ | wc -l
```

The `tooltip:` count must be ≥ the `IconButton` count. Every `IconButton` must have `tooltip` set.

Every `GestureDetector` wrapping meaningful content must have a `Semantics` wrapper:
```dart
Semantics(
  label: 'Watch ${video.title}',
  button: true,
  child: GestureDetector(
    onTap: () => context.push(AppRoutes.player, extra: video),
    child: PremiumVideoCard(video: video),
  ),
)
```

### 14.2 Font Scale Safety

Test on device with font scale set to 1.5×:
```
Settings → Accessibility → Font Size → Largest
```

Fix any `RenderFlex overflowed` errors by:
- Wrapping fixed-height containers that contain text in `FittedBox`.
- Replacing `Text` in badges with `FittedBox(child: Text(...))`.
- Using `Flexible` instead of fixed `SizedBox` for text-containing rows.

### 14.3 Color Contrast Verification

Verify these combinations meet WCAG AA (4.5:1 ratio for normal text):
- `colorTextSecondary` (#9CA3AF) on `colorSurface` (#121212): 5.4:1 ✓
- `colorTextMuted` (#6B7280) on `colorSurface` (#121212): 3.9:1 — only use for decorative text.
- White text on gradient `#C026D3`: 4.8:1 ✓

Never use `colorTextMuted` for interactive labels or navigation text.

---

## 15. PRODUCTION BUILD CONFIGURATION

### 15.1 Android Production Configuration

**`android/app/build.gradle.kts` — production settings:**
```kotlin
android {
    compileSdk = 36
    defaultConfig {
        applicationId = "com.streampro.app"
        minSdk = 21
        targetSdk = 36
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }
    buildTypes {
        release {
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
            signingConfig = signingConfigs.getByName("release")
        }
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }
}
dependencies {
    coreLibraryDesugaring("com.android.tools.build:desugaring:2.1.4")
}
```

**`android/app/proguard-rules.pro`:**
```
# Hive
-keep class * extends com.google.flatbuffers.Table
-keep class io.hive.** { *; }
-keep @com.google.flatbuffers.Struct class * { *; }

# Flutter InAppWebView
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }

# Keep generated Hive adapters
-keep class **.*Adapter { *; }
-keepclassmembers class ** {
    @io.hive.annotations.HiveField *;
}

# General Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
```

### 15.2 iOS Production Configuration

**`ios/Runner/Info.plist` — verify all keys:**
```xml
<key>CFBundleDisplayName</key>
<string>StreamPro</string>
<key>CFBundleName</key>
<string>StreamPro</string>
<key>CFBundleIdentifier</key>
<string>com.streampro.app</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>StreamPro needs access to your photo library to let you set a custom profile picture.</string>
<key>NSCameraUsageDescription</key>
<string>StreamPro needs camera access for future live streaming features.</string>
<key>NSMicrophoneUsageDescription</key>
<string>StreamPro needs microphone access for future voice search features.</string>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>fetch</string>
</array>
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
</dict>
```

### 15.3 Pre-Release Build Commands

Run in this exact order:
```bash
# 1. Clean
flutter clean

# 2. Get dependencies
flutter pub get

# 3. Regenerate Hive adapters
dart run build_runner build --delete-conflicting-outputs

# 4. Generate icons and splash
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# 5. Analyze
flutter analyze
# MUST return: "No issues found!"

# 6. Run tests
flutter test --timeout 60s test/unit/
flutter test --timeout 60s test/widget/
# MUST return: "All tests passed!"

# 7. Android App Bundle (required for Play Store)
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab

# 8. iOS Archive
flutter build ipa --release
# Output: build/ios/archive/Runner.xcarchive
```

---

## 16. APP STORE DEPLOYMENT CHECKLIST

### 16.1 Google Play Store

**Console setup:**
- [ ] Create app listing in Play Console at play.google.com/console
- [ ] App category: Entertainment
- [ ] App type: App (not Game)
- [ ] Free app: Yes

**Content rating questionnaire:**
- [ ] Does the app include violent content? No
- [ ] Does the app include sexual content? No
- [ ] Does the app display user-generated content? Yes (simulated comments)
- [ ] Is content gated behind an age check? Yes
- [ ] Expected rating result: Teen (T) / 13+

**Data Safety section (mandatory):**
- [ ] Data collected: None (all local)
- [ ] Data shared: None
- [ ] Security practices: Data encrypted in transit (WebView HTTPS)
- [ ] Committed to Play Families Policy: No
- [ ] Data deletion provided: Yes (via Settings → Clear Data)

**Store listing:**
- [ ] App name: "StreamPro - Free Video Streaming" (50 chars max)
- [ ] Short description: "Stream premium videos free. HD quality, no subscription." (80 chars max)
- [ ] Full description: 4000 chars covering all 10 features
- [ ] App icon: 512×512 PNG (generated by flutter_launcher_icons)
- [ ] Feature graphic: 1024×500 PNG (`assets/images/feature_graphic.png`)
- [ ] Screenshots: minimum 2, maximum 8 for phone; at least 2 for 7" tablet
- [ ] Video (optional): 30-second screen recording

**Technical requirements:**
- [ ] Upload: `build/app/outputs/bundle/release/app-release.aab` (AAB, not APK)
- [ ] Target API: 36 (required for new apps from Nov 2024)
- [ ] 64-bit support: Verified (Flutter default)
- [ ] Multi-window support: Declared in manifest

### 16.2 Apple App Store

**App Store Connect setup:**
- [ ] Create new app at appstoreconnect.apple.com
- [ ] Bundle ID: `com.streampro.app` (must match Info.plist)
- [ ] SKU: `streampro-001`
- [ ] Primary language: English (U.S.)

**App information:**
- [ ] Name: "StreamPro" (30 chars max)
- [ ] Subtitle: "Free Video Streaming App" (30 chars max)
- [ ] Category: Entertainment
- [ ] Secondary category: Utilities

**Age rating:**
- [ ] Cartoon or fantasy violence: None
- [ ] Realistic violence: None
- [ ] Sexual content: None
- [ ] Profanity: None
- [ ] Mature/suggestive themes: None
- [ ] Expected result: 12+

**Privacy policy:**
- [ ] URL to privacy policy: Required (host your `/privacy` content at a public URL)
- [ ] Suggested: GitHub Pages hosting `privacy.html` with the app's privacy policy text

**App review information:**
- [ ] Demo credentials: Not required (no login)
- [ ] Notes: "StreamPro is a free video streaming app. All data is stored locally on-device. The app requires age verification (13+) on first launch. Videos are embedded via YouTube iframes. No user accounts or cloud storage are used."

**Pricing:**
- [ ] Price: Free
- [ ] In-app purchases: None
- [ ] Subscriptions: None

**Distribution:**
- [ ] Upload IPA via: Xcode Organizer → Distribute App → App Store Connect
- [ ] Or use: `xcrun altool --upload-app -f build/ios/ipa/StreamPro.ipa -t ios -u APPLE_ID -p APP_SPECIFIC_PASSWORD`
- [ ] Wait for processing (typically 15-30 minutes)
- [ ] Submit for review

**Screenshots required:**
- [ ] iPhone 6.7" (iPhone 15 Pro Max): at minimum Splash, Home, Player, Profile, Settings
- [ ] iPhone 6.5" (iPhone 14 Plus): same screens
- [ ] iPad Pro 12.9" (if supporting iPad): same screens (declare `UISupportedInterfaceOrientations~ipad` in Info.plist)

---

## 17. IMPLEMENTATION SPRINT PLAN

### Sprint A — Debug & Fix (Days 1–3)

**Day 1 — Static analysis and routing:**
1. Run `flutter analyze` — fix every issue to zero.
2. Run routing audit from Section 4 — fix every broken navigation.
3. Fix all `onTap: () {}` and `onTap: null` elements from Section 9.2.
4. Fix `dispose()` methods across all stateful widgets — Section 3.10.

**Day 2 — Screen completeness:**
1. Audit every screen for four-state BLoC handling — Section 3.
2. Fix every screen that shows blank, raw spinner, or unhandled error state.
3. Fix `PremiumVideoCard` — all 10 requirements from Section 3.5.
4. Fix non-functional Settings items — Section 3.13.

**Day 3 — Database and logic:**
1. Run `video_repository_test.dart` — all 10 tests must pass.
2. Verify seed data counts with assertions — Section 6.2.
3. Implement missing features: Not Interested, Auto-Play Next, Video Resume — Section 11.
4. Implement notification triggers — Section 11.4.
5. Replace all mock/placeholder data — Section 10.

### Sprint B — Security & Performance (Day 4)

1. Implement PIN hashing — Section 13.1.
2. Move sensitive fields to `flutter_secure_storage` — Section 13.4.
3. Add WebView security handlers — Section 13.3.
4. Apply image loading optimization to all lists — Section 12.1.
5. Add `RepaintBoundary` to all list items — Section 12.2.
6. Create `AppConstants` class and replace all hardcoded values — Section 10.3.
7. Add `NotFoundPage` and register in GoRouter errorBuilder — Section 11.1.
8. Add `AppLifecycleService` — Section 11.2.

### Sprint C — Testing & Release (Days 5–6)

**Day 5 — Test coverage:**
1. Write all missing unit test files — Section 2.3.
2. Write all widget tests — Section 2.2.
3. Write integration tests — Section 2.4.
4. Run full test suite: `flutter test test/ --timeout 60s`
5. Fix any failing tests.
6. Achieve 0 failing tests.

**Day 6 — Production builds:**
1. Run full pre-release build sequence — Section 15.3.
2. Install APK on physical Android device — run 5-point manual verification.
3. Install IPA on physical iOS device — run 5-point manual verification.
4. Fix any device-specific bugs found.
5. Re-run release builds after fixes.
6. Submit to Google Play Store — Section 16.1.
7. Submit to Apple App Store — Section 16.2.

### Final Verification Before Submission

Before clicking Submit on either store, verify these 10 items on a physical device:

1. App icon is the branded gradient design (not Flutter default blue).
2. Splash screen shows StreamPro icon on black background (no white flash).
3. Age gate appears on clean install with back button blocked.
4. Both legal screens accessible and "I Accept" functional.
5. Onboarding interest selection requires 3+ chips before enabling "Get Started".
6. One video plays successfully in the player.
7. Long-press on a video card shows the full context menu with 7 items.
8. Parental PIN can be set and successfully blocks R-rated content.
9. Disconnect WiFi — offline overlay appears. Reconnect — overlay dismisses with snackbar.
10. App version on About screen shows "1.0.0" (from package_info_plus, not hardcoded).

All 10 must pass. Do not submit until they do.

---

*End of StreamPro Production Debugging & Deployment PRD v3.0*

*Total coverage: 32 screens audited, 8 unit test suites specified, 5 integration tests specified, 15 security/performance fixes, complete app store submission guide for both platforms.*

*This document is ready for direct implementation. No additional clarification is required.*
