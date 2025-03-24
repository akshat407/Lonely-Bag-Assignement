import 'package:flutter/material.dart';
import '../models/news.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = false;
  bool _isRefreshing = false;  
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  bool get isRefreshing => _isRefreshing;  

  Future<void> fetchNews() async {
    if (_isRefreshing) return;  // Prevent multiple refresh triggers
    _isRefreshing = true;
    notifyListeners();

    try {
      _isLoading = true;
      _articles = await _newsService.fetchNews(country: 'us');
    } catch (e) {
      print('Failed to fetch news: $e');
    } finally {
      _isLoading = false;
      _isRefreshing = false;  
      notifyListeners();
    }
  }
}
