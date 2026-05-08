import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/di/injection.dart';
import '../blocs/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProfileBloc>()..add(LoadProfile()),
      child: const _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('My Profile',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500)),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.push('/profile/edit'),
          ),
        ],
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading || state is ProfileInitial) {
            return const Center(
                child:
                    CircularProgressIndicator(color: AppColors.colorPrimary));
          } else if (state is ProfileLoaded ||
              state is ProfileSaving ||
              state is ProfileSaved) {
            final profile = (state is ProfileLoaded)
                ? state.profile
                : (state is ProfileSaving
                    ? state.profile
                    : (state as ProfileSaved).profile);

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        // Avatar
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              AppColors.colorPrimary,
                              AppColors.colorSecondary
                            ]),
                          ),
                          child: profile.avatarUrl != null &&
                                  profile.avatarUrl!.isNotEmpty
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: profile.avatarUrl!,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        const CircularProgressIndicator(
                                            color: Colors.white),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.person,
                                            color: Colors.white, size: 40),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    profile.displayName.isNotEmpty
                                        ? profile.displayName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                        ),
                        const SizedBox(height: 16),

                        // Name
                        Text(
                          profile.displayName,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        const SizedBox(height: 8),

                        // Badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.colorPrimary),
                          ),
                          child: const Text('Free Member',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: AppColors.colorPrimary)),
                        ),
                        const SizedBox(height: 32),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard('Videos Watched',
                                profile.totalWatchedVideos.toString()),
                            _buildStatCard(
                                'Watch Time',
                                _formatWatchTime(
                                    profile.totalWatchTimeSeconds)),
                            _buildStatCard(
                                'Liked Videos', profile.totalLikes.toString()),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // My Interests
                        if (profile.interests.isNotEmpty) ...[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('My Interests',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                              TextButton(
                                onPressed: () => context.push('/profile/edit'),
                                child: const Text('Edit',
                                    style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: AppColors.colorPrimary)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 40,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: profile.interests.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                return Chip(
                                  label: Text(profile.interests[index],
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 12,
                                          color: Colors.white)),
                                  backgroundColor: AppColors.colorSurface3,
                                  side: BorderSide.none,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                ),

                // Quick Links
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Text('Quick Links',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      _buildListTile(context, Icons.playlist_play,
                          'My Playlists', () => context.push('/playlists')),
                      _buildListTile(context, Icons.download, 'My Downloads',
                          () => context.push('/downloads')),
                      _buildListTile(context, Icons.favorite, 'Liked Videos',
                          () => context.push('/liked')),
                      _buildListTile(context, Icons.history, 'Watch History',
                          () {
                        // Switch to library tab, conceptually handled by parent or by pushing a new route
                        context.go('/home'); // Or specific tab handling
                      }),
                      const SizedBox(height: 24),
                      const Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 8.0),
                        child: Text('Account',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                      ),
                      _buildListTile(context, Icons.settings, 'Settings',
                          () => context.push('/settings')),
                      _buildListTile(context, Icons.help_outline, 'Help & FAQ',
                          () => context.push('/help')),
                      _buildListTile(context, Icons.info_outline,
                          'About StreamPro', () => context.push('/about')),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            );
          } else if (state is ProfileError) {
            return Center(
                child: Text(state.message,
                    style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        const SizedBox(height: 4),
        Text(label,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: AppColors.colorTextSecondary)),
      ],
    );
  }

  Widget _buildListTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.colorSurface3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(title,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
      trailing: const Icon(Icons.chevron_right,
          color: AppColors.colorTextMuted, size: 20),
      onTap: onTap,
    );
  }

  String _formatWatchTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}
