import 'package:flutter/material.dart';
import '../../../../core/mixins/safe_pop_mixin.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> with SafePopMixin {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        safePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: safePop,
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'General',
              style: TextStyle(
                  color: Color(0xFFC026D3),
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(height: 10),
            ListTile(
              leading: const Icon(Icons.palette),
              title: const Text('Theme'),
              trailing:
                  const Text('Dark', style: TextStyle(color: Colors.grey)),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Clear Watch History'),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Watch History Cleared')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About StreamPro'),
              subtitle: const Text('v1.0.0'),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
