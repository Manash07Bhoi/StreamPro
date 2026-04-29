import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryGridPage extends StatelessWidget {
  const CategoryGridPage({super.key});

  final List<Map<String, dynamic>> _categories = const [
    {'name': 'Action', 'icon': Icons.flash_on, 'color1': Color(0xFFEF4444), 'color2': Color(0xFFB91C1C)},
    {'name': 'Comedy', 'icon': Icons.sentiment_very_satisfied, 'color1': Color(0xFFF59E0B), 'color2': Color(0xFFD97706)},
    {'name': 'Drama', 'icon': Icons.theater_comedy, 'color1': Color(0xFF8B5CF6), 'color2': Color(0xFF6D28D9)},
    {'name': 'Documentary', 'icon': Icons.public, 'color1': Color(0xFF10B981), 'color2': Color(0xFF059669)},
    {'name': 'Music', 'icon': Icons.music_note, 'color1': Color(0xFFEC4899), 'color2': Color(0xFFBE185D)},
    {'name': 'Sports', 'icon': Icons.sports_basketball, 'color1': Color(0xFFF97316), 'color2': Color(0xFFC2410C)},
    {'name': 'Technology', 'icon': Icons.computer, 'color1': Color(0xFF3B82F6), 'color2': Color(0xFF1D4ED8)},
    {'name': 'Travel', 'icon': Icons.flight_takeoff, 'color1': Color(0xFF14B8A6), 'color2': Color(0xFF0F766E)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
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
