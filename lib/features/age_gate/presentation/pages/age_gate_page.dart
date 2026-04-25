import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/models/app_config.dart';
import '../../../../core/models/user_profile.dart';
import '../../../../core/routes/app_router.dart';
import 'package:flutter/services.dart';

class AgeGatePage extends StatefulWidget {
  const AgeGatePage({super.key});

  @override
  State<AgeGatePage> createState() => _AgeGatePageState();
}

class _AgeGatePageState extends State<AgeGatePage> {
  int? _selectedYear;

  void _onConfirm() async {
    if (_selectedYear == null) return;

    final currentYear = DateTime.now().year;
    final age = currentYear - _selectedYear!;

    if (age < 13) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Access Restricted'),
          content: const Text('This app requires users to be at least 13 years of age.'),
          actions: [
            TextButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Exit App'),
            ),
          ],
        ),
      );
      return;
    }

    final configBox = Hive.box<AppConfig>('app_config_box');
    AppConfig? config = configBox.isNotEmpty ? configBox.getAt(0) : null;

    if (config != null) {
      if (!config.hasAcceptedTerms || !config.hasAcceptedPrivacy) {
         ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept terms and privacy policy first')));
         return;
      }
      config.hasAcceptedAgeGate = true;
      await config.save();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept terms and privacy policy first')));
      return;
    }

    if (Hive.isBoxOpen('user_profile_box')) {
        final profileBox = Hive.box<UserProfile>('user_profile_box');
        UserProfile? profile = profileBox.isNotEmpty ? profileBox.getAt(0) : null;
        if(profile != null){
           profile.birthYear = _selectedYear.toString();
           profile.isAgeVerified = age >= 18;
           await profile.save();
        }
    }

    if (config.isFirstLaunch == true) {
      if (mounted) context.go(AppRoutes.onboarding);
    } else {
      if (mounted) context.go(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, size: 72),
              const SizedBox(height: 24),
              Text('Age Verification Required', style: Theme.of(context).textTheme.headlineLarge, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              Text('StreamPro contains content that may not be suitable for all audiences. Please confirm your age to continue.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),
              SizedBox(
                height: 80,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 40,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: (index) {
                     setState(() {
                       _selectedYear = DateTime.now().year - 100 + index;
                     });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final year = DateTime.now().year - 100 + index;
                      return Center(child: Text(year.toString(), style: Theme.of(context).textTheme.titleLarge));
                    },
                    childCount: 101,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _selectedYear != null ? _onConfirm : null,
                child: const Text('Confirm My Age'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                   showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Access Restricted'),
                      content: const Text('This app requires users to be at least 13 years of age.'),
                      actions: [
                        TextButton(
                          onPressed: () => SystemNavigator.pop(),
                          child: const Text('Exit App'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('I am under 13'),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.push(AppRoutes.terms),
                    child: const Text('Terms of Service'),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.privacy),
                    child: const Text('Privacy Policy'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
