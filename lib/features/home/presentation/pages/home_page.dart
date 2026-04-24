import 'package:flutter/material.dart';
import '../widgets/home_feed_view.dart';
import '../../../discover/presentation/pages/discover_view.dart';
import '../../../trending/presentation/pages/trending_view.dart';
import '../../../library/presentation/pages/library_view.dart';
import '../../../../core/routes/app_routes.dart';
import '../widgets/main_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeFeedView(),
    const DiscoverView(),
    const TrendingView(),
    const LibraryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StreamPro'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {}, // Handled in discover tab
          ),
          IconButton(
            icon: const Icon(Icons.security),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.vpn);
            },
          ),
        ],
      ),
      drawer: const MainDrawer(),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Discover'),
          BottomNavigationBarItem(
              icon: Icon(Icons.trending_up), label: 'Trending'),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_library), label: 'Library'),
        ],
      ),
    );
  }
}
