import 'package:equatable/equatable.dart';
import 'news_article.dart';

class NewsResponse extends Equatable {
  final String status;
  final int totalResults;
  final List<NewsArticle> articles;

  const NewsResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  factory NewsResponse.fromJson(Map<String, dynamic> json) {
    return NewsResponse(
      status: json['status'] ?? 'error',
      totalResults: json['totalResults'] ?? 0,
      articles: (json['articles'] as List<dynamic>?)
              ?.map((articleJson) => NewsArticle.fromJson(articleJson))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((article) => article.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, totalResults, articles];

  bool get isSuccess => status == 'ok';
  bool get hasArticles => articles.isNotEmpty;
}
