import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../models/news_category.dart';
import '../services/news_service.dart';
import '../widgets/news_future_view.dart';
import 'search_result_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _service = NewsService();

  /// Cache hasil per kategori agar kembali ke chip yang sama
  /// tidak memicu request baru (hemat kuota).
  final Map<String, Future<List<ArticleModel>>> _cache = {};

  String _category = NewsCategory.defaultCategory.key;
  late Future<List<ArticleModel>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load(_category);
  }

  Future<List<ArticleModel>> _load(String category) {
    return _cache.putIfAbsent(category, () {
      final future = _service.fetchByCategory(category);
      // Future yang gagal dibuang dari cache supaya bisa dicoba lagi.
      future.catchError((_) {
        _cache.remove(category);
        return <ArticleModel>[];
      });
      return future;
    });
  }

  void _selectCategory(String key) {
    if (key == _category) return;
    setState(() {
      _category = key;
      _future = _load(key); // dari cache bila sudah pernah dimuat
    });
  }

  /// Dipakai tombol "Coba Lagi" dan pull-to-refresh: paksa request baru.
  Future<void> _reload() async {
    _cache.remove(_category);
    final future = _load(_category);
    setState(() => _future = future);
    try {
      await future;
    } catch (_) {
      // error ditampilkan oleh FutureBuilder
    }
  }

  Future<void> _openSearch() async {
    final query = await showDialog<String>(
      context: context,
      builder: (_) => const _SearchDialog(),
    );
    if (query == null || query.trim().isEmpty || !mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: query.trim())),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Indonesia'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari berita',
            onPressed: _openSearch,
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: NewsCategory.all.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final category = NewsCategory.all[i];
                return ChoiceChip(
                  label: Text(category.label),
                  selected: category.key == _category,
                  onSelected: (_) => _selectCategory(category.key),
                );
              },
            ),
          ),
          Expanded(
            child: NewsFutureView(
              future: _future,
              onRetry: _reload,
              onRefresh: _reload,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchDialog extends StatefulWidget {
  const _SearchDialog();

  @override
  State<_SearchDialog> createState() => _SearchDialogState();
}

class _SearchDialogState extends State<_SearchDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cari Berita'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: const InputDecoration(hintText: 'Kata kunci, mis. AI'),
        textInputAction: TextInputAction.search,
        onSubmitted: (v) => Navigator.pop(context, v),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Cari'),
        ),
      ],
    );
  }
}
