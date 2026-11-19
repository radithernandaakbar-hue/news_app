import 'dart:async';
import 'dart:convert';
import 'dart:io' show SocketException;

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/article_model.dart';
import 'api_exception.dart';

class NewsService {
  NewsService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<ArticleModel>> fetchByCategory(String category) =>
      _get(ApiConfig.topHeadlinesPath, {'category': category});

  Future<List<ArticleModel>> search(String query) =>
      _get(ApiConfig.searchPath, {'q': query});

  Future<List<ArticleModel>> _get(String path, Map<String, String> params) async {
    final uri = Uri.https(ApiConfig.host, '${ApiConfig.basePath}/$path', {
      ...params,
      'lang': ApiConfig.language,
      'country': ApiConfig.country,
      'max': ApiConfig.maxArticles,
      'apikey': ApiConfig.apiKey,
    });

    try {
      final response = await _client.get(uri).timeout(ApiConfig.timeout);
      return _parse(response);
    } on SocketException {
      throw const ApiException.noConnection();
    } on http.ClientException {
      throw const ApiException.noConnection();
    } on TimeoutException {
      throw const ApiException.timeout();
    } on FormatException {
      throw const ApiException.badResponse();
    } on TypeError {
      throw const ApiException.badResponse();
    }
  }

  List<ArticleModel> _parse(http.Response response) {
    final code = response.statusCode;
    if (code == 401) throw const ApiException.invalidKey();
    if (code == 403 || code == 429) throw const ApiException.quotaExceeded();
    if (code >= 500) throw const ApiException.serverError();
    if (code != 200) throw const ApiException.unknown();

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = (body['articles'] ?? []) as List<dynamic>;
    return list
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
