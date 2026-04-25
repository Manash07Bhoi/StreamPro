# StreamPro — Complete Product Requirements Document
## Version 2.0 | Production-Ready Specification | April 2026

---

> **Document Purpose:** This PRD is the single source of truth for implementing StreamPro from its current MVP state to a fully publish-ready, industry-grade Flutter video streaming application. Every screen, state, gesture, database entity, UI component, and user flow is specified at the level required for direct implementation by a developer agent (e.g., Replit Agent) without additional clarification.

---

## TABLE OF CONTENTS

1. Executive Summary
2. Product Vision & Design Philosophy
3. Complete Technology Stack & Dependencies
4. Complete Local Database Schema (Hive — Full Expansion)
5. Complete Screen Inventory (All 30+ Screens)
6. Screen-by-Screen Specifications (Every Screen, Full Detail)
7. 10 New Core Features (Full Specification)
8. 10 New Global App Gestures (Full Specification)
9. 10 New Video Player Gestures (Full Specification)
10. Global UI State System (Empty, Error, Skeleton Loading)
11. Complete Navigation Flow & Route Map
12. Complete UI Component Library
13. Legal & Compliance Screens
14. Animation & Transition System
15. BLoC Architecture Expansion Map
16. Dependency Injection Expansion
17. Implementation Sprint Roadmap

---

## 1. EXECUTIVE SUMMARY

StreamPro is a premium free video streaming application built with Flutter targeting Android (minSdk 21), iOS (13.0+), and Web. The current build is a well-architected MVP with clean BLoC/Clean Architecture, 30 local sample videos, an immersive WebView player, VPN simulation, and a polished dark glassmorphic UI.

This PRD specifies the complete delta from the current MVP to a production-ready, publish-ready application. The scope includes: 11 missing screens to be built, 10 new feature modules, 20 new gesture interactions (10 global + 10 player-specific), a fully expanded Hive local database, and a universal UI state system covering every edge case (empty, error, skeleton, shimmer, age gate, legal).

The design language remains fixed: Background `#0A0A0A`, Surface `#121212`, Primary gradient `#C026D3 → #DB2777`, Poppins typography, Material 3 Dark, glassmorphic card overlays.

---

## 2. PRODUCT VISION & DESIGN PHILOSOPHY

### 2.1 Product Mission
StreamPro delivers the feel of a premium paid streaming service at zero cost, with a UI quality benchmarked against Netflix, YouTube Premium, and Plex — with a distinctive neon-dark aesthetic that sets it apart.

### 2.2 Design System Constants

The following tokens are fixed across the entire application and must never deviate.

**Color Palette:**
- `colorBackground`: `#0A0A0A` — deepest background, used for Scaffold backgrounds
- `colorSurface`: `#121212` — card surfaces, bottom sheets, drawers
- `colorSurface2`: `#1A1A1A` — elevated surfaces, dialogs
- `colorSurface3`: `#242424` — input fields, chips, dividers
- `colorPrimary`: `#C026D3` — primary purple, buttons, active states
- `colorSecondary`: `#DB2777` — secondary pink, gradients endpoint
- `colorGradientStart`: `#C026D3`
- `colorGradientEnd`: `#DB2777`
- `colorTextPrimary`: `#FFFFFF`
- `colorTextSecondary`: `#9CA3AF` (Gray-400)
- `colorTextMuted`: `#6B7280` (Gray-500)
- `colorSuccess`: `#10B981` (Emerald)
- `colorWarning`: `#F59E0B` (Amber)
- `colorError`: `#EF4444` (Red)
- `colorBorder`: `rgba(255,255,255,0.08)`
- `colorGlow`: `rgba(192, 38, 211, 0.35)` — neon glow shadow

**Typography (Poppins):**
- `textDisplayLarge`: Poppins Bold, 32sp, letterSpacing -0.5
- `textDisplayMedium`: Poppins SemiBold, 26sp
- `textHeadlineLarge`: Poppins SemiBold, 22sp
- `textHeadlineMedium`: Poppins Medium, 18sp
- `textTitleLarge`: Poppins Medium, 16sp
- `textTitleMedium`: Poppins Medium, 14sp
- `textBodyLarge`: Poppins Regular, 16sp
- `textBodyMedium`: Poppins Regular, 14sp
- `textBodySmall`: Poppins Regular, 12sp
- `textLabelLarge`: Poppins SemiBold, 14sp, letterSpacing 0.1
- `textLabelMedium`: Poppins Medium, 12sp
- `textLabelSmall`: Poppins Medium, 10sp, letterSpacing 0.5, UPPERCASE

**Spacing Scale (8pt grid):**
- `xs`: 4dp, `sm`: 8dp, `md`: 12dp, `lg`: 16dp, `xl`: 24dp, `2xl`: 32dp, `3xl`: 48dp, `4xl`: 64dp

**Border Radius:**
- `radiusXS`: 4dp, `radiusSM`: 8dp, `radiusMD`: 12dp, `radiusLG`: 16dp, `radiusXL`: 20dp, `radiusFull`: 999dp

**Elevation / Shadow:**
- `shadowGlow`: `BoxShadow(color: colorGlow, blurRadius: 20, spreadRadius: 2)`
- `shadowCard`: `BoxShadow(color: Colors.black54, blurRadius: 12, offset: Offset(0,4))`
- `shadowSubtle`: `BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0,2))`

**Glassmorphic Helper:**
```
BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12))
Container(color: Colors.white.withOpacity(0.05), border: Border.all(color: colorBorder))
```

### 2.3 Animation Standards

Every animated element in the app follows these timing standards to create a cohesive, fluid experience.

- **Micro interaction (tap feedback):** 80ms, `Curves.easeOut`
- **Transition enter:** 280ms, `Curves.easeOutCubic`
- **Transition exit:** 200ms, `Curves.easeInCubic`
- **Shimmer sweep duration:** 1500ms, looping
- **Skeleton pulse duration:** 1000ms, reverse looping, opacity 0.4 → 0.8
- **Overlay fade in/out:** 200ms / 160ms
- **Bottom sheet slide up:** 350ms, `Curves.easeOutQuart`
- **Lottie empty state loop:** plays once then holds last frame
- **Page enter route:** `FadeTransition` + `SlideTransition` (dy: 0.04 → 0.0), 320ms
- **Card scale on press:** scale 1.0 → 0.97 on down, → 1.0 on up, 80ms

---

## 3. COMPLETE TECHNOLOGY STACK & DEPENDENCIES

### 3.1 pubspec.yaml — Complete Dependencies

The following is the complete, production-ready `pubspec.yaml` dependency list. All packages listed must be added to the project.

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.6
  equatable: ^2.0.5

  # Dependency Injection
  get_it: ^8.0.0

  # Local Storage / Database
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # Navigation
  go_router: ^13.2.0          # Upgrade from named routes for deep linking support

  # Video Playback
  flutter_inappwebview: ^6.0.0

  # Networking & Images
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0

  # UI & Layout
  google_fonts: ^6.2.1
  carousel_slider: ^4.2.1
  flutter_staggered_grid_view: ^0.7.0
  infinite_scroll_pagination: ^4.0.0

  # Animations
  lottie: ^3.1.2               # For animated empty/error states
  animate_do: ^3.3.4           # FadeIn, SlideIn, ZoomIn utilities

  # Gestures & Interactions
  flutter_slidable: ^3.1.0     # Swipe-to-action on list items
  haptic_feedback: ^0.0.2      # Enhanced haptics

  # System / Platform
  flutter_system_chrome: ...   # Already included via Flutter SDK
  wakelock_plus: ^1.2.3        # Keep screen on during playback
  package_info_plus: ^8.0.0    # App version info for About screen
  share_plus: ^9.0.0           # Share video links
  url_launcher: ^6.2.6         # Open URLs in Privacy Policy / Terms

  # Permissions
  permission_handler: ^11.3.1

  # Local Notifications (simulated)
  flutter_local_notifications: ^17.2.2

  # Connectivity
  connectivity_plus: ^6.0.3

  # Device Info
  device_info_plus: ^10.1.0

  # Date & Time Utilities
  intl: ^0.19.0
  timeago: ^3.6.1

  # UUID Generation
  uuid: ^4.4.2

  # Secure Storage (for age gate preference)
  flutter_secure_storage: ^9.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
  flutter_lints: ^4.0.0
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
```

### 3.2 New Permissions Required

**Android (`AndroidManifest.xml`):**
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<!-- For PiP -->
<uses-permission android:name="android.permission.SYSTEM_ALERT_WINDOW"/>
```

Activity manifest for PiP:
```xml
<activity android:supportsPictureInPicture="true"
          android:configChanges="screenSize|smallestScreenSize|screenLayout|orientation"/>
```

**iOS (`Info.plist`) additions:**
```xml
<key>UIBackgroundModes</key>
<array>
  <string>audio</string>
  <string>fetch</string>
</array>
```

---

## 4. COMPLETE LOCAL DATABASE SCHEMA (HIVE — FULL EXPANSION)

### 4.1 Architecture Overview

The Hive local database is expanded from 4 boxes to 12 boxes. Each box is described with its entity class, type ID, all fields with types, indexes (where applicable), and CRUD operations that the repository layer must implement.

### 4.2 Box Registry

| Box Name | Type ID Range | Description |
|---|---|---|
| `app_config_box` | 0 | Global app configuration & preferences |
| `videos_box` | 1 | Master video catalog (sample data) |
| `history_box` | 2 | Watch history entries |
| `bookmarks_box` | 3 | Bookmarked videos |
| `downloads_box` | 4 | Download records & progress |
| `playlists_box` | 5 | User-created playlists |
| `playlist_items_box` | 6 | Videos inside playlists |
| `likes_box` | 7 | Liked/disliked video records |
| `comments_box` | 8 | Simulated local comments |
| `user_profile_box` | 9 | Guest user profile data |
| `notifications_box` | 10 | In-app notification records |
| `search_history_box` | 11 | Recent search query history |

### 4.3 Entity Definitions

---

#### `AppConfig` (typeId: 0) — Box: `app_config_box`
```dart
@HiveType(typeId: 0)
class AppConfig extends HiveObject {
  @HiveField(0) bool isVpnEnabled;           // Default: false
  @HiveField(1) String lastConnectedCountry; // Default: 'US'
  @HiveField(2) String themeMode;            // 'dark' | 'light' | 'system'. Default: 'dark'
  @HiveField(3) bool hasAcceptedAgeGate;     // Default: false — critical for age restriction
  @HiveField(4) bool hasAcceptedTerms;       // Default: false — required at onboarding
  @HiveField(5) bool hasAcceptedPrivacy;     // Default: false — required at onboarding
  @HiveField(6) bool isFirstLaunch;          // Default: true
  @HiveField(7) String videoQuality;         // 'auto' | '1080p' | '720p' | '480p' | '360p'. Default: 'auto'
  @HiveField(8) bool autoPlayEnabled;        // Default: true
  @HiveField(9) bool autoPlayNextEnabled;    // Default: false
  @HiveField(10) bool notificationsEnabled;  // Default: true
  @HiveField(11) String preferredLanguage;   // Default: 'en'
  @HiveField(12) bool parentalControlEnabled;// Default: false
  @HiveField(13) String parentalPin;         // 4-digit PIN, empty string if not set
  @HiveField(14) double defaultBrightness;   // 0.0–1.0. Default: -1.0 (system)
  @HiveField(15) double defaultVolume;       // 0.0–1.0. Default: 1.0
  @HiveField(16) bool loopVideoEnabled;      // Default: false
  @HiveField(17) String onboardingCompletedAt; // ISO8601 DateTime string
  @HiveField(18) int totalWatchTimeSeconds;  // Cumulative, for profile stats
  @HiveField(19) bool showSubtitles;         // Default: false
  @HiveField(20) String appVersion;          // Stored version to detect upgrades
}
```

**Repository methods required:**
- `AppConfig getConfig()` — returns the single config object, creating default if absent
- `Future<void> saveConfig(AppConfig config)` — persists the full config
- `Future<void> updateField<T>(String field, T value)` — partial field update helper
- `Future<void> resetToDefaults()` — factory reset all config

---

#### `VideoEntity` (typeId: 1) — Box: `videos_box`
```dart
@HiveType(typeId: 1)
class VideoEntity extends HiveObject {
  @HiveField(0) String id;               // UUID v4
  @HiveField(1) String title;
  @HiveField(2) String thumbnailUrl;
  @HiveField(3) String duration;         // e.g. "12:34"
  @HiveField(4) int durationSeconds;     // e.g. 754 — for sorting/filtering
  @HiveField(5) String embedCode;        // Full iframe HTML string
  @HiveField(6) String category;         // e.g. 'Action', 'Comedy', 'Drama'
  @HiveField(7) String description;      // 1-3 sentence video description
  @HiveField(8) String channelName;      // e.g. "StreamPro Originals"
  @HiveField(9) String channelAvatar;    // URL for channel avatar image
  @HiveField(10) int viewCount;          // Simulated view count
  @HiveField(11) int likeCount;          // Simulated like count
  @HiveField(12) int dislikeCount;       // Simulated dislike count
  @HiveField(13) String uploadedAt;      // ISO8601 DateTime string
  @HiveField(14) List<String> tags;      // ['4K', 'HDR', 'New', 'Trending', etc.]
  @HiveField(15) bool isNew;             // Badge flag
  @HiveField(16) bool isTrending;        // Shows in trending feed
  @HiveField(17) bool isHD;             // Quality indicator badge
  @HiveField(18) bool isFeatured;        // Shows in hero carousel
  @HiveField(19) String contentRating;   // 'G' | 'PG' | 'PG-13' | 'R' | 'NC-17'
  @HiveField(20) bool requiresAgeVerification; // true if contentRating is R or NC-17
  @HiveField(21) String subtitleUrl;     // Empty string if none available
  @HiveField(22) List<String> relatedVideoIds; // IDs for the related videos section
  @HiveField(23) String playlistPreviewUrl;    // Short preview clip URL (optional)
  @HiveField(24) int commentCount;       // Simulated comment count
  @HiveField(25) bool isDownloadable;    // Whether simulated download is allowed
}
```

**Seed Data Requirements:**
The `VideoRepository` must initialize 60 sample videos (up from 30) spread across the following categories, each with realistic simulated metadata:
- `Action` (10 videos), `Comedy` (8 videos), `Drama` (8 videos), `Documentary` (7 videos), `Music` (7 videos), `Sports` (6 videos), `Technology` (7 videos), `Travel` (7 videos)

All thumbnails sourced from `https://picsum.photos/seed/{unique_seed}/640/360`. YouTube embed codes should use standard iframe format. Duration should range from 3 minutes to 45 minutes across the catalog.

---

#### `WatchHistoryEntry` (typeId: 2) — Box: `history_box`
```dart
@HiveType(typeId: 2)
class WatchHistoryEntry extends HiveObject {
  @HiveField(0) String id;               // UUID v4 (unique history entry ID)
  @HiveField(1) String videoId;          // Foreign key → VideoEntity.id
  @HiveField(2) String watchedAt;        // ISO8601 DateTime string
  @HiveField(3) int watchedDurationSeconds; // How long user watched (for resume)
  @HiveField(4) double progressPercent;  // 0.0–1.0 for progress bar on card
  @HiveField(5) bool isCompleted;        // progressPercent >= 0.9
  @HiveField(6) int watchCount;          // Increments each rewatch
}
```

**Repository methods:**
- `Future<void> addOrUpdateHistory(String videoId, {int watchedDuration, double progress})`
- `List<WatchHistoryEntry> getHistory({int limit = 50, int offset = 0})`
- `Future<void> removeFromHistory(String videoId)`
- `Future<void> clearAllHistory()`
- `WatchHistoryEntry? getHistoryEntry(String videoId)` — for resume bar on card

---

#### `BookmarkEntry` (typeId: 3) — Box: `bookmarks_box`
```dart
@HiveType(typeId: 3)
class BookmarkEntry extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String videoId;      // Foreign key → VideoEntity.id
  @HiveField(2) String savedAt;      // ISO8601 DateTime string
  @HiveField(3) String? note;        // Optional user note (up to 200 chars)
}
```

**Repository methods:**
- `Future<void> addBookmark(String videoId, {String? note})`
- `Future<void> removeBookmark(String videoId)`
- `bool isBookmarked(String videoId)`
- `List<BookmarkEntry> getBookmarks({int limit = 50, int offset = 0})`
- `Future<void> clearAllBookmarks()`

---

#### `DownloadRecord` (typeId: 4) — Box: `downloads_box`
```dart
@HiveType(typeId: 4)
class DownloadRecord extends HiveObject {
  @HiveField(0) String id;                  // UUID v4
  @HiveField(1) String videoId;             // Foreign key → VideoEntity.id
  @HiveField(2) String status;              // 'queued' | 'downloading' | 'completed' | 'failed' | 'paused'
  @HiveField(3) double progressPercent;     // 0.0–1.0
  @HiveField(4) int fileSizeBytes;          // Simulated file size
  @HiveField(5) int downloadedBytes;        // Simulated downloaded bytes
  @HiveField(6) String startedAt;           // ISO8601 DateTime string
  @HiveField(7) String? completedAt;        // ISO8601 DateTime string, null if not done
  @HiveField(8) String? localFilePath;      // Simulated local path
  @HiveField(9) String quality;             // '1080p' | '720p' | '480p'
  @HiveField(10) bool isExpired;            // Download expired after 30 days (simulated)
  @HiveField(11) String expiresAt;          // ISO8601 DateTime string
}
```

**Repository methods:**
- `Future<void> startDownload(String videoId, String quality)`
- `Future<void> pauseDownload(String downloadId)`
- `Future<void> resumeDownload(String downloadId)`
- `Future<void> cancelDownload(String downloadId)`
- `Future<void> deleteDownload(String downloadId)`
- `List<DownloadRecord> getAllDownloads()`
- `DownloadRecord? getDownloadForVideo(String videoId)`
- `int getTotalStorageUsedBytes()`
- `Future<void> simulateDownloadProgress(String downloadId)` — timer-based simulation

---

#### `Playlist` (typeId: 5) — Box: `playlists_box`
```dart
@HiveType(typeId: 5)
class Playlist extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String name;         // User-provided name (max 50 chars)
  @HiveField(2) String? description; // Optional description (max 200 chars)
  @HiveField(3) String createdAt;    // ISO8601 DateTime string
  @HiveField(4) String updatedAt;    // ISO8601 DateTime string
  @HiveField(5) String coverVideoId; // VideoId used for cover thumbnail
  @HiveField(6) int videoCount;      // Denormalized count for display
  @HiveField(7) bool isPublic;       // Future use — always false locally
  @HiveField(8) String color;        // Accent hex color chosen by user for playlist card
}
```

**Repository methods:**
- `Future<Playlist> createPlaylist(String name, {String? description})`
- `Future<void> updatePlaylist(Playlist playlist)`
- `Future<void> deletePlaylist(String playlistId)`
- `List<Playlist> getAllPlaylists()`
- `Playlist? getPlaylist(String playlistId)`

---

#### `PlaylistItem` (typeId: 6) — Box: `playlist_items_box`
```dart
@HiveType(typeId: 6)
class PlaylistItem extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String playlistId;   // Foreign key → Playlist.id
  @HiveField(2) String videoId;      // Foreign key → VideoEntity.id
  @HiveField(3) int position;        // Sort order within playlist
  @HiveField(4) String addedAt;      // ISO8601 DateTime string
}
```

**Repository methods:**
- `Future<void> addVideoToPlaylist(String playlistId, String videoId)`
- `Future<void> removeVideoFromPlaylist(String playlistId, String videoId)`
- `Future<void> reorderPlaylistItem(String playlistId, int oldIndex, int newIndex)`
- `List<PlaylistItem> getPlaylistItems(String playlistId)`
- `bool isVideoInPlaylist(String playlistId, String videoId)`
- `List<Playlist> getPlaylistsContainingVideo(String videoId)`

---

#### `LikeRecord` (typeId: 7) — Box: `likes_box`
```dart
@HiveType(typeId: 7)
class LikeRecord extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String videoId;      // Foreign key → VideoEntity.id
  @HiveField(2) String reaction;     // 'like' | 'dislike' | 'none'
  @HiveField(3) String reactedAt;    // ISO8601 DateTime string
}
```

**Repository methods:**
- `Future<void> setReaction(String videoId, String reaction)` — upsert
- `String getReaction(String videoId)` — returns 'like', 'dislike', or 'none'
- `List<LikeRecord> getLikedVideos()`
- `int getLikeCount()` — total liked videos count

---

#### `Comment` (typeId: 8) — Box: `comments_box`
```dart
@HiveType(typeId: 8)
class Comment extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String videoId;      // Foreign key → VideoEntity.id
  @HiveField(2) String authorName;   // Simulated author name (from seeded list)
  @HiveField(3) String authorAvatar; // Simulated avatar URL
  @HiveField(4) String text;         // Comment text (max 500 chars)
  @HiveField(5) String postedAt;     // ISO8601 DateTime string
  @HiveField(6) int likeCount;       // Simulated likes on comment
  @HiveField(7) bool isUserComment;  // True if written by the current user/guest
  @HiveField(8) String? parentId;    // For threaded replies — null if top-level
}
```

**Seed Data:** Each video in `videos_box` must have 5–15 pre-seeded simulated comments added to `comments_box` at `VideoRepository.init()` time. Comments use a pool of 20 fake names and avatar URLs.

**Repository methods:**
- `Future<Comment> addUserComment(String videoId, String text)`
- `Future<void> deleteUserComment(String commentId)`
- `List<Comment> getCommentsForVideo(String videoId, {int limit = 30})`
- `int getCommentCount(String videoId)`

---

#### `UserProfile` (typeId: 9) — Box: `user_profile_box`
```dart
@HiveType(typeId: 9)
class UserProfile extends HiveObject {
  @HiveField(0) String id;                // UUID v4 — generated on first launch
  @HiveField(1) String displayName;       // Default: 'Guest User'
  @HiveField(2) String? avatarUrl;        // URL or null for default avatar initials
  @HiveField(3) String? customAvatarPath; // Local path if user selected a local image
  @HiveField(4) String createdAt;         // ISO8601 DateTime string
  @HiveField(5) String membershipType;    // 'free' — always, for display
  @HiveField(6) int totalLikes;           // Denormalized from likes_box
  @HiveField(7) int totalWatchedVideos;   // Denormalized from history_box
  @HiveField(8) int totalWatchTimeSeconds;// Denormalized from app_config
  @HiveField(9) String favoriteCategory; // Most-watched category (computed)
  @HiveField(10) List<String> interests; // User-selected interests for personalization
  @HiveField(11) String birthYear;        // e.g. '1995' — for age gate compliance
  @HiveField(12) bool isAgeVerified;      // Set when age gate is passed
}
```

