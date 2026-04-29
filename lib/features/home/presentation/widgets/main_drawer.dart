import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../vpn/presentation/blocs/vpn_bloc.dart';
import '../../../profile/presentation/blocs/profile_bloc.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: Column(
        children: [
          BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              String displayName = 'StreamPro Guest';
              if (state is ProfileLoaded) {
                displayName = state.profile.displayName;
              } else if (state is ProfileSaving) {
                displayName = state.profile.displayName;
              } else if (state is ProfileSaved) {
                displayName = state.profile.displayName;
              }

              return Container(
                padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white24,
                      child: Icon(Icons.person, size: 36, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Free Member',
                            style: TextStyle(color: Colors.white70, fontSize: 10, fontFamily: 'Poppins'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  icon: Icons.home_rounded,
                  title: 'Home',
                  onTap: () {
                    Navigator.pop(context);
                    context.go(AppRoutes.home);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/profile');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.playlist_play,
                  title: 'My Playlists',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/playlists');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.download_outlined,
                  title: 'Downloads',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/downloads');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.favorite_border,
                  title: 'Liked Videos',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/liked');
                  },
                ),
                _buildVpnDrawerItem(context),
                _buildDrawerItem(
                  icon: Icons.settings_outlined,
                  title: 'Settings',
                  onTap: () {
                    Navigator.pop(context);
                    context.push(AppRoutes.settings);
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.help_outline,
                  title: 'Help & FAQ',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/help');
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.info_outline,
                  title: 'About',
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/about');
                  },
                ),
              ],
            ),
          ),
          const Divider(color: Color(0xFF242424), height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/privacy');
                      },
                      child: const Text('Privacy Policy', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontFamily: 'Poppins', decoration: TextDecoration.underline)),
                    ),
                    const Text('  •  ', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.push('/terms');
                      },
                      child: const Text('Terms of Service', style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 12, fontFamily: 'Poppins', decoration: TextDecoration.underline)),
                    ),
                  ],
                ),
                const Text('v1.0.0', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontFamily: 'Poppins')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    // Basic active state simulation could be added here by passing current route
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9CA3AF)),
      title: Text(title, style: const TextStyle(color: Colors.white, fontFamily: 'Poppins', fontSize: 14)),
      onTap: onTap,
    );
  }

  Widget _buildVpnDrawerItem(BuildContext context) {
    return BlocBuilder<VpnBloc, VpnState>(
      builder: (context, state) {
        bool isConnected = state is VpnConnected;
        return ListTile(
          leading: Icon(
            Icons.security,
            color: isConnected ? Colors.green : Colors.red,
          ),
          title:
              const Text('VPN Status', style: TextStyle(color: Colors.white)),
          subtitle: Text(
            isConnected ? 'Connected (${state.country})' : 'Disconnected',
            style: TextStyle(color: isConnected ? Colors.green : Colors.red),
          ),
          onTap: () {
            Navigator.pop(context); // close drawer
            context.push(AppRoutes.vpn);
          },
        );
      },
    );
  }
}
