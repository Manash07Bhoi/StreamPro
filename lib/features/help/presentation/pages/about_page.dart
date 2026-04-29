import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
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
                gradient: LinearGradient(colors: [Color(0xFFC026D3), Color(0xFFDB2777)]),
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
              style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Premium. Free. Unlimited.',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Color(0xFFC026D3)),
            ),
            const SizedBox(height: 48),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF121212),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionRow(Icons.description_outlined, 'Open Source Licenses'),
                  const Divider(color: Color(0xFF242424), height: 1),
                  _buildActionRow(Icons.star_rate_outlined, 'Rate the App'),
                  const Divider(color: Color(0xFF242424), height: 1),
                  _buildActionRow(Icons.share_outlined, 'Share the App'),
                  const Divider(color: Color(0xFF242424), height: 1),
                  _buildActionRow(Icons.public, 'Follow Us'),
                ],
              ),
            ),

            const SizedBox(height: 48),
            const Text(
              'Made with ♥ using Flutter',
              style: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionRow(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF9CA3AF)),
      title: Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFF6B7280)),
      onTap: () {
        // Handle action
      },
    );
  }
}
