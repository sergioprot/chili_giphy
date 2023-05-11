import 'package:chiligiphy/search/search_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stacked/stacked.dart';

/// The main page of the app: Search screen
class SearchView extends StatelessWidget {
  static const double padding = 8;

  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ViewModelBuilder.reactive(
      viewModelBuilder: () => SearchViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Search'),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(padding),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0, vertical: padding),
                  child: TextField(
                    controller: model.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search for GIFs',
                      suffixIcon: Icon(Icons.search),
                    ),
                    onChanged: model.onChanged,
                    onSubmitted: (_) => model.search(),
                  ),
                ),
                Expanded(
                  child: NotificationListener(
                    onNotification: model.onScrollNotification,
                    child: MasonryGridView.count(
                      itemCount: model.gifs.length,
                      crossAxisCount: model.getColumnAmount(screenWidth),
                      mainAxisSpacing: padding,
                      crossAxisSpacing: padding,
                      itemBuilder: (context, index) {
                        final item = model.gifs.elementAt(index);
                        double width;
                        double height;
                        (width, height) = model.getGifSize(item, screenWidth: screenWidth);
                        return ClipRRect(
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          child: Image.network(
                            item.url,
                            width: width,
                            height: height,
                            loadingBuilder: (context, child, progress) => progress == null
                                ? child
                                : SizedBox(
                                    width: width,
                                    height: height,
                                    child: const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
