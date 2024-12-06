import 'package:flutter/foundation.dart';
import '../models/news_model.dart';
import '../services/api_service.dart';

class NewsViewModel extends ChangeNotifier {
  final ApiService apiService = ApiService();

  List<News> _newsList = [];
  List<News> _favoriteNews = [];
  bool _isLoading = false;
  String _currentCategory = "All";

  // Public getters
  List<News> get newsList => _newsList;
  List<News> get favoriteNews => _favoriteNews;
  bool get isLoading => _isLoading;
  String get currentCategory => _currentCategory;

  // Fetch all news
  Future<void> fetchAllNews() async {
    _setLoading(true); // Show loading indicator
    try {
      _currentCategory = "All"; // Update the current category to "All"
      final articles = await ApiService.fetchNews(''); // Fetch all news
      _newsList = articles.map((json) => News.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching news: $e');
    } finally {
      _setLoading(false); // Hide loading indicator
    }
  }

  // Add news to favorites
  void addToFavorites(News news) {
    if (!_favoriteNews.contains(news)) {
      _favoriteNews.add(news);
      notifyListeners();
    }
  }

  // Remove news from favorites
  void removeFromFavorites(News news) {
    _favoriteNews.remove(news);
    notifyListeners();
  }

  // Fetch news by category
  Future<void> fetchNewsByCategory(String category) async {
    _setLoading(true);
    try {
      _currentCategory = category; // Update current category
      final articles = await ApiService.fetchNews(category.toLowerCase());
      _newsList = articles.map((json) => News.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching news for $category: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Helper to manage loading state
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  List<News> _allNews = []; 
  List<News> _filteredNews = []; // Filtered and sorted news list

  List<News> get allNews => _allNews;
  List<News> get filteredNews => _filteredNews;

  void setNews(List<News> news) {
    _allNews = news;
    _filteredNews = List.from(_allNews);
    notifyListeners();
  }

   // Sort news based on the selected criteria
  void sortNews(String criteria) {
    switch (criteria) {
      case 'Date':
        _filteredNews.sort((a, b) => b.date.compareTo(a.date)); // Sort by latest date
        break;
      case 'Title':
        _filteredNews.sort((a, b) => a.title.compareTo(b.title)); // Alphabetical order
        break;
      case 'Popularity':
        _filteredNews.sort((a, b) => b.popularity.compareTo(a.popularity)); // High to low popularity
        break;
      default:
        _filteredNews = List.from(_allNews); // Reset to original list
    }
    notifyListeners();
  }

}