**Repository methods:**
- `UserProfile getOrCreateProfile()`
- `Future<void> updateProfile(UserProfile profile)`
- `Future<void> updateDisplayName(String name)`
- `Future<void> updateAvatar(String? url)`
- `Future<void> syncStats()` — recomputes denormalized stats from other boxes

---

#### `AppNotification` (typeId: 10) — Box: `notifications_box`
```dart
@HiveType(typeId: 10)
class AppNotification extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String type;         // 'new_video' | 'trending' | 'system' | 'reminder'
  @HiveField(2) String title;
  @HiveField(3) String body;
  @HiveField(4) String? imageUrl;    // Optional thumbnail
  @HiveField(5) String? actionRoute; // Route to push on tap (e.g., '/player')
  @HiveField(6) String? actionArg;   // Argument for route (e.g., videoId)
  @HiveField(7) bool isRead;         // Default: false
  @HiveField(8) String createdAt;    // ISO8601 DateTime string
}
```

**Seed Data:** 5 simulated notifications are seeded on first launch.

**Repository methods:**
- `Future<void> addNotification(AppNotification notification)`
- `List<AppNotification> getAllNotifications({int limit = 50})`
- `Future<void> markAsRead(String notificationId)`
- `Future<void> markAllAsRead()`
- `Future<void> deleteNotification(String notificationId)`
- `int getUnreadCount()`

---

#### `SearchHistoryEntry` (typeId: 11) — Box: `search_history_box`
```dart
@HiveType(typeId: 11)
class SearchHistoryEntry extends HiveObject {
  @HiveField(0) String id;           // UUID v4
  @HiveField(1) String query;        // The search string
  @HiveField(2) String searchedAt;   // ISO8601 DateTime string
  @HiveField(3) int resultCount;     // How many results were returned
}
```

**Repository methods:**
- `Future<void> addSearchQuery(String query, int resultCount)` — deduplicates
- `List<SearchHistoryEntry> getRecentSearches({int limit = 10})`
- `Future<void> removeSearch(String id)`
- `Future<void> clearSearchHistory()`

---

## 5. COMPLETE SCREEN INVENTORY

### 5.1 All Screens — Master List

The following 32 screens comprise the complete StreamPro application. Screens marked [EXISTING] are already built but require enhancement. Screens marked [NEW] must be built from scratch.

| # | Screen Name | Route | Type | Status |
|---|---|---|---|---|
| 1 | Splash Screen | `/` | Full-screen | EXISTING — enhance |
| 2 | **Age Gate Screen** | `/age-gate` | Full-screen modal | **NEW** |
| 3 | **Onboarding Screen** | `/onboarding` | Multi-step | **NEW** |
| 4 | **Terms & Conditions Screen** | `/terms` | Scrollable legal | **NEW** |
| 5 | **Privacy Policy Screen** | `/privacy` | Scrollable legal | **NEW** |
| 6 | Home Screen | `/home` | Tab scaffold | EXISTING — enhance |
| 7 | Home Feed View | `/home` (tab 0) | Sub-view | EXISTING — enhance |
| 8 | Discover / Search View | `/home` (tab 1) | Sub-view | EXISTING — enhance |
| 9 | Trending View | `/home` (tab 2) | Sub-view | EXISTING — enhance |
| 10 | Library View | `/home` (tab 3) | Sub-view | EXISTING — enhance |
| 11 | **Profile Screen** | `/profile` | Full-screen | **NEW** |
| 12 | Video Player Screen | `/player` | Full-screen immersive | EXISTING — enhance |
| 13 | VPN Status Screen | `/vpn` | Full-screen | EXISTING — enhance |
| 14 | **Category Grid Screen** | `/categories` | Full-screen grid | **NEW** |
| 15 | Category Feed Screen | `/category/:id` | Paginated list | EXISTING — enhance |
| 16 | Settings Screen | `/settings` | Full-screen list | EXISTING — rewrite |
| 17 | **Playback Settings Screen** | `/settings/playback` | Sub-settings | **NEW** |
| 18 | **Notification Center Screen** | `/notifications` | List screen | **NEW** |
| 19 | **Downloads Screen** | `/downloads` | List + storage | **NEW** |
| 20 | **Playlists Screen** | `/playlists` | Grid list | **NEW** |
| 21 | **Playlist Detail Screen** | `/playlists/:id` | Ordered list | **NEW** |
| 22 | **Liked Videos Screen** | `/liked` | Grid view | **NEW** |
| 23 | **Comments Bottom Sheet** | N/A (modal) | Bottom sheet | **NEW** |
| 24 | **Long-Press Context Menu** | N/A (overlay) | Overlay modal | **NEW** |
| 25 | **Add to Playlist Bottom Sheet** | N/A (modal) | Bottom sheet | **NEW** |
| 26 | **Help & FAQ Screen** | `/help` | Accordion list | **NEW** |
| 27 | **About Screen** | `/about` | Info screen | **NEW** |
| 28 | **Advanced Search Filter Sheet** | N/A (modal) | Bottom sheet | **NEW** |
| 29 | **Parental Control Setup Screen** | `/settings/parental` | PIN flow | **NEW** |
| 30 | **Edit Profile Screen** | `/profile/edit` | Form screen | **NEW** |
| 31 | **Cast / Screen Mirror Screen** | `/cast` | Device picker | **NEW** |
| 32 | **No Internet / Offline Screen** | N/A (overlay) | Overlay | **NEW** |

---

## 6. SCREEN-BY-SCREEN SPECIFICATIONS

---

### SCREEN 1: Splash Screen (`/`) — ENHANCED

**Purpose:** Brand entry point. Loads configuration, checks first-launch state, routes to appropriate next screen.

**Layout:** Full-screen, no AppBar, no status bar. Background: `colorBackground (#0A0A0A)`. Centered vertically and horizontally.

**Visual Elements:**
- Animated logo mark: A stylized "SP" monogram inside a circle with a gradient border (`#C026D3 → #DB2777`). Size: 96×96dp. The border animates with a rotating gradient sweep (2000ms loop).
- App name text: "StreamPro" in `textDisplayLarge`, gradient shader from `#C026D3` to `#DB2777`.
- Tagline text: "Premium. Free. Unlimited." in `textBodyMedium`, color `colorTextMuted`.
- Bottom loading indicator: A custom thin progress bar (4dp height, full width minus 64dp horizontal padding), gradient fill, animated with a shimmer-pulse effect.

**Animation Sequence (timeline):**
1. 0ms: Screen appears with black background.
2. 0–300ms: Logo mark fades in + scales from 0.6 to 1.0 (`Curves.elasticOut`).
3. 300–600ms: App name fades in + slides up 12dp.
4. 600–900ms: Tagline fades in.
5. 900ms: Loading bar appears and begins pulse animation.
6. 1800ms: Load complete — route decision made (see routing logic below).
7. 1800–2100ms: All elements fade out simultaneously.
8. 2100ms: Route push with `FadeTransition`.

**Routing Logic (in order of priority):**
1. If `AppConfig.hasAcceptedTerms == false` → route to `/age-gate`
2. If `AppConfig.isFirstLaunch == true` → route to `/onboarding`
3. Otherwise → route to `/home`

---

### SCREEN 2: Age Gate Screen (`/age-gate`) — NEW

**Purpose:** Legal compliance gate. User must confirm they are 13+ (or 18+ for R-rated content) before proceeding to the app. This screen CANNOT be bypassed via back button.

**Behavior:** `WillPopScope`/`PopScope` with `canPop: false`. No back button. User must interact with the screen to exit.

**Layout:** Full-screen. Background: `colorBackground`. Centered column layout with 48dp horizontal padding.

**Visual Elements (top to bottom):**
1. Shield icon with a gradient fill (Material `Icons.shield_outlined`, size 72dp) — centered, with the neon glow shadow beneath it.
2. Heading: "Age Verification Required" in `textHeadlineLarge`, centered.
3. Body text (16dp top margin): "StreamPro contains content that may not be suitable for all audiences. Please confirm your age to continue." — `textBodyMedium`, `colorTextSecondary`, centered, 3 lines max.
4. Divider (32dp margin top/bottom): Full-width with `colorBorder`.
5. Year of Birth picker (custom widget): A horizontal scrollable row of 4-digit year numbers. Years range from current year minus 100 to current year. Selected year is centered and full brightness; adjacent years fade. Snap physics. Selected year stored in `UserProfile.birthYear`. Height: 80dp.
6. Age calculation label: "You are [X] years old" updates live as user scrolls the year picker. Color: `colorTextSecondary`.
7. Confirmation button (32dp top margin): Full-width `GradientButton` (primary style). Label: "Confirm My Age". Disabled state (gray) until a year is selected.
8. "I am under 13" link (16dp top margin): TextButton in `colorTextMuted`. Tapping shows a dialog: "Access Restricted. This app requires users to be at least 13 years of age." with a single "Exit App" button that calls `SystemNavigator.pop()`.
9. Terms reminder (bottom, 24dp above safe area): "By continuing, you agree to our [Terms of Service] and [Privacy Policy]" — inline hyperlinks that push those screens while keeping this screen in the stack.

**Logic:**
- If calculated age is < 13 → show the "under 13" dialog and block.
- If calculated age is 13–17 → set `AppConfig.hasAcceptedAgeGate = true`, `UserProfile.isAgeVerified = false`. R/NC-17 content will be hidden.
- If calculated age is 18+ → set `AppConfig.hasAcceptedAgeGate = true`, `UserProfile.isAgeVerified = true`. All content unlocked.
- After successful confirmation → route to `/onboarding` (if first launch) or `/home`.

---

### SCREEN 3: Onboarding Screen (`/onboarding`) — NEW

**Purpose:** First-launch flow introducing features and capturing user interests for personalization. Three steps.

**Layout:** Full-screen. `PageView` with 3 pages. No AppBar. Safe area respected.

**Navigation:** Dots indicator at bottom center (3 dots, active dot has gradient fill). "Skip" TextButton top-right. "Next" / "Get Started" button bottom-right.

**Page 1 — "Welcome to StreamPro":**
- Large Lottie animation (streaming/play themed) — 240dp height, centered.
- Title: "Stream Anything, Anytime" in `textDisplayMedium`.
- Body: "Discover thousands of premium videos across every genre — completely free." in `textBodyLarge`, `colorTextSecondary`.

**Page 2 — "Build Your Library":**
- Lottie animation (library/bookshelf themed) — 240dp height.
- Title: "Your Personal Library" in `textDisplayMedium`.
- Body: "Bookmark favorites, create playlists, and pick up right where you left off." in `textBodyLarge`.

**Page 3 — "Choose Your Interests" (interactive):**
- Title: "What Do You Love?" in `textDisplayMedium`.
- Subtitle: "Select at least 3 to personalize your feed."
- Interest chips grid: A `Wrap` of `FilterChip` widgets. Categories: Action, Comedy, Drama, Documentary, Music, Sports, Technology, Travel, Animation, Horror, Romance, Thriller, Science, Gaming, Cooking. Each chip has an emoji prefix.
- Chips use gradient border when selected, `colorSurface3` background when unselected.
- "Get Started" button is disabled until 3+ chips are selected. Enabled state has gradient background.
- On confirm: saves selected interests to `UserProfile.interests`, sets `AppConfig.isFirstLaunch = false`, routes to `/home`.

---

### SCREEN 4: Terms & Conditions Screen (`/terms`) — NEW

**Purpose:** Display the full app terms of service. Required for legal compliance.

**Layout:** Full-screen with custom AppBar. Background `colorBackground`.

**AppBar:**
- Title: "Terms of Service" in `textTitleLarge`.
- Leading: back arrow (only if opened from within the app, not from age gate blocking flow).
- No actions.

**Body:** `SingleChildScrollView` with 24dp horizontal padding.

**Content sections (each styled as expandable or continuous scroll):**
1. Last updated date: "Last Updated: January 1, 2026" — `textLabelSmall`, `colorTextMuted`.
2. Section headings: `textTitleLarge`, `colorTextPrimary`, 24dp top margin.
3. Body text: `textBodyMedium`, `colorTextSecondary`, 1.6 line height.
4. Sections required: Acceptance of Terms, Use of the Service, Intellectual Property, User Conduct, Disclaimers, Limitation of Liability, Changes to Terms, Contact Information.
5. Placeholder legal text appropriate for a free streaming app.

**Bottom Action Bar (only shown when accessed from age gate / onboarding):**
- Fixed at bottom, `colorSurface` background with top border.
- "I Accept" gradient button (full width minus 32dp padding).
- Sets `AppConfig.hasAcceptedTerms = true` on tap, then pops back.

---

### SCREEN 5: Privacy Policy Screen (`/privacy`) — NEW

**Purpose:** Display the app's privacy policy. Required for app store compliance.

**Layout:** Identical structure to Terms & Conditions screen.

**AppBar:** Title: "Privacy Policy".

**Content sections:** Introduction, Information We Collect, How We Use Information, Local Storage Disclosure (key: this app stores all data locally on-device), Third-Party Services (WebView / iFrame content), Your Rights, Children's Privacy (13+ requirement), Contact Us.

**Bottom Action Bar:** Same "I Accept" pattern, sets `AppConfig.hasAcceptedPrivacy = true`.

---

### SCREEN 6: Home Screen (`/home`) — ENHANCED

**Purpose:** Main app shell. Contains the `BottomNavigationBar`, `AppBar`, and `DrawerMenu`. Houses the four primary sub-views via `IndexedStack` (preserves state across tab switches).

**Layout:** `Scaffold` with:
- Custom `AppBar` (transparent, blurred via `BackdropFilter`)
- `BottomNavigationBar` (custom styled)
- `Drawer` (existing `MainDrawer`, enhanced)
- `IndexedStack` body with 4 children

**AppBar:**
- Background: transparent with a `BackdropFilter` blur (sigmaX: 20, sigmaY: 20), painted only over the status bar area.
- Leading: hamburger icon → opens `Drawer`. Uses `AnimatedIcon` that morphs between menu and close states.
- Center widget: "StreamPro" logo text in `textTitleLarge` with gradient shader. Only visible on Home Feed tab. Other tabs show their tab name.
- Actions row (right side):
  - Notification bell icon (from `AppNotification.getUnreadCount()`, shows red dot badge if count > 0) → pushes `/notifications`.
  - VPN quick-toggle icon: Shows green dot (connected) or gray dot (disconnected). Tapping pushes `/vpn`.
  - Search icon (only visible on non-Discover tabs) → programmatically switches to Discover tab and focuses the search field.

