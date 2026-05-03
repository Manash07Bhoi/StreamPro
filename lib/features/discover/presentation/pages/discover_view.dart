import '../../../../core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../blocs/search_bloc.dart';
import '../../../../core/models/search_history_entry.dart';

class DiscoverView extends StatefulWidget {
  const DiscoverView({super.key});

  @override
  State<DiscoverView> createState() => _DiscoverViewState();
}

class _DiscoverViewState extends State<DiscoverView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SearchBloc>(),
      child: Builder(
        builder: (context) {
          return Column(
            children: [
              _buildSearchBar(context),
              _buildActiveFilters(context),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state is SearchIdle) {
                      return _buildIdleState(context, state.recentSearches);
                    } else if (state is SearchLoading) {
                      return const Center(child: CircularProgressIndicator(color: AppColors.colorPrimary));
                    } else if (state is SearchResultsLoaded) {
                      return _buildResultsGrid(state.results);
                    } else if (state is SearchEmpty) {
                      return _buildEmptyState();
                    } else if (state is SearchError) {
                      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 52,
              decoration: BoxDecoration(
                color: AppColors.colorSurface3,
                borderRadius: BorderRadius.circular(16),
                border: _searchFocus.hasFocus ? Border.all(color: AppColors.colorPrimary, width: 1.5) : null,
              ),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocus,
                style: const TextStyle(fontFamily: 'Poppins', color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search premium videos...',
                  hintStyle: const TextStyle(color: AppColors.colorTextMuted, fontFamily: 'Poppins'),
                  prefixIcon: ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(colors: [AppColors.colorPrimary, AppColors.colorSecondary]).createShader(bounds),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.close, color: AppColors.colorTextSecondary),
                          onPressed: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(SearchQueryChanged(''));
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.mic, color: AppColors.colorTextSecondary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice search coming soon')));
                          },
                        ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {}); // to update suffix icon
                  context.read<SearchBloc>().add(SearchQueryChanged(value));
                },
                onSubmitted: (value) {
                  context.read<SearchBloc>().add(SearchSubmitted(value));
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              int filterCount = 0;
              if (state is SearchResultsLoaded) filterCount = state.filters.activeFilterCount;

              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.tune, color: Colors.white),
                    onPressed: () => _showFilterSheet(context),
                  ),
                  if (filterCount > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: AppColors.colorPrimary, shape: BoxShape.circle),
                        child: Text(filterCount.toString(), style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilters(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if (state is SearchResultsLoaded && state.filters.isActive) {
          final filters = state.filters;
          final chips = <Widget>[];
          if (filters.sortBy != 'relevant') chips.add(_buildFilterChip(context, 'Sort: ${filters.sortBy}'));
          if (filters.duration != 'any') chips.add(_buildFilterChip(context, 'Duration: ${filters.duration}'));
          for (var c in filters.categories) { chips.add(_buildFilterChip(context, c)); }
          for (var r in filters.ratings) { chips.add(_buildFilterChip(context, r)); }

          return SizedBox(
            height: 40,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: chips.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => chips[index],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    return Chip(
      label: Text(label, style: const TextStyle(fontFamily: 'Poppins', fontSize: 12, color: Colors.white)),
      backgroundColor: AppColors.colorSurface3,
      side: const BorderSide(color: AppColors.colorPrimary),
      onDeleted: () {
         // To fully implement single deletion requires updating the SearchFilters object
         context.read<SearchBloc>().add(SearchFiltersReset());
      },
      deleteIconColor: AppColors.colorTextSecondary,
    );
  }

  Widget _buildIdleState(BuildContext context, List<SearchHistoryEntry> recentSearches) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (recentSearches.isNotEmpty) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Searches', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
              TextButton(
                onPressed: () => context.read<SearchBloc>().add(ClearSearchHistory()),
                child: const Text('Clear All', style: TextStyle(fontFamily: 'Poppins', color: AppColors.colorPrimary)),
              ),
            ],
          ),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: recentSearches.map((entry) => InputChip(
              label: Text(entry.query, style: const TextStyle(fontFamily: 'Poppins', color: Colors.white)),
              backgroundColor: AppColors.colorSurface2,
              deleteIcon: const Icon(Icons.close, size: 16, color: AppColors.colorTextSecondary),
              onDeleted: () => context.read<SearchBloc>().add(RemoveSearchHistoryEntry(entry.id)),
              onPressed: () {
                _searchController.text = entry.query;
                context.read<SearchBloc>().add(SearchSubmitted(entry.query));
              },
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide.none),
            )).toList(),
          ),
          const SizedBox(height: 32),
        ],
        const Text('Browse by Category', style: TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 16 / 9,
          children: const [
            _CategoryCardMock(title: 'Action', color1: AppColors.colorError, color2: AppColors.colorError, icon: Icons.flash_on),
            _CategoryCardMock(title: 'Comedy', color1: AppColors.colorWarning, color2: AppColors.colorWarning, icon: Icons.sentiment_very_satisfied),
            _CategoryCardMock(title: 'Drama', color1: AppColors.colorPrimary, color2: AppColors.colorSecondary, icon: Icons.theater_comedy),
            _CategoryCardMock(title: 'Documentary', color1: AppColors.colorSuccess, color2: AppColors.colorSuccess, icon: Icons.public),
          ],
        ),
        TextButton(
          onPressed: () => context.push('/categories'),
          child: const Text('View All Categories', style: TextStyle(fontFamily: 'Poppins', color: AppColors.colorPrimary)),
        ),
      ],
    );
  }

  Widget _buildResultsGrid(List<VideoEntity> results) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      padding: const EdgeInsets.all(12),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final height = (index % 3 == 0) ? 220.0 : 160.0;
        return PremiumVideoCard(
          video: results[index],
          width: double.infinity,
          height: height,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, size: 80, color: AppColors.colorSurface3),
          const SizedBox(height: 16),
          const Text('No Results Found', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 8),
          const Text('Try different keywords or browse by category.', style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: AppColors.colorTextSecondary)),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () => context.push('/categories'),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.colorPrimary),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Browse Categories', style: TextStyle(color: Colors.white, fontFamily: 'Poppins')),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final searchBloc = context.read<SearchBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.colorSurface2,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (bottomSheetContext) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filters', style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                TextButton(
                  onPressed: () {
                    searchBloc.add(SearchFiltersReset());
                    Navigator.pop(bottomSheetContext);
                  },
                  child: const Text('Reset', style: TextStyle(color: AppColors.colorTextSecondary, fontFamily: 'Poppins')),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Mock filter options for UI
            const Text('Sort By', style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: ['Relevant', 'Views', 'Newest', 'Duration'].map((e) => ChoiceChip(
                label: Text(e),
                selected: e == 'Relevant', // Mock state
                onSelected: (_) {},
                backgroundColor: AppColors.colorSurface3,
                selectedColor: AppColors.colorPrimary.withValues(alpha:0.2),
                side: BorderSide(color: e == 'Relevant' ? AppColors.colorPrimary : Colors.transparent),
                labelStyle: TextStyle(color: e == 'Relevant' ? Colors.white : AppColors.colorTextSecondary, fontFamily: 'Poppins'),
              )).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  // Apply logic here
                  searchBloc.add(SearchFiltersApplied(const SearchFilters(sortBy: 'views')));
                  Navigator.pop(bottomSheetContext);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.colorPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text('Apply Filters', style: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }
}

class _CategoryCardMock extends StatelessWidget {
  final String title;
  final Color color1;
  final Color color2;
  final IconData icon;

  const _CategoryCardMock({required this.title, required this.color1, required this.color2, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/category/$title'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white.withValues(alpha:0.8), size: 32),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontFamily: 'Poppins', fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
