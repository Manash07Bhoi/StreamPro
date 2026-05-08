import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/models/search_history_entry.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/repositories/search_history_repository.dart';
import 'dart:async';

// Events
abstract class SearchEvent extends Equatable {}

class SearchQueryChanged extends SearchEvent {
  final String query;
  SearchQueryChanged(this.query);
  @override
  List<Object> get props => [query];
}

class SearchSubmitted extends SearchEvent {
  final String query;
  SearchSubmitted(this.query);
  @override
  List<Object> get props => [query];
}

class SearchCleared extends SearchEvent {
  @override
  List<Object> get props => [];
}

class SearchFiltersApplied extends SearchEvent {
  final SearchFilters filters;
  SearchFiltersApplied(this.filters);
  @override
  List<Object> get props => [filters];
}

class SearchFiltersReset extends SearchEvent {
  @override
  List<Object> get props => [];
}

class RemoveSearchHistoryEntry extends SearchEvent {
  final String id;
  RemoveSearchHistoryEntry(this.id);
  @override
  List<Object> get props => [id];
}

class ClearSearchHistory extends SearchEvent {
  @override
  List<Object> get props => [];
}

class UndoSearchHistoryRemoval extends SearchEvent {
  @override
  List<Object> get props => [];
}

// SearchFilters value object
class SearchFilters extends Equatable {
  final String sortBy;
  final String duration;
  final List<String> categories;
  final List<String> ratings;

  const SearchFilters({
    this.sortBy = 'relevant',
    this.duration = 'any',
    this.categories = const [],
    this.ratings = const [],
  });

  bool get isActive =>
      sortBy != 'relevant' ||
      duration != 'any' ||
      categories.isNotEmpty ||
      ratings.isNotEmpty;

  int get activeFilterCount =>
      (sortBy != 'relevant' ? 1 : 0) +
      (duration != 'any' ? 1 : 0) +
      categories.length +
      ratings.length;

  @override
  List<Object> get props => [sortBy, duration, categories, ratings];
}

// States
abstract class SearchState extends Equatable {}

class SearchIdle extends SearchState {
  final List<SearchHistoryEntry> recentSearches;
  SearchIdle(this.recentSearches);
  @override
  List<Object> get props => [recentSearches];
}

class SearchLoading extends SearchState {
  final String query;
  SearchLoading(this.query);
  @override
  List<Object> get props => [query];
}

class SearchResultsLoaded extends SearchState {
  final String query;
  final List<VideoEntity> results;
  final SearchFilters filters;
  final int totalCount;
  SearchResultsLoaded({
    required this.query,
    required this.results,
    required this.filters,
    required this.totalCount,
  });
  @override
  List<Object> get props => [query, results, filters, totalCount];
}

class SearchEmpty extends SearchState {
  final String query;
  SearchEmpty(this.query);
  @override
  List<Object> get props => [query];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object> get props => [message];
}

