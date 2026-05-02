import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/comment.dart';
import '../../../../core/models/video_entity.dart';
import '../blocs/comment_bloc.dart';
import 'package:intl/intl.dart';

class CommentsBottomSheet extends StatefulWidget {
  final VideoEntity video;

  const CommentsBottomSheet({super.key, required this.video});

  @override
  State<CommentsBottomSheet> createState() => _CommentsBottomSheetState();
}

class _CommentsBottomSheetState extends State<CommentsBottomSheet> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CommentBloc>()..add(LoadComments(widget.video.id)),
      child: DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.15,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: AppColors.colorSurface,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                // Drag handle
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 12),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.colorSurface3,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),

                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Comments',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.colorTextSecondary),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppColors.colorSurface3, height: 1),

                // Comments List
                Expanded(
                  child: BlocBuilder<CommentBloc, CommentState>(
                    builder: (context, state) {
                      if (state is CommentLoading || state is CommentInitial) {
                        return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
                      } else if (state is CommentLoaded || state is CommentPosting) {
                        final comments = state is CommentLoaded ? state.comments : (state as CommentPosting).currentComments;

                        if (comments.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat_bubble_outline, size: 64, color: AppColors.colorSurface3),
                                const SizedBox(height: 16),
                                const Text('No Comments Yet', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 8),
                                const Text('Be the first to comment on this video.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          padding: const EdgeInsets.all(16),
                          itemCount: comments.length,
                          itemBuilder: (context, index) {
                            return _buildCommentCard(context, comments[index]);
                          },
                        );
                      } else if (state is CommentError) {
                        return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                // Add Comment Input
                BlocBuilder<CommentBloc, CommentState>(
                  builder: (context, state) {
                    return Container(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        top: 12,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.colorSurface2,
                        border: Border(top: BorderSide(color: AppColors.colorSurface3)),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            radius: 16,
                            backgroundColor: AppColors.colorSurface3,
                            child: Icon(Icons.person, size: 20, color: Colors.white54),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _commentController,
                              style: const TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14),
                              maxLength: 500,
                              buildCounter: (context, {required currentLength, required isFocused, maxLength}) => null,
                              decoration: InputDecoration(
                                hintText: 'Add a comment...',
                                hintStyle: const TextStyle(color: AppColors.colorTextMuted, fontFamily: 'Poppins', fontSize: 14),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppColors.colorSurface3,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (state is CommentPosting)
                            const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: AppColors.colorPrimary, strokeWidth: 2),
                            )
                          else
                            IconButton(
                              icon: const Icon(Icons.send, color: AppColors.colorPrimary),
                              onPressed: () {
                                if (_commentController.text.trim().isNotEmpty) {
                                  context.read<CommentBloc>().add(PostComment(widget.video.id, _commentController.text));
                                  _commentController.clear();
                                }
                              },
                            ),
                        ],
                      ),
                    );
                  }
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCommentCard(BuildContext context, Comment comment) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppColors.colorSurface3,
            backgroundImage: comment.authorAvatar.isNotEmpty ? CachedNetworkImageProvider(comment.authorAvatar) : null,
            child: comment.authorAvatar.isEmpty ? const Icon(Icons.person, color: Colors.white54) : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    if (comment.isUserComment) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.colorSurface3,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('You', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white)),
                      ),
                    ],
                    const SizedBox(width: 8),
                    Text(
                      _formatTimeAgo(comment.postedAt),
                      style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextMuted),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onLongPress: () {
                    if (comment.isUserComment) {
                      _showDeleteDialog(context, comment);
                    }
                  },
                  child: Text(
                    comment.text,
                    style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextPrimary),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<CommentBloc>().add(LikeComment(comment.id));
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.thumb_up_alt_outlined, size: 14, color: AppColors.colorTextSecondary),
                          const SizedBox(width: 4),
                          Text(comment.likeCount.toString(), style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextSecondary)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Text('Reply', style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext blocContext, Comment comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.colorSurface2,
        title: const Text('Delete Comment', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
        content: const Text('Are you sure you want to delete this comment?', style: TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins')),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              blocContext.read<CommentBloc>().add(DeleteComment(comment.id));
            },
            child: const Text('Delete', style: TextStyle(color: AppColors.colorError, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  String _formatTimeAgo(String isoTime) {
    final date = DateTime.parse(isoTime);
    final difference = DateTime.now().difference(date);

    if (difference.inDays > 7) {
      return DateFormat('MMM d, yyyy').format(date);
    } else if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}
