import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/settings/data/repositories/app_config_repository.dart';
import '../../../../features/profile/data/repositories/profile_repository.dart';
import '../../../../core/routes/app_routes.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _selectedInterests = [];

  final List<String> _allInterests = [
    'Action', 'Comedy', 'Drama', 'Documentary', 'Music', 'Sports',
    'Technology', 'Travel', 'Animation', 'Horror', 'Romance',
    'Thriller', 'Science', 'Gaming', 'Cooking'
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    } else {
      _finishOnboarding();
    }
  }

  void _finishOnboarding() async {
    final configRepo = sl<AppConfigRepository>();
    final profileRepo = sl<ProfileRepository>();

    configRepo.updateField('isFirstLaunch', false);

    final profile = profileRepo.getOrCreateProfile();
    profile.interests.addAll(_selectedInterests);
    await profileRepo.updateProfile(profile);

    if (mounted) {
      context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_currentPage < 2)
                  TextButton(
                    onPressed: _finishOnboarding,
                    child: const Text('Skip', style: TextStyle(color: Color(0xFF9CA3AF), fontFamily: 'Poppins')),
                  )
                else
                  const SizedBox(height: 48), // Spacer to match button height
              ],
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildPage1(),
                  _buildPage2(),
                  _buildPage3(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(3, (index) => _buildDot(index)),
                  ),
                  _buildActionButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? const Color(0xFFC026D3) : const Color(0xFF242424),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActionButton() {
    bool isEnabled = _currentPage < 2 || _selectedInterests.length >= 3;

    return GestureDetector(
      onTap: isEnabled ? _onNext : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: isEnabled
              ? const LinearGradient(colors: [Color(0xFFC026D3), Color(0xFFDB2777)])
              : const LinearGradient(colors: [Color(0xFF242424), Color(0xFF242424)]),
        ),
        child: Text(
          _currentPage == 2 ? 'Get Started' : 'Next',
          style: TextStyle(
            color: isEnabled ? Colors.white : const Color(0xFF6B7280),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.play_circle_fill, size: 80, color: Color(0xFFC026D3)), // Placeholder for Lottie
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Stream Anything, Anytime',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Discover thousands of premium videos across every genre — completely free.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 240,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.video_library, size: 80, color: Color(0xFFC026D3)), // Placeholder for Lottie
            ),
          ),
          const SizedBox(height: 48),
          const Text(
            'Your Personal Library',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          const Text(
            'Bookmark favorites, create playlists, and pick up right where you left off.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'What Do You Love?',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Select at least 3 to personalize your feed.',
            style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: _allInterests.map((interest) {
              final isSelected = _selectedInterests.contains(interest);
              return FilterChip(
                label: Text(interest),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest);
                    } else {
                      _selectedInterests.remove(interest);
                    }
                  });
                },
                backgroundColor: const Color(0xFF242424),
                selectedColor: Colors.transparent, // Background will be gradient border simulation later
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF9CA3AF),
                  fontFamily: 'Poppins',
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected ? const Color(0xFFC026D3) : Colors.transparent,
                    width: 1.5,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
