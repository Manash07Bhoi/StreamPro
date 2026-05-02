import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('About StreamPro', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]),
              ),
              child: const Center(
                child: Icon(Icons.play_arrow, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'StreamPro',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text(
              'v1.0.0 (Build 1)',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium. Free. Unlimited.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: AppColors.colorPrimary),
            ),
            const SizedBox(height: 48),

            Container(
              decoration: BoxDecoration(
                color: AppColors.colorSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionRow(Icons.description_outlined, 'Open Source Licenses'),
                  const Divider(color: AppColors.colorSurface3, height: 1),
                  _buildActionRow(Icons.star_rate_outlined, 'Rate the App'),
                  const Divider(color: AppColors.colorSurface3, height: 1),
                  _buildActionRow(Icons.share_outlined, 'Share the App'),
                  const Divider(color: AppColors.colorSurface3, height: 1),
                  _buildActionRow(Icons.public, 'Follow Us'),
                ],
              ),
            ),

            const SizedBox(height: 48),
            const Text(
              'Made with ♥ using Flutter',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: AppColors.colorTextMuted),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: AppColors.colorTextSecondary),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: AppColors.colorTextMuted),
      onTap: () {
        // Handle action
      },
    );
  }
}
