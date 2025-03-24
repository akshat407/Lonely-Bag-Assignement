import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  List<Article> _filteredArticles = [];
  bool _isLoading = false;

  List<Article> get articles => _filteredArticles;
  bool get isLoading => _isLoading;

  Future<void> fetchNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await _newsService.fetchNews();
      _filteredArticles = _articles;  // Initially show all articles
    } catch (e) {
      _articles = [];
      _filteredArticles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // New method to filter articles by search term
  void searchNews(String query) {
    if (query.isEmpty) {
      _filteredArticles = _articles;  // Reset to all articles
    } else {
      _filteredArticles = _articles
          .where((article) =>
              article.title.toLowerCase().contains(query.toLowerCase()) ||
              article.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}

