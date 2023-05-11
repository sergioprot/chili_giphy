import 'package:chiligiphy/search/search_constants.dart';
import 'package:chiligiphy/search/search_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

void main() {
  test('valid responses', () async {
    SearchService.perPage = 2;
    final searchService = SearchService();

    final dio = searchService.dio;
    final dioAdapter = DioAdapter(dio: dio);
    dioAdapter.onGet(
        'search',
        queryParameters: {
          'api_key': SearchConstants.apiKey,
          'q': 'query',
          'limit': 2,
          'offset': 0,
        },
        (server) => server.reply(200, {
              "data": [
                {
                  "images": {
                    "downsized_medium": {
                      "height": "1",
                      "width": "2",
                      "size": "12",
                      "url": "url-1",
                    }
                  }
                },
                {
                  "images": {
                    "downsized_medium": {
                      "height": "3",
                      "width": "4",
                      "size": "34",
                      "url": "url-2",
                    }
                  }
                }
              ]
            }));
    dioAdapter.onGet(
        'search',
        queryParameters: {
          'api_key': SearchConstants.apiKey,
          'q': 'query',
          'limit': 2,
          'offset': 2,
        },
        (server) => server.reply(200, {
              "data": [
                {
                  "images": {
                    "downsized_medium": {
                      "height": "5",
                      "width": "6",
                      "size": "56",
                      "url": "url-3",
                    }
                  }
                },
                {
                  "images": {
                    "downsized_medium": {
                      "height": "7",
                      "width": "8",
                      "size": "78",
                      "url": "url-4",
                    }
                  }
                }
              ]
            }));

    final gifs = await searchService.search(query: 'query');
    expect(gifs.length, 2);
    expect(gifs[0].url, 'url-1');
    expect(gifs[0].height, 1);
    expect(gifs[0].width, 2);
    expect(gifs[1].url, 'url-2');
    expect(gifs[1].height, 3);
    expect(gifs[1].width, 4);

    final moreGifs = await searchService.search(query: 'query', page: 2);
    expect(moreGifs.length, 2);
    expect(moreGifs[0].url, 'url-3');
    expect(moreGifs[0].height, 5);
    expect(moreGifs[0].width, 6);
    expect(moreGifs[1].url, 'url-4');
    expect(moreGifs[1].height, 7);
    expect(moreGifs[1].width, 8);
  });
}
