/// Gif class
///
/// Stores info about one GIF image
class Gif {
  /// GIF url
  final String url;

  /// GIF image width
  final double width;

  /// GIF image height
  final double height;

  Gif({
    required this.url,
    required this.width,
    required this.height,
  });

  /// Gif factory from API data
  factory Gif.fromJson(final json) {
    String type = 'preview_gif';
    String url = json['images'][type]['url'] as String;
    double width = double.parse(json['images'][type]['width'] as String);
    double height = double.parse(json['images'][type]['height'] as String);
    return Gif(
      url: url,
      width: width,
      height: height,
    );
  }
}
