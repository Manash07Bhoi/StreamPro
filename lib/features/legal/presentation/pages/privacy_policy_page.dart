import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/settings/data/repositories/app_config_repository.dart';
import 'package:go_router/go_router.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide bottom action bar if already accepted
    final configRepo = sl<AppConfigRepository>();
    final config = configRepo.getConfig();
    final bool showAcceptButton = !config.hasAcceptedPrivacy;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Privacy Policy', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500)),
        leading: showAcceptButton ? const SizedBox.shrink() : BackButton(onPressed: () => context.pop()),
        automaticallyImplyLeading: !showAcceptButton,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last Updated: January 1, 2026', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Color(0xFF6B7280))),
            const SizedBox(height: 24),
            _buildSection('Introduction', 'This Privacy Policy explains how StreamPro collects, uses, and discloses information about you.'),
            _buildSection('Information We Collect', 'We collect information you provide directly to us, such as when you create an account, update your profile, or interact with the app.'),
            _buildSection('How We Use Information', 'We use the information we collect to provide, maintain, and improve our services, and to personalize your experience.'),
            _buildSection('Local Storage Disclosure', 'StreamPro stores all your data, including watch history, bookmarks, and preferences, locally on your device. We do not transmit this data to external servers.'),
            _buildSection('Third-Party Services', 'The app uses WebView to embed third-party video content. These services may collect information according to their own privacy policies.'),
            _buildSection('Your Rights', 'Because your data is stored locally, you have full control over it. You can clear your data at any time from the app settings.'),
            _buildSection('Children\'s Privacy', 'Our Service is not directed to anyone under the age of 13. We do not knowingly collect personal identifiable information from children under 13.'),
            _buildSection('Contact Us', 'If you have any questions about this Privacy Policy, please contact us.'),
            if (showAcceptButton) const SizedBox(height: 100), // padding for bottom bar
          ],
        ),
      ),
      bottomSheet: showAcceptButton ? Container(
        color: const Color(0xFF121212),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color.fromRGBO(255, 255, 255, 0.08))),
        ),
        child: SafeArea(
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(colors: [Color(0xFFC026D3), Color(0xFFDB2777)]),
            ),
            child: ElevatedButton(
              onPressed: () {
                configRepo.updateField('hasAcceptedPrivacy', true);
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('I Accept', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ),
          ),
        ),
      ) : null,
    );
  }

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white)),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF), height: 1.6)),
        ],
      ),
    );
  }
}
