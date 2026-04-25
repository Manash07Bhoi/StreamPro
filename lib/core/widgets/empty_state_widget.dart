import 'package:flutter/material.dart';

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
    String title = customTitle ?? _getDefaultTitle();
    String message = customMessage ?? _getDefaultMessage();

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.inbox_outlined, size: 80, color: Colors.grey), // Lottie placeholder
            const SizedBox(height: 24),
            Text(title, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey), textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              )
            ]
          ],
        ),
      ),
    );
  }

  String _getDefaultTitle() {
    switch (type) {
      case EmptyStateType.search: return 'No Results Found';
      case EmptyStateType.history: return 'Nothing Here Yet';
      case EmptyStateType.bookmarks: return 'No Bookmarks Yet';
      case EmptyStateType.downloads: return 'No Downloads';
      case EmptyStateType.playlists: return 'No Playlists';
      case EmptyStateType.liked: return 'No Liked Videos';
      case EmptyStateType.notifications: return 'All Caught Up!';
      case EmptyStateType.comments: return 'No Comments Yet';
    }
  }

  String _getDefaultMessage() {
    switch (type) {
      case EmptyStateType.search: return 'Try different keywords or browse by category.';
      case EmptyStateType.history: return 'Videos you watch will appear in your history.';
      case EmptyStateType.bookmarks: return 'Tap the bookmark icon on any video to save it.';
      case EmptyStateType.downloads: return 'Download videos to watch them offline.';
      case EmptyStateType.playlists: return 'Create a playlist to organize your favorites.';
      case EmptyStateType.liked: return 'Double-tap a video or tap the heart to like it.';
      case EmptyStateType.notifications: return 'No new notifications right now.';
      case EmptyStateType.comments: return 'Be the first to comment on this video.';
    }
  }
}
