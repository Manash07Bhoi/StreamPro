import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/video_entity.dart';
import '../blocs/player_bloc.dart';

class PlayerControlsOverlay extends StatelessWidget {
  final VideoEntity video;
  final bool isBookmarked;
  final String reaction;
  final VoidCallback onPop;
  final VoidCallback onToggleBookmark;
  final VoidCallback onToggleLike;
  final VoidCallback onToggleDislike;
  final VoidCallback onRevealComments;

  const PlayerControlsOverlay({
    super.key,
    required this.video,
    required this.isBookmarked,
    required this.reaction,
    required this.onPop,
    required this.onToggleBookmark,
    required this.onToggleLike,
    required this.onToggleDislike,
    required this.onRevealComments,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        if (state is! PlayerReady) return const SizedBox.shrink();

        return AnimatedOpacity(
          opacity: state.isControlsVisible ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: IgnorePointer(
            ignoring: !state.isControlsVisible,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.2, 0.6, 1.0],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTopBar(context),
                  _buildCenterControls(context, state.isPlaying),
                  _buildBottomBar(context, state.progressPercent, state.currentSeconds),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: onPop,
            ),
            Expanded(
              child: Text(
                video.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.cast, color: Colors.white),
              onPressed: () => context.push('/cast'),
            ),
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () {}, // share logic
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterControls(BuildContext context, bool isPlaying) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 48),
          onPressed: () {},
        ),
        const SizedBox(width: 32),
        GestureDetector(
          onTap: () => context.read<PlayerBloc>().add(TogglePlayPause()),
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [Color(0xFFC026D3), Color(0xFFDB2777)]),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 48),
            ),
          ),
        ),
        const SizedBox(width: 32),
        IconButton(
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 48),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context, double progressPercent, int currentSeconds) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: reaction == 'like' ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                label: video.likeCount.toString(),
                color: reaction == 'like' ? const Color(0xFFC026D3) : Colors.white,
                onTap: onToggleLike,
              ),
              _buildActionButton(
                icon: reaction == 'dislike' ? Icons.thumb_down : Icons.thumb_down_alt_outlined,
                label: 'Dislike',
                color: reaction == 'dislike' ? const Color(0xFFEF4444) : Colors.white,
                onTap: onToggleDislike,
              ),
              _buildActionButton(
                icon: isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                label: 'Save',
                color: isBookmarked ? const Color(0xFFC026D3) : Colors.white,
                onTap: onToggleBookmark,
              ),
              _buildActionButton(
                icon: Icons.playlist_add,
                label: 'Add',
                color: Colors.white,
                onTap: () {}, // Add to playlist
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_formatTime(currentSeconds), style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 12)),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 2,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  ),
                  child: Slider(
                    value: progressPercent.clamp(0.0, 1.0),
                    onChanged: (value) {
                      if (video.durationSeconds > 0) {
                         context.read<PlayerBloc>().add(SeekTo((value * video.durationSeconds).round()));
                      }
                    },
                    activeColor: const Color(0xFFC026D3),
                    inactiveColor: const Color(0xFF242424),
                  ),
                ),
              ),
              Text(video.duration, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 12)),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.fullscreen, color: Colors.white),
                onPressed: () => context.read<PlayerBloc>().add(ToggleFitMode()),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 4.0),
            child: GestureDetector(
              onTap: onRevealComments,
              child: const Text('↑ Related & Comments', style: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins', fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(color: color, fontFamily: 'Poppins', fontSize: 10)),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }
}
