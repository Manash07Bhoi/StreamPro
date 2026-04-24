import 'package:flutter/material.dart';

class LibraryView extends StatelessWidget {
  const LibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          const TabBar(
            tabs: [
              Tab(text: 'Watch History'),
              Tab(text: 'Bookmarks'),
            ],
            indicatorColor: Color(0xFFC026D3),
          ),
          Expanded(
            child: TabBarView(
              children: [
                const Center(child: Text('Watch History (Local Hive)')),
                const Center(child: Text('Bookmarks (Local Hive)')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