**BottomNavigationBar:**
- Type: `BottomNavigationBarType.fixed`.
- Background: `colorSurface` with a top border `colorBorder`.
- Selected item color: gradient (use `ShaderMask` on the icon and label).
- Unselected item color: `colorTextMuted`.
- Items: Home (`Icons.home_rounded`), Discover (`Icons.explore_rounded`), Trending (`Icons.local_fire_department_rounded`), Library (`Icons.video_library_rounded`).
- Tab switch is animated: `AnimatedSwitcher` with a `FadeTransition` (160ms).
- Swipe left/right on the body area (not on videos) switches tabs (see Gesture #5).

**MainDrawer (Enhanced):**
- Header: gradient background (`colorGradientStart → colorGradientEnd`), user avatar (circle, 56dp), display name in `textTitleLarge`, "Free Member" badge.
- Navigation items with icons: Home, My Profile, My Playlists, Downloads, Liked Videos, VPN Status, Settings, Help & FAQ, About.
- Bottom of drawer: Divider, then "Privacy Policy" and "Terms of Service" text links side by side, then app version ("v1.0.0") in `textLabelSmall`.
- Active item has a gradient left border (4dp wide) and `colorSurface2` background.

---

### SCREEN 7: Home Feed View (Tab 0) — ENHANCED

**Purpose:** The main content discovery surface. Hero carousel + curated horizontal sections.

**Layout:** `CustomScrollView` with `SliverList` children. Pull-to-refresh enabled (Gesture #1).

**Sections (top to bottom):**

1. **Hero Featured Carousel:**
   - Full-width, 220dp height.
   - `CarouselSlider` of featured videos (`VideoEntity.isFeatured == true`, up to 6 items).
   - Each slide: full-bleed thumbnail with gradient overlay from transparent to `colorBackground` at the bottom. Over the gradient: video title in `textHeadlineMedium`, category chip, duration badge, and a "Watch Now" gradient button.
   - Auto-advances every 5 seconds. Dots indicator below.
   - Taps push `/player` with the video entity.

2. **"Continue Watching" Section** (only shows if `history_box` has entries with `progressPercent < 0.9`):
   - Section header with "Continue Watching" title and "See All" → `/library`.
   - Horizontal `ListView` of `VideoCard` widgets with a progress bar overlay (bottom, 3dp height, gradient fill).
   - Card size: 160dp wide, 100dp tall.

3. **"New This Week" Section:**
   - Section header with "New This Week" and "See All" → `/category/new`.
   - Horizontal `ListView` of standard `VideoCard` (160×100dp). Videos with `isNew == true`.

4. **Category Row Chips:**
   - Horizontally scrollable `FilterChip` row of all unique categories.
   - Tapping a chip pushes `/category/:name`.

5. **"Trending Now" Section:**
   - Section header with fire emoji, "Trending Now" title, "See All" → Trending tab.
   - Horizontal `ListView`. Videos where `isTrending == true`.

6. **"Recommended For You" Section:**
   - Section header. Videos filtered by `UserProfile.interests`.
   - Horizontal `ListView`.

7. **"Top Rated" Section:**
   - Vertical `ListView` of ranked items (numbered 1–10) with rank number in large gradient text.

---

### SCREEN 8: Discover / Search View (Tab 1) — ENHANCED

**Purpose:** Full-text search + browse by filters.

**Layout:** Column: Search bar at top (sticky), filter chips row below, results grid fills remainder.

**Search Bar:**
- Custom styled `TextField` inside a `Container` with `colorSurface3` background, `radiusLG`, and a gradient border when focused.
- Leading: gradient search icon. Trailing: clear button (appears when text is non-empty), or microphone icon (placeholder for voice search, shows "Coming Soon" snackbar).
- Debounce: 350ms.
- On submit: saves query to `search_history_box`.

**Below Search Bar — States:**
- **Idle (no text):** Shows "Recent Searches" chips (from `search_history_box`), then "Trending Searches" static chips, then "Browse by Category" 2-column grid of category cards.
- **Searching (text entered, results loading):** Shows `SkeletonVideoCard` grid.
- **Search Results (results loaded):** Shows `PagedMasonryGridView` of `PremiumVideoCard`.
- **Empty Results:** Shows `EmptyStateWidget` (see Section 10).
- **Error:** Shows `ErrorStateWidget` with retry.

**Filter Bottom Sheet (triggered by filter icon in search bar):**
- Slide-up bottom sheet.
- Sections: Sort By (Most Relevant, Most Views, Newest, Duration), Duration (Any, <5min, 5–20min, 20–60min, 60min+), Category (multi-select chips), Content Rating (G, PG, PG-13, R — R disabled if `isAgeVerified == false`).
- "Apply Filters" gradient button. "Reset" text button.

---

### SCREEN 9: Trending View (Tab 2) — ENHANCED

**Purpose:** Ranked discovery of top content.

**Layout:** `DefaultTabController` with two sub-tabs: "Today" and "This Week".

**Tab Content:** `PagedListView` of ranking rows.

Each ranking row:
- Rank number in `textDisplayLarge`, gradient color, 48dp wide, left-aligned.
- Thumbnail 80×52dp, `radiusSM`.
- Right of thumbnail: title in `textTitleMedium`, view count in `textLabelSmall` with eye icon, duration chip.
- Trailing: bookmark icon button (toggles bookmark, filled/outlined state).

**Pull-to-refresh enabled.** Skeleton loading for initial load.

---

### SCREEN 10: Library View (Tab 3) — ENHANCED

**Purpose:** Personal content hub — history, bookmarks, downloads, playlists, liked videos.

**Layout:** `DefaultTabController` with 5 sub-tabs.

**Sub-tabs:** History, Bookmarks, Downloads, Playlists, Liked.

**History sub-tab:**
- Chronological list of `WatchHistoryEntry` records joined with `VideoEntity`.
- Each item: thumbnail with progress bar overlay, title, "watched X ago" in `textLabelSmall`.
- Swipe-to-delete (left swipe reveals red delete action using `flutter_slidable`).
- Header: "Clear All History" button (right side) → confirmation dialog.

**Bookmarks sub-tab:**
- `PagedMasonryGridView` of bookmarked videos.
- Long-press → context menu (remove bookmark, add to playlist).

**Downloads sub-tab:**
- List of `DownloadRecord` items.
- Each item shows: thumbnail, title, status badge (colored by status), progress bar (if downloading), file size, expiry date.
- Swipe-to-delete.
- Header shows total storage used ("2.4 GB used").

**Playlists sub-tab:**
- Grid (2 columns) of `Playlist` cards.
- Card: cover thumbnail (from `coverVideoId`), playlist name, video count.
- "+" FAB in bottom-right → "Create Playlist" bottom sheet.

**Liked sub-tab:**
- `PagedMasonryGridView` of liked videos (from `likes_box` where `reaction == 'like'`).
- Empty state: heart illustration with "Like videos to find them here."

---

### SCREEN 11: Profile Screen (`/profile`) — NEW

**Purpose:** Guest profile overview with stats and quick links.

**AppBar:** "My Profile", back button, edit icon → `/profile/edit`.

**Layout:** `CustomScrollView`.

**Header section:**
- Large avatar (80dp circle). Default: gradient circle with user initial. Custom: `CachedNetworkImage`.
- Display name in `textHeadlineMedium`.
- "Free Member" badge (pill chip with gradient border).
- Row of 3 stats: Videos Watched (number), Watch Time (formatted "Xh Ym"), Liked Videos (number). Each stat in a `_StatCard` with value in `textDisplayMedium` and label in `textLabelSmall`.

**Sections:**
- My Interests (horizontal chip row of `UserProfile.interests` with edit button).
- Recent Activity (last 5 watched videos in horizontal scroll).
- Quick Links list: My Playlists, My Downloads, Liked Videos, Watch History.
- Account section: Privacy Settings, Help & FAQ, About.

---

### SCREEN 12: Video Player Screen (`/player`) — HEAVILY ENHANCED

**Purpose:** Immersive full-screen video playback with complete gesture system and supplementary content.

**Layout:** Full-screen, `SystemUiMode.immersiveSticky`. Background `#000000`. The WebView fills the entire screen. All controls are overlay layers using `Stack`.

**Layer Stack (bottom to top):**
1. `InAppWebView` — fills entire screen.
2. `GestureDetector` transparent overlay — captures all player gestures (see Section 9 for complete gesture spec).
3. Brightness overlay (left 40% of screen) — a semi-transparent black/white `AnimatedOpacity` layer for brightness gesture feedback.
4. Volume overlay (right 40% of screen) — same pattern for volume.
5. Seek feedback overlay (center) — shows "◀◀ 10s" or "10s ▶▶" text + ripple animation on double-tap.
6. Main controls overlay (fades in/out on tap):
   - Top bar: back button (gradient circle icon button), video title (truncated), cast icon, share icon.
   - Center: Previous, Play/Pause, Next (large gradient icon buttons).
   - Bottom bar: current time text, thin gradient progress/seek bar (custom `CustomPainter`), total time text, fullscreen toggle, quality selector, subtitles toggle.
7. Speed indicator (top-right corner) — shows "2×" badge when long-press speed boost is active.
8. PiP button (top-right, below cast) — activates Picture-in-Picture mode.
9. Mini brightness/volume HUD (left/right edges) — vertical slider visualization during gesture.
10. Related videos / comments sheet (slides up from bottom, 40% screen height) — triggered by swipe-up gesture or "↑ More" label.

**Controls auto-hide:** Controls overlay auto-hides after 3 seconds of inactivity. Re-appear on any tap.

**Related Videos in sheet:**
- Horizontal scrollable list of related videos (from `VideoEntity.relatedVideoIds`).
- Tapping a related video navigates to it (replaces current player instance, does not push new route).

**Comments in sheet:**
- Toggle between "Related" and "Comments" via two tabs within the bottom sheet.
- Comment list from `comments_box`.
- "Add Comment" text field pinned at bottom of sheet (keyboard-aware).

**Landscape mode:** Automatically triggered when device is rotated. Controls layout adjusts for wider aspect ratio.

---

### SCREEN 13: VPN Status Screen (`/vpn`) — ENHANCED

**Purpose:** Simulate and display VPN status with country selection.

**AppBar:** "VPN Protection", back button.

**Layout:** `SingleChildScrollView`. Column.

**Connection Widget:**
- Large animated circle (120dp). When connected: pulsing green glow (`colorSuccess`). When connecting: rotating arc animation. When disconnected: static gray.
- Status text: "Protected" / "Connecting..." / "Not Protected".
- Toggle switch with "Auto-Connect" label.

**Connected Server Card:**
- `colorSurface2` background, `radiusLG`.
- Flag emoji, country name, server city, ping (simulated, e.g., "24ms"), connection type ("Optimal Server").

**Country List:**
- Section header "Select Server".
- List of 20 country options with flag, name, ping badge.
- Currently selected has gradient left border.
- Tapping triggers `VpnBloc.ConnectToCountryEvent`.

**Info Cards Row (3 cards):**
- IP Protection, No Logs, 256-bit (all cosmetic, with icons and labels).

---

### SCREEN 14: Category Grid Screen (`/categories`) — NEW

**Purpose:** Visual entry point to all content categories.

**AppBar:** "Browse Categories".

**Layout:** `GridView.count(crossAxisCount: 2)` with 12dp spacing.

**Category Card (each cell):**
- Size: fills cell, aspect ratio 16:9.
- Background: category-specific gradient (unique gradient per category from a predefined palette map).
- Center: category icon (custom icons per category) + category name in `textHeadlineMedium`.
- Bottom-right: video count badge (e.g., "10 videos").
- Tap → pushes `/category/:name`.

**Categories:** Action, Comedy, Drama, Documentary, Music, Sports, Technology, Travel (8 required, 160 total videos distributed).

---

### SCREEN 15: Category Feed Screen (`/category/:id`) — ENHANCED

**AppBar:** Category name as title. Filter icon action → Advanced Search Filter Sheet.

**Layout:** `PagedMasonryGridView` (staggered grid, 2 columns).

**Sub-tab row:** Filters by "All", "New", "Most Viewed", "Shortest", "Longest".

Pull-to-refresh enabled. Skeleton loading on initial load. Empty state when no results.

---

### SCREEN 16: Settings Screen (`/settings`) — REWRITE

**Purpose:** Full functional settings (replacing the current placeholder).

**AppBar:** "Settings".

**Layout:** `ListView` of section groups.

**Section 1 — Playback:**
- "Playback Settings" → `/settings/playback` (new dedicated screen).

**Section 2 — Notifications:**
- "Push Notifications" toggle (linked to `AppConfig.notificationsEnabled`).
- "Notification Preferences" → sub-screen.

**Section 3 — Privacy & Parental Controls:**
- "Parental Controls" → `/settings/parental`.
- "Privacy Policy" → `/privacy`.
- "Terms of Service" → `/terms`.

**Section 4 — Storage:**
- "Cache Size" — computed and displayed (e.g., "Cached thumbnails: 12 MB").
- "Clear Image Cache" → action with confirmation dialog → calls `CachedNetworkImage.evictFromCache()` equivalent.
- "Clear Watch History" → confirmation dialog → calls `repository.clearAllHistory()` (functional now, not a snackbar placeholder).
- "Clear All Downloads" → confirmation dialog.

**Section 5 — About:**
- "App Version" — reads from `package_info_plus`, shows "StreamPro v1.0.0 (Build 1)".
- "Help & FAQ" → `/help`.
- "About StreamPro" → `/about`.
- "Rate the App" → `url_launcher` to app store (placeholder URL).
- "Share App" → `share_plus` plugin.

---

### SCREEN 17: Playback Settings Screen (`/settings/playback`) — NEW

**AppBar:** "Playback Settings", back button.

**Settings Items:**
- "Default Video Quality" → `DropdownButton`: Auto, 1080p, 720p, 480p, 360p. Saved to `AppConfig.videoQuality`.
- "Auto-Play Videos" toggle → `AppConfig.autoPlayEnabled`.
- "Auto-Play Next Video" toggle → `AppConfig.autoPlayNextEnabled`.
- "Loop Video" toggle → `AppConfig.loopVideoEnabled`.
- "Keep Screen On During Playback" toggle → `wakelock_plus`.
- "Show Subtitles" toggle → `AppConfig.showSubtitles`.

---

### SCREEN 18: Notification Center Screen (`/notifications`) — NEW

**AppBar:** "Notifications", back button. "Mark All Read" text action button.

**Layout:** `ListView` of notification cards.

**Notification Card:**
- `colorSurface` background (unread: slightly elevated, `colorSurface2`).
- Leading: notification type icon with gradient background circle.
- Title in `textTitleMedium` (bold if unread).
- Body in `textBodySmall`, `colorTextSecondary`, max 2 lines.
- Timestamp in `textLabelSmall`, `colorTextMuted`.
- Unread blue dot indicator (right side).
- Tap → marks as read, navigates to `actionRoute` if set.
- Swipe-to-delete (left swipe).

**Empty State:** Bell illustration with "No notifications yet. Check back soon!"

---

### SCREEN 19: Downloads Screen (`/downloads`) — NEW

**AppBar:** "My Downloads". Storage usage subtitle: "X GB used of simulated storage".

**Layout:** `Column`: storage summary card at top, then `ListView` of download items.

**Storage Summary Card:**
- `colorSurface2` background, `radiusLG`, 16dp padding.
- Progress bar showing storage percentage used (simulated max 10 GB).
- "X.X GB of 10 GB used" label.

**Download Item:**
- Thumbnail 80×52dp.
- Title in `textTitleMedium`.
- Status badge (gradient "Completed" / amber "Downloading" / red "Failed" / gray "Queued").
- Progress bar (only shown if status is 'downloading', animated).
- File size and quality badge (e.g., "720p • 450 MB").
- Expiry: "Expires in X days" in `textLabelSmall colorWarning`.
- Swipe-to-delete via `flutter_slidable`.
- Tap: opens player if completed; shows progress/options if in progress.

**FAB:** "Download New Videos" → navigates back to Home.

**Empty State:** Download icon illustration with "No downloads yet. Save videos to watch offline!"

---

### SCREEN 20: Playlists Screen (`/playlists`) — NEW

**AppBar:** "My Playlists". "+" action button → Create Playlist bottom sheet.

**Layout:** `PagedGridView` (2 columns).

**Playlist Card:**
- Thumbnail from cover video.
- Gradient overlay at bottom.
- Playlist name in `textTitleLarge`.
- Video count badge.
- User-selected accent color as a thin border (from `Playlist.color`).

**Create Playlist Bottom Sheet:**
- "New Playlist" title.
- Name field (required), description field (optional).
- Color picker row (6 preset accent colors as circle taps).
- "Create" gradient button.
- Validates: name required, max 50 chars.

**Empty State:** Playlist icon with "Create your first playlist!"

---

### SCREEN 21: Playlist Detail Screen (`/playlists/:id`) — NEW

**AppBar:** Playlist name. Edit icon (opens rename bottom sheet). More menu (3-dot): Rename, Delete Playlist, Share.

**Header:**
- Full-width cover image (from first video thumbnail) with gradient overlay.
- Playlist name in `textDisplayMedium`, description, video count.
- "Play All" and "Shuffle" gradient buttons side by side.

**Body:** `ReorderableListView` of `PlaylistItem` cards.
- Each item: thumbnail, title, duration, drag handle (right side).
- Swipe-to-delete via `flutter_slidable`.

---

### SCREEN 22: Liked Videos Screen (`/liked`) — NEW

**AppBar:** "Liked Videos". `{count}` subtitle showing total likes.

**Layout:** `PagedMasonryGridView`.

**Empty State:** Heart illustration, "Videos you like will appear here."

---

### SCREEN 23: Comments Bottom Sheet — NEW

**Trigger:** Swipe-up from player, or "Comments" tab in the player bottom sheet.

**Layout:** `DraggableScrollableSheet` (initial size: 0.5, max: 0.9, min: 0.15).

**Header:** Drag handle pill, "Comments" title, comment count, close button.

**Comment Card:**
- Avatar circle (40dp).
- Author name `textTitleMedium`, timestamp `textLabelSmall`.
- Comment text `textBodyMedium`.
- Like button (thumbs up + count), Reply button (text).
- User's own comments: delete icon on long-press.

**Add Comment area (pinned to bottom, above keyboard):**
- User avatar (24dp circle), `TextField` with hint "Add a comment...", gradient "Post" button.
- Keyboard-aware via `Padding(padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom))`.

---

### SCREEN 24: Long-Press Context Menu — NEW

**Trigger:** Long-press on any `PremiumVideoCard` anywhere in the app (Gesture #4).

**Presentation:** `showModalBottomSheet` with a handle, non-dismissible until user taps an option or the backdrop.

**Header:** Video thumbnail (60×40dp), title (truncated to 2 lines), duration chip.

**Menu Items (each a `ListTile`):**
- ▶ Watch Now → navigates to player.
- ＋ Add to Playlist → pushes Add to Playlist bottom sheet.
- ↓ Download (if not already downloaded) OR ✓ Downloaded (if it is).
- ♥ Like / ♡ Unlike (toggle based on current `likes_box` state).
- 🔖 Bookmark / Remove Bookmark (toggle).
- ↗ Share → `share_plus` with video title and a placeholder URL.
- 🚫 Not Interested (removes from current feed; stored in a local exclusion list).

---

### SCREEN 25: Add to Playlist Bottom Sheet — NEW

**Trigger:** "Add to Playlist" from long-press menu or player screen.

**Layout:** `showModalBottomSheet`, non-scrollable if fewer than 6 playlists, scrollable otherwise.

**Header:** "Add to Playlist" title, close button.

**Body:** List of all user playlists. Each row: playlist cover thumbnail (40dp circle), name, video count. Checkmark shown if the video is already in that playlist.

**Footer:** "Create New Playlist +" button.

---

### SCREEN 26: Help & FAQ Screen (`/help`) — NEW

**AppBar:** "Help & FAQ".

**Layout:** `ExpansionTile` list grouped by category.

**Categories and Sample Questions:**
- Getting Started: "How do I bookmark a video?", "How do I create a playlist?", "What is VPN Simulation?"
- Playback: "Why won't the video load?", "How do I change video quality?", "What does the gesture control do?"
- Library: "How do I download a video?", "How do I clear my watch history?"
- Privacy: "What data does StreamPro collect?", "How do I delete my data?"

Each expansion shows answer text in `textBodyMedium`, `colorTextSecondary`.

**Contact footer:** "Still need help? [Contact Us]" → `url_launcher` with `mailto:` scheme.

---

### SCREEN 27: About Screen (`/about`) — NEW

**AppBar:** "About StreamPro".

**Layout:** Centered column, padded.

**Content:** Large app logo, app name, version number (from `package_info_plus`), tagline. Then a list: Open Source Licenses, Rate the App, Share the App, Follow Us. Divider. "Made with ♥ using Flutter" credit at bottom.

---

### SCREEN 28: Advanced Search Filter Sheet — NEW

Already specified in Screen 8 body. Must be reachable from Discover, Category Feed, and Trending screens via a filter icon in the AppBar.

---

### SCREEN 29: Parental Control Setup Screen (`/settings/parental`) — NEW

**Purpose:** Enable PIN-based parental lock to restrict R/NC-17 content.

**AppBar:** "Parental Controls".

**States:**
- **Disabled state:** Explanation of what parental controls do + "Enable Parental Controls" gradient button.
- **Setup state (setting PIN):** Number pad (0–9 + backspace). Row of 4 dot indicators (filled as PIN entered). Instructions: "Enter a 4-digit PIN". After 4 digits → "Confirm PIN" step. If match → saves PIN to `AppConfig.parentalPin`, sets `parentalControlEnabled = true`.
- **Enabled state:** "Parental Controls Active" checkmark, "Change PIN" and "Disable Parental Controls" (requires entering current PIN) options.

---

### SCREEN 30: Edit Profile Screen (`/profile/edit`) — NEW

**AppBar:** "Edit Profile". "Save" action button.

**Form fields:**
- Avatar: Tappable circle. Options: "Choose from Gallery" (calls image picker — `image_picker` package), "Remove Photo". Preview updates live.
- Display Name: `TextField`, required, max 30 chars.
- Interests: Scrollable chip grid (same as onboarding step 3, pre-selected with current interests).
- "Save" button validates and writes to `UserProfile`.

---

### SCREEN 31: Cast / Screen Mirror Screen (`/cast`) — NEW

**AppBar:** "Cast to Device".

**Layout:** Centered illustration + content.

**Content:** Animated Wi-Fi / cast icon. "Looking for devices..." spinner. List of simulated nearby devices (3 hardcoded entries: "Living Room TV", "Bedroom Display", "Kitchen Screen"). Each device has a cast icon, device name, and signal strength bars. Tapping shows a "Cast Started" confirmation snackbar. This is a UI placeholder — actual casting not implemented.

**Note at bottom:** "Chromecast and AirPlay support coming soon."

---

### SCREEN 32: No Internet / Offline Overlay — NEW

**Trigger:** `connectivity_plus` stream emits `ConnectivityResult.none`.

**Presentation:** Full-screen overlay (not a new route) using an `OverlayEntry` inserted into the app's `Overlay`. Non-dismissible.

**Layout:** Centered column. Wi-Fi-off Lottie animation. "No Internet Connection" heading. "Check your connection and try again." body text. "Try Again" button → re-checks connectivity and removes overlay if restored.

**Auto-dismiss:** When connectivity is restored, the overlay fades out and a brief "Back Online" success snackbar appears at the top.

---

## 7. 10 NEW CORE FEATURES — FULL SPECIFICATION

---

### Feature 1: Complete Local Database Expansion

This is fully specified in Section 4. All 12 Hive boxes must be implemented with complete CRUD repository methods, seed data, and BLoC integration. A `DatabaseService` class must be created in `core/services/database_service.dart` that handles all box initialization, migration versioning, and factory-reset logic. All repositories registered in `injection.dart` as lazy singletons.

---

### Feature 2: Picture-in-Picture (PiP) Mode

**Platform support:** Android (API 26+), iOS (15+).

**Trigger:** Player screen "PiP" button tap, OR swipe-down from top edge of player (see Video Player Gesture #8), OR pressing the Home button while in the player.

**Android implementation:**
- Override `onUserLeaveHint()` in `MainActivity.kt` via a Method Channel to enter PiP mode.
- PiP window size: 16:9 aspect ratio, 250×140dp.
- PiP remote actions: Play/Pause, Close.
- `flutter_pip` package or custom platform channel in `pip_platform_channel.dart` (new file in `features/player/data/datasources/`).

**iOS implementation:**
- Use `AVKit` Picture in Picture via platform channel.
- iOS 15+ only. Graceful degradation on older versions (hide button, show "Not available on this device" snackbar).

**Flutter overlay (both platforms):**
- When PiP is active and the user navigates away but doesn't use native PiP, show a floating draggable mini-player widget using `OverlayEntry`.
- Mini-player: 180×100dp, `colorSurface` background, video title truncated, tap-to-return to full player, close button.
- Draggable to any corner of the screen (snaps to nearest corner on release with spring animation).

**State management:** New `PipBloc` with states: `PipInactive`, `PipActive(videoId)`. Registered in injection.

---

### Feature 3: Casting Support (UI + Hooks)

Fully specified in Screen 31. Additionally:
- Cast icon button added to the Video Player top bar (Screen 12).
- A `CastService` class in `core/services/cast_service.dart` with method `Future<void> startCast(VideoEntity video, String deviceId)` — currently a no-op with a success simulation after 1 second.
- Simulated cast state: `isCasting: bool`, `castingToDevice: String?`. Stored in `AppConfig`.
- When `isCasting == true`, a "Casting to [Device Name]" banner appears at the top of the video player.

---

### Feature 4: Custom Playlists Creation

Fully specified in Screens 20, 21, and 25. Additionally:
- "Add to Playlist" action accessible from: Long-press context menu (Screen 24), Video player top-bar more menu, library view long-press.
- Playlist reordering via `ReorderableListView` in Screen 21 updates `PlaylistItem.position` in Hive.
- Maximum playlists: 20. If exceeded, show "Playlist limit reached (20/20)" snackbar.
- Playlist cover auto-updates to the first video in the playlist whenever items are reordered.
- New `PlaylistBloc` managing `PlaylistState` with events: `LoadPlaylists`, `CreatePlaylist`, `UpdatePlaylist`, `DeletePlaylist`, `AddVideoToPlaylist`, `RemoveVideoFromPlaylist`, `ReorderPlaylist`.

---

### Feature 5: Offline Downloads Simulation

Fully specified in Screen 19. Additional implementation details:
- `DownloadSimulationService` in `core/services/download_service.dart` — manages a `Timer`-based progress simulation. Each simulated download progresses at a rate of ~5% per second, with random pauses simulating real network variance.
- Download speed display: "1.2 MB/s" (randomized between 0.8 and 2.5 MB/s).
- Maximum concurrent downloads: 2. If a 3rd is requested → queued state.
- `DownloadBloc` with states: `DownloadsLoaded(List<DownloadRecord>)`, `DownloadStarted(id)`, `DownloadProgressUpdated(id, progress)`, `DownloadCompleted(id)`, `DownloadFailed(id, reason)`.
- Local notification fired on download completion via `flutter_local_notifications`.

---

### Feature 6: Global Empty / Error / Skeleton States

Fully specified in Section 10. Every screen in the app must handle all three states. No screen is permitted to show a raw `CircularProgressIndicator` without theming, or an empty white/black void.

---

### Feature 7: In-App Notification System

**`NotificationBloc`:** New BLoC managing `notifications_box` state. Events: `LoadNotifications`, `MarkAsRead(id)`, `MarkAllRead`, `DeleteNotification(id)`, `AddNotification(AppNotification)`.

**Simulated notifications are generated at these app events:**
- First launch → "Welcome to StreamPro! Start exploring." (type: `system`).
- After watching 5 videos → "🔥 You're on a roll! Check out today's trending videos." (type: `trending`).
- After creating a playlist → "Playlist created! Keep adding your favorites." (type: `system`).
- On app resume after 24+ hours → "New videos added this week. Don't miss out!" (type: `new_video`).

**Notification badge:** The bell icon in the AppBar shows a red dot when `unreadCount > 0`. The dot is a 8dp circle at the top-right of the icon, filled `colorError`.

---

### Feature 8: Like / Dislike System

**UI integration:**
- `PremiumVideoCard` updated with a small heart icon in the bottom-right of the thumbnail overlay. Filled gradient heart if liked, outlined if not.
- Video player top bar: Like (thumbs-up) and dislike (thumbs-down) icon buttons, with counts.
- Liked Videos screen (Screen 22).

**Animation:** On like tap: heart icon bounces (scale 1.0 → 1.4 → 1.0 with `Curves.elasticOut`, 350ms) + particle burst effect (5 small heart particles fly outward and fade, using `AnimationController` + `CustomPainter`).

**`LikeBloc`:** Events: `SetReaction(videoId, reaction)`, `LoadReaction(videoId)`. States: `ReactionState(videoId, reaction)`.

---

### Feature 9: Simulated Comments Section

Fully specified in Screen 23 and Section 4 (`comments_box`). Additional details:
- Comment character limit: 500. Live counter shown as user types.
- Posted user comments have a "You" badge next to the author name.
- Long-press on user's own comment → delete option.
- `CommentBloc` per video (factory, not singleton). Events: `LoadComments(videoId)`, `PostComment(videoId, text)`, `DeleteComment(commentId)`, `LikeComment(commentId)`.

---

### Feature 10: Advanced Video Filtering & Sorting

Already specified in Screen 28 (Advanced Search Filter Sheet). Additional requirements:
- Filter state is preserved within a session (not persisted across app restarts).
- Active filters are displayed as dismissible chips below the search bar in Discover view.
- A filter count badge on the filter icon (e.g., "3" badge when 3 filters are active).
- `FilterBloc` (or extend `VideoListBloc`) with `FilterState(sortBy, durationRange, categories, ratings)`.
- All filtering is performed in-memory on the local Hive dataset using Dart collection operations.

---

## 8. 10 NEW GLOBAL APP GESTURES — FULL SPECIFICATION

Each gesture requires: the detection implementation, haptic feedback, animation/visual feedback, and the resulting action.

---

### Gesture 1: Pull-to-Refresh

**Screens:** Home Feed, Discover (when showing results), Trending, Category Feed.

**Implementation:** Wrap `CustomScrollView` in `RefreshIndicator`. Customize the `RefreshIndicator` indicator to use the app's brand colors: gradient circular indicator, 40dp displacement, 2dp stroke width.

**Action:** Triggers the relevant BLoC `Reload` event, which clears `PagingController` and restarts the first page load. Success: brief "Updated" snackbar. The `RefreshIndicator` color must match the gradient — use `color: colorPrimary`.

**Haptics:** `HapticFeedback.mediumImpact()` when the refresh threshold is crossed.

---

### Gesture 2: Swipe-to-Dismiss (Bottom Sheets & Dialogs)

**Screens:** All bottom sheets (Comments, Context Menu, Add to Playlist, Filter Sheet, Create Playlist).

**Implementation:** All bottom sheets use `DraggableScrollableSheet` with a drag handle indicator (centered pill, 4×40dp, `colorSurface3`). Dragging down past 30% of initial size triggers dismissal with `Navigator.pop()`.

**Visual feedback:** The sheet's background opacity decreases as the user drags down (opacity = 1.0 - (dragOffset / maxOffset) * 0.5).

**Haptics:** `HapticFeedback.selectionClick()` when dismissal threshold is crossed.

---

### Gesture 3: Edge-Swipe Back (iOS-Style on Android)

**Screens:** All secondary screens (not main tabs).

**Implementation:** Wrap the entire `MaterialApp` with a custom `BackGestureDetector`. On Android, `PopScope(canPop: false)` is already used; replace with logic that detects a left-edge horizontal swipe (starting within 20dp of the left edge, minimum velocity 300dp/s) and programmatically calls `_safePop()`.

**Visual feedback:** As the swipe progresses, the current screen slides right (transform translate x = swipeOffset), and a semi-transparent shadow appears on the left edge revealing the previous screen behind it.

**Haptics:** `HapticFeedback.lightImpact()` when back gesture commits.

---

### Gesture 4: Long-Press on Video Card (Context Menu)

**Screens:** All screens containing `PremiumVideoCard`.

**Implementation:** In `PremiumVideoCard`, wrap the card `GestureDetector`'s existing `onTap` with also `onLongPress`. On long-press: `HapticFeedback.heavyImpact()` + card scales to 0.95 (80ms) + shows the Long-Press Context Menu bottom sheet (Screen 24).

**Visual feedback:** During the long-press hold (before threshold), the card's brightness increases slightly (add a white overlay with opacity 0.05) and a ripple emits from the press point.

---

### Gesture 5: Horizontal Swipe Between BottomNav Tabs

**Screens:** Main `HomePage` body.

**Implementation:** Wrap the `IndexedStack` body in a `GestureDetector`. Detect horizontal swipe with minimum velocity 400dp/s and minimum drag distance 50dp. Swipe left → next tab, swipe right → previous tab. Clamp at tab bounds (0 and 3).

**Visual feedback:** `AnimatedSwitcher` between tabs with a horizontal slide direction (slide left when going to higher index, right when going to lower). Transition duration 250ms.

**Haptics:** `HapticFeedback.selectionClick()` on tab change.

---

### Gesture 6: Double-Tap on Card (Quick Like)

**Screens:** All `PremiumVideoCard` instances.

**Implementation:** In `PremiumVideoCard`, use `GestureDetector.onDoubleTap`. Call `LikeBloc.add(SetReaction(videoId, 'like'))`. Show a floating like animation: a large heart icon (64dp) animates from the tap position — it scales from 0.5 to 1.2 to 1.0 (Elastic curve) then fades out over 800ms. The animation is implemented via `OverlayEntry` positioned at the tap coordinates.

**Haptics:** `HapticFeedback.mediumImpact()`.

---

### Gesture 7: Pinch-to-Zoom on Grid (Column Count)

**Screens:** Discover (`PagedMasonryGridView`), Liked Videos, Bookmarks, Category Feed.

**Implementation:** Wrap the grid in a `GestureDetector` with `onScaleUpdate`. Map the scale value to column count: scale < 0.8 → 3 columns, 0.8–1.2 → 2 columns, scale > 1.2 → 1 column. Debounce transitions (minimum 200ms between column count changes to avoid rapid flickering).

**Visual feedback:** On column count change, `AnimatedSwitcher` replaces the grid with the new column count variant (200ms fade). Show a brief overlay badge in the top-right corner indicating the new column count (e.g., a "⬛⬛" icon for 2 columns).

**Haptics:** `HapticFeedback.selectionClick()` on each column change.

---

### Gesture 8: Two-Finger Tap (Global Play/Pause for Active PiP)

**Screens:** Any screen while PiP mini-player is active.

**Implementation:** The draggable `OverlayEntry` mini-player widget (Feature 2) listens for `onTapUp` on itself. Additionally, when PiP is active, the `Scaffold` body is wrapped in a `RawGestureDetector` that detects simultaneous two-finger tap anywhere on screen.

**Action:** Toggles `PipBloc` play/pause state. The mini-player shows a brief play/pause icon flash (icon appears centered, opacity 1.0 → 0.0 over 600ms).

**Haptics:** `HapticFeedback.lightImpact()`.

---

### Gesture 9: Swipe-Up on Home Feed (Jump to Search)

**Screens:** Home Feed View (Tab 0 only).

**Implementation:** In `HomeFeedView`, detect an upward fling gesture (`onVerticalDragEnd` with velocity < -800dp/s) while the scroll position is at the very top (offset == 0). This fast upward swipe switches to the Discover tab (Tab 1) and programmatically requests focus on the search `TextField`.

**Visual feedback:** The tab switch includes the standard animated switcher transition. The search field pulses with a brief gradient glow animation when focus is given.

**Haptics:** `HapticFeedback.mediumImpact()`.

---

### Gesture 10: Shake-to-Undo (Clear Recent Search)

**Screens:** Discover View, specifically the "Recent Searches" section.

**Implementation:** Use the device accelerometer via `sensors_plus` package. Listen to accelerometer events. If the magnitude of acceleration exceeds 25 m/s² twice within 500ms (classic shake detection), trigger the undo action.

**Context:**
- If the user just removed a search history entry within the last 10 seconds → restore it (undo).
- If no recent removal → show a bottom snackbar: "Shake detected! Nothing to undo."

**Visual feedback:** On shake detection, briefly animate the recent searches list with a horizontal wobble (translate x oscillates ±4dp, 3 cycles, 400ms total). Show a brief banner "↩ Undo last removal?" with a 3-second auto-dismiss.

**Haptics:** `HapticFeedback.heavyImpact()`.

---

## 9. 10 NEW VIDEO PLAYER GESTURES — FULL SPECIFICATION

All player gestures operate on a transparent `GestureDetector` overlay that sits above the `InAppWebView`. The overlay is divided into three vertical zones: Left Zone (0–40% width), Center Zone (40–60% width), Right Zone (60–100% width). When gesture controls are active, `AbsorbPointer` wraps the WebView to prevent iframe from capturing touch events.

---

### Player Gesture 1: Swipe Up/Down on Left Zone — Brightness

**Detection:** `onVerticalDragUpdate` within the Left Zone (x < 40% of screen width).

**Action:** Brightness adjustment. Drag up → increase brightness. Drag down → decrease brightness. Each 1dp of drag = 0.002 brightness change (full screen height maps to full 0.0–1.0 range). Value is clamped to [0.05, 1.0]. Apply via `ScreenBrightness` package (`screen_brightness` on pub.dev).

**Visual HUD (Left side):**
- Vertical slider bar (8dp wide, 120dp tall, `colorSurface2` background, gradient fill based on level, `radiusFull`).
- Sun icon above slider.
- Percentage text below slider.
- All elements housed in a translucent pill container with `BackdropFilter` blur.
- HUD appears on drag start, disappears 1.5 seconds after drag ends.

**Haptics:** Subtle tick every 10% brightness change: `HapticFeedback.selectionClick()`.

---

### Player Gesture 2: Swipe Up/Down on Right Zone — Volume

**Detection:** `onVerticalDragUpdate` within the Right Zone (x > 60% of screen width).

**Action:** Volume adjustment. Drag up → increase volume. Drag down → decrease volume. Use `volume_controller` package to set system media volume. Each 1dp = 0.002 volume change.

**Visual HUD (Right side):** Same design as brightness HUD but with a speaker/volume icon. When volume reaches 0, icon changes to a muted speaker.

**Haptics:** Same tick pattern as brightness gesture.

---

### Player Gesture 3: Double-Tap Left Zone — Seek Backward 10s

**Detection:** `onDoubleTapDown` within Left Zone (x < 40% width).

**Action:** Inject JavaScript into the WebView: `window.postMessage({type: 'seek', delta: -10}, '*')`. Since iframe content may block this, also update a simulated progress tracker stored in `VideoPlayerBloc`. Show the visual feedback regardless.

**Visual feedback:**
- A ripple circle expands from the tap point (opacity 0.3 → 0.0, radius 0 → 60dp, 400ms).
- "◀◀ 10 seconds" text appears centered in the left zone, fades in from opacity 0.0 to 1.0 in 100ms, holds 400ms, fades out in 300ms.
- Two left-pointing chevrons animate sequentially (staggered 80ms apart).

**Haptics:** `HapticFeedback.lightImpact()`.

---

### Player Gesture 4: Double-Tap Right Zone — Seek Forward 10s

**Detection:** `onDoubleTapDown` within Right Zone.

**Action:** Same as Gesture 3 but forward (+10s delta).

**Visual feedback:** Same as Gesture 3 but mirrored: "10 seconds ▶▶", right-pointing chevrons, ripple from tap point.

**Haptics:** `HapticFeedback.lightImpact()`.

---

### Player Gesture 5: Horizontal Drag (Center Zone) — Scrub / Seek

**Detection:** `onHorizontalDragUpdate` within Center Zone (40–60% width), or when a horizontal drag starts anywhere and the intent is clearly horizontal (dx > 3 × dy after first 20dp).

**Action:** Scrubbing. Display a progress preview overlay with the computed seek time. On drag end: inject seek JavaScript to WebView, update `VideoPlayerBloc` progress. Full screen width = full video duration.

**Visual feedback during drag:**
- The controls overlay becomes fully visible.
- Center overlay appears: a large time label (e.g., "→ +0:32" or "← -1:15") in `textDisplayLarge`.
- The bottom progress bar shows a preview indicator (a ghost thumb at the seek target position).
- A semi-transparent strip (16dp height) highlights across the progress bar area.

**Haptics:** Tick every 30 seconds of simulated seek: `HapticFeedback.selectionClick()`.

---

### Player Gesture 6: Pinch-to-Zoom — Video Fit Toggle

**Detection:** `onScaleUpdate` (scale != 1.0) anywhere on the player screen.

**Action:** When scale > 1.2 → switch from `BoxFit.contain` (letterboxed) to `BoxFit.cover` (cropped to fill). When scale < 0.8 → switch back to `BoxFit.contain`. The `InAppWebView` is wrapped in a `Transform.scale` that adjusts its scale to simulate the crop mode visually (scale set to screen_height / (screen_width × 9/16) when in fill mode).

**Visual feedback:**
- On mode switch, a brief overlay shows "⊞ Fill" or "⊟ Fit" in a pill badge (top-center, fades out in 2 seconds).
- The WebView scale transition is animated over 300ms.

**Haptics:** `HapticFeedback.mediumImpact()` on mode switch.

---

### Player Gesture 7: Long-Press (Hold) — 2× Speed

**Detection:** `onLongPressStart` / `onLongPressEnd` anywhere in Center Zone (40–60% width) on the player.

**Action:** While holding: set playback speed to 2× by injecting JavaScript `document.querySelector('video').playbackRate = 2.0` into the WebView. On release: set back to 1×.

**Visual feedback:**
- A "2×" speed badge pill appears in the top-right of the player overlay. It pulsates (scale 1.0 → 1.08 → 1.0 at 1Hz).
- A brief animation of fast-forward lines plays when entering 2× mode.

**Haptics:** `HapticFeedback.heavyImpact()` on long-press start, `HapticFeedback.lightImpact()` on release.

---

### Player Gesture 8: Swipe Down (Top Edge) — Minimize / PiP

**Detection:** `onVerticalDragEnd` where the drag started within the top 15% of the screen height AND velocity > 400dp/s downward.

**Action:**
- If PiP is supported on this device → activate PiP mode (Feature 2).
- If PiP is not supported → minimize player (pop the player route back to the previous screen).

**Visual feedback:**
- As the drag begins, the player screen scales down slightly (scale 1.0 → 0.95 proportional to drag distance, 0 → 100dp = full 5% scale reduction).
- A downward chevron indicator appears at the top-center of the screen, pulsing gently.

**Haptics:** `HapticFeedback.mediumImpact()` when swipe threshold is committed.

---

### Player Gesture 9: Two-Finger Tap — Play / Pause Toggle

**Detection:** `RawGestureDetector` with a custom `MultiTapGestureRecognizer` detecting exactly 2 simultaneous touch points within 200ms of each other, without significant movement (<20dp).

**Action:** Toggle play/pause state by injecting `document.querySelector('video').paused ? document.querySelector('video').play() : document.querySelector('video').pause()` into the WebView. Update `VideoPlayerBloc.isPlaying` state.

**Visual feedback:**
- A play or pause icon (64dp, white with 0.9 opacity) appears centered on screen, scales from 0.6 to 1.1 to 1.0 (Elastic, 400ms) then fades out over 500ms.

**Haptics:** `HapticFeedback.mediumImpact()`.

---

### Player Gesture 10: Swipe Up (Bottom Edge) — Reveal Content Sheet

**Detection:** `onVerticalDragEnd` where drag started within the bottom 20% of screen height AND velocity > 300dp/s upward.

**Action:** Reveals the `DraggableScrollableSheet` containing the "Related Videos" and "Comments" tabs (Screen 23 + related videos list).

**Visual feedback:**
- The sheet animates up from `initialChildSize: 0.0` to `initialChildSize: 0.45` over 350ms with `Curves.easeOutQuart`.
- As the sheet rises, the main player content slides slightly upward (translate y = -(sheetHeight × 0.1)) to create a parallax effect.
- The "↑ Related & Comments" hint label at the very bottom of the player fades out as the sheet appears.

**Haptics:** `HapticFeedback.lightImpact()`.

---

## 10. GLOBAL UI STATE SYSTEM (EMPTY, ERROR, SKELETON LOADING)

Every list, grid, and content area in the app must implement all three states. No exceptions.

---

### 10.1 Skeleton Loading State

**Trigger:** BLoC state is `Loading` / `Initial` before data arrives.

**`ShimmerLoadingCard` widget (expand the existing one):**
- A `Shimmer.fromColors` widget wrapping a gray rounded rectangle.
- Shimmer base color: `Color(0xFF1A1A1A)`. Highlight color: `Color(0xFF2A2A2A)`.
- Duration: 1500ms, looping.
- Shape variants:
  - `ShimmerVideoCard` (for grid/list items): thumbnail rect (full-width, 16:9 ratio, `radiusLG`) + two text lines below.
  - `ShimmerListTile`: 56×56dp square + two text lines (tall and short).
  - `ShimmerCarouselItem`: Full-width, 220dp height.
  - `ShimmerCategoryCard`: 16:9, full cell size.
  - `ShimmerNotificationItem`: 40dp circle avatar + two text lines.
  - `ShimmerCommentItem`: 40dp circle + three text lines of varying width.
  - `ShimmerProfileHeader`: 80dp circle + two text lines centered.

**Count rules:** Show exactly as many skeleton items as would fill one viewport:
- Grid (2 columns): 6 skeletons.
- Grid (3 columns): 9 skeletons.
- List: 5 skeletons.
- Carousel: 1 full-width skeleton.
- Horizontal list: 3 skeletons.

---

### 10.2 Empty State Widget

**`EmptyStateWidget` — universal widget in `core/widgets/empty_state_widget.dart`.**

**Constructor signature:**
```dart
EmptyStateWidget({
  required EmptyStateType type,
  String? customTitle,
  String? customMessage,
  String? actionLabel,
  VoidCallback? onAction,
})
```

**`EmptyStateType` enum values and their corresponding assets/messages:**

| Type | Lottie Asset | Title | Message | Action |
|---|---|---|---|---|
| `search` | `assets/lottie/empty_search.json` | "No Results Found" | "Try different keywords or browse by category." | "Browse Categories" |
| `history` | `assets/lottie/empty_history.json` | "Nothing Here Yet" | "Videos you watch will appear in your history." | "Discover Videos" |
| `bookmarks` | `assets/lottie/empty_bookmarks.json` | "No Bookmarks Yet" | "Tap the bookmark icon on any video to save it." | "Browse Videos" |
| `downloads` | `assets/lottie/empty_downloads.json` | "No Downloads" | "Download videos to watch them offline." | "Find Videos" |
| `playlists` | `assets/lottie/empty_playlists.json` | "No Playlists" | "Create a playlist to organize your favorites." | "Create Playlist" |
| `liked` | `assets/lottie/empty_liked.json` | "No Liked Videos" | "Double-tap a video or tap the heart to like it." | "Discover Videos" |
| `notifications` | `assets/lottie/empty_notifications.json` | "All Caught Up!" | "No new notifications right now." | null |
| `comments` | `assets/lottie/empty_comments.json` | "No Comments Yet" | "Be the first to comment on this video." | null |

**Layout:**
- Centered column in the available space.
- Lottie animation: 200dp height, plays once then loops.
- Title: `textHeadlineMedium`, centered.
- Message: `textBodyMedium`, `colorTextSecondary`, centered, max width 280dp.
- Action button (if provided): `OutlinedButton` with gradient border (12dp top margin).

---

### 10.3 Error State Widget

**`ErrorStateWidget` — universal widget in `core/widgets/error_state_widget.dart`.**

```dart
ErrorStateWidget({
  required String message,
  required VoidCallback onRetry,
  bool showRetry = true,
})
```

**Layout:** Centered column.
- A static error Lottie animation or, if Lottie not available, the `Icons.error_outline_rounded` icon (64dp, `colorError`).
- "Something Went Wrong" heading in `textHeadlineMedium`.
- `message` in `textBodyMedium`, `colorTextSecondary`, centered.
- "Try Again" gradient-border outlined button (calls `onRetry`).

**Error snackbar variant (for non-fatal inline errors):**
- `ScaffoldMessenger.of(context).showSnackBar(...)` with a custom styled snackbar:
  - Background: `colorSurface2`.
  - Leading: red error icon.
  - Text in `textBodyMedium`.
  - "Dismiss" action in `colorPrimary`.
  - Duration: 4 seconds.

---

### 10.4 Connectivity Error State

When `ConnectivityResult.none` is detected and a data load fails:
- Show `ErrorStateWidget` with message "No internet connection. Please check your network and try again."
- `onRetry` re-dispatches the original BLoC load event.
- The overlay from Screen 32 (full-screen offline) is shown for complete loss of connectivity; the inline `ErrorStateWidget` is used for mid-session data fetch failures.

---

### 10.5 State Implementation Checklist (Per Screen)

Every screen implementing a `BlocBuilder` or `BlocConsumer` must handle these BLoC states:

```
Initial     → show SkeletonLoadingWidget (appropriate variant)
Loading     → show SkeletonLoadingWidget
Loaded      → show content (empty check: if list.isEmpty → EmptyStateWidget)
Error       → show ErrorStateWidget
```

For `InfiniteScrollPagination` (PagingController), configure:
```dart
pagedController.addPageRequestListener(...)
// Built-in states from infinite_scroll_pagination:
firstPageProgressIndicatorBuilder: (_) => SkeletonLoadingWidget()
newPageProgressIndicatorBuilder: (_) => SkeletonListTile() // small indicator for subsequent pages
firstPageErrorIndicatorBuilder: (_) => ErrorStateWidget(...)
newPageErrorIndicatorBuilder: (_) => NewPageErrorWidget(onRetry: ...) // smaller inline error
noItemsFoundIndicatorBuilder: (_) => EmptyStateWidget(...)
noMoreItemsIndicatorBuilder: (_) => EndOfListWidget() // "You've seen it all!" with a checkmark
```

The `EndOfListWidget` is a small, centered "· · ·" dot separator or "You're all caught up ✓" text in `textLabelSmall colorTextMuted`.

---

## 11. COMPLETE NAVIGATION FLOW & ROUTE MAP

### 11.1 Route Definitions

All routes are defined in `core/routes/app_routes.dart`. Migrate from `onGenerateRoute` to `GoRouter` for deep linking support.

```dart
class AppRoutes {
  static const String splash = '/';
  static const String ageGate = '/age-gate';
  static const String onboarding = '/onboarding';
  static const String terms = '/terms';
  static const String privacy = '/privacy';
  static const String home = '/home';
  static const String player = '/player';
  static const String vpn = '/vpn';
  static const String categories = '/categories';
  static const String category = '/category/:id';
  static const String profile = '/profile';
  static const String profileEdit = '/profile/edit';
  static const String notifications = '/notifications';
  static const String downloads = '/downloads';
  static const String playlists = '/playlists';
  static const String playlistDetail = '/playlists/:id';
  static const String liked = '/liked';
  static const String settings = '/settings';
  static const String settingsPlayback = '/settings/playback';
  static const String settingsParental = '/settings/parental';
  static const String help = '/help';
  static const String about = '/about';
  static const String cast = '/cast';
}
```

### 11.2 Complete Navigation Flow Diagram

```
App Launch
    │
    ▼
/splash (1.8s)
    │
    ├─── hasAcceptedTerms == false ──────► /age-gate
    │                                           │
    │                                    confirm age
    │                                           │
    │                              ┌────────────┘
    │                              ▼
    │                         isFirstLaunch == true ──► /onboarding
    │                              │
    │                              ▼
    └─── all conditions met ──────► /home
                                      │
              ┌───────────────────────┼───────────────────────┐
              ▼                       ▼                       ▼
           Tab 0                   Tab 1                   Tab 2
        Home Feed               Discover                 Trending
              │                       │                       │
              ▼                       ▼                       ▼
         /player              filter sheet              /player
         /categories          /player
         /category/:id

              ▼
           Tab 3
          Library
              │
    ┌─────────┼─────────────────┐
    ▼         ▼        ▼        ▼
 History  Bookmarks Downloads Playlists
                               │        ▼
                        /playlists  /playlists/:id
                           
AppBar Actions:
  🔔 ──► /notifications
  🌐 ──► /vpn

Drawer:
  Profile ──► /profile ──► /profile/edit
  Playlists ──► /playlists
  Downloads ──► /downloads
  Liked ──► /liked
  VPN ──► /vpn
  Settings ──► /settings ──► /settings/playback
                          └──► /settings/parental
  Help ──► /help
  About ──► /about
  Privacy ──► /privacy
  Terms ──► /terms

Player Screen:
  Cast icon ──► /cast
  Comments gesture ──► Comments Bottom Sheet (modal)
  Long-press card ──► Context Menu Bottom Sheet (modal)
```

### 11.3 Transition Specifications

Each route transition uses a consistent animation:
- **Push (new screen):** Slide in from right (dx: 1.0 → 0.0) + fade (0.0 → 1.0), 300ms, `Curves.easeOutCubic`.
- **Pop (back):** Slide out to right + fade, 250ms, `Curves.easeInCubic`.
- **Modal (bottom sheets):** Slide up from bottom, 350ms, `Curves.easeOutQuart`.
- **Player push:** Fade only (no slide — preserves immersive feel), 300ms.
- **Splash to home:** Fade only, 400ms.
- **Tab switch:** Cross-fade (no slide), 200ms.

---

## 12. COMPLETE UI COMPONENT LIBRARY

All shared widgets live in `core/widgets/`. New widgets to be created:

### 12.1 `GradientButton` (Primary)
Full-width or intrinsic-width button with gradient background (`colorGradientStart → colorGradientEnd`, linear, 45° angle). Border radius: `radiusLG`. Height: 52dp. Text: `textLabelLarge`, white. Disabled state: gradient replaced with `colorSurface3`, text `colorTextMuted`. Tap: scale 0.97 animation (80ms).

### 12.2 `OutlinedGradientButton` (Secondary)
Same dimensions as primary. Background: transparent. Border: 1.5dp gradient stroke (using `ShaderMask` with `BoxDecoration` trick). Text: gradient shader matching border color.

### 12.3 `GradientIconButton`
Circular button (40dp default size). Gradient background. Icon in white. Used for action buttons in AppBar and player controls. Tap scale animation.

### 12.4 `PremiumVideoCard` (Updated)
Existing widget enhanced with:
- Progress bar overlay (3dp at bottom, gradient fill, shown if `WatchHistoryEntry.progressPercent > 0.0 && < 0.9`).
- "Completed" overlay (semi-transparent dark overlay with a checkmark icon) if `progressPercent >= 0.9`.
- Like animation overlay (heart particle burst — see Feature 8).
- "NEW" badge (top-left corner, gradient pill) if `VideoEntity.isNew`.
- "HD" badge (top-right corner, dark pill with gold text) if `VideoEntity.isHD`.
- Content rating badge (top-left, below NEW badge) if `requiresAgeVerification`.
- Bookmark icon integrated into the card overlay (bottom-right, with filled/outlined toggle state).
- Long-press detection (Gesture #4).
- Double-tap detection (Gesture #6).
- On the bottom overlay, in addition to title: channel name in `textLabelSmall colorTextSecondary`, view count formatted (e.g., "1.2M views").

### 12.5 `SectionHeader`
Row widget: title text (`textHeadlineMedium`) on left, optional "See All" `TextButton` in `colorPrimary` on right. Standard 24dp top margin, 16dp left/right padding.

### 12.6 `StatusBadge`
A pill chip (height 22dp, horizontal padding 8dp). Uses `colorSuccess`/`colorWarning`/`colorError`/`colorPrimary` background based on a `StatusType` enum. Text in `textLabelSmall`, white.

### 12.7 `CountBadge`
A small circle (20dp) with a count number inside. Used for notification bell unread count. Background: `colorError`. Text: `textLabelSmall`, white. Positioned with `Positioned` inside a `Stack` overlay.

### 12.8 `GradientText`
A `Text` widget wrapped in `ShaderMask` applying the brand gradient. Used for logo, display numbers, category card titles.

### 12.9 `GlassmorphicContainer`
A `ClipRRect` + `BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12))` + `Container(color: Colors.white.withOpacity(0.05), border: Border.all(color: colorBorder, width: 1))`. Used for card overlays, HUDs, snackbars.

### 12.10 `AnimatedBottomBar`
Custom-painted bottom navigation bar replacement. Uses `CustomPainter` to draw a gradient top border of 1.5dp. Selected items render their icons with gradient color via `ShaderMask`. Ink ripple on tap with `colorPrimary` tint.

### 12.11 `DraggableBottomSheet`
A reusable wrapper around `DraggableScrollableSheet` with standard drag handle, `colorSurface2` background, `radiusXL` on top corners only, and standardized header layout (handle + title + close button row).

### 12.12 `VideoProgressBar`
`CustomPainter` drawing a horizontal bar: background track (`colorSurface3`), filled track (gradient), thumb circle (white, 14dp diameter, with glow shadow). Used in the video player overlay and on `PremiumVideoCard` (no thumb in card variant).

### 12.13 `RatingBadge`
A chip showing the content rating (e.g., "PG-13", "R"). Background: dark with a colored border (`colorWarning` for PG-13, `colorError` for R). Text: `textLabelSmall`.

### 12.14 `AvatarWidget`
Handles all avatar rendering scenarios: URL (`CachedNetworkImage`), initials fallback (gradient circle with first letter of display name), loading (shimmer circle). Sizes: small (32dp), medium (40dp), large (56dp), xl (80dp).

---

## 13. LEGAL & COMPLIANCE SCREENS — DETAILED CONTENT SPEC

### 13.1 Age Gate Compliance Rules

The age gate (Screen 2) must meet the following compliance requirements for both Google Play and Apple App Store:
- Users under 13 must be completely blocked (`SystemNavigator.pop()` — no soft redirect).
- Users 13–17 must have R/NC-17 content hidden.
- The confirmed age setting (`AppConfig.hasAcceptedAgeGate`, `UserProfile.birthYear`, `UserProfile.isAgeVerified`) must persist across sessions and app restarts via Hive.
- The age gate must not be re-shown if `AppConfig.hasAcceptedAgeGate == true`, except on factory reset.
- `ContentRating` filtering rule: if `isAgeVerified == false`, all queries to `VideoRepository` must exclude videos where `requiresAgeVerification == true`. This filtering must be applied at the repository layer, not the UI layer.

### 13.2 Parental Controls Integration

When `AppConfig.parentalControlEnabled == true` AND `AppConfig.parentalPin != ''`:
- Any attempt to play a video where `requiresAgeVerification == true` shows a PIN entry dialog before proceeding.
- PIN entry: 4-dot indicator + number pad (same style as Screen 29). Wrong PIN: shake animation on dots + `HapticFeedback.heavyImpact()` + "Incorrect PIN" error label. 3 wrong attempts → 30-second cooldown with countdown timer displayed.

### 13.3 Terms & Privacy — First-Launch Gate

Both documents must be accepted before the user can use the app. The gate flow is:
1. Splash detects `hasAcceptedTerms == false`.
2. Routes to `/age-gate`.
3. Age gate footer links to `/terms` and `/privacy` (pushed over age gate, preserving it in stack).
4. User reads, taps "I Accept" on each.
5. On return to age gate: if both `hasAcceptedTerms == true` AND `hasAcceptedPrivacy == true` → the "Confirm My Age" button becomes enabled.

If user tries to skip: `PopScope.canPop = false` on the age gate prevents back navigation entirely until both are accepted.

---

## 14. ANIMATION & TRANSITION SYSTEM

### 14.1 `AnimationConstants` class

Create `core/theme/animation_constants.dart`:
```dart
class AnimationConstants {
  // Durations
  static const micro = Duration(milliseconds: 80);
  static const fast = Duration(milliseconds: 160);
  static const normal = Duration(milliseconds: 280);
  static const slow = Duration(milliseconds: 400);
  static const verySlow = Duration(milliseconds: 600);
  static const shimmer = Duration(milliseconds: 1500);
  static const splash = Duration(milliseconds: 1800);

  // Curves
  static const curveEnter = Curves.easeOutCubic;
  static const curveExit = Curves.easeInCubic;
  static const curveBounce = Curves.elasticOut;
  static const curveSheetSlide = Curves.easeOutQuart;
  static const curveSpring = Curves.easeOutBack;
}
```

### 14.2 Page Transition Builder

```dart
// In GoRouter route configuration:
pageBuilder: (context, state) => CustomTransitionPage(
  key: state.pageKey,
  child: const MyScreen(),
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0.04, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: AnimationConstants.curveEnter)),
        child: child,
      ),
    );
  },
  transitionDuration: AnimationConstants.normal,
),
```

### 14.3 Lottie Assets Required

Create `assets/lottie/` directory. The following Lottie files are required. Use free assets from LottieFiles.com that match these descriptions (dark-theme compatible):

- `splash_logo.json` — abstract streaming/media animated logo
- `empty_search.json` — magnifying glass with "not found" animation
- `empty_history.json` — clock/time themed empty state
- `empty_bookmarks.json` — bookmark page turning
- `empty_downloads.json` — download arrow going nowhere
- `empty_playlists.json` — musical notes floating
- `empty_liked.json` — heart breaking or empty heart
- `empty_notifications.json` — bell with "zzz"
- `empty_comments.json` — chat bubbles
- `error_state.json` — broken connection or warning
- `vpn_connecting.json` — rotating shield or globe
- `vpn_connected.json` — shield with checkmark and pulse
- `download_complete.json` — checkmark with download arrow
- `like_burst.json` — heart particle explosion (looped: false, plays on like action)
- `onboarding_stream.json` — streaming/video themed
- `onboarding_library.json` — library/books themed
- `offline_state.json` — wifi-off animation

All Lottie assets must be registered in `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/lottie/
    - assets/images/
    - assets/icons/
```

---

## 15. BLOC ARCHITECTURE EXPANSION MAP

### 15.1 New BLoCs to Create

| BLoC | File Path | Purpose |
|---|---|---|
| `HomeFeedBloc` | `features/home/presentation/blocs/home_feed_bloc.dart` | Split from VideoListBloc — manages home carousel + sections |
| `SearchBloc` | `features/discover/presentation/blocs/search_bloc.dart` | Split from VideoListBloc — manages search query + results + filters |
| `TrendingBloc` | `features/trending/presentation/blocs/trending_bloc.dart` | Manages trending Today/Week data |
| `PlayerBloc` | `features/player/presentation/blocs/player_bloc.dart` | Manages player state: playing, paused, seek position, speed, volume, brightness |
| `PlaylistBloc` | `features/library/presentation/blocs/playlist_bloc.dart` | Manages playlist CRUD |
| `DownloadBloc` | `features/library/presentation/blocs/download_bloc.dart` | Manages download records + simulation |
| `LikeBloc` | `features/library/presentation/blocs/like_bloc.dart` | Manages like/dislike reactions |
| `CommentBloc` | `features/player/presentation/blocs/comment_bloc.dart` | Manages comments per video |
| `NotificationBloc` | `features/notifications/presentation/blocs/notification_bloc.dart` | Manages in-app notifications |
| `ProfileBloc` | `features/profile/presentation/blocs/profile_bloc.dart` | Manages user profile state |
| `SettingsBloc` | `features/settings/presentation/blocs/settings_bloc.dart` | Manages all AppConfig fields |
| `ConnectivityBloc` | `core/blocs/connectivity_bloc.dart` | Manages internet connectivity state globally |
| `PipBloc` | `features/player/presentation/blocs/pip_bloc.dart` | Manages PiP mode state |
| `FilterBloc` | `core/blocs/filter_bloc.dart` | Manages active filter/sort state for video lists |

### 15.2 Existing BLoC Refactoring

- `VideoListBloc`: Kept only for Category Feed page pagination. Home and Search responsibilities moved to `HomeFeedBloc` and `SearchBloc`.
- `VpnBloc`: No changes needed.

### 15.3 `MultiBlocProvider` Root Configuration

`main.dart` `MultiBlocProvider` must provide all BLoCs:
```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (_) => sl<ConnectivityBloc>()..add(StartMonitoring())),
    BlocProvider(create: (_) => sl<VpnBloc>()..add(AutoConnectVpnEvent())),
    BlocProvider(create: (_) => sl<NotificationBloc>()..add(LoadNotifications())),
    BlocProvider(create: (_) => sl<SettingsBloc>()..add(LoadSettings())),
    BlocProvider(create: (_) => sl<ProfileBloc>()..add(LoadProfile())),
    // Feature-specific BLoCs are created locally via BlocProvider in their feature routes
  ],
)
```

---

## 16. DEPENDENCY INJECTION EXPANSION

`core/di/injection.dart` must register all new services and BLoCs:

```dart
Future<void> setupInjection() async {
  // === SERVICES (Singletons) ===
  sl.registerLazySingleton<DatabaseService>(() => DatabaseService());
  sl.registerLazySingleton<DownloadSimulationService>(() => DownloadSimulationService());
  sl.registerLazySingleton<CastService>(() => CastService());
  sl.registerLazySingleton<ConnectivityService>(() => ConnectivityService());

  // === REPOSITORIES (Lazy Singletons) ===
  sl.registerLazySingleton<VideoRepository>(() => VideoRepository());
  sl.registerLazySingleton<PlaylistRepository>(() => PlaylistRepository());
  sl.registerLazySingleton<DownloadRepository>(() => DownloadRepository());
  sl.registerLazySingleton<LikeRepository>(() => LikeRepository());
  sl.registerLazySingleton<CommentRepository>(() => CommentRepository());
  sl.registerLazySingleton<NotificationRepository>(() => NotificationRepository());
  sl.registerLazySingleton<ProfileRepository>(() => ProfileRepository());
  sl.registerLazySingleton<SearchHistoryRepository>(() => SearchHistoryRepository());
  sl.registerLazySingleton<AppConfigRepository>(() => AppConfigRepository());

  // === BLOCS (Factories — new instance per route) ===
  sl.registerFactory<VideoListBloc>(() => VideoListBloc(sl()));
  sl.registerFactory<HomeFeedBloc>(() => HomeFeedBloc(sl()));
  sl.registerFactory<SearchBloc>(() => SearchBloc(sl(), sl()));
  sl.registerFactory<TrendingBloc>(() => TrendingBloc(sl()));
  sl.registerFactory<PlayerBloc>(() => PlayerBloc(sl(), sl(), sl()));
  sl.registerFactory<PlaylistBloc>(() => PlaylistBloc(sl()));
  sl.registerFactory<DownloadBloc>(() => DownloadBloc(sl(), sl()));
  sl.registerFactory<LikeBloc>(() => LikeBloc(sl()));
  sl.registerFactory<CommentBloc>(() => CommentBloc(sl()));
  sl.registerFactory<FilterBloc>(() => FilterBloc());

  // === BLOCS (Singletons — global state) ===
  sl.registerLazySingleton<VpnBloc>(() => VpnBloc(sl()));
  sl.registerLazySingleton<NotificationBloc>(() => NotificationBloc(sl()));
  sl.registerLazySingleton<SettingsBloc>(() => SettingsBloc(sl()));
  sl.registerLazySingleton<ProfileBloc>(() => ProfileBloc(sl()));
  sl.registerLazySingleton<ConnectivityBloc>(() => ConnectivityBloc(sl()));
  sl.registerLazySingleton<PipBloc>(() => PipBloc());
}
```

---

## 17. IMPLEMENTATION SPRINT ROADMAP

The remaining implementation is organized into 5 sprint phases, each producing a testable, shippable increment.

---

### Sprint 1: Database & Legal Foundation (Priority: Critical)
**Duration:** 3–4 days
**Deliverables:**
- All 12 Hive boxes defined, generated, and initialized.
- `AppConfigRepository`, `ProfileRepository`, `SearchHistoryRepository` fully implemented.
- `VideoRepository` updated: 60 seed videos, all new fields populated, seeded comments.
- Age Gate Screen (Screen 2) — fully functional.
- Terms & Conditions Screen (Screen 4) — complete with acceptance logic.
- Privacy Policy Screen (Screen 5) — complete with acceptance logic.
- Splash routing logic updated (age gate check, terms check, first launch check).
- `AppConfig.hasAcceptedTerms/Privacy/AgeGate` gates fully wired.

**Acceptance Criteria:** App launches → shows age gate on first run → both legal screens accessible and functional → acceptance persists across restarts → subsequent launches go directly to home.

---

### Sprint 2: New Screens & Navigation (Priority: High)
**Duration:** 4–5 days
**Deliverables:**
- Onboarding Screen (Screen 3) with interest selection.
- Profile Screen (Screen 11) + Edit Profile (Screen 30).
- Category Grid Screen (Screen 14).
- Notification Center (Screen 18).
- Downloads Screen (Screen 19) with simulated download logic.
- Playlists Screen (Screen 20) + Playlist Detail (Screen 21).
- Liked Videos Screen (Screen 22).
- Help & FAQ (Screen 26) + About (Screen 27).
- All new routes registered in `GoRouter`.
- `MainDrawer` updated with all new links.
- `NotificationBloc`, `ProfileBloc`, `PlaylistBloc`, `DownloadBloc` implemented.

**Acceptance Criteria:** All new screens navigable from drawer and bottom bar. Data persists correctly in Hive across app restarts.

---

### Sprint 3: Enhanced Existing Screens + Settings Rewrite (Priority: High)
**Duration:** 3–4 days
**Deliverables:**
- Settings Screen (Screen 16) — fully functional (clear history works, all toggles wired).
- Playback Settings (Screen 17) — all settings linked to AppConfig.
- Parental Control Screen (Screen 29) — PIN setup and enforcement.
- Home Feed (Screen 7) — all sections (Continue Watching, New This Week, chips, etc.).
- Library View (Screen 10) — all 5 sub-tabs with proper data.
- Video Player (Screen 12) — complete overlay stack, cast icon, share icon.
- Category Feed (Screen 15) — filter sub-tabs and AppBar filter button.
- Discover (Screen 8) — filter bottom sheet, recent searches, search history.
- `SettingsBloc`, `FilterBloc` implemented.
- `PremiumVideoCard` updated with all new fields (badges, progress bar, bookmarks, like button).

---

### Sprint 4: Gestures, States & Player (Priority: Medium-High)
**Duration:** 4–5 days
**Deliverables:**
- All 10 Global App Gestures implemented (Section 8).
- All 10 Video Player Gestures implemented (Section 9).
- Comments Bottom Sheet (Screen 23) — full implementation.
- Long-Press Context Menu (Screen 24) — full implementation.
- Add to Playlist Bottom Sheet (Screen 25).
- Advanced Search Filter Sheet (Screen 28).
- `CommentBloc`, `LikeBloc`, `PlayerBloc` implemented.
- Cast Screen (Screen 31) — UI placeholder implemented.
- PiP mode — Flutter overlay mini-player implemented (native platform channels as no-ops with UI simulation).

---

### Sprint 5: UI State System, Polish & Compliance (Priority: Medium)
**Duration:** 3–4 days
**Deliverables:**
- `ShimmerLoadingCard` all variants implemented.
- `EmptyStateWidget` all type variants with Lottie files.
- `ErrorStateWidget` implemented.
- `EndOfListWidget` implemented.
- All screens verified to handle Loading / Empty / Error states correctly (checklist from Section 10.5).
- Connectivity service and offline overlay (Screen 32) implemented.
- `ConnectivityBloc` wired globally.
- No Internet handling across all data-fetching BLoCs.
- All Lottie assets sourced and integrated.
- `GradientButton`, `OutlinedGradientButton`, `GlassmorphicContainer`, `VideoProgressBar`, `AvatarWidget`, `StatusBadge`, `CountBadge`, `GradientText` all implemented in `core/widgets/`.
- All animations match `AnimationConstants` timing spec.
- Final QA pass: back navigation safety, haptics on all interactive elements, consistent typography across all screens.

---

## APPENDIX A: Video Seed Data Template

Each of the 60 seed videos must follow this template:

```dart
VideoEntity(
  id: const Uuid().v4(),
  title: 'Sample Title for Category',
  thumbnailUrl: 'https://picsum.photos/seed/UNIQUE_INT/640/360',
  duration: 'MM:SS',
  durationSeconds: N,
  embedCode: '<iframe width="100%" height="100%" src="https://www.youtube.com/embed/dQw4w9WgXcQ?autoplay=1&controls=0" frameborder="0" allowfullscreen></iframe>',
  category: 'CategoryName',
  description: 'A compelling 1-2 sentence description of this video.',
  channelName: 'StreamPro [Category]',
  channelAvatar: 'https://picsum.photos/seed/CHANNEL_SEED/100/100',
  viewCount: RANDOM_100K_TO_10M,
  likeCount: RANDOM_1K_TO_500K,
  dislikeCount: RANDOM_100_TO_5K,
  uploadedAt: DateTime.now().subtract(Duration(days: RANDOM_1_TO_365)).toIso8601String(),
  tags: ['TAG1', 'TAG2'],
  isNew: BOOL,
  isTrending: BOOL,
  isHD: BOOL,
  isFeatured: BOOL_FOR_6_VIDEOS,
  contentRating: 'PG' or 'G' or 'PG-13',
  requiresAgeVerification: false,
  subtitleUrl: '',
  relatedVideoIds: [/* 4–5 other video IDs from same category */],
  commentCount: RANDOM_5_TO_200,
  isDownloadable: true,
)
```

---

## APPENDIX B: Comment Seed Data Authors

The following 20 simulated users provide comments in `comments_box`:

Alex Rivera, Jordan Kim, Taylor Brooks, Morgan Chen, Sam Patel, Casey Wilson, Drew Thompson, Blake Anderson, Quinn Martinez, Reese Garcia, Avery Johnson, Riley Lee, Finley Williams, Peyton Davis, Hayden Brown, Dakota Miller, Sydney Moore, Cameron Taylor, Kendall Jackson, Sage White.

Each has a corresponding avatar URL: `https://picsum.photos/seed/{author_index_1_to_20}/100/100`.

---

## APPENDIX C: Simulated Countries for VPN

The following 20 countries are available in the VPN screen with their flag emojis and simulated ping values:

🇺🇸 United States (New York) — 12ms, 🇬🇧 United Kingdom (London) — 18ms, 🇩🇪 Germany (Frankfurt) — 22ms, 🇯🇵 Japan (Tokyo) — 45ms, 🇸🇬 Singapore (Singapore) — 38ms, 🇨🇦 Canada (Toronto) — 15ms, 🇦🇺 Australia (Sydney) — 62ms, 🇫🇷 France (Paris) — 21ms, 🇳🇱 Netherlands (Amsterdam) — 19ms, 🇧🇷 Brazil (São Paulo) — 55ms, 🇰🇷 South Korea (Seoul) — 42ms, 🇮🇳 India (Mumbai) — 48ms, 🇸🇪 Sweden (Stockholm) — 24ms, 🇨🇭 Switzerland (Zurich) — 20ms, 🇦🇪 UAE (Dubai) — 35ms, 🇲🇽 Mexico (Mexico City) — 28ms, 🇿🇦 South Africa (Johannesburg) — 72ms, 🇦🇹 Austria (Vienna) — 23ms, 🇵🇱 Poland (Warsaw) — 27ms, 🇳🇴 Norway (Oslo) — 25ms.

---

## APPENDIX D: FAQ Content

**Getting Started:**
- "How do I bookmark a video?" → "Tap the bookmark icon on any video card, or use the long-press menu for quick access."
- "How do I create a playlist?" → "Go to Library → Playlists tab, then tap the + button to create a new playlist."
- "What is VPN Simulation?" → "StreamPro's built-in VPN simulation routes your app traffic indicator through a virtual server to enhance privacy awareness."

**Playback:**
- "How do I control brightness/volume?" → "In the video player, swipe up or down on the left side of the screen for brightness, and the right side for volume."
- "How do I skip forward/backward?" → "Double-tap the left side of the player to go back 10 seconds, or the right side to skip forward 10 seconds."
- "What does pinch-to-zoom do in the player?" → "Pinching to zoom toggles between 'fit' mode (shows full video) and 'fill' mode (crops to fill the screen)."

**Library:**
- "How do I download a video?" → "Long-press any video card and select 'Download', or tap the download icon in the player."
- "How do I clear my watch history?" → "Go to Settings → Clear Watch History. You can also swipe individual entries in Library → History to delete them."

**Privacy:**
- "What data does StreamPro collect?" → "StreamPro stores all data locally on your device only. We do not collect or transmit any personal information to external servers."
- "How do I delete all my data?" → "Go to Settings → Clear Watch History, Clear Downloads, and Clear Cache. To reset completely, uninstall the app."

---

---

## APPENDIX E: Complete BLoC Event & State Definitions

Every BLoC in the expanded architecture must implement the following events and states. All event and state classes must extend `Equatable`. All BLoCs must `extend Bloc<Event, State>` and use `on<Event>()` registration (not `mapEventToState`).

---

### E.1 `ConnectivityBloc`

```dart
// Events
abstract class ConnectivityEvent extends Equatable {}
class StartMonitoring extends ConnectivityEvent {
  @override List<Object> get props => [];
}
class ConnectivityChanged extends ConnectivityEvent {
  final bool isConnected;
  const ConnectivityChanged(this.isConnected);
  @override List<Object> get props => [isConnected];
}

// States
abstract class ConnectivityState extends Equatable {}
class ConnectivityInitial extends ConnectivityState {
  @override List<Object> get props => [];
}
class ConnectivityOnline extends ConnectivityState {
  @override List<Object> get props => [];
}
class ConnectivityOffline extends ConnectivityState {
  @override List<Object> get props => [];
}
```

**Handler logic:**
- `StartMonitoring`: Subscribe to `connectivity_plus` stream. For each result emit `ConnectivityOnline` or `ConnectivityOffline`. Also immediately check current status on start.
- `ConnectivityChanged`: Emit the appropriate online/offline state.

---

### E.2 `SettingsBloc`

```dart
// Events
abstract class SettingsEvent extends Equatable {}
class LoadSettings extends SettingsEvent { @override List<Object> get props => []; }
class UpdateVideoQuality extends SettingsEvent {
  final String quality;
  const UpdateVideoQuality(this.quality);
  @override List<Object> get props => [quality];
}
class ToggleAutoPlay extends SettingsEvent { @override List<Object> get props => []; }
class ToggleAutoPlayNext extends SettingsEvent { @override List<Object> get props => []; }
class ToggleLoopVideo extends SettingsEvent { @override List<Object> get props => []; }
class ToggleNotifications extends SettingsEvent { @override List<Object> get props => []; }
class ToggleSubtitles extends SettingsEvent { @override List<Object> get props => []; }
class ClearWatchHistory extends SettingsEvent { @override List<Object> get props => []; }
class ClearImageCache extends SettingsEvent { @override List<Object> get props => []; }
class ClearAllDownloads extends SettingsEvent { @override List<Object> get props => []; }
class EnableParentalControl extends SettingsEvent {
  final String pin;
  const EnableParentalControl(this.pin);
  @override List<Object> get props => [pin];
}
class DisableParentalControl extends SettingsEvent {
  final String pin;
  const DisableParentalControl(this.pin);
  @override List<Object> get props => [pin];
}
class ChangeParentalPin extends SettingsEvent {
  final String oldPin;
  final String newPin;
  const ChangeParentalPin(this.oldPin, this.newPin);
  @override List<Object> get props => [oldPin, newPin];
}
class ResetAllSettings extends SettingsEvent { @override List<Object> get props => []; }

// States
abstract class SettingsState extends Equatable {}
class SettingsInitial extends SettingsState { @override List<Object> get props => []; }
class SettingsLoading extends SettingsState { @override List<Object> get props => []; }
class SettingsLoaded extends SettingsState {
  final AppConfig config;
  const SettingsLoaded(this.config);
  @override List<Object> get props => [config];
}
class SettingsError extends SettingsState {
  final String message;
  const SettingsError(this.message);
  @override List<Object> get props => [message];
}
class SettingsActionSuccess extends SettingsState {
  final String message;
  final AppConfig config;
  const SettingsActionSuccess(this.message, this.config);
  @override List<Object> get props => [message, config];
}
class ParentalPinError extends SettingsState {
  final String message;
  final int attemptsRemaining;
  const ParentalPinError(this.message, this.attemptsRemaining);
  @override List<Object> get props => [message, attemptsRemaining];
}
```

---

### E.3 `PlayerBloc`

```dart
// Events
abstract class PlayerEvent extends Equatable {}
class InitializePlayer extends PlayerEvent {
  final VideoEntity video;
  const InitializePlayer(this.video);
  @override List<Object> get props => [video];
}
class TogglePlayPause extends PlayerEvent { @override List<Object> get props => []; }
class SeekTo extends PlayerEvent {
  final int seconds;
  const SeekTo(this.seconds);
  @override List<Object> get props => [seconds];
}
class SeekDelta extends PlayerEvent {
  final int deltaSeconds; // negative for backward
  const SeekDelta(this.deltaSeconds);
  @override List<Object> get props => [deltaSeconds];
}
class SetSpeed extends PlayerEvent {
  final double speed; // 0.5, 1.0, 1.5, 2.0
  const SetSpeed(this.speed);
  @override List<Object> get props => [speed];
}
class SetBrightness extends PlayerEvent {
  final double brightness; // 0.05 – 1.0
  const SetBrightness(this.brightness);
  @override List<Object> get props => [brightness];
}
class SetVolume extends PlayerEvent {
  final double volume; // 0.0 – 1.0
  const SetVolume(this.volume);
  @override List<Object> get props => [volume];
}
class ToggleFitMode extends PlayerEvent { @override List<Object> get props => []; }
class ShowControls extends PlayerEvent { @override List<Object> get props => []; }
class HideControls extends PlayerEvent { @override List<Object> get props => []; }
class ToggleControlsVisibility extends PlayerEvent { @override List<Object> get props => []; }
class PlayerCompleted extends PlayerEvent { @override List<Object> get props => []; }
class UpdateProgress extends PlayerEvent {
  final int currentSeconds;
  const UpdateProgress(this.currentSeconds);
  @override List<Object> get props => [currentSeconds];
}
class ActivatePip extends PlayerEvent { @override List<Object> get props => []; }
class DeactivatePip extends PlayerEvent { @override List<Object> get props => []; }

// States
abstract class PlayerState extends Equatable {}
class PlayerInitial extends PlayerState { @override List<Object> get props => []; }
class PlayerLoading extends PlayerState { @override List<Object> get props => []; }
class PlayerReady extends PlayerState {
  final VideoEntity video;
  final bool isPlaying;
  final bool isControlsVisible;
  final int currentSeconds;
  final int totalSeconds;
  final double progressPercent;
  final double speed;
  final double brightness;
  final double volume;
  final bool isFillMode; // vs fit mode
  final bool isPipActive;
  const PlayerReady({
    required this.video,
    this.isPlaying = true,
    this.isControlsVisible = true,
    this.currentSeconds = 0,
    this.totalSeconds = 0,
    this.progressPercent = 0.0,
    this.speed = 1.0,
    this.brightness = -1.0,
    this.volume = 1.0,
    this.isFillMode = false,
    this.isPipActive = false,
  });
  PlayerReady copyWith({...}); // standard copyWith
  @override List<Object> get props => [video, isPlaying, isControlsVisible,
    currentSeconds, totalSeconds, progressPercent, speed, brightness, volume,
    isFillMode, isPipActive];
}
class PlayerError extends PlayerState {
  final String message;
  const PlayerError(this.message);
  @override List<Object> get props => [message];
}
```

**Handler logic notes:**
- On `InitializePlayer`: save to history box, set up a `Timer.periodic(Duration(seconds: 1))` to emit `UpdateProgress` events for the simulated progress tracker. Since the actual video is in an iframe and progress cannot be read, the simulated tracker uses `video.durationSeconds` and counts up from 0. On dispose, cancel the timer.
- On `UpdateProgress`: update `progressPercent`. When progress reaches 0.9 → mark history entry as `isCompleted = true`. When `autoPlayNextEnabled` and progress reaches 1.0 → emit a navigation event to play the next related video.
- Controls auto-hide: use a `Timer` that emits `HideControls` after 3 seconds. Any interaction cancels and restarts the timer.

---

### E.4 `ProfileBloc`

```dart
// Events
abstract class ProfileEvent extends Equatable {}
class LoadProfile extends ProfileEvent { @override List<Object> get props => []; }
class UpdateDisplayName extends ProfileEvent {
  final String name;
  const UpdateDisplayName(this.name);
  @override List<Object> get props => [name];
}
class UpdateAvatar extends ProfileEvent {
  final String? url;
  const UpdateAvatar(this.url);
  @override List<Object> get props => [url ?? ''];
}
class UpdateInterests extends ProfileEvent {
  final List<String> interests;
  const UpdateInterests(this.interests);
  @override List<Object> get props => [interests];
}
class SyncProfileStats extends ProfileEvent { @override List<Object> get props => []; }
class SetBirthYear extends ProfileEvent {
  final String year;
  const SetBirthYear(this.year);
  @override List<Object> get props => [year];
}

// States
abstract class ProfileState extends Equatable {}
class ProfileInitial extends ProfileState { @override List<Object> get props => []; }
class ProfileLoading extends ProfileState { @override List<Object> get props => []; }
class ProfileLoaded extends ProfileState {
  final UserProfile profile;
  const ProfileLoaded(this.profile);
  @override List<Object> get props => [profile];
}
class ProfileSaving extends ProfileState {
  final UserProfile profile;
  const ProfileSaving(this.profile);
  @override List<Object> get props => [profile];
}
class ProfileSaved extends ProfileState {
  final UserProfile profile;
  const ProfileSaved(this.profile);
  @override List<Object> get props => [profile];
}
class ProfileError extends ProfileState {
  final String message;
  const ProfileError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.5 `PlaylistBloc`

```dart
// Events
abstract class PlaylistEvent extends Equatable {}
class LoadPlaylists extends PlaylistEvent { @override List<Object> get props => []; }
class CreatePlaylist extends PlaylistEvent {
  final String name;
  final String? description;
  final String color;
  const CreatePlaylist({required this.name, this.description, required this.color});
  @override List<Object> get props => [name, description ?? '', color];
}
class UpdatePlaylist extends PlaylistEvent {
  final Playlist playlist;
  const UpdatePlaylist(this.playlist);
  @override List<Object> get props => [playlist];
}
class DeletePlaylist extends PlaylistEvent {
  final String playlistId;
  const DeletePlaylist(this.playlistId);
  @override List<Object> get props => [playlistId];
}
class AddVideoToPlaylist extends PlaylistEvent {
  final String playlistId;
  final String videoId;
  const AddVideoToPlaylist(this.playlistId, this.videoId);
  @override List<Object> get props => [playlistId, videoId];
}
class RemoveVideoFromPlaylist extends PlaylistEvent {
  final String playlistId;
  final String videoId;
  const RemoveVideoFromPlaylist(this.playlistId, this.videoId);
  @override List<Object> get props => [playlistId, videoId];
}
class ReorderPlaylistItems extends PlaylistEvent {
  final String playlistId;
  final int oldIndex;
  final int newIndex;
  const ReorderPlaylistItems(this.playlistId, this.oldIndex, this.newIndex);
  @override List<Object> get props => [playlistId, oldIndex, newIndex];
}

// States
abstract class PlaylistState extends Equatable {}
class PlaylistInitial extends PlaylistState { @override List<Object> get props => []; }
class PlaylistLoading extends PlaylistState { @override List<Object> get props => []; }
class PlaylistLoaded extends PlaylistState {
  final List<Playlist> playlists;
  const PlaylistLoaded(this.playlists);
  @override List<Object> get props => [playlists];
}
class PlaylistActionSuccess extends PlaylistState {
  final List<Playlist> playlists;
  final String message;
  const PlaylistActionSuccess(this.playlists, this.message);
  @override List<Object> get props => [playlists, message];
}
class PlaylistError extends PlaylistState {
  final String message;
  const PlaylistError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.6 `DownloadBloc`

```dart
// Events
abstract class DownloadEvent extends Equatable {}
class LoadDownloads extends DownloadEvent { @override List<Object> get props => []; }
class StartDownload extends DownloadEvent {
  final VideoEntity video;
  final String quality;
  const StartDownload(this.video, this.quality);
  @override List<Object> get props => [video.id, quality];
}
class PauseDownload extends DownloadEvent {
  final String downloadId;
  const PauseDownload(this.downloadId);
  @override List<Object> get props => [downloadId];
}
class ResumeDownload extends DownloadEvent {
  final String downloadId;
  const ResumeDownload(this.downloadId);
  @override List<Object> get props => [downloadId];
}
class CancelDownload extends DownloadEvent {
  final String downloadId;
  const CancelDownload(this.downloadId);
  @override List<Object> get props => [downloadId];
}
class DeleteDownload extends DownloadEvent {
  final String downloadId;
  const DeleteDownload(this.downloadId);
  @override List<Object> get props => [downloadId];
}
class DownloadProgressTick extends DownloadEvent {
  final String downloadId;
  final double progress;
  const DownloadProgressTick(this.downloadId, this.progress);
  @override List<Object> get props => [downloadId, progress];
}
class DownloadCompleted extends DownloadEvent {
  final String downloadId;
  const DownloadCompleted(this.downloadId);
  @override List<Object> get props => [downloadId];
}
class ClearAllDownloads extends DownloadEvent { @override List<Object> get props => []; }

// States
abstract class DownloadState extends Equatable {}
class DownloadInitial extends DownloadState { @override List<Object> get props => []; }
class DownloadLoading extends DownloadState { @override List<Object> get props => []; }
class DownloadLoaded extends DownloadState {
  final List<DownloadRecord> downloads;
  final int totalStorageBytes;
  const DownloadLoaded(this.downloads, this.totalStorageBytes);
  @override List<Object> get props => [downloads, totalStorageBytes];
}
class DownloadError extends DownloadState {
  final String message;
  const DownloadError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.7 `LikeBloc`

```dart
// Events
abstract class LikeEvent extends Equatable {}
class LoadReaction extends LikeEvent {
  final String videoId;
  const LoadReaction(this.videoId);
  @override List<Object> get props => [videoId];
}
class SetReaction extends LikeEvent {
  final String videoId;
  final String reaction; // 'like' | 'dislike' | 'none'
  const SetReaction(this.videoId, this.reaction);
  @override List<Object> get props => [videoId, reaction];
}
class LoadAllLikes extends LikeEvent { @override List<Object> get props => []; }

// States
abstract class LikeState extends Equatable {}
class LikeInitial extends LikeState { @override List<Object> get props => []; }
class LikeLoaded extends LikeState {
  final Map<String, String> reactions; // videoId → reaction
  const LikeLoaded(this.reactions);
  @override List<Object> get props => [reactions];
}
class LikeError extends LikeState {
  final String message;
  const LikeError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.8 `CommentBloc`

```dart
// Events
abstract class CommentEvent extends Equatable {}
class LoadComments extends CommentEvent {
  final String videoId;
  const LoadComments(this.videoId);
  @override List<Object> get props => [videoId];
}
class PostComment extends CommentEvent {
  final String videoId;
  final String text;
  const PostComment(this.videoId, this.text);
  @override List<Object> get props => [videoId, text];
}
class DeleteComment extends CommentEvent {
  final String commentId;
  const DeleteComment(this.commentId);
  @override List<Object> get props => [commentId];
}
class LikeComment extends CommentEvent {
  final String commentId;
  const LikeComment(this.commentId);
  @override List<Object> get props => [commentId];
}

// States
abstract class CommentState extends Equatable {}
class CommentInitial extends CommentState { @override List<Object> get props => []; }
class CommentLoading extends CommentState { @override List<Object> get props => []; }
class CommentLoaded extends CommentState {
  final List<Comment> comments;
  final bool isPosting;
  const CommentLoaded(this.comments, {this.isPosting = false});
  @override List<Object> get props => [comments, isPosting];
}
class CommentPosting extends CommentState {
  final List<Comment> currentComments;
  const CommentPosting(this.currentComments);
  @override List<Object> get props => [currentComments];
}
class CommentError extends CommentState {
  final String message;
  const CommentError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.9 `NotificationBloc`

```dart
// Events
abstract class NotificationEvent extends Equatable {}
class LoadNotifications extends NotificationEvent { @override List<Object> get props => []; }
class MarkNotificationRead extends NotificationEvent {
  final String notificationId;
  const MarkNotificationRead(this.notificationId);
  @override List<Object> get props => [notificationId];
}
class MarkAllNotificationsRead extends NotificationEvent { @override List<Object> get props => []; }
class DeleteNotification extends NotificationEvent {
  final String notificationId;
  const DeleteNotification(this.notificationId);
  @override List<Object> get props => [notificationId];
}
class AddNotification extends NotificationEvent {
  final AppNotification notification;
  const AddNotification(this.notification);
  @override List<Object> get props => [notification];
}

// States
abstract class NotificationState extends Equatable {}
class NotificationInitial extends NotificationState { @override List<Object> get props => []; }
class NotificationLoading extends NotificationState { @override List<Object> get props => []; }
class NotificationLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;
  const NotificationLoaded(this.notifications, this.unreadCount);
  @override List<Object> get props => [notifications, unreadCount];
}
class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.10 `HomeFeedBloc`

```dart
// Events
abstract class HomeFeedEvent extends Equatable {}
class LoadHomeFeed extends HomeFeedEvent { @override List<Object> get props => []; }
class RefreshHomeFeed extends HomeFeedEvent { @override List<Object> get props => []; }
class ChangeSelectedCategory extends HomeFeedEvent {
  final String? category; // null = All
  const ChangeSelectedCategory(this.category);
  @override List<Object> get props => [category ?? ''];
}

// States
abstract class HomeFeedState extends Equatable {}
class HomeFeedInitial extends HomeFeedState { @override List<Object> get props => []; }
class HomeFeedLoading extends HomeFeedState { @override List<Object> get props => []; }
class HomeFeedLoaded extends HomeFeedState {
  final List<VideoEntity> featuredVideos;      // isFeatured == true, max 6
  final List<VideoEntity> continueWatching;   // from history, progress 0.0–0.9
  final List<VideoEntity> newThisWeek;         // isNew == true
  final List<VideoEntity> trendingNow;         // isTrending == true
  final List<VideoEntity> recommendedForYou;   // matches UserProfile.interests
  final List<VideoEntity> topRated;            // sorted by viewCount desc, top 10
  final List<String> allCategories;
  final String? selectedCategory;
  const HomeFeedLoaded({
    required this.featuredVideos,
    required this.continueWatching,
    required this.newThisWeek,
    required this.trendingNow,
    required this.recommendedForYou,
    required this.topRated,
    required this.allCategories,
    this.selectedCategory,
  });
  @override List<Object> get props => [featuredVideos, continueWatching, newThisWeek,
    trendingNow, recommendedForYou, topRated, allCategories, selectedCategory ?? ''];
}
class HomeFeedError extends HomeFeedState {
  final String message;
  const HomeFeedError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.11 `SearchBloc`

```dart
// Events
abstract class SearchEvent extends Equatable {}
class SearchQueryChanged extends SearchEvent {
  final String query;
  const SearchQueryChanged(this.query);
  @override List<Object> get props => [query];
}
class SearchSubmitted extends SearchEvent {
  final String query;
  const SearchSubmitted(this.query);
  @override List<Object> get props => [query];
}
class SearchCleared extends SearchEvent { @override List<Object> get props => []; }
class SearchFiltersApplied extends SearchEvent {
  final SearchFilters filters;
  const SearchFiltersApplied(this.filters);
  @override List<Object> get props => [filters];
}
class SearchFiltersReset extends SearchEvent { @override List<Object> get props => []; }
class RemoveSearchHistoryEntry extends SearchEvent {
  final String id;
  const RemoveSearchHistoryEntry(this.id);
  @override List<Object> get props => [id];
}
class ClearSearchHistory extends SearchEvent { @override List<Object> get props => []; }
class UndoSearchHistoryRemoval extends SearchEvent { @override List<Object> get props => []; }

// SearchFilters value object
class SearchFilters extends Equatable {
  final String sortBy;    // 'relevant' | 'views' | 'newest' | 'duration_asc' | 'duration_desc'
  final String duration;  // 'any' | 'short' | 'medium' | 'long' | 'very_long'
  final List<String> categories;
  final List<String> ratings;
  const SearchFilters({
    this.sortBy = 'relevant',
    this.duration = 'any',
    this.categories = const [],
    this.ratings = const [],
  });
  bool get isActive => sortBy != 'relevant' || duration != 'any' ||
      categories.isNotEmpty || ratings.isNotEmpty;
  int get activeFilterCount => (sortBy != 'relevant' ? 1 : 0) +
      (duration != 'any' ? 1 : 0) + categories.length + ratings.length;
  @override List<Object> get props => [sortBy, duration, categories, ratings];
}

// States
abstract class SearchState extends Equatable {}
class SearchIdle extends SearchState {
  final List<SearchHistoryEntry> recentSearches;
  const SearchIdle(this.recentSearches);
  @override List<Object> get props => [recentSearches];
}
class SearchLoading extends SearchState {
  final String query;
  const SearchLoading(this.query);
  @override List<Object> get props => [query];
}
class SearchResultsLoaded extends SearchState {
  final String query;
  final List<VideoEntity> results;
  final SearchFilters filters;
  final int totalCount;
  const SearchResultsLoaded({
    required this.query,
    required this.results,
    required this.filters,
    required this.totalCount,
  });
  @override List<Object> get props => [query, results, filters, totalCount];
}
class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);
  @override List<Object> get props => [query];
}
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override List<Object> get props => [message];
}
```

---

### E.12 `PipBloc`

```dart
// Events
abstract class PipEvent extends Equatable {}
class ActivatePip extends PipEvent {
  final VideoEntity video;
  final int currentSeconds;
  const ActivatePip(this.video, this.currentSeconds);
  @override List<Object> get props => [video.id, currentSeconds];
}
class DeactivatePip extends PipEvent { @override List<Object> get props => []; }
class ReturnToFullscreen extends PipEvent { @override List<Object> get props => []; }
class PipProgressUpdated extends PipEvent {
  final int currentSeconds;
  const PipProgressUpdated(this.currentSeconds);
  @override List<Object> get props => [currentSeconds];
}

// States
abstract class PipState extends Equatable {}
class PipInactive extends PipState { @override List<Object> get props => []; }
class PipActive extends PipState {
  final VideoEntity video;
  final int currentSeconds;
  final bool isMinimized; // flutter overlay vs native PiP window
  const PipActive({required this.video, required this.currentSeconds, this.isMinimized = false});
  @override List<Object> get props => [video.id, currentSeconds, isMinimized];
}
```

---

## APPENDIX F: Platform Channel Implementation Guide

### F.1 Architecture

Platform channels are defined in `features/player/data/datasources/`. Each channel handles exactly one capability group.

File structure:
```
features/player/data/datasources/
├── brightness_channel.dart
├── volume_channel.dart
└── pip_channel.dart
```

---

### F.2 `BrightnessChannel`

```dart
// lib/features/player/data/datasources/brightness_channel.dart
import 'package:flutter/services.dart';

class BrightnessChannel {
  static const _channel = MethodChannel('com.streampro.app/brightness');

  Future<double> getCurrentBrightness() async {
    try {
      final double brightness = await _channel.invokeMethod('getBrightness');
      return brightness;
    } on PlatformException {
      return 0.5; // fallback
    }
  }

  Future<void> setBrightness(double brightness) async {
    try {
      await _channel.invokeMethod('setBrightness', {'brightness': brightness.clamp(0.05, 1.0)});
    } on PlatformException catch (e) {
      debugPrint('Brightness error: ${e.message}');
    }
  }

  Future<void> restoreSystemBrightness() async {
    try {
      await _channel.invokeMethod('restoreSystemBrightness');
    } on PlatformException catch (e) {
      debugPrint('Restore brightness error: ${e.message}');
    }
  }
}
```

**Android Kotlin (`MainActivity.kt`):**
```kotlin
private fun setupBrightnessChannel() {
    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "com.streampro.app/brightness")
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "getBrightness" -> {
                    val lp = window.attributes
                    result.success(if (lp.screenBrightness < 0) 0.5 else lp.screenBrightness.toDouble())
                }
                "setBrightness" -> {
                    val brightness = call.argument<Double>("brightness")?.toFloat() ?: 0.5f
                    val lp = window.attributes
                    lp.screenBrightness = brightness
                    window.attributes = lp
                    result.success(null)
                }
                "restoreSystemBrightness" -> {
                    val lp = window.attributes
                    lp.screenBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
                    window.attributes = lp
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
}
```

**iOS Swift (`AppDelegate.swift`):**
```swift
private func setupBrightnessChannel(_ controller: FlutterViewController) {
    let channel = FlutterMethodChannel(name: "com.streampro.app/brightness",
                                       binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { call, result in
        switch call.method {
        case "getBrightness":
            result(Double(UIScreen.main.brightness))
        case "setBrightness":
            if let args = call.arguments as? [String: Any],
               let brightness = args["brightness"] as? Double {
                DispatchQueue.main.async {
                    UIScreen.main.brightness = CGFloat(brightness)
                }
                result(nil)
            }
        case "restoreSystemBrightness":
            // iOS doesn't have a "system" restore, no-op here
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
```

---

### F.3 `VolumeChannel`

```dart
// lib/features/player/data/datasources/volume_channel.dart
class VolumeChannel {
  static const _channel = MethodChannel('com.streampro.app/volume');

  Future<double> getCurrentVolume() async {
    try {
      return await _channel.invokeMethod<double>('getVolume') ?? 1.0;
    } on PlatformException {
      return 1.0;
    }
  }

  Future<void> setVolume(double volume) async {
    try {
      await _channel.invokeMethod('setVolume', {'volume': volume.clamp(0.0, 1.0)});
    } on PlatformException catch (e) {
      debugPrint('Volume error: ${e.message}');
    }
  }
}
```

**Android Kotlin:**
```kotlin
private fun setupVolumeChannel() {
    val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
    val maxVolume = audioManager.getStreamMaxVolume(AudioManager.STREAM_MUSIC)

    MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, "com.streampro.app/volume")
        .setMethodCallHandler { call, result ->
            when (call.method) {
                "getVolume" -> {
                    val current = audioManager.getStreamVolume(AudioManager.STREAM_MUSIC)
                    result.success(current.toDouble() / maxVolume.toDouble())
                }
                "setVolume" -> {
                    val volume = call.argument<Double>("volume") ?: 1.0
                    val targetVolume = (volume * maxVolume).toInt()
                    audioManager.setStreamVolume(AudioManager.STREAM_MUSIC, targetVolume,
                        AudioManager.FLAG_SHOW_UI)
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
}
```

**iOS Swift:**
```swift
// Uses MPVolumeView or AVAudioSession for iOS volume control.
// Note: iOS volume cannot be set programmatically from code without using MPVolumeView.
// Implement a transparent MPVolumeView overlay as a native view, triggered from Flutter
// via EventChannel. For PRD purposes, the volume gesture on iOS shows a HUD slider
// that mirrors the system volume indicator.
```

---

### F.4 `PipChannel`

```dart
// lib/features/player/data/datasources/pip_channel.dart
class PipChannel {
  static const _channel = MethodChannel('com.streampro.app/pip');
  static const _eventChannel = EventChannel('com.streampro.app/pip_events');

  Future<bool> isPipSupported() async {
    try {
      return await _channel.invokeMethod<bool>('isSupported') ?? false;
    } on PlatformException {
      return false;
    }
  }

  Future<void> enterPip({required int width, required int height}) async {
    try {
      await _channel.invokeMethod('enterPip', {'width': width, 'height': height});
    } on PlatformException catch (e) {
      debugPrint('PiP error: ${e.message}');
    }
  }

  Future<void> exitPip() async {
    try {
      await _channel.invokeMethod('exitPip');
    } on PlatformException catch (e) {
      debugPrint('Exit PiP error: ${e.message}');
    }
  }

  Stream<String> get pipEventStream => _eventChannel
      .receiveBroadcastStream()
      .map((event) => event.toString()); // 'entered', 'exited', 'play', 'pause'
}
```

**Android Kotlin:**
```kotlin
override fun onUserLeaveHint() {
    super.onUserLeaveHint()
    // Triggered when user presses Home during video playback
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
        val aspectRatio = Rational(16, 9)
        val pipParams = PictureInPictureParams.Builder()
            .setAspectRatio(aspectRatio)
            .build()
        enterPictureInPictureMode(pipParams)
    }
}

override fun onPictureInPictureModeChanged(isInPictureInPictureMode: Boolean, newConfig: Configuration) {
    super.onPictureInPictureModeChanged(isInPictureInPictureMode, newConfig)
    // Send event to Flutter via EventChannel
    pipEventSink?.success(if (isInPictureInPictureMode) "entered" else "exited")
}
```

---

## APPENDIX G: Complete `GoRouter` Configuration

```dart
// lib/core/routes/app_router.dart
import 'package:go_router/go_router.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final config = sl<AppConfigRepository>().getConfig();
    final isOnSplash = state.matchedLocation == AppRoutes.splash;
    final isOnLegal = state.matchedLocation == AppRoutes.ageGate ||
        state.matchedLocation == AppRoutes.terms ||
        state.matchedLocation == AppRoutes.privacy;

    // If first time user hits any deep link, gate them first
    if (!config.hasAcceptedTerms && !isOnLegal && !isOnSplash) {
      return AppRoutes.ageGate;
    }
    return null;
  },
  routes: [
    GoRoute(path: AppRoutes.splash, builder: (c, s) => const SplashPage()),
    GoRoute(path: AppRoutes.ageGate, builder: (c, s) => const AgeGatePage()),
    GoRoute(path: AppRoutes.onboarding, builder: (c, s) => const OnboardingPage()),
    GoRoute(path: AppRoutes.terms, builder: (c, s) => const TermsPage()),
    GoRoute(path: AppRoutes.privacy, builder: (c, s) => const PrivacyPolicyPage()),
    GoRoute(
      path: AppRoutes.home,
      pageBuilder: (c, s) => _fadeTransition(s, const HomePage()),
      routes: [],
    ),
    GoRoute(
      path: AppRoutes.player,
      pageBuilder: (c, s) {
        final video = s.extra as VideoEntity;
        return _fadeTransition(s, VideoPlayerPage(video: video));
      },
    ),
    GoRoute(path: AppRoutes.vpn, builder: (c, s) => const VpnStatusScreen()),
    GoRoute(path: AppRoutes.categories, builder: (c, s) => const CategoryGridPage()),
    GoRoute(
      path: '/category/:id',
      builder: (c, s) {
        final categoryName = s.pathParameters['id']!;
        return CategoryFeedPage(categoryName: categoryName);
      },
    ),
    GoRoute(path: AppRoutes.profile, builder: (c, s) => const ProfilePage()),
    GoRoute(path: AppRoutes.profileEdit, builder: (c, s) => const EditProfilePage()),
    GoRoute(path: AppRoutes.notifications, builder: (c, s) => const NotificationsPage()),
    GoRoute(path: AppRoutes.downloads, builder: (c, s) => const DownloadsPage()),
    GoRoute(path: AppRoutes.playlists, builder: (c, s) => const PlaylistsPage()),
    GoRoute(
      path: '/playlists/:id',
      builder: (c, s) {
        final playlistId = s.pathParameters['id']!;
        return PlaylistDetailPage(playlistId: playlistId);
      },
    ),
    GoRoute(path: AppRoutes.liked, builder: (c, s) => const LikedVideosPage()),
    GoRoute(path: AppRoutes.settings, builder: (c, s) => const SettingsPage()),
    GoRoute(path: AppRoutes.settingsPlayback, builder: (c, s) => const PlaybackSettingsPage()),
    GoRoute(path: AppRoutes.settingsParental, builder: (c, s) => const ParentalControlPage()),
    GoRoute(path: AppRoutes.help, builder: (c, s) => const HelpFaqPage()),
    GoRoute(path: AppRoutes.about, builder: (c, s) => const AboutPage()),
    GoRoute(path: AppRoutes.cast, builder: (c, s) => const CastPage()),
  ],
  errorBuilder: (context, state) => const NotFoundPage(),
);

CustomTransitionPage<void> _fadeTransition(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );
}
```

---

## APPENDIX H: Complete `main.dart` Specification

```dart
// lib/main.dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize Hive
  await Hive.initFlutter();
  _registerHiveAdapters();
  await _openHiveBoxes();

  // 2. Initialize Dependency Injection
  await setupInjection();

  // 3. Initialize seed data (runs only if videos_box is empty)
  await sl<VideoRepository>().initializeSeedData();
  await sl<CommentRepository>().seedCommentsIfNeeded();
  await sl<NotificationRepository>().seedNotificationsIfNeeded();

  // 4. Configure system UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Color(0xFF0A0A0A),
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const StreamProApp());
}

void _registerHiveAdapters() {
  Hive.registerAdapter(AppConfigAdapter());    // typeId: 0
  Hive.registerAdapter(VideoEntityAdapter());  // typeId: 1
  Hive.registerAdapter(WatchHistoryEntryAdapter()); // typeId: 2
  Hive.registerAdapter(BookmarkEntryAdapter()); // typeId: 3
  Hive.registerAdapter(DownloadRecordAdapter()); // typeId: 4
  Hive.registerAdapter(PlaylistAdapter());      // typeId: 5
  Hive.registerAdapter(PlaylistItemAdapter());  // typeId: 6
  Hive.registerAdapter(LikeRecordAdapter());    // typeId: 7
  Hive.registerAdapter(CommentAdapter());       // typeId: 8
  Hive.registerAdapter(UserProfileAdapter());   // typeId: 9
  Hive.registerAdapter(AppNotificationAdapter()); // typeId: 10
  Hive.registerAdapter(SearchHistoryEntryAdapter()); // typeId: 11
}

Future<void> _openHiveBoxes() async {
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

class StreamProApp extends StatelessWidget {
  const StreamProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<ConnectivityBloc>()..add(StartMonitoring())),
        BlocProvider(create: (_) => sl<VpnBloc>()..add(AutoConnectVpnEvent())),
        BlocProvider(create: (_) => sl<NotificationBloc>()..add(LoadNotifications())),
        BlocProvider(create: (_) => sl<SettingsBloc>()..add(LoadSettings())),
        BlocProvider(create: (_) => sl<ProfileBloc>()..add(LoadProfile())),
        BlocProvider(create: (_) => sl<PipBloc>()),
      ],
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prev, curr) => curr is SettingsLoaded,
        builder: (context, state) {
          return MaterialApp.router(
            title: 'StreamPro',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.darkTheme,
            routerConfig: appRouter,
            builder: (context, child) {
              return ConnectivityOverlay(child: child ?? const SizedBox());
            },
          );
        },
      ),
    );
  }
}
```

**`ConnectivityOverlay` widget:**
```dart
// core/widgets/connectivity_overlay.dart
class ConnectivityOverlay extends StatelessWidget {
  final Widget child;
  const ConnectivityOverlay({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, state) {
        if (state is ConnectivityOffline) {
          _showOfflineOverlay(context);
        } else if (state is ConnectivityOnline) {
          _hideOfflineOverlay(context);
          _showOnlineSnackbar(context);
        }
      },
      child: child,
    );
  }

  void _showOfflineOverlay(BuildContext context) { /* OverlayEntry insertion */ }
  void _hideOfflineOverlay(BuildContext context) { /* OverlayEntry removal */ }
  void _showOnlineSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Back Online ✓'),
        backgroundColor: Color(0xFF10B981),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
