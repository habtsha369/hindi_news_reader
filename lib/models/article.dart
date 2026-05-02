class Article {
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String sourceName;
  final String author;
  final String publishedAt;

  Article({
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.sourceName,
    required this.author,
    required this.publishedAt,
  });

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
