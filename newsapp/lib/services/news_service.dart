import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';  

class NewsService {
  final String baseUrl = 'https://newsapi.org/v2/top-headlines';

  Future<List<Article>> fetchNews({String country = 'us'}) async {
    final String apiKey = dotenv.env['NEWS_API_KEY'] ?? ''; 

    if (apiKey.isEmpty) {
      throw Exception('API Key not found');
    }

    final url = Uri.parse('$baseUrl?country=$country&apiKey=$apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Article> articles = (data['articles'] as List)
            .map((json) => Article.fromJson(json))
            .toList();
        return articles;
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
