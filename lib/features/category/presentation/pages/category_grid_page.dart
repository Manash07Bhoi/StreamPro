import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryGridPage extends StatelessWidget {
  const CategoryGridPage({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Action', 'icon': Icons.flash_on, 'color1': AppColors.colorError, 'color2': AppColors.colorError},
    {'name': 'Comedy', 'icon': Icons.sentiment_very_satisfied, 'color1': AppColors.colorWarning, 'color2': AppColors.colorWarning},
    {'name': 'Drama', 'icon': Icons.theater_comedy, 'color1': AppColors.colorPrimary, 'color2': AppColors.colorSecondary},
    {'name': 'Documentary', 'icon': Icons.public, 'color1': AppColors.colorSuccess, 'color2': AppColors.colorSuccess},
    {'name': 'Music', 'icon': Icons.music_note, 'color1': AppColors.colorSecondary, 'color2': AppColors.colorSecondary},
    {'name': 'Sports', 'icon': Icons.sports_basketball, 'color1': AppColors.colorWarning, 'color2': AppColors.colorWarning},
    {'name': 'Technology', 'icon': Icons.computer, 'color1': Color(0xFF3B82F6), 'color2': Color(0xFF1D4ED8)},
    {'name': 'Travel', 'icon': Icons.flight_takeoff, 'color1': Color(0xFF14B8A6), 'color2': Color(0xFF0F766E)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.colorBackground,
        title: const Text('Browse Categories', style: TextStyle(fontFamily: 'Poppins', fontSize: 18, fontWeight: FontWeight.w500)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 16 / 9,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          return GestureDetector(
            onTap: () => context.push('/category/${category['name']}'),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [category['color1'], category['color2']],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(category['icon'], color: Colors.white.withValues(alpha:0.8), size: 32),
                        const SizedBox(height: 8),
                        Text(
                          category['name'],
                          style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha:0.3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('20 videos', style: TextStyle(fontFamily: 'Poppins', fontSize: 10, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
