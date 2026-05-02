import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/article.dart';

class NewsApiService {
  static const String baseUrl = 'https://newsapi.org/v2';

  static String get apiKey {
    return dotenv.env['NEWS_API_KEY'] ?? '';
  }

  static final Map<String, String> _countryNames = {
    'us': 'United States',
    'in': 'India',
    'gb': 'United Kingdom',
    'ca': 'Canada',
    'au': 'Australia',
    'et': 'Ethiopia',
  };

  static Future<List<Article>> getTopHeadlines(String country) async {
    if (apiKey.isEmpty || apiKey == 'your_api_key_here') throw Exception('Please configure a valid API Key in the .env file');
    
    Uri url;
    if (country == 'us') {
      url = Uri.parse('$baseUrl/top-headlines?country=us&apiKey=$apiKey');
    } else {
      final query = _countryNames[country] ?? 'News';
      url = Uri.parse('$baseUrl/everything?q=$query&sortBy=publishedAt&apiKey=$apiKey');
    }
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        final List<dynamic> articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to load headlines');
      }
    } else {
      throw Exception('Failed to load headlines: ${response.statusCode}');
    }
  }

  static Future<List<Article>> searchArticles(String query) async {
    if (apiKey.isEmpty || apiKey == 'your_api_key_here') throw Exception('Please configure a valid API Key in the .env file');
    
    final url = Uri.parse('$baseUrl/everything?q=$query&apiKey=$apiKey&pageSize=20');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        final List<dynamic> articlesJson = data['articles'];
        return articlesJson.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception(data['message'] ?? 'Failed to search articles');
      }
    } else {
      throw Exception('Failed to search articles: ${response.statusCode}');
    }
  }
}
