import 'package:chiligiphy/search/gif.dart';
import 'package:dio/dio.dart';

/// Search service.
///
/// Contains method to fetch GIFs from API
class SearchService {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.giphy.com/v1/gifs/',
    queryParameters: {
      'api_key': 'lIQQ04DzQai4aR3sekuMLXfHiYsjzILX',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ));

  /// Fetches GIFs from API.
  ///
  /// Returns them as a List
  Future<List<Gif>> search({
    required String query,
  }) async {
    final response = await dio.get('search', queryParameters: {'q': query});
    List<Gif> gifs = [];
    for (var item in (response.data['data'] as List)) {
      gifs.add(Gif.fromJson(item));
    }
    // print(gifs.length);
    // print(query);
    return gifs;
  }
}