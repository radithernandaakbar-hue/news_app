/// Semua konfigurasi API dikumpulkan di sini supaya tidak ada URL / string
/// yang diulang-ulang di tempat lain.
class ApiConfig {
  ApiConfig._();

  /// Diisi lewat --dart-define=GNEWS_API_KEY=xxxx, atau ganti defaultValue.
  static const String apiKey =
      String.fromEnvironment('GNEWS_API_KEY', defaultValue: 'ISI_API_KEY_GNEWS');

  static const String host = 'gnews.io';
  static const String basePath = '/api/v4';
  static const String topHeadlinesPath = 'top-headlines';
  static const String searchPath = 'search';

  static const String language = 'id';
  static const String country = 'id';
  static const String maxArticles = '10';
  static const Duration timeout = Duration(seconds: 10);
}
