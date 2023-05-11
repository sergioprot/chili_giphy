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

  /// List of GIFs
  List<Gif> gifs = [];

  final TextEditingController searchController = TextEditingController();

  /// Current search text
  String _searchText = '';

  /// Updates search text
  void updateSearchText(String value) {
    _searchText = value;
  }

  /// Fetches GIFs from API
  Future<void> search() async {
    if (_searchText.isEmpty) {
      return;
    }
    gifs = await searchService.search(query: _searchText);
    notifyListeners();
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

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