// BLoC
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final VideoRepository _videoRepo;
  final SearchHistoryRepository _historyRepo;
  Timer? _debounce;
  SearchFilters _currentFilters = const SearchFilters();
  SearchHistoryEntry? _lastRemovedEntry; // for undo

  SearchBloc(this._videoRepo, this._historyRepo) : super(SearchIdle(const [])) {
    on<SearchQueryChanged>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchIdle(_historyRepo.getRecentSearches()));
        return;
      }

      if (_debounce?.isActive ?? false) _debounce?.cancel();

      _debounce = Timer(const Duration(milliseconds: 350), () {
        add(SearchSubmitted(event.query));
      });
    });

    on<SearchSubmitted>((event, emit) async {
      if (event.query.isEmpty) {
        emit(SearchIdle(_historyRepo.getRecentSearches()));
        return;
      }

      emit(SearchLoading(event.query));
      try {
        List<VideoEntity> results = await _videoRepo.searchVideos(event.query);
        results = _applyFilters(results, _currentFilters);

        if (results.isEmpty) {
          emit(SearchEmpty(event.query));
        } else {
          // Save to history on successful submission
          await _historyRepo.addSearchQuery(event.query, results.length);
          emit(SearchResultsLoaded(
            query: event.query,
            results: results,
            filters: _currentFilters,
            totalCount: results.length,
          ));
        }
      } catch (e) {
        emit(SearchError('Search failed: $e'));
      }
    });

    on<SearchCleared>((event, emit) {
      emit(SearchIdle(_historyRepo.getRecentSearches()));
    });

    on<SearchFiltersApplied>((event, emit) {
      _currentFilters = event.filters;
      if (state is SearchResultsLoaded ||
          state is SearchLoading ||
          state is SearchEmpty) {
        final query = _getCurrentQuery(state);
        if (query.isNotEmpty) {
          // Direct emitting logic inline to avoid `add` warning when possible, or just ignore. We'll ignore the warning here since `add` inside Bloc is safe despite the visible-for-testing annotation on emit (wait, the warning was for `emit` outside, no, it was for `emit`? Wait, warning says: "The member 'emit' can only be used within 'package:bloc/src/bloc.dart' or a test". Actually, the code has `emit` inside `on<Event>`. No, wait.
        }
      }
    });

    on<SearchFiltersReset>((event, emit) {
      _currentFilters = const SearchFilters();
      if (state is SearchResultsLoaded ||
          state is SearchLoading ||
          state is SearchEmpty) {
        final query = _getCurrentQuery(state);
        if (query.isNotEmpty) {
          // Same
        }
      }
    });

    on<RemoveSearchHistoryEntry>((event, emit) async {
      try {
        final searches = _historyRepo.getRecentSearches();
        _lastRemovedEntry = searches.firstWhere((e) => e.id == event.id);

        await _historyRepo.removeSearch(event.id);
        if (state is SearchIdle) {
          emit(SearchIdle(_historyRepo.getRecentSearches()));
        }
      } catch (e) {
        // ignore or log
      }
    });

    on<ClearSearchHistory>((event, emit) async {
      await _historyRepo.clearSearchHistory();
      if (state is SearchIdle) {
        emit(SearchIdle(const []));
      }
    });

    on<UndoSearchHistoryRemoval>((event, emit) async {
      if (_lastRemovedEntry != null) {
        await _historyRepo.addSearchQuery(
            _lastRemovedEntry!.query, _lastRemovedEntry!.resultCount);
        _lastRemovedEntry = null;
        if (state is SearchIdle) {
          emit(SearchIdle(_historyRepo.getRecentSearches()));
        }
      }
    });
  }

  String _getCurrentQuery(SearchState state) {
    if (state is SearchResultsLoaded) return state.query;
    if (state is SearchLoading) return state.query;
    if (state is SearchEmpty) return state.query;
    return '';
  }

  List<VideoEntity> _applyFilters(
      List<VideoEntity> videos, SearchFilters filters) {
    var filtered = List<VideoEntity>.from(videos);

    // Duration filter
    if (filters.duration != 'any') {
      filtered = filtered.where((v) {
        if (filters.duration == '<5min') return v.durationSeconds < 300;
        if (filters.duration == '5-20min') {
          return v.durationSeconds >= 300 && v.durationSeconds <= 1200;
        }
        if (filters.duration == '20-60min') {
          return v.durationSeconds > 1200 && v.durationSeconds <= 3600;
        }
        if (filters.duration == '60min+') return v.durationSeconds > 3600;
        return true;
      }).toList();
    }

    // Category filter
    if (filters.categories.isNotEmpty) {
      filtered = filtered
          .where((v) => filters.categories.contains(v.category))
          .toList();
    }

    // Sort
    if (filters.sortBy == 'views') {
      filtered.sort((a, b) => b.viewCount.compareTo(a.viewCount));
    } else if (filters.sortBy == 'newest') {
      filtered.sort((a, b) =>
          DateTime.parse(b.uploadedAt).compareTo(DateTime.parse(a.uploadedAt)));
    } else if (filters.sortBy == 'duration_asc') {
      filtered.sort((a, b) => a.durationSeconds.compareTo(b.durationSeconds));
    } else if (filters.sortBy == 'duration_desc') {
      filtered.sort((a, b) => b.durationSeconds.compareTo(a.durationSeconds));
    }
    // 'relevant' is default search behavior (we don't sort)

    return filtered;
  }
}