```

---

## APPENDIX I: Quality Assurance & Testing Specification

### I.1 Testing Philosophy

StreamPro targets the following test coverage distribution:
- Unit tests (BLoC + Repository): 70% minimum coverage
- Widget tests (core widgets): 20% minimum coverage
- Integration tests (critical flows): 10%

### I.2 Required Unit Tests (BLoC Layer)

For each BLoC listed below, the following test cases must be written using `bloc_test` and `mocktail`.

**`HomeFeedBloc` tests:**
```
✓ emits [HomeFeedLoading, HomeFeedLoaded] when LoadHomeFeed is added and videos exist
✓ emits [HomeFeedLoading, HomeFeedError] when repository throws
✓ HomeFeedLoaded.featuredVideos only contains videos where isFeatured == true
✓ HomeFeedLoaded.continueWatching only contains videos with progressPercent between 0.0 and 0.9
✓ emits [HomeFeedLoading, HomeFeedLoaded] with filtered results on RefreshHomeFeed
✓ ChangeSelectedCategory updates selectedCategory in new HomeFeedLoaded state
```

**`SearchBloc` tests:**
```
✓ emits [SearchLoading, SearchResultsLoaded] when query matches videos
✓ emits [SearchLoading, SearchEmpty] when query matches no videos
✓ debounces rapid SearchQueryChanged events (only fires after 350ms silence)
✓ SearchSubmitted saves to search_history_box
✓ SearchFiltersApplied filters results correctly by duration
✓ SearchFiltersApplied filters results correctly by category
✓ SearchCleared returns to SearchIdle state with recent searches
✓ UndoSearchHistoryRemoval restores last removed entry
```

**`PlayerBloc` tests:**
```
✓ emits PlayerReady on InitializePlayer with correct video
✓ TogglePlayPause flips isPlaying in PlayerReady state
✓ SetBrightness clamps value to [0.05, 1.0]
✓ SetVolume clamps value to [0.0, 1.0]
✓ SeekDelta adds deltaSeconds to currentSeconds, clamped to [0, totalSeconds]
✓ ToggleFitMode flips isFillMode
✓ HideControls sets isControlsVisible to false
✓ Controls auto-hide timer fires HideControls after 3 seconds of inactivity
✓ AddToHistory is called on InitializePlayer
```

**`PlaylistBloc` tests:**
```
✓ CreatePlaylist adds entry and emits PlaylistLoaded with new list
✓ DeletePlaylist removes entry and its PlaylistItems
✓ AddVideoToPlaylist rejects if playlist already has the video (duplicate guard)
✓ ReorderPlaylistItems updates position fields correctly
✓ CreatePlaylist rejects if playlist count == 20 (limit check)
```

**`SettingsBloc` tests:**
```
✓ LoadSettings returns default AppConfig on first run
✓ ToggleAutoPlay inverts autoPlayEnabled
✓ ClearWatchHistory calls repository.clearAllHistory()
✓ EnableParentalControl saves PIN and sets parentalControlEnabled = true
✓ DisableParentalControl fails with wrong PIN, emits ParentalPinError
✓ DisableParentalControl succeeds with correct PIN
```

### I.3 Required Repository Unit Tests

```
VideoRepository:
  ✓ initializeSeedData creates exactly 60 videos
  ✓ getVideosByCategory returns only videos matching that category
  ✓ searchVideos returns correct results for partial title match
  ✓ searchVideos with age restriction filter excludes requiresAgeVerification == true
  ✓ getPaginatedVideos returns correct page sizes (default 10)
  ✓ getRelatedVideos returns videos from same category

