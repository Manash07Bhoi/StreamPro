# StreamPro — Agent Implementation Brief

You are a senior Flutter developer. Your sole task is to fully implement the StreamPro application exactly as specified in `StreamPro_PRD_v2.md`. Read that document completely before writing a single line of code — it is the absolute source of truth for every screen, widget, BLoC, database schema, gesture, animation, route, and platform channel in this project.

## What You Are Building

StreamPro is a premium dark-themed free video streaming Flutter app (Android + iOS + Web) using Clean Architecture (feature-first), `flutter_bloc` for state management, `get_it` for dependency injection, `hive` as the local database, `flutter_inappwebview` for video playback, and `go_router` for navigation. The full tech stack and every dependency version is listed in PRD Section 3.

## Implementation Order — Follow This Exactly

Work through the five sprints defined in PRD Section 17 in strict order. Do not skip ahead. Complete each sprint fully before starting the next.

**Sprint 1 (Database & Legal):** Register all 12 Hive adapters and open all 12 boxes in `main.dart` (Appendix H). Implement all 12 entity classes with their `.g.dart` generated files (Section 4). Implement all repository classes with every CRUD method listed. Seed 60 videos, 5–15 comments per video, 5 notifications, and default `AppConfig`. Build `AgeGatePage`, `TermsPage`, and `PrivacyPolicyPage` with full acceptance logic and `PopScope(canPop: false)` gating. Wire splash routing logic (age gate → onboarding → home priority chain).

**Sprint 2 (New Screens):** Build all 11 new screens listed in the Screen Inventory (Section 5) that are marked NEW — `OnboardingPage`, `ProfilePage`, `EditProfilePage`, `CategoryGridPage`, `NotificationsPage`, `DownloadsPage`, `PlaylistsPage`, `PlaylistDetailPage`, `LikedVideosPage`, `HelpFaqPage`, `AboutPage`. Register all routes in `GoRouter` (Appendix G). Update `MainDrawer` with all new navigation links.

**Sprint 3 (Enhanced Screens + Settings Rewrite):** Rewrite `SettingsPage` so every toggle and action is fully functional (no snackbar placeholders). Build `PlaybackSettingsPage` and `ParentalControlPage` with PIN flow. Enhance `HomeFeedView` with all 7 sections. Enhance `LibraryView` with all 5 sub-tabs. Update `PremiumVideoCard` with progress bar, badges (NEW, HD, rating), bookmark toggle, like button, double-tap, and long-press. Rebuild the `VideoPlayerPage` overlay stack with the full 10-layer structure from Section 6 Screen 12.

**Sprint 4 (Gestures + Player + Modals):** Implement all 10 global gestures (Section 8) and all 10 video player gestures (Section 9) using the `GestureDetector` overlay strategy. Implement `BrightnessChannel`, `VolumeChannel`, and `PipChannel` with the exact Kotlin and Swift native code in Appendix F. Build `CommentsBottomSheet`, `LongPressContextMenu`, `AddToPlaylistSheet`, and `AdvancedSearchFilterSheet`. Implement the floating PiP mini-player `OverlayEntry`.

**Sprint 5 (States + Polish):** Implement `ShimmerLoadingCard` in all 7 variants, `EmptyStateWidget` for all 8 `EmptyStateType` values with Lottie, `ErrorStateWidget`, and `EndOfListWidget`. Wire every `BlocBuilder` in every screen to handle `Loading → Skeleton`, `Loaded (empty) → EmptyState`, `Loaded (data) → Content`, `Error → ErrorState`. Implement `ConnectivityBloc` and the `ConnectivityOverlay` offline screen. Add all `Semantics` wrappers and `Tooltip` labels. Verify all `dispose()` methods cancel timers, restore brightness, disable wakelock, and clear WebView.

## Non-Negotiable Rules

- **Never use placeholder comments** like `// TODO` or `// implement later`. Every method listed in the PRD must be fully implemented, not stubbed.
- **Every screen handles all four BLoC states** — Initial/Loading shows skeleton, Loaded-empty shows `EmptyStateWidget`, Loaded-data shows content, Error shows `ErrorStateWidget` with retry. No exceptions.
- **Design tokens are fixed.** Background `#0A0A0A`, Surface `#121212`, Primary `#C026D3`, Secondary `#DB2777`, font Poppins throughout. Never deviate. All spacing follows the 8pt grid from Section 2.2.
- **All Hive writes are `await`ed.** Never fire-and-forget a Hive write. Seed data runs inside `compute()` if writing more than 20 entities.
- **`PopScope(canPop: false)` is mandatory** on `AgeGatePage` and anywhere a legal gate must not be bypassed.
- **`dispose()` must be complete** on `VideoPlayerPage` — cancel all timers, `restoreSystemBrightness()`, `WakelockPlus.disable()`, reset `SystemChrome` orientation and UI mode.
- **Run `dart run build_runner build --delete-conflicting-outputs`** after creating every Hive entity to generate `.g.dart` files before using them anywhere.
- **All BLoC events and states use `Equatable`.** Copy the exact event/state class definitions from Appendix E — do not improvise different names or field structures.
- **`GoRouter` is the only navigation system.** Remove all `Navigator.pushNamed` calls from the existing codebase and replace with `context.go()` or `context.push()`.
- **Platform channels are real implementations**, not empty stubs. The Kotlin and Swift code from Appendix F must be copied verbatim into `MainActivity.kt` and `AppDelegate.swift`.
- **Haptic feedback on every interactive element** — use `HapticFeedback.selectionClick()` for taps and tab changes, `HapticFeedback.mediumImpact()` for confirms and gesture commits, `HapticFeedback.heavyImpact()` for long-press and errors, as specified per gesture in Sections 8 and 9.
- **All animations use `AnimationConstants`** from `core/theme/animation_constants.dart`. Never hardcode duration milliseconds inline.
- **`CachedNetworkImage` must set `memCacheWidth: 320` and `memCacheHeight: 180`** on all card thumbnails. Never load full-resolution images into memory for list items.
- **The final file tree must match Appendix O exactly.** Every file listed there must exist. No file may be missing.

## Quick Reference — Key File Locations

| What | Where |
|---|---|
| All entity classes + Hive typeIds | PRD Section 4 |
| All 32 screen specs | PRD Section 6 |
| All 10 new features | PRD Section 7 |
| All 10 global gestures | PRD Section 8 |
| All 10 player gestures | PRD Section 9 |
| Empty/Error/Skeleton system | PRD Section 10 |
| GoRouter full config | PRD Appendix G |
| main.dart full spec | PRD Appendix H |
| All BLoC events & states | PRD Appendix E |
| Platform channel code | PRD Appendix F |
| pubspec.yaml dependencies | PRD Section 3.1 |
| Android/iOS permissions | PRD Section 3.2 |
| Design tokens (colors, type, spacing) | PRD Section 2.2 |
| Seed data template | PRD Appendix A |
| Comment seed authors | PRD Appendix B |
| VPN country list | PRD Appendix C |
| FAQ content | PRD Appendix D |
| Test specifications | PRD Appendix I |
| Store submission checklists | PRD Appendix L |
| Error handling catalog | PRD Appendix M |
| Complete file structure | PRD Appendix O |

Begin immediately with Sprint 1. Do not ask for clarification — every decision is already made in the PRD.
