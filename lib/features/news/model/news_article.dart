import 'package:equatable/equatable.dart';

class NewsArticle extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String? content;
  final String? author;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String sourceName;
  final bool isBookmarked;

  const NewsArticle({
    required this.id,
    required this.title,
    this.description,
    this.content,
    this.author,
    this.url,
    this.urlToImage,
    this.publishedAt,
    required this.sourceName,
    this.isBookmarked = false,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['url'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      title: json['title'] ?? 'No title',
      description: json['description'],
      content: json['content'],
      author: json['author'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] != null
          ? DateTime.parse(json['publishedAt'])
          : null,
      sourceName: json['source'] is Map
          ? json['source']['name'] ?? 'Unknown source'
          : 'Unknown source',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'source': {'name': sourceName},
      'isBookmarked': isBookmarked,
    };
  }

  NewsArticle copyWith({
    String? id,
    String? title,
    String? description,
    String? content,
    String? author,
    String? url,
    String? urlToImage,
    DateTime? publishedAt,
    String? sourceName,
  }) {
    return NewsArticle(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      content: content ?? this.content,
      author: author ?? this.author,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      sourceName: sourceName ?? this.sourceName,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        content,
        author,
        url,
        urlToImage,
        publishedAt,
        sourceName,
      ];

  String get formattedPublishedDate {
    if (publishedAt == null) return 'No date';
    return '${publishedAt!.day}/${publishedAt!.month}/${publishedAt!.year}';
  }

  String get shortDescription {
    return description?.replaceAll('\n', ' ').substring(
              0,
              description!.length < 100 ? description!.length : 100,
            ) ??
        'No description available';
  }

  bool get hasImage => urlToImage != null && urlToImage!.isNotEmpty;
}