WatchHistoryRepository:
  ✓ addOrUpdateHistory creates new entry if video not in history
  ✓ addOrUpdateHistory updates existing entry and increments watchCount
  ✓ clearAllHistory empties the box
  ✓ getHistory returns max `limit` entries
  ✓ removeFromHistory deletes the correct entry

PlaylistRepository:
  ✓ createPlaylist generates a UUID id
  ✓ addVideoToPlaylist updates Playlist.videoCount
  ✓ reorderPlaylistItem correctly updates all position fields
  ✓ deletePlaylist also deletes all PlaylistItems for that playlist
```

### I.4 Required Widget Tests

```
PremiumVideoCard:
  ✓ renders title text
  ✓ renders thumbnail via CachedNetworkImage
  ✓ shows progress bar when progressPercent is between 0.0 and 0.9
  ✓ does not show progress bar when progressPercent == 0.0
  ✓ shows "NEW" badge when VideoEntity.isNew == true
  ✓ shows "HD" badge when VideoEntity.isHD == true
  ✓ bookmark icon is filled when isBookmarked == true
  ✓ onTap callback is called on tap
  ✓ onLongPress callback is called on long press
  ✓ onDoubleTap callback is called on double tap

ShimmerLoadingCard (ShimmerVideoCard variant):
  ✓ renders a Shimmer widget
  ✓ has correct aspect ratio for thumbnail placeholder

