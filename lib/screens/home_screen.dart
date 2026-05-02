import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/article.dart';
import '../services/news_api_service.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Map<String, String> _countries = {
    'et': 'Ethiopia',
    'us': 'United States',
    'in': 'India',
    'gb': 'United Kingdom',
    'ca': 'Canada',
    'au': 'Australia',
  };

  String _selectedCountry = 'et';
  late Future<List<Article>> _headlinesFuture;

  @override
  void initState() {
    super.initState();
    _fetchHeadlines();
  }

  void _fetchHeadlines() {
    _headlinesFuture = NewsApiService.getTopHeadlines(_selectedCountry);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Headlines'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCountry,
                dropdownColor: Theme.of(context).colorScheme.surface,
                icon: Icon(Icons.arrow_drop_down, color: Theme.of(context).colorScheme.onPrimary),
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16),
                selectedItemBuilder: (BuildContext context) {
                  return _countries.keys.map<Widget>((String item) {
                    return Center(
                      child: Text(
                        _countries[item]!,
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    );
                  }).toList();
                },
                items: _countries.entries.map((entry) {
                  return DropdownMenuItem<String>(
                    value: entry.key,
                    child: Text(entry.value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null && newValue != _selectedCountry) {
                    setState(() {
                      _selectedCountry = newValue;
                      _fetchHeadlines();
                    });
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Article>>(
        future: _headlinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _fetchHeadlines();
                        });
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No headlines found.'));
          }

          final articles = snapshot.data!;
          return ListView.builder(
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(8),
                  leading: article.urlToImage.isNotEmpty
                      ? SizedBox(
                          width: 80,
                          child: CachedNetworkImage(
                            imageUrl: article.urlToImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.image_not_supported),
                          ),
                        )
                      : const SizedBox(width: 80, child: Icon(Icons.image_not_supported)),
                  title: Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    article.sourceName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailScreen(article: article),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}