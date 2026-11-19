import 'package:flutter/material.dart';

import '../models/article_model.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.article});

  final ArticleModel article;

  String _formatDate(DateTime? d) {
    if (d == null) return '';
    final local = d.toLocal();
    return '${local.day}/${local.month}/${local.year}';
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Berita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article.image,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            const SizedBox(height: 16),
            Text(article.title, style: textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              '${article.sourceName}  •  ${_formatDate(article.publishedAt)}',
              style: textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(article.description, style: textTheme.bodyLarge),
            const SizedBox(height: 12),
            Text(article.content),
            const SizedBox(height: 16),
            const Text('Baca selengkapnya:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SelectableText(article.url),
          ],
        ),
      ),
    );
  }
}
