import 'package:equatable/equatable.dart';
import '../model/news_article.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<NewsArticle> articles;
  final String? error;

  const NewsLoaded(this.articles, {this.error});

  NewsLoaded copyWith({List<NewsArticle>? articles, String? error}) {
    return NewsLoaded(articles ?? this.articles, error: error ?? this.error);
  }

  @override
  List<Object> get props => [articles, error ?? ''];
}

class NewsError extends NewsState {
  final String message;

  const NewsError(this.message);

  @override
  List<Object> get props => [message];
}
