import 'package:chiligiphy/search/gif.dart';
import 'package:chiligiphy/search/search_service.dart';
import 'package:chiligiphy/search/search_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

class _SearchServiceMock extends SearchService {
  @override
  Future<List<Gif>> search({required String query, int page = 1}) {
    return page == 1
        ? SynchronousFuture([
            Gif(url: 'url-1', width: 1, height: 1),
            Gif(url: 'url-2', width: 2, height: 2),
          ])
        : SynchronousFuture([
            Gif(url: 'url-3', width: 3, height: 3),
            Gif(url: 'url-4', width: 4, height: 4),
          ]);
  }
}

void main() {
  group('SearchViewModel', () {
    final model = SearchViewModel();
    model.searchService = _SearchServiceMock();

    test('search', () async {
      expect(model.gifs.length, 0);
      expect(model.searchText, '');
      model.updateSearchText('cat');
      expect(model.searchText, 'cat');

      await model.search();
      expect(model.gifs.length, 2);
      expect(model.gifs[0].url, 'url-1');
      expect(model.gifs[1].url, 'url-2');
    });

    test('search more', () async {
      await model.searchMore();
      expect(model.gifs.length, 4);
      expect(model.gifs[0].url, 'url-1');
      expect(model.gifs[1].url, 'url-2');
      expect(model.gifs[2].url, 'url-3');
      expect(model.gifs[3].url, 'url-4');

      await model.search();
      expect(model.gifs.length, 2);
    });

    test('get column amount', () {
      int n = model.getColumnAmount(250);
      expect(n, 1);
      n = model.getColumnAmount(350);
      expect(n, 2);
      n = model.getColumnAmount(599);
      expect(n, 2);
      n = model.getColumnAmount(601);
      expect(n, 3);
    });

    test('get size of gif', () {
      double width;
      double height;
      // 600 - 3 * 8 == 288
      final gif1 = Gif(url: 'url', width: 288, height: 500);
      (width, height) = model.getGifSize(gif1, screenWidth: 600);
      // Width stays exactly the same, so does height
      expect(width, 288);
      expect(height, 500);

      final gif2 = Gif(url: 'url', width: 576, height: 500);
      (width, height) = model.getGifSize(gif2, screenWidth: 600);
      // Have to divide width by 2, thus height is divided by 2 too.
      expect(width, 288);
      expect(height, 250);
    });
  });
}
