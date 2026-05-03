/// A model class representing a news article.
class Article {
  /// The title of the article.
  final String title;
  /// A brief description of the article's content.
  final String description;
  /// The URL to the full article.
  final String url;
  /// The URL to an image associated with the article.
  final String urlToImage;
  /// The name of the source that published the article.
  final String sourceName;
  /// The author of the article.
  final String author;
  /// The date and time the article was published.
  final String publishedAt;

  /// Creates a new [Article] instance.
  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    required this.author,
    required this.publishedAt,
  });

  /// Creates an [Article] instance from a JSON map.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      sourceName: json['source'] != null ? json['source']['name'] ?? '' : '',
      author: json['author'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
    );
  }
}
