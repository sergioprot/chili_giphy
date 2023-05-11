import 'package:chiligiphy/search/gif.dart';
import 'package:chiligiphy/search/search_constants.dart';
import 'package:dio/dio.dart';

/// Search service.
///
/// Contains method to fetch GIFs from API
class SearchService {
  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.giphy.com/v1/gifs/',
    queryParameters: {
      'api_key': SearchConstants.apiKey,
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    sendTimeout: const Duration(seconds: 10),
  ));

  /// API one request limit
  static int perPage = 25;

  /// Fetches GIFs from API.
  ///
  /// Returns them as a List
  Future<List<Gif>> search({
    required String query,
    int page = 1,
  }) async {
    int offset = (page - 1) * perPage;
    final response = await dio.get('search', queryParameters: {
      'q': query,
      'limit': perPage,
      'offset': offset,
    });
    List<Gif> gifs = [];
    for (var item in (response.data['data'] as List)) {
      gifs.add(Gif.fromJson(item));
    }
    return gifs;
  }
}
