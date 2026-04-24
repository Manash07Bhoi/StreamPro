import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../vpn/presentation/blocs/vpn_bloc.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppTheme.backgroundColor,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 60, bottom: 20, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.person, size: 36, color: Colors.white),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'StreamPro Guest',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Free Member',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildDrawerItem(
            icon: Icons.category,
            title: 'Categories',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.category,
                  arguments: 'Action');
            },
          ),
          _buildVpnDrawerItem(context),
          _buildDrawerItem(
            icon: Icons.settings,
            title: 'Settings',
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, AppRoutes.settings);
            },
          ),
          _buildDrawerItem(
            icon: Icons.info_outline,
            title: 'About',
            onTap: () {},
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'v1.0.0',
              style: TextStyle(color: Colors.grey),
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
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
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
            Navigator.pushNamed(context, AppRoutes.vpn);
          },
        );
      },
    );
  }
}
