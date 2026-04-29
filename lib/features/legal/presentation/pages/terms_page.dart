import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/settings/data/repositories/app_config_repository.dart';
import 'package:go_router/go_router.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Hide bottom action bar if already accepted
    final configRepo = sl<AppConfigRepository>();
    final config = configRepo.getConfig();
    final bool showAcceptButton = !config.hasAcceptedTerms;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: const Text('Terms of Service', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w500)),
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
            _buildSection('Acceptance of Terms', 'By accessing or using StreamPro, you agree to be bound by these Terms of Service. If you disagree with any part of the terms, you may not access the service.'),
            _buildSection('Use of the Service', 'StreamPro provides a simulated free streaming experience. Content is gathered for demonstration purposes.'),
            _buildSection('Intellectual Property', 'All content, features, and functionality are owned by StreamPro or its licensors and are protected by international copyright laws.'),
            _buildSection('User Conduct', 'You agree not to use the app in any way that violates any applicable local, national, or international law or regulation.'),
            _buildSection('Disclaimers', 'The service is provided on an "AS IS" and "AS AVAILABLE" basis. StreamPro makes no representations or warranties of any kind.'),
            _buildSection('Limitation of Liability', 'In no event shall StreamPro be liable for any indirect, incidental, special, consequential, or punitive damages.'),
            _buildSection('Changes to Terms', 'We reserve the right to modify or replace these Terms at any time. We will provide notice of any significant changes.'),
            _buildSection('Contact Information', 'If you have any questions about these Terms, please contact us.'),
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
                configRepo.updateField('hasAcceptedTerms', true);
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
