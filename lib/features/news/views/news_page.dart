import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import 'news_list.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  final RefreshController _newsRefreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(FetchNews());
  }

  @override
  void dispose() {
    _newsRefreshController.dispose();
    super.dispose();
  }

  void _onNewsRefresh() async {
    context.read<NewsBloc>().add(RefreshNews());
    _newsRefreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return buildNews();
  }

  Widget buildNews() {
    return BlocConsumer<NewsBloc, NewsState>(
      listener: (context, state) {
        if (state is NewsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is NewsLoaded) {
          return SmartRefresher(
            controller: _newsRefreshController,
            onRefresh: _onNewsRefresh,
            child: NewsList(articles: state.articles),
          );
        } else if (state is NewsError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
