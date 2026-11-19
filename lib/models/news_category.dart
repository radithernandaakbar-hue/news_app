class NewsCategory {
  const NewsCategory(this.label, this.key);

  final String label;

  /// Nilai parameter `category` pada GNews.
  final String key;

  static const List<NewsCategory> all = [
    NewsCategory('Teknologi', 'technology'),
    NewsCategory('Olahraga', 'sports'),
    NewsCategory('Bisnis', 'business'),
    NewsCategory('Sains', 'science'),
    NewsCategory('Hiburan', 'entertainment'),
    NewsCategory('Kesehatan', 'health'),
  ];

  static const NewsCategory defaultCategory = NewsCategory('Teknologi', 'technology');
}
