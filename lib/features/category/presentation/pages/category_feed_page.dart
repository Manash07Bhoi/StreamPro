import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../core/models/video_entity.dart';
import '../../../../core/widgets/premium_video_card.dart';
import '../../../discover/data/repositories/video_repository.dart';
import '../../../../core/di/injection.dart';

class CategoryFeedPage extends StatefulWidget {
  final String category;

  const CategoryFeedPage({super.key, required this.category});

  @override
  State<CategoryFeedPage> createState() => _CategoryFeedPageState();
}

class _CategoryFeedPageState extends State<CategoryFeedPage> {
  final PagingController<int, VideoEntity> _pagingController = PagingController(
    firstPageKey: 0,
  );
  final _repository = getIt<VideoRepository>();
  static const _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final allInCategory = await _repository.getVideosByCategory(
        widget.category,
      );
      final start = pageKey * _pageSize;
      if (start >= allInCategory.length) {
        _pagingController.appendLastPage([]);
        return;
      }
      final end = (start + _pageSize > allInCategory.length)
          ? allInCategory.length
          : start + _pageSize;
      final newItems = allInCategory.sublist(start, end);

      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  bool _canPop = false;

  void _safePop() {
    if (_canPop) return;
    HapticFeedback.selectionClick();
    setState(() {
      _canPop = true;
    });
    // Let the frame build with canPop: true, then pop
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _safePop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.category),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: _safePop,
          ),
        ),
        body: PagedListView<int, VideoEntity>(
          padding: const EdgeInsets.all(16),
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<VideoEntity>(
            itemBuilder: (context, video, index) {
              return PremiumVideoCard(
                video: video,
                width: double.infinity,
                height: 200,
              );
            },
            firstPageProgressIndicatorBuilder: (_) =>
                const Center(child: CircularProgressIndicator()),
            noItemsFoundIndicatorBuilder: (_) =>
                const Center(child: Text('No videos found in this category.')),
          ),
        ),
      ),
    );
  }
}
