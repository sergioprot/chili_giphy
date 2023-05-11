import 'package:chiligiphy/search/gif.dart';
import 'package:chiligiphy/search/search_service.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

/// Search screen ViewModel
class SearchViewModel extends BaseViewModel {
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
    final newGifs = await searchService.search(query: _searchText);
    gifs.addAll(newGifs);
    notifyListeners();
  }
}
