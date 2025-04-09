import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:geo_cam_news/features/news/model/news_article.dart';
import 'package:geo_cam_news/features/news/views/news_detail.dart';

class NewsList extends StatelessWidget {
  final List<NewsArticle> articles;

  const NewsList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return Card(
          margin: const EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsDetailPage(article: article),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (article.urlToImage != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        article.urlToImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .then(delay: 100.ms)
                        .slide(begin: const Offset(0, 0.1)),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .then(delay: 200.ms)
                      .slide(begin: const Offset(0, 0.1)),
                  const SizedBox(height: 4),
                  Text(
                    article.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )
                      .animate()
                      .fadeIn(duration: 300.ms)
                      .then(delay: 300.ms)
                      .slide(begin: const Offset(0, 0.1)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.sourceName,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ).animate().scale(delay: (100 * index).ms).then(delay: 100.ms).fadeIn();
      },
    );
  }
}
