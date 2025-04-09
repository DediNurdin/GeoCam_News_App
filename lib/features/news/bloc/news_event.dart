import 'package:equatable/equatable.dart';
import 'package:geo_cam_news/features/news/model/news_article.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();

  @override
  List<Object> get props => [];
}

class FetchNews extends NewsEvent {}

class RefreshNews extends NewsEvent {}

class BookmarkNews extends NewsEvent {
  final NewsArticle article;

  const BookmarkNews(this.article);

  @override
  List<Object> get props => [article];
}

class LoadBookmarkedNews extends NewsEvent {}
