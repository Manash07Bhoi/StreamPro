import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/models/video_entity.dart';
import 'package:share_plus/share_plus.dart';
import '../../features/library/presentation/blocs/download_bloc.dart';
import '../../core/di/injection.dart';

class LongPressContextMenu extends StatelessWidget {
  final VideoEntity video;
  const LongPressContextMenu({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: AppColors.colorSurface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.share, color: Colors.white),
            title: const Text('Share', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              SharePlus.instance.share(ShareParams(
                text: 'Check out StreamPro — Premium free video streaming!\n\nhttps://streampro.app/watch/${video.id}',
              ));
            },
          ),
          ListTile(
            leading: const Icon(Icons.download, color: Colors.white),
            title: const Text('Download', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              sl<DownloadBloc>().add(StartDownload(video, '1080p'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Download started')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.not_interested, color: Colors.white),
            title: const Text('Not Interested', style: TextStyle(color: Colors.white)),
            onTap: () {
              Navigator.pop(context);
              // Not Interested feature will be handled later
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Marked as not interested')),
              );
            },
          ),
        ],
      ),
    );
  }
}
