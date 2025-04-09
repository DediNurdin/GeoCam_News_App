import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geo_cam_news/features/news/repository/news_repository.dart';

import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;

  NewsBloc(this.newsRepository) : super(NewsInitial()) {
    on<FetchNews>(_onFetchNews);
    on<RefreshNews>(_onRefreshNews);
  }

  Future<void> _onFetchNews(FetchNews event, Emitter<NewsState> emit) async {
    emit(NewsLoading());
    try {
      final articles = await newsRepository.fetchNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onRefreshNews(
    RefreshNews event,
    Emitter<NewsState> emit,
  ) async {
    try {
      final articles = await newsRepository.fetchNews();
      emit(NewsLoaded(articles));
    } catch (e) {
      emit(
        state is NewsLoaded
            ? (state as NewsLoaded).copyWith(error: e.toString())
            : NewsError(e.toString()),
      );
    }
  }
}
