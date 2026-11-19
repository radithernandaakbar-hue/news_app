import 'package:flutter/material.dart';

import '../models/article_model.dart';
import '../screens/detail_screen.dart';
import '../services/api_exception.dart';
import 'article_card.dart';

/// Menampilkan 4 state dari sebuah Future: loading, error, kosong, dan data.
/// Future-nya dibuat & disimpan oleh State parent, BUKAN di build().
class NewsFutureView extends StatelessWidget {
  const NewsFutureView({
    super.key,
    required this.future,
    required this.onRetry,
    required this.onRefresh,
  });

  final Future<List<ArticleModel>> future;
  final VoidCallback onRetry;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ArticleModel>>(
      future: future,
      builder: (context, snapshot) {
        // 1. LOADING
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        // 2. ERROR
        if (snapshot.hasError) {
          final error = snapshot.error;
          final apiError =
              error is ApiException ? error : const ApiException.unknown();
          return _refreshable(
            _Message(
              icon: _iconFor(apiError.type),
              text: apiError.message,
              action: FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
              ),
            ),
          );
        }

        // 3. KOSONG
        final articles = snapshot.data ?? [];
        if (articles.isEmpty) {
          return _refreshable(
            const _Message(
              icon: Icons.inbox_outlined,
              text: 'Tidak ada berita yang ditemukan.',
            ),
          );
        }

        // 4. DATA
        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: articles.length,
            itemBuilder: (context, i) => ArticleCard(
              article: articles[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(article: articles[i]),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Membungkus pesan dengan RefreshIndicator supaya pull-to-refresh
  /// tetap berfungsi pada state error / kosong.
  Widget _refreshable(Widget child) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }

  IconData _iconFor(ApiErrorType type) {
    switch (type) {
      case ApiErrorType.noConnection:
        return Icons.wifi_off;
      case ApiErrorType.timeout:
        return Icons.timer_off_outlined;
      case ApiErrorType.invalidKey:
        return Icons.vpn_key_off;
      case ApiErrorType.quotaExceeded:
        return Icons.block;
      case ApiErrorType.serverError:
        return Icons.cloud_off;
      case ApiErrorType.badResponse:
      case ApiErrorType.unknown:
        return Icons.error_outline;
    }
  }
}

class _Message extends StatelessWidget {
  const _Message({required this.icon, required this.text, this.action});

  final IconData icon;
  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: Colors.grey),
          const SizedBox(height: 12),
          Text(text, textAlign: TextAlign.center),
          if (action != null) ...[const SizedBox(height: 16), action!],
        ],
      ),
    );
  }
}