EmptyStateWidget:
  ✓ renders correct title for EmptyStateType.search
  ✓ renders action button when actionLabel is provided
  ✓ does not render action button when actionLabel is null
  ✓ calls onAction when action button is tapped

GradientButton:
  ✓ renders label text
  ✓ calls onPressed on tap
  ✓ is visually disabled (no gradient, reduced opacity) when disabled
```

### I.5 Required Integration Tests

**Critical user flows tested end-to-end:**

```
Flow 1: First Launch
  1. Launch app
  2. Verify SplashPage appears
  3. Verify AgeGatePage is pushed automatically (hasAcceptedTerms == false)
  4. Select birth year (18+)
  5. Tap "Confirm My Age"
  6. Verify OnboardingPage appears
  7. Select 3 interests
  8. Tap "Get Started"
  9. Verify HomePage with HomeFeed is visible

Flow 2: Video Discovery to Playback
  1. Start on HomePage
  2. Tap Discover tab
  3. Enter "Action" in search bar
  4. Wait for results
  5. Tap first result video card
  6. Verify VideoPlayerPage appears
  7. Verify video title is visible in player overlay
  8. Tap player to show controls
  9. Verify controls overlay appears
  10. Tap back button
  11. Verify return to Discover tab

Flow 3: Playlist Creation
  1. Start on HomePage
  2. Navigate to Library tab → Playlists
  3. Tap "+" button
  4. Enter playlist name "My Favorites"
  5. Select a color
  6. Tap "Create"
  7. Verify new playlist card appears
  8. Long-press any video card on Home
  9. Select "Add to Playlist"
  10. Select "My Favorites"
  11. Verify success snackbar
  12. Navigate to playlist
  13. Verify video appears in playlist

