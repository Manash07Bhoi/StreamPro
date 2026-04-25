import 'package:flutter/material.dart';
import '../widgets/home_feed_view.dart';
import '../../../discover/presentation/pages/discover_view.dart';
import '../../../trending/presentation/pages/trending_view.dart';
import '../../../library/presentation/pages/library_view.dart';
import '../widgets/main_drawer.dart';
import 'package:haptic_feedback/haptic_feedback.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _views = [
    const HomeFeedView(),
    const DiscoverView(),
    const TrendingView(),
    const LibraryView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _currentIndex == 0
            ? Text('StreamPro', style: Theme.of(context).textTheme.titleLarge)
            : Text(_getTabName(_currentIndex)),
        centerTitle: false,
        actions: [
           IconButton(
             icon: const Icon(Icons.notifications_none),
             onPressed: () {}, // To implement
           ),
           IconButton(
             icon: const Icon(Icons.vpn_key),
             onPressed: () {}, // To implement
           )
        ],
      ),
      drawer: const MainDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: _views,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          Haptics.vibrate(HapticsType.selection);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore_rounded),
            label: 'Discover',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department_rounded),
            label: 'Trending',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_rounded),
            label: 'Library',
          ),
        ],
      ),
    );
  }

  String _getTabName(int index) {
    switch(index) {
      case 1: return 'Discover';
      case 2: return 'Trending';
      case 3: return 'Library';
      default: return 'StreamPro';
    }
  }
}
