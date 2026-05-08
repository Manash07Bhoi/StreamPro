import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class HelpFaqPage extends StatelessWidget {
  const HelpFaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('Help & FAQ',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategory('Getting Started', [
            _buildFaqItem('How do I bookmark a video?',
                'Tap the bookmark icon on any video card, or use the long-press menu for quick access.'),
            _buildFaqItem('How do I create a playlist?',
                'Go to Library → Playlists tab, then tap the + button to create a new playlist.'),
            _buildFaqItem('What is VPN Simulation?',
                'StreamPro\'s built-in VPN simulation routes your app traffic indicator through a virtual server to enhance privacy awareness.'),
          ]),
          const SizedBox(height: 16),
          _buildCategory('Playback', [
            _buildFaqItem('Why won\'t the video load?',
                'Ensure you have an active internet connection. Try clearing your cache from the Settings menu if the problem persists.'),
            _buildFaqItem('How do I change video quality?',
                'Open the settings menu during playback or go to Settings → Playback Settings to set your default preference.'),
            _buildFaqItem('What do the gesture controls do?',
                'Swipe left side for brightness, right side for volume. Double tap left/right to skip 10s. Pinch to zoom video.'),
          ]),
          const SizedBox(height: 16),
          _buildCategory('Library', [
            _buildFaqItem('How do I download a video?',
                'Long-press any video card and select \'Download\', or tap the download icon in the player.'),
            _buildFaqItem('How do I clear my watch history?',
                'Go to Settings → Clear Watch History. You can also swipe individual entries in Library → History to delete them.'),
          ]),
          const SizedBox(height: 16),
          _buildCategory('Privacy', [
            _buildFaqItem('What data does StreamPro collect?',
                'StreamPro stores all data locally on your device only. We do not collect or transmit any personal information to external servers.'),
            _buildFaqItem('How do I delete my data?',
                'Go to Settings → Clear Watch History, Clear Downloads, and Clear Cache. To reset completely, uninstall the app.'),
          ]),
          const SizedBox(height: 32),
          Center(
            child: TextButton.icon(
              onPressed: () {
                // url_launcher mailto placeholder
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact support action')));
              },
              icon: const Icon(Icons.email_outlined,
                  color: AppColors.colorPrimary),
              label: const Text('Still need help? Contact Us',
                  style: TextStyle(
                      fontFamily: 'Poppins', color: AppColors.colorPrimary)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCategory(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0, bottom: 8.0, top: 8.0),
          child: Text(
            title,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.colorPrimary),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.colorSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.colorSurface3),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Colors.white54,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.colorPrimary,
        ),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(
              fontFamily: 'Poppins', fontSize: 14, color: Colors.white),
        ),
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(
              answer,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.colorTextSecondary,
                  height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
