import 'dart:async';

import 'package:chiligiphy/search/gif.dart';
import 'package:chiligiphy/search/search_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

/// Search screen ViewModel
class SearchViewModel extends BaseViewModel {
  /// Search field timer
  Timer? _debounce;

  final searchService = SearchService();

  static const busyLoadingMore = 'busyLoadingMore';

  static const double preloadDistance = 500;

  /// List of GIFs
  List<Gif> gifs = [];

  final TextEditingController searchController = TextEditingController();

  /// Current search text
  String _searchText = '';

  int _page = 1;

  /// Updates search text
  void updateSearchText(String value) {
    _searchText = value;
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
  }

  /// Handles search text updated
  void onChanged(value) {
    updateSearchText(value);
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // print(value);
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
