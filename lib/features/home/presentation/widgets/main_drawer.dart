import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_router.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text('Guest User'),
            accountEmail: const Text('Free Member'),
            currentAccountPicture: const CircleAvatar(
              child: Icon(Icons.person),
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor, Colors.pink],
              )
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home_rounded),
                  title: const Text('Home'),
                  onTap: () {
                    context.pop();
                    context.go(AppRoutes.home);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('My Profile'),
                  onTap: () {
                     context.pop();
                     context.push(AppRoutes.profile);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.playlist_play),
                  title: const Text('My Playlists'),
                  onTap: () {
                     context.pop();
                     context.push(AppRoutes.playlists);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.download_rounded),
                  title: const Text('Downloads'),
                  onTap: () {
                     context.pop();
                     context.push(AppRoutes.downloads);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Liked Videos'),
                  onTap: () {
                     context.pop();
                     context.push(AppRoutes.liked);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.vpn_key_outlined),
                  title: const Text('VPN Status'),
                  onTap: () {
                     context.pop();
                     context.push(AppRoutes.vpn);
                  },
                ),
                const Divider(),
                ListTile(
                   leading: const Icon(Icons.settings),
                   title: const Text('Settings'),
                   onTap: () {
                     context.pop();
                     context.push(AppRoutes.settings);
                   },
                ),
                ListTile(
                   leading: const Icon(Icons.help_outline),
                   title: const Text('Help & FAQ'),
                   onTap: () {
                      context.pop();
                      context.push(AppRoutes.help);
                   },
                ),
                ListTile(
                   leading: const Icon(Icons.info_outline),
                   title: const Text('About'),
                   onTap: () {
                      context.pop();
                      context.push(AppRoutes.about);
                   },
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () => context.push(AppRoutes.privacy),
                  child: Text('Privacy', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () => context.push(AppRoutes.terms),
                  child: Text('Terms', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
                ),
              ],
            ),
          ),
          Text('v1.0.0', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.grey)),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
