# AI_AGENT_CONTEXT.md

## Project Overview
- **App Name:** StreamPro
- **Package Name / Application ID:** com.streampro.app
- **Description:** A premium, modern, high-quality free video streaming application.
- **Platforms Enabled:** Android, iOS, Web
- **Version:** v1.0.0+1
- **Architecture:** Feature-first Clean Architecture

## Tech Stack & Libraries
- **Framework:** Flutter (latest stable, SDK >=3.3.0 <4.0.0)
- **State Management:** `flutter_bloc`
- **Dependency Injection:** `get_it`
- **Local Storage / Database:** `hive`, `hive_flutter`
- **Navigation:** Named Routes via `Navigator` with custom `PopScope` safe-back implementation
- **Video Playback:** `flutter_inappwebview` (embedded iframe playback)
- **UI / UX / Theming:** Material 3, custom Dark Theme with Glassmorphic effects, Neon purple/pink accents (#C026D3 to #DB2777), `google_fonts` (Poppins)
- **Pagination & Scrolling:** `infinite_scroll_pagination`
- **Image Caching & Loaders:** `cached_network_image`, `shimmer`
- **Carousels & Layouts:** `carousel_slider`, `flutter_staggered_grid_view`
- **Haptic Feedback:** Native Flutter `HapticFeedback.selectionClick()`

## Native Configurations & Permissions
### Android (`AndroidManifest.xml` & `build.gradle.kts`)
- `minSdkVersion`: 21
- `targetSdkVersion`: 35
- `compileSdkVersion`: 35
- **Permissions:** `INTERNET`, `ACCESS_NETWORK_STATE`
- **Configurations:** `android:usesCleartextTraffic="true"`, `android:largeHeap="true"`, hardware acceleration enabled.

### iOS (`Info.plist`)
- `IPHONEOS_DEPLOYMENT_TARGET`: 13.0
- **Permissions/Privacy:** `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`, `NSMicrophoneUsageDescription`
- **Configurations:** `NSAppTransportSecurity` (NSAllowsArbitraryLoads = true)

### Web (`index.html`)
- Custom Meta Tags: `theme-color` (#0A0A0A), custom `description`, `viewport` for non-scalable app-like feel.

---

## Directory Structure (Feature-First Clean Architecture)
```text
lib/
├── core/
│   ├── di/               # GetIt dependency injection setup (injection.dart)
│   ├── models/           # Shared models (app_config.dart, video_entity.dart)
│   ├── routes/           # AppRoutes and onGenerateRoute configuration
│   ├── theme/            # AppTheme, Colors, Glassmorphic helper
│   └── widgets/          # Shared UI components (PremiumVideoCard, Shimmer Loading)
├── features/
│   ├── category/         # Category feed with paginated videos
│   ├── discover/         # Search functionality and Discover Grid
│   ├── home/             # Splash Screen, Main Home Feed, Carousel, Drawer
│   ├── library/          # Watch History and Bookmarks from Hive
│   ├── player/           # Immersive Video Player with iframe and related videos
│   ├── settings/         # Settings page (theme, clear history, about)
│   ├── trending/         # Ranked lists of trending videos
│   └── vpn/              # Background VPN connection simulation and status UI
└── main.dart             # App initialization, Hive, GetIt, MultiBlocProvider
```

---

## Implemented Features (Current State)
1. **Core Navigation:** `HomePage` with `BottomNavigationBar`, robust hamburger `MainDrawer`, and strict safe-back navigation (`PopScope` ensuring overlays close before popping) on all secondary screens.
2. **Video Data & Storage:** `VideoRepository` initializes 30 sample iframe-based videos. Local storage managed via `Hive` for Watch History, Bookmarks, and VPN AppConfig.
3. **Immersive Video Player:** Full-screen immersive mode (`SystemChrome.setEnabledSystemUIMode`), responsive landscape/portrait rotation, custom fading overlay controls with `AnimationController`, and horizontal related videos that push-replace the current view.
4. **Automated VPN Simulation:** `VpnBloc` handles automatic simulated connection on app launch to an optimal server, saving state to `AppConfig`. `VpnStatusScreen` provides a UI to toggle connection and select countries.
5. **Infinite Scroll Pagination:** `PagedListView` and `PagedMasonryGridView` are actively used in Discover, Category, and Trending tabs to prevent bulk loading.
6. **Premium UI/UX:** `PremiumVideoCard` utilizes glassmorphic gradients, cached imagery, and neon glowing play buttons. Beautiful empty states built for search and library.
7. **Search & Debounce:** Live search implemented in `VideoListBloc` with debounce logic to query the local database.

---

## Gaps, Missing Screens, and Required Expansions (To-Do / Roadmap)

### Missing & Required Screens (10+)
1. **Age Restriction / Content Warning Screen** (Shown on first launch or specific adult content)
2. **Privacy Policy Screen**
3. **Terms and Conditions Screen**
4. **User Profile / Guest Profile Management**
5. **Downloads / Offline Mode Library**
6. **Custom Playlists Screen**
7. **Liked / Favorites Grid Screen**
8. **Notification Center Screen**
9. **Help & Support / FAQ Screen**
10. **Advanced App Settings** (Playback quality defaults, auto-play toggles)
11. **Category Overview / Grid Screen** (A dedicated screen just for browsing large category tiles)

### 10 New Core Features
1. **Complete Local Database Expansion:** Hive boxes for Downloads, Playlists, User Profile, Likes, Comments (local simulation), and detailed User Preferences.
2. **Picture-in-Picture (PiP) Mode:** For video playback while navigating the app.
3. **Casting Support:** UI placeholders and logic hooks for Chromecast / AirPlay.
4. **Custom Playlists Creation:** Ability to create, edit, and delete local video playlists.
5. **Offline Downloads Simulation:** Visual tracking of download progress and storage management.
6. **Global Empty/Error/Skeleton States:** Implement comprehensive, animated (Lottie) states for *every* edge case across the app.
7. **In-App Notifications:** Simulated push notifications for "New Video Released" or "Trending Now".
8. **Like / Dislike System:** Persistent local tracking of user ratings.
9. **Simulated Comments Section:** A bottom-sheet view on the player page for reading/writing local simulated comments.
10. **Advanced Video Filtering/Sorting:** Filter by duration, release date, or exact category inside Discover and Trending.

### 10 New Global App Gestures
1. **Pull-to-Refresh:** On Home, Trending, and Discover feeds.
2. **Swipe-to-Dismiss:** On bottom sheets and dialogs.
3. **Edge-Swipe Back:** Global iOS-style edge swipe to pop screens (enhancing `PopScope`).
4. **Long-Press on Video Card:** Opens a sleek contextual menu (Add to Playlist, Download, Bookmark).
5. **Swipe Left/Right on BottomNav:** Switch between main tabs via horizontal swiping.
6. **Double-Tap on Card:** Quick "Like" action with a floating heart animation.
7. **Pinch-to-Zoom on Grid:** Change the number of columns in staggered grid views.
8. **Two-Finger Tap:** Quick pause/play of the currently mini-playing video (if PiP is active).
9. **Swipe Up on Home Screen:** Quick jump to "Search" input.
10. **Shake-to-Undo:** Clear recent search or undo "remove from history".

### 10 New Video Player Gestures
*(Note: Because the player currently uses `flutter_inappwebview` for iframe embeds, native overlay gestures must be carefully overlaid on top of the web view, using `AbsorbPointer` or transparent overlays when controls are active.)*
1. **Swipe Up/Down (Left Side):** Adjust screen brightness (via native platform channels or simulated UI).
2. **Swipe Up/Down (Right Side):** Adjust media volume.
3. **Double-Tap Left Side:** Skip backward 10 seconds.
4. **Double-Tap Right Side:** Skip forward 10 seconds.
5. **Horizontal Swipe (Center):** Scrub / seek through the video timeline.
6. **Pinch-to-Zoom:** Switch video fit from 'contain' to 'cover' (crop to fill screen).
7. **Long-Press (Hold):** Temporarily play at 2x speed while holding.
8. **Swipe Down (Top Edge):** Minimize the player into Picture-in-Picture (PiP) or close it.
9. **Two-Finger Tap:** Play / Pause toggle.
10. **Swipe Up (Bottom Edge):** Reveal the "Related Videos" or "Comments" bottom sheet seamlessly.
