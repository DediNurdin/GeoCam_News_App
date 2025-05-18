import '../model/news_article.dart';
import '../model/news_response.dart';
import '../../../services/storage_services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsRepository {
  final StorageService storageService;
  final String apiKey = '989a5e51bc4f44ac9fcf494992f1ceff';
  final String baseUrl = 'https://newsapi.org/v2';

  NewsRepository({required this.storageService});

  Future<List<NewsArticle>> fetchNews() async {
    final response = await http.get(
      Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      final newsResponse = NewsResponse.fromJson(json.decode(response.body));

      return newsResponse.articles.map((article) {
        return article;
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
