import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../../../features/settings/data/repositories/app_config_repository.dart';
import '../../../../features/profile/data/repositories/profile_repository.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/models/user_profile.dart';

class AgeGatePage extends StatefulWidget {
  const AgeGatePage({super.key});

  @override
  State<AgeGatePage> createState() => _AgeGatePageState();
}

class _AgeGatePageState extends State<AgeGatePage> {
  final int currentYear = DateTime.now().year;
  late int selectedYear;
  late List<int> years;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    selectedYear = currentYear - 25; // Default selection to 25 years ago
    years = List.generate(101, (index) => currentYear - index);
    _scrollController = ScrollController(initialScrollOffset: 25 * 80.0); // Rough initial offset
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onConfirm() {
    final age = currentYear - selectedYear;
    if (age < 13) {
      _showUnder13Dialog();
      return;
    }

    final configRepo = sl<AppConfigRepository>();
    final profileRepo = sl<ProfileRepository>();

    configRepo.updateField('hasAcceptedAgeGate', true);

    final profile = profileRepo.getOrCreateProfile();
    final updatedProfile = UserProfile(
      id: profile.id,
      displayName: profile.displayName,
      avatarUrl: profile.avatarUrl,
      customAvatarPath: profile.customAvatarPath,
      createdAt: profile.createdAt,
      membershipType: profile.membershipType,
      totalLikes: profile.totalLikes,
      totalWatchedVideos: profile.totalWatchedVideos,
      totalWatchTimeSeconds: profile.totalWatchTimeSeconds,
      favoriteCategory: profile.favoriteCategory,
      interests: profile.interests,
      birthYear: selectedYear.toString(),
      isAgeVerified: age >= 18,
    );
    profileRepo.updateProfile(updatedProfile);

    // Navigation logic handled after checking terms
    final config = configRepo.getConfig();
    if (!config.hasAcceptedTerms || !config.hasAcceptedPrivacy) {
        // Can't proceed yet
    } else {
      if (config.isFirstLaunch) {
        context.go('/onboarding');
      } else {
        context.go(AppRoutes.home);
      }
    }
  }

  void _showUnder13Dialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.colorSurface2,
        title: const Text('Access Restricted', style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
        content: const Text('This app requires users to be at least 13 years of age.', style: TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins')),
        actions: [
          TextButton(
            onPressed: () {
              SystemNavigator.pop();
            },
            child: const Text('Exit App', style: TextStyle(color: AppColors.colorPrimary, fontFamily: 'Poppins', fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.colorBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(192, 38, 211, 0.35),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                    ),
                    ShaderMask(
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [AppColors.colorPrimary, AppColors.colorSecondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ).createShader(bounds),
                      child: const Icon(
                        Icons.shield_outlined,
                        size: 72,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Age Verification Required',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'StreamPro contains content that may not be suitable for all audiences. Please confirm your age to continue.',
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.colorTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                const Divider(color: Color.fromRGBO(255, 255, 255, 0.08)),
                const SizedBox(height: 32),
                SizedBox(
                  height: 80,
                  child: ListWheelScrollView.useDelegate(
                    controller: _scrollController,
                    itemExtent: 40,
                    physics: const FixedExtentScrollPhysics(),
                    onSelectedItemChanged: (index) {
                      setState(() {
                        selectedYear = years[index];
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final isSelected = years[index] == selectedYear;
                        return Center(
                          child: Text(
                            years[index].toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: isSelected ? 24 : 18,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                              color: isSelected ? Colors.white : AppColors.colorTextMuted,
                            ),
                          ),
                        );
                      },
                      childCount: years.length,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'You are ${currentYear - selectedYear} years old',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.colorTextSecondary,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  width: double.infinity,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppColors.colorPrimary, AppColors.colorSecondary],
                    ),
                  ),
                  child: ElevatedButton(
                    onPressed: _onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Confirm My Age',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _showUnder13Dialog,
                  child: const Text(
                    'I am under 13',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColors.colorTextMuted,
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        'By continuing, you agree to our ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.colorTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Push Terms while keeping Age Gate in stack
                          context.push('/terms');
                        },
                        child: const Text(
                          'Terms of Service',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.colorPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      const Text(
                        ' and ',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          color: AppColors.colorTextSecondary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.push('/privacy');
                        },
                        child: const Text(
                          'Privacy Policy',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: AppColors.colorPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
