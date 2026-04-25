import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_config.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/routes/app_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<String> _selectedInterests = [];

  final List<Map<String, String>> _interests = [
    {'emoji': '💥', 'name': 'Action'},
    {'emoji': '😂', 'name': 'Comedy'},
    {'emoji': '🎭', 'name': 'Drama'},
    {'emoji': '📽️', 'name': 'Documentary'},
    {'emoji': '🎵', 'name': 'Music'},
    {'emoji': '🏀', 'name': 'Sports'},
    {'emoji': '💻', 'name': 'Technology'},
    {'emoji': '✈️', 'name': 'Travel'},
    {'emoji': '🎨', 'name': 'Animation'},
    {'emoji': '👻', 'name': 'Horror'},
    {'emoji': '❤️', 'name': 'Romance'},
    {'emoji': '🔪', 'name': 'Thriller'},
    {'emoji': '🔬', 'name': 'Science'},
    {'emoji': '🎮', 'name': 'Gaming'},
    {'emoji': '🍳', 'name': 'Cooking'},
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finishOnboarding() async {
    final configBox = Hive.box<AppConfig>('app_config_box');
    AppConfig? config = configBox.isNotEmpty ? configBox.getAt(0) : null;
    if (config != null) {
      config.isFirstLaunch = false;
      await config.save();
    } else {
      config = AppConfig()..isFirstLaunch = false;
      await configBox.put(0, config);
    }

    final profileBox = Hive.box<UserProfile>('user_profile_box');
    UserProfile? profile = profileBox.isNotEmpty ? profileBox.getAt(0) : null;
    if (profile != null) {
      profile.interests = _selectedInterests;
      await profile.save();
    }

    if (mounted) context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
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
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildPage1() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.play_circle_fill, size: 120, color: Colors.purple),
          const SizedBox(height: 32),
          Text('Stream Anything, Anytime', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Discover thousands of premium videos across every genre — completely free.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage2() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.library_books, size: 120, color: Colors.pink),
          const SizedBox(height: 32),
          Text('Your Personal Library', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            'Bookmark favorites, create playlists, and pick up right where you left off.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPage3() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('What Do You Love?', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text('Select at least 3 to personalize your feed.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _interests.map((interest) {
              final isSelected = _selectedInterests.contains(interest['name']);
              return FilterChip(
                label: Text('${interest['emoji']} ${interest['name']}'),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedInterests.add(interest['name']!);
                    } else {
                      _selectedInterests.remove(interest['name']);
                    }
                  });
                },
                selectedColor: Colors.purple.withOpacity(0.3),
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? Colors.purple : Colors.grey.shade800,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: List.generate(3, (index) => _buildDot(index)),
          ),
          if (_currentPage < 2)
             Row(
               children: [
                 TextButton(
                    onPressed: () {
                      _pageController.animateToPage(2, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                    },
                    child: const Text('Skip', style: TextStyle(color: Colors.grey)),
                 ),
                 ElevatedButton(
                    onPressed: _nextPage,
                    child: const Text('Next'),
                 ),
               ],
             )
          else
            ElevatedButton(
              onPressed: _selectedInterests.length >= 3 ? _finishOnboarding : null,
              style: ElevatedButton.styleFrom(
                 backgroundColor: _selectedInterests.length >= 3 ? Colors.purple : Colors.grey,
              ),
              child: const Text('Get Started'),
            ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.purple : Colors.grey.shade800,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
