import 'dart:async';

import 'package:chiligiphy/search/gif.dart';
import 'package:chiligiphy/search/search_service.dart';
import 'package:chiligiphy/search/search_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

/// Search screen ViewModel
class SearchViewModel extends BaseViewModel {
  /// Search field timer
  Timer? _debounce;

  /// Search Service (API)
  SearchService searchService = SearchService();

  /// Loading more busy indicator
  static const busyLoadingMore = 'busyLoadingMore';

  /// If [preloadDistance] pixels left till maximum scroll range, will fetch more GIFs
  static const double preloadDistance = 500;

  /// List of GIFs
  List<Gif> gifs = [];

  /// Search text field controller
  final TextEditingController searchController = TextEditingController();

  /// Current search text
  String _searchText = '';
  String get searchText => _searchText;

  /// API page number
  ///
  /// API doesn't really have "pages", it has "limit" and "offset" instead. But that's what SearchService will handle.
  int _page = 1;

  /// Updates search text
  void updateSearchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  /// Fetches GIFs from API
  Future<void> search() async {
    _page = 1;
    if (_searchText.isEmpty) {
      return;
    }
    final newGifs = await runBusyFuture(searchService.search(query: _searchText));
    gifs = newGifs;
    notifyListeners();
  }

  /// Fetches more GIFs from API
  Future<void> searchMore() async {
    final newGifs =
        await runBusyFuture(searchService.search(query: _searchText, page: ++_page), busyObject: busyLoadingMore);
    gifs.addAll(newGifs);
    notifyListeners();
  }

  /// Handles search text updated
  void onChanged(value) {
    updateSearchText(value);
    // https://stackoverflow.com/questions/51791501/how-to-debounce-textfield-onchange-in-dart/57207610#57207610
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      search();
    });
  }

  /// Handles user scroll
  ///
  /// If close to scroll limit, loads more gifs
  bool onScrollNotification(ScrollNotification notification) {
    if (!isBusy &&
        !busy(busyLoadingMore) &&
        notification.metrics.pixels >= notification.metrics.maxScrollExtent - preloadDistance) {
      searchMore();
    }
    return true;
  }

  /// Returns width and height of image
  (double, double) getGifSize(
    Gif gif, {
    required double screenWidth,
  }) {
    int columns = getColumnAmount(screenWidth);
    double availableWidth = screenWidth - SearchView.padding * (columns + 1);
    double width = availableWidth / columns;
    double height = (gif.height * width) / gif.width;
    return (width, height);
  }

  /// Returns the amount of columns for MasonryGridView
  int getColumnAmount(double screenWidth) {
    return (screenWidth / 300).ceil();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
