import 'package:flutter/material.dart';

import '../models/article_model.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({super.key, required this.article, required this.onTap});

  final ArticleModel article;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 110,
              child: article.image.isEmpty
                  ? const _ImagePlaceholder()
                  : Image.network(
                      article.image,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      article.sourceName,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) => Container(
        color: Colors.grey.shade300,
        child: const Icon(Icons.image_not_supported_outlined),
      );
}