Flow 4: Settings - Clear History
  1. Watch at least 1 video (so history is not empty)
  2. Navigate to Library → History
  3. Verify history entry exists
  4. Navigate to Settings
  5. Tap "Clear Watch History"
  6. Confirm in dialog
  7. Navigate back to Library → History
  8. Verify EmptyStateWidget is shown
```

---

## APPENDIX J: Performance Optimization Requirements

### J.1 Frame Rate Targets
- All list scrolling: 60fps minimum, 120fps on supported devices.
- Player controls fade animation: 60fps.
- Shimmer loading: 60fps.
- All `CustomPainter` implementations must use `shouldRepaint` correctly to avoid unnecessary repaints.

### J.2 Memory Management

**`InAppWebView` disposal:**
```dart
@override
void dispose() {
  _webViewController?.stopLoading();
  _webViewController?.clearCache();
  _webViewController = null;
  _autoHideTimer?.cancel();
  _progressTimer?.cancel();
  _brightnessChannel.restoreSystemBrightness();
  WakelockPlus.disable();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  super.dispose();
}
```

**Image caching policy:**
- `CachedNetworkImage` must be configured with `maxHeightDiskCache: 360` and `maxWidthDiskCache: 640` to avoid storing full-resolution source images.
- `memCacheWidth` and `memCacheHeight` must be set on all card thumbnails:
  ```dart
  CachedNetworkImage(
    memCacheWidth: 320,
    memCacheHeight: 180,
    ...
  )
  ```

**List performance:**
- All `ListView.builder` and `GridView.builder` must set `addRepaintBoundaries: true` (default, confirm it is not overridden).
- `PremiumVideoCard` must be wrapped in `RepaintBoundary` to isolate repaints.
- `itemExtent` should be set on all lists where card height is fixed (e.g., trending list rows: `itemExtent: 80.0`).

### J.3 Hive Performance

- All Hive write operations must be awaited and performed in `compute()` if writing more than 20 entities simultaneously (e.g., during seed data initialization).
- Do not call `.toList()` on large Hive boxes on the main thread. Use `.values.take(n)` for pagination.
- Compact boxes on app startup if waste ratio exceeds 20%:
  ```dart
  if (box.isOpen && box.keys.length > 50) {
    await box.compact();
  }
  ```

### J.4 Shimmer Performance

- `Shimmer.fromColors` must not be rebuilt unnecessarily. Wrap in `const` where possible.
- Never place a `Shimmer` widget inside an `AnimatedSwitcher` with rapid state changes — debounce the state before switching from shimmer to content.

---

## APPENDIX K: Accessibility Requirements

All screens must meet WCAG AA accessibility standards and pass Google Play / App Store accessibility reviews.

### K.1 Semantic Labels

Every interactive element must have a `Tooltip` or `Semantics` wrapper:

```dart
// Example — Bookmark icon button
Semantics(
  label: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
  button: true,
  child: IconButton(
    tooltip: isBookmarked ? 'Remove bookmark' : 'Add bookmark',
    onPressed: onBookmarkTap,
    icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
  ),
)
```

Required semantic labels for every screen:
- All icon-only buttons must have `tooltip` set.
- All images must have `semanticLabel` set (e.g., `Image(semanticLabel: 'Thumbnail for ${video.title}')`).
- `PremiumVideoCard` must have `Semantics(label: '${video.title}, ${video.duration}, ${video.category}. Double-tap to play.')`.
- `ShimmerLoadingCard` must have `Semantics(label: 'Loading content', excludeSemantics: true)`.
- `EmptyStateWidget` must have `Semantics(liveRegion: true)` so screen readers announce it.

### K.2 Color Contrast

All text must meet a minimum contrast ratio:
- `colorTextPrimary` (#FFFFFF) on `colorBackground` (#0A0A0A): 21:1 ✓
- `colorTextSecondary` (#9CA3AF) on `colorBackground` (#0A0A0A): 5.4:1 ✓
- `colorTextMuted` (#6B7280) on `colorBackground` (#0A0A0A): 3.9:1 — Acceptable for decorative text, not for primary content.
- All action text (buttons, links) must use `colorTextPrimary` or the gradient, both of which pass.

**Rule:** Never use `colorTextMuted` for text that conveys meaning. Only use it for timestamps, decorative labels, and metadata where `colorTextSecondary` or `colorTextPrimary` alternatives are available nearby.

### K.3 Touch Target Sizes

All tappable elements must have a minimum touch target of 48×48dp, even if the visual element is smaller. Use `Material` + `InkWell` with explicit `constraints` or wrap small icons in a `SizedBox(width: 48, height: 48)`:

```dart
SizedBox(
  width: 48,
  height: 48,
  child: IconButton(
    padding: EdgeInsets.zero,
    icon: const Icon(Icons.more_vert, size: 20),
    onPressed: onMoreTap,
  ),
)
```

### K.4 Font Scaling

All text in the app must respect the system font scale. Never use `textScaleFactor: 1.0` to override user font preferences. Test all screens at font scale 1.5× to ensure no overflow or clipping. Use `FittedBox` on badges and chips where a fixed-size container could clip large text.

---

## APPENDIX L: App Store & Google Play Submission Checklist

### L.1 Google Play Store Requirements

**App Content:**
- [ ] Privacy Policy URL provided in Play Console (can point to in-app `/privacy` screen as a hosted HTML page).
- [ ] Content rating questionnaire completed in Play Console — StreamPro should receive a rating of "Teen" (13+).
- [ ] Target audience set to "13 and older".
- [ ] Age gate confirmation (`AppConfig.hasAcceptedAgeGate`) implemented and functional.
- [ ] App does not collect or transmit personal data (all local) — declare this in the Data Safety section.
- [ ] `INTERNET` and `ACCESS_NETWORK_STATE` permissions justified in the store description.
- [ ] `android:largeHeap="true"` justified by WebView usage.

**Technical:**
- [ ] `minSdkVersion` 21 set correctly.
- [ ] `targetSdkVersion` 35 set.
- [ ] All `<uses-permission>` tags present and justified.
- [ ] `android:usesCleartextTraffic` only enabled because iframe embeds may use HTTP — must be noted in security review.
- [ ] App passes `bundletool` validation (build `.aab` not `.apk` for submission).
- [ ] ProGuard/R8 configured for release: `minifyEnabled true`, `shrinkResources true`.
- [ ] `build.gradle.kts` production `signingConfig` configured.

**Store Listing:**
- [ ] App name: "StreamPro - Free Video Streaming" (max 50 chars).
- [ ] Short description (80 chars): "Stream premium videos free. HD quality, no subscription required."
- [ ] Full description written (4000 chars max) covering all features.
- [ ] Screenshots: Phone (minimum 2, recommended 8) + 7-inch tablet + 10-inch tablet.
- [ ] Feature graphic: 1024×500 PNG, brand gradient background with logo.
- [ ] App icon: 512×512 PNG, adaptive icon with foreground layer.

### L.2 Apple App Store Requirements

**App Review Guidelines:**
- [ ] Age rating set to 12+ in App Store Connect (streaming app with mild content).
- [ ] NSAllowsArbitraryLoads justification written for App Review: "Required for embedding third-party video iframes that may use HTTP. All video content sources are controlled."
- [ ] Camera/Photo/Microphone `Info.plist` descriptions filled in (even if features not yet active):
  - `NSPhotoLibraryUsageDescription`: "StreamPro needs access to your photo library to let you set a custom profile picture."
  - `NSCameraUsageDescription`: "StreamPro needs camera access for future live features."
  - `NSMicrophoneUsageDescription`: "StreamPro needs microphone access for future voice search features."
- [ ] `UIBackgroundModes` justification: audio background mode required for PiP audio continuity.
- [ ] App does not use IDFA — declare in App Store Connect.
- [ ] PiP usage on iOS complies with App Review Guideline 4.2.7 (iOS 15+ minimum enforced).

**Technical:**
- [ ] `IPHONEOS_DEPLOYMENT_TARGET` = 13.0.
- [ ] `CFBundleShortVersionString` = "1.0.0".
- [ ] `CFBundleVersion` = "1".
- [ ] App passes `altool` validation.
- [ ] CocoaPods `Podfile.lock` committed.
- [ ] Archive built with Xcode Release scheme, distribution certificate.

**Store Listing:**
- [ ] App name: "StreamPro" (30 chars max).
- [ ] Subtitle: "Free Video Streaming App" (30 chars max).
- [ ] Keywords: "streaming, video, movies, free, HD, entertainment, watch, tv, series, shows".
- [ ] Screenshots: iPhone 6.7" (required), iPhone 6.5", iPad Pro 12.9" (if iPad supported).
- [ ] App preview video (optional but recommended): 15–30 second screen recording.

---

## APPENDIX M: Error Handling & Edge Case Catalog

This appendix catalogs every known error condition in the app and the required handling behavior.

| Error Condition | Detection Point | Required Behavior |
|---|---|---|
| No videos in Hive on cold start | `VideoRepository.initializeSeedData()` | Re-run seed, log warning, show loading for 2s |
| Age gate back press attempt | `PopScope.onPopInvokedWithResult` | Do nothing — `canPop` stays false |
| Parental PIN entered 3 times wrong | `SettingsBloc.DisableParentalControl` handler | 30-second lockout, countdown shown in dialog |
| Playlist name empty on create | `PlaylistBloc.CreatePlaylist` handler | Emit `PlaylistError('Playlist name cannot be empty')`, show field error |
| Playlist limit (20) reached | `PlaylistBloc.CreatePlaylist` handler | Emit `PlaylistError('Playlist limit reached (20/20)')` |
| Download simulation fails | `DownloadBloc.DownloadProgressTick` | Set status to 'failed', emit error, show notification |
| Comment text empty | `CommentBloc.PostComment` | Ignore event, show "Comment cannot be empty" snackbar |
| Comment text over 500 chars | `CommentBloc.PostComment` | Trim to 500, show warning snackbar |
| WebView fails to load | `InAppWebView.onReceivedError` | Show in-player error overlay with retry button that calls `webViewController.reload()` |
| WebView SSL error | `InAppWebView.onReceivedServerTrustAuthRequest` | Cancel request, show "Content unavailable" error |
| Brightness channel not available | `BrightnessChannel.setBrightness()` catch | Silently use overlay brightness simulation (semi-transparent overlay changing opacity) |
| Volume channel not available | `VolumeChannel.setVolume()` catch | Show a "Volume control unavailable on this device" snackbar once, then silently ignore |
| PiP not supported | `PipChannel.isPipSupported()` returns false | Hide PiP button, show "PiP not available on this device" snackbar when user tries |
| Connectivity lost mid-session | `ConnectivityBloc` emits `ConnectivityOffline` | Show offline overlay (Screen 32), freeze all non-local operations |
| Hive box corrupted | `Hive.openBox()` throws | Delete and recreate the box with empty data, log the error |
| Invalid video ID in route | `GoRouter.redirect` or screen `initState` | Navigate to 404 screen, show "Video not found" message |
| Shake gesture false positive | `ShakeDetector` | Debounce: only fire if 2 threshold-exceeding events occur within 500ms |
| Deep link to protected content (R-rated) without age verification | `GoRouter.redirect` | Redirect to home, show "Content restricted. Age verification required." snackbar |

---

## APPENDIX N: Localization Preparation (i18n)

StreamPro v1.0 ships in English only. However, the codebase must be prepared for future localization to avoid a costly refactor.

### N.1 Requirements

- All user-facing strings must be extracted to `lib/core/l10n/app_en.arb` using Flutter's `intl` package.
- No hardcoded user-facing strings in widget files. Use `AppLocalizations.of(context)!.stringKey` pattern.
- All date/time formatting must use `intl.DateFormat` with locale awareness.
- All number formatting (view counts, file sizes) must use `intl.NumberFormat`.

### N.2 String Categories in `app_en.arb`

```json
{
  "appName": "StreamPro",
  "splashTagline": "Premium. Free. Unlimited.",
  "ageGateTitle": "Age Verification Required",
  "ageGateBody": "StreamPro contains content that may not be suitable for all audiences. Please confirm your age to continue.",
  "ageGateConfirmButton": "Confirm My Age",
  "ageGateUnder13Link": "I am under 13",
  "ageGateUnder13Title": "Access Restricted",
  "ageGateUnder13Body": "This app requires users to be at least 13 years of age.",
  "onboardingTitle1": "Stream Anything, Anytime",
  "onboardingBody1": "Discover thousands of premium videos across every genre — completely free.",
  "emptySearchTitle": "No Results Found",
  "emptySearchBody": "Try different keywords or browse by category.",
  "emptyHistoryTitle": "Nothing Here Yet",
  "emptyHistoryBody": "Videos you watch will appear in your history.",
  ... (all strings from EmptyStateWidget type table in Section 10.2)
}
```

### N.3 Date/Time Formatting Utility

```dart
// lib/core/utils/date_formatter.dart
class DateFormatter {
  static String timeAgo(String isoString) {
    final date = DateTime.parse(isoString);
    return timeago.format(date);
  }

