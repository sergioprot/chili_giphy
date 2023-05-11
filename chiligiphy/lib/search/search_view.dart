import 'package:chiligiphy/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

/// The main page of the app: Search screen
class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: model.searchController,
                decoration: const InputDecoration(
                  hintText: 'Search for GIFs',
                  suffixIcon: Icon(Icons.search),
                ),
                onChanged: model.onChanged,
                onSubmitted: (_) => model.search(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (var item in model.gifs)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(
                            item.url,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
