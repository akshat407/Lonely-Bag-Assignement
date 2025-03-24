import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../models/news.dart';
import 'news_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search news',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    newsProvider.searchNews('');
                  },
                ),
              ),
              onChanged: (value) => newsProvider.searchNews(value),
            ),
          ),
          Expanded(
            child: newsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: newsProvider.articles.length,
                    itemBuilder: (ctx, index) {
                      final Article article = newsProvider.articles[index];
                      return ListTile(
                        leading: article.urlToImage != null
                            ? Image.network(article.urlToImage!,
                                width: 100, fit: BoxFit.cover)
                            : const Icon(Icons.image_not_supported),
                        title: Text(article.title),
                        subtitle: Text(article.description),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  NewsDetailScreen(article: article),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
