class ArticleModel {
  const ArticleModel({
    required this.title,
    required this.description,
    required this.content,
    required this.url,
    required this.image,
    required this.sourceName,
    required this.publishedAt,
  });

  final String title;
  final String description;
  final String content;
  final String url;
  final String image;
  final String sourceName;
  final DateTime? publishedAt;

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    final source = json['source'];
    return ArticleModel(
      title: (json['title'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      content: (json['content'] ?? '') as String,
      url: (json['url'] ?? '') as String,
      image: (json['image'] ?? '') as String,
      sourceName: source is Map ? (source['name'] ?? '') as String : '',
      publishedAt: DateTime.tryParse((json['publishedAt'] ?? '') as String),
    );
  }
}
