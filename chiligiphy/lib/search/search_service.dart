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
    connectTimeout: const Duration(seconds: 5),
    receiveTimeout: const Duration(seconds: 5),
    sendTimeout: const Duration(seconds: 5),
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
    return gifs;
  }
}
