import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../services/news_service.dart';
import '../widgets/news_future_view.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.query});

  final String query;

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final NewsService _service = NewsService();
  late Future<List<ArticleModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _service.search(widget.query);
  }

  Future<void> _reload() async {
    final future = _service.search(widget.query);
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // error ditampilkan oleh FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hasil: ${widget.query}')),
      body: NewsFutureView(
        future: _future,
        onRetry: _reload,
        onRefresh: _reload,
      ),
    );
  }
}
