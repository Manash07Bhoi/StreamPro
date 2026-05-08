import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../blocs/profile_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  final List<String> _selectedInterests = [];

  final List<String> _allInterests = [
    'Action',
    'Comedy',
    'Drama',
    'Documentary',
    'Music',
    'Sports',
    'Technology',
    'Travel',
    'Animation',
    'Horror',
    'Romance',
    'Thriller',
    'Science',
    'Gaming',
    'Cooking'
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    // In a real implementation, we would extract the current state from the BLoC to populate these fields.
    // Assuming the bloc is already loaded since we navigated from ProfilePage.
    final profileBloc = sl<ProfileBloc>();
    if (profileBloc.state is ProfileLoaded) {
      final profile = (profileBloc.state as ProfileLoaded).profile;
      _nameController.text = profile.displayName;
      _selectedInterests.addAll(profile.interests);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Display name cannot be empty')));
      return;
    }

    final profileBloc = sl<ProfileBloc>();
    profileBloc.add(UpdateDisplayName(_nameController.text.trim()));
    profileBloc.add(UpdateInterests(List.from(_selectedInterests)));

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('Edit Profile',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w500)),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Save',
                style: TextStyle(
                    color: AppColors.colorPrimary,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  final picker = ImagePicker();
                  final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                  if (pickedFile != null) {
                    if (!context.mounted) return;
                    // Update BLoC
                    context.read<ProfileBloc>().add(UpdateAvatar(pickedFile.path));
                  }
                },
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.colorSurface3,
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: AppColors.colorPrimary, width: 2),
                      ),
                      child: const Center(
                        child: Icon(Icons.person,
                            size: 50, color: AppColors.colorTextMuted),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: AppColors.colorPrimary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt,
                            size: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Display Name',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.colorTextSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style:
                  const TextStyle(fontFamily: 'Poppins', color: Colors.white),
              maxLength: 30,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.colorSurface2,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.colorPrimary),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Interests',
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: AppColors.colorTextSecondary)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 12.0,
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
                  backgroundColor: AppColors.colorSurface2,
                  selectedColor: AppColors.colorPrimary.withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.colorTextSecondary,
                    fontFamily: 'Poppins',
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.colorPrimary
                          : Colors.transparent,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
