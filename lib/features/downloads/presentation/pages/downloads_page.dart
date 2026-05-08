import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../../core/di/injection.dart';
import '../../../library/presentation/blocs/download_bloc.dart';
import '../../../../core/models/download_record.dart';

class DownloadsPage extends StatelessWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DownloadBloc>()..add(LoadDownloads()),
      child: const _DownloadsPageContent(),
    );
  }
}

class _DownloadsPageContent extends StatelessWidget {
  const _DownloadsPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('My Downloads',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
      body: BlocBuilder<DownloadBloc, DownloadState>(
        builder: (context, state) {
          if (state is DownloadLoading || state is DownloadInitial) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.colorPrimary));
          } else if (state is DownloadLoaded) {
            return Column(
              children: [
                _buildStorageSummaryCard(state.totalStorageBytes),
                Expanded(
                  child: state.downloads.isEmpty
                      ? _buildEmptyState()
                      : ListView.separated(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: state.downloads.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            return _buildDownloadItem(
                                context, state.downloads[index]);
                          },
                        ),
                ),
              ],
            );
          } else if (state is DownloadError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/home'),
        backgroundColor: AppColors.colorPrimary,
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text('Download New Videos',
            style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
      ),
    );
  }

  Widget _buildStorageSummaryCard(int totalStorageBytes) {
    // Simulated max 10 GB
    const double maxStorageGB = 10.0;
    final double usedStorageGB = totalStorageBytes / (1024 * 1024 * 1024);
    final double progress = (usedStorageGB / maxStorageGB).clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.colorSurface2,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Device Storage',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white)),
              Text('${usedStorageGB.toStringAsFixed(1)} GB of 10 GB used',
                  style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: AppColors.colorTextSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.colorSurface3,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.colorPrimary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_for_offline,
              size: 80, color: AppColors.colorSurface3),
          SizedBox(height: 16),
          Text('No Downloads',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white)),
          SizedBox(height: 8),
          Text('Download videos to watch them offline.',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 14,
                  color: AppColors.colorTextSecondary)),
        ],
      ),
    );
  }

  Widget _buildDownloadItem(BuildContext context, DownloadRecord record) {
    Color badgeColor;
    String badgeText;

    switch (record.status) {
      case 'completed':
        badgeColor = AppColors.colorSuccess;
        badgeText = 'Completed';
        break;
      case 'downloading':
        badgeColor = AppColors.colorWarning;
        badgeText =
            '${(record.progressPercent * 100).toStringAsFixed(0)}% Downloading';
        break;
      case 'failed':
        badgeColor = AppColors.colorError;
        badgeText = 'Failed';
        break;
      case 'paused':
      default:
        badgeColor = AppColors.colorTextMuted;
        badgeText = 'Queued';
        break;
    }

    final double fileMB = record.fileSizeBytes / (1024 * 1024);

    // Calculate expiry days
    final expires = DateTime.parse(record.expiresAt);
    final daysLeft = expires.difference(DateTime.now()).inDays;

    return Slidable(
      key: Key(record.id),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              context.read<DownloadBloc>().add(DeleteDownload(record.id));
            },
            backgroundColor: AppColors.colorError,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.colorSurface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
              child: SizedBox(
                width: 140,
                height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl:
                          'https://picsum.photos/seed/${record.videoId}/640/360', // Mocking thumbnail based on id
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const ColoredBox(color: AppColors.colorSurface3),
                    ),
                    if (record.status == 'downloading')
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: LinearProgressIndicator(
                          value: record.progressPercent,
                          backgroundColor: Colors.black54,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.colorWarning),
                          minHeight: 4,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video Title for ${record.videoId}', // In a real app we'd fetch the title from video_box
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: badgeColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            badgeText,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 10,
                                color: badgeColor,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${record.quality} • ${fileMB.toStringAsFixed(0)} MB',
                      style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.colorTextSecondary),
                    ),
                    if (record.status == 'completed') ...[
                      const SizedBox(height: 2),
                      Text(
                        'Expires in $daysLeft days',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 10,
                            color: AppColors.colorWarning),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