  static String formatDuration(int seconds) {
    final d = Duration(seconds: seconds);
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return hours > 0 ? '$hours:$minutes:$secs' : '$minutes:$secs';
  }

  static String formatViewCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M views';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(0)}K views';
    return '$count views';
  }

  static String formatFileSize(int bytes) {
    if (bytes >= 1073741824) return '${(bytes / 1073741824).toStringAsFixed(1)} GB';
    if (bytes >= 1048576) return '${(bytes / 1048576).toStringAsFixed(0)} MB';
    if (bytes >= 1024) return '${(bytes / 1024).toStringAsFixed(0)} KB';
    return '$bytes B';
  }

  static String formatWatchTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
```

---

## APPENDIX O: Final File Structure (Complete)

The following is the complete target file structure for the production-ready StreamPro app. Every file listed must exist in the final codebase.

```
lib/
├── core/
│   ├── blocs/
│   │   ├── connectivity_bloc.dart
│   │   └── filter_bloc.dart
│   ├── di/
│   │   └── injection.dart
│   ├── l10n/
│   │   └── app_en.arb
│   ├── models/
│   │   ├── app_config.dart + app_config.g.dart
│   │   ├── video_entity.dart + video_entity.g.dart
│   │   ├── watch_history_entry.dart + .g.dart
│   │   ├── bookmark_entry.dart + .g.dart
│   │   ├── download_record.dart + .g.dart
│   │   ├── playlist.dart + .g.dart
│   │   ├── playlist_item.dart + .g.dart
│   │   ├── like_record.dart + .g.dart
│   │   ├── comment.dart + .g.dart
│   │   ├── user_profile.dart + .g.dart
│   │   ├── app_notification.dart + .g.dart
│   │   └── search_history_entry.dart + .g.dart
│   ├── routes/
│   │   ├── app_routes.dart
│   │   └── app_router.dart
│   ├── services/
│   │   ├── database_service.dart
│   │   ├── download_simulation_service.dart
│   │   ├── cast_service.dart
│   │   └── connectivity_service.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── animation_constants.dart
│   ├── utils/
│   │   └── date_formatter.dart
│   └── widgets/
│       ├── premium_video_card.dart
│       ├── shimmer_loading_card.dart
│       ├── empty_state_widget.dart
│       ├── error_state_widget.dart
│       ├── gradient_button.dart
│       ├── outlined_gradient_button.dart
│       ├── gradient_icon_button.dart
│       ├── gradient_text.dart
│       ├── glassmorphic_container.dart
│       ├── video_progress_bar.dart
│       ├── rating_badge.dart
│       ├── status_badge.dart
│       ├── count_badge.dart
│       ├── avatar_widget.dart
│       ├── section_header.dart
│       ├── draggable_bottom_sheet.dart
│       ├── animated_bottom_bar.dart
│       ├── connectivity_overlay.dart
│       └── end_of_list_widget.dart
├── features/
│   ├── age_gate/
│   │   └── presentation/pages/age_gate_page.dart
│   ├── onboarding/
│   │   └── presentation/pages/onboarding_page.dart
│   ├── legal/
│   │   └── presentation/pages/
│   │       ├── terms_page.dart
│   │       └── privacy_policy_page.dart
│   ├── home/
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   └── home_feed_bloc.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── splash_page.dart
│   │       └── widgets/
│   │           ├── home_feed_view.dart
│   │           └── main_drawer.dart
│   ├── discover/
│   │   ├── data/repositories/video_repository.dart
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── search_bloc.dart
│   │       │   └── video_list_bloc.dart
│   │       └── pages/discover_view.dart
│   ├── trending/
│   │   └── presentation/
│   │       ├── blocs/trending_bloc.dart
│   │       └── pages/trending_view.dart
│   ├── library/
│   │   ├── data/repositories/
│   │   │   ├── history_repository.dart
│   │   │   ├── bookmark_repository.dart
│   │   │   ├── download_repository.dart
│   │   │   ├── playlist_repository.dart
│   │   │   └── like_repository.dart
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── playlist_bloc.dart
│   │       │   ├── download_bloc.dart
│   │       │   └── like_bloc.dart
│   │       └── pages/library_view.dart
│   ├── player/
│   │   ├── data/datasources/
│   │   │   ├── brightness_channel.dart
│   │   │   ├── volume_channel.dart
│   │   │   └── pip_channel.dart
│   │   ├── data/repositories/comment_repository.dart
│   │   └── presentation/
│   │       ├── blocs/
│   │       │   ├── player_bloc.dart
│   │       │   ├── comment_bloc.dart
│   │       │   └── pip_bloc.dart
│   │       ├── pages/video_player_page.dart
│   │       └── widgets/
│   │           ├── player_controls_overlay.dart
│   │           ├── player_gesture_detector.dart
│   │           ├── brightness_hud.dart
│   │           ├── volume_hud.dart
│   │           ├── seek_feedback_overlay.dart
│   │           ├── pip_mini_player.dart
│   │           └── comments_bottom_sheet.dart
│   ├── category/
│   │   └── presentation/pages/
│   │       ├── category_grid_page.dart
│   │       └── category_feed_page.dart
│   ├── profile/
│   │   ├── data/repositories/profile_repository.dart
│   │   └── presentation/
│   │       ├── blocs/profile_bloc.dart
│   │       └── pages/
│   │           ├── profile_page.dart
│   │           └── edit_profile_page.dart
│   ├── notifications/
│   │   ├── data/repositories/notification_repository.dart
│   │   └── presentation/
│   │       ├── blocs/notification_bloc.dart
│   │       └── pages/notifications_page.dart
│   ├── downloads/
│   │   └── presentation/pages/downloads_page.dart
│   ├── playlists/
│   │   └── presentation/pages/
│   │       ├── playlists_page.dart
│   │       └── playlist_detail_page.dart
│   ├── liked/
│   │   └── presentation/pages/liked_videos_page.dart
│   ├── settings/
│   │   ├── blocs/settings_bloc.dart
│   │   └── presentation/pages/
│   │       ├── settings_page.dart
│   │       ├── playback_settings_page.dart
│   │       └── parental_control_page.dart
│   ├── vpn/
│   │   ├── data/datasources/vpn_platform_channel.dart
│   │   └── presentation/
│   │       ├── blocs/vpn_bloc.dart
│   │       └── pages/vpn_status_screen.dart
│   ├── cast/
│   │   └── presentation/pages/cast_page.dart
│   └── help/
│       └── presentation/pages/
│           ├── help_faq_page.dart
│           └── about_page.dart
└── main.dart

assets/
├── lottie/
│   ├── splash_logo.json
│   ├── empty_search.json
│   ├── empty_history.json
│   ├── empty_bookmarks.json
│   ├── empty_downloads.json
│   ├── empty_playlists.json
│   ├── empty_liked.json
│   ├── empty_notifications.json
│   ├── empty_comments.json
│   ├── error_state.json
│   ├── vpn_connecting.json
│   ├── vpn_connected.json
│   ├── download_complete.json
│   ├── like_burst.json
│   ├── onboarding_stream.json
│   └── onboarding_library.json
├── images/
│   └── logo.png
└── icons/
    └── (category icons per category name)

android/
├── app/src/main/
│   ├── AndroidManifest.xml
│   └── kotlin/com/streampro/app/
│       └── MainActivity.kt  ← ALL platform channels implemented here

ios/
├── Runner/
│   ├── Info.plist
│   └── AppDelegate.swift  ← ALL platform channels implemented here

test/
├── unit/
│   ├── blocs/
│   │   ├── home_feed_bloc_test.dart
│   │   ├── search_bloc_test.dart
│   │   ├── player_bloc_test.dart
│   │   ├── playlist_bloc_test.dart
│   │   ├── download_bloc_test.dart
│   │   ├── like_bloc_test.dart
│   │   ├── comment_bloc_test.dart
│   │   ├── settings_bloc_test.dart
│   │   └── notification_bloc_test.dart
│   └── repositories/
│       ├── video_repository_test.dart
│       ├── history_repository_test.dart
│       └── playlist_repository_test.dart
├── widget/
│   ├── premium_video_card_test.dart
│   ├── shimmer_loading_card_test.dart
│   ├── empty_state_widget_test.dart
│   └── gradient_button_test.dart
└── integration/
    ├── first_launch_flow_test.dart
    ├── video_playback_flow_test.dart
    ├── playlist_creation_flow_test.dart
    └── settings_clear_history_test.dart
```

---

*End of StreamPro PRD v2.0 — Extended Edition*

*Total Specification Coverage:*
- *32 screens fully specified*
- *12 Hive database entities with complete schemas and CRUD methods*
- *14 BLoCs with complete event/state definitions*
- *10 global app gestures with implementation details*
- *10 video player gestures with implementation details*
- *10 new feature modules fully specified*
- *Universal UI state system (empty, error, skeleton) for every screen*
- *Platform channel implementations for Brightness, Volume, and PiP*
- *Complete GoRouter configuration*
- *Complete main.dart specification*
- *Full testing specification (unit, widget, integration)*
- *Performance optimization requirements*
- *Accessibility requirements (WCAG AA)*
- *Google Play + App Store submission checklists*
- *Error handling catalog for every known edge case*
- *Localization preparation (i18n)*
- *Complete target file structure (100+ files)*

*This document is ready for direct implementation. No additional clarification is required.*
