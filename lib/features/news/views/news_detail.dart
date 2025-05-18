import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../model/news_article.dart';
import 'package:intl/intl.dart';

class NewsDetailPage extends StatelessWidget {
  final NewsArticle article;

  const NewsDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.sourceName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.hasImage)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  placeholder: (context, url) =>
                      Container(height: 200, color: Colors.grey[200]),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    child: const Icon(Icons.error),
                  ),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Text(
              article.title,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 16),
                const SizedBox(width: 4),
                Text(
                  article.author ?? 'Unknown author',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(
                  DateFormat(
                    'MMM d, y',
                  ).format(article.publishedAt ?? DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              article.description ?? '',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 20),
            if (article.content != null)
              Text(
                article.content!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
