import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum EmptyStateType { search, history, bookmarks, downloads, playlists, liked, notifications, comments }

class EmptyStateWidget extends StatelessWidget {
  final EmptyStateType type;
  final String? customTitle;
  final String? customMessage;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.type,
    this.customTitle,
    this.customMessage,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    String lottieAsset;
    String title;
    String message;

    switch (type) {
      case EmptyStateType.search:
        lottieAsset = 'assets/lottie/empty_search.json';
        title = 'No Results Found';
        message = 'Try different keywords or browse by category.';
        break;
      case EmptyStateType.history:
        lottieAsset = 'assets/lottie/empty_history.json';
        title = 'Nothing Here Yet';
        message = 'Videos you watch will appear in your history.';
        break;
      case EmptyStateType.bookmarks:
        lottieAsset = 'assets/lottie/empty_bookmarks.json';
        title = 'No Bookmarks Yet';
        message = 'Tap the bookmark icon on any video to save it.';
        break;
      case EmptyStateType.downloads:
        lottieAsset = 'assets/lottie/empty_downloads.json';
        title = 'No Downloads';
        message = 'Download videos to watch them offline.';
        break;
      case EmptyStateType.playlists:
        lottieAsset = 'assets/lottie/empty_playlists.json';
        title = 'No Playlists';
        message = 'Create a playlist to organize your favorites.';
        break;
      case EmptyStateType.liked:
        lottieAsset = 'assets/lottie/empty_liked.json';
        title = 'No Liked Videos';
        message = 'Double-tap a video or tap the heart to like it.';
        break;
      case EmptyStateType.notifications:
        lottieAsset = 'assets/lottie/empty_notifications.json';
        title = 'All Caught Up!';
        message = 'No new notifications right now.';
        break;
      case EmptyStateType.comments:
        lottieAsset = 'assets/lottie/empty_comments.json';
        title = 'No Comments Yet';
        message = 'Be the first to comment on this video.';
        break;
    }

    title = customTitle ?? title;
    message = customMessage ?? message;

    return Semantics(
      liveRegion: true,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Fallback to icon if lottie is missing
              Lottie.asset(
                lottieAsset,
                height: 200,
                repeat: false,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.hourglass_empty, size: 80, color: Color(0xFF242424)),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 280,
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF)),
                ),
              ),
              if (actionLabel != null && onAction != null) ...[
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: onAction,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC026D3)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  child: Text(actionLabel!, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins')),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
