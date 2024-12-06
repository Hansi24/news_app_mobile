import 'package:flutter/material.dart';
import '../../models/news_model.dart';
import '../news_detail_screen.dart';
import 'package:provider/provider.dart';
import '../../view_models/news_view_model.dart';

class NewsList extends StatefulWidget {
  final List<News> newsList;

  NewsList({required this.newsList});

  @override
  _NewsListState createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  String _currentSortCriteria = 'Date'; // Default sorting by date

  @override
  Widget build(BuildContext context) {
    // Access the NewsViewModel to handle favorites and sorting
    final newsViewModel = Provider.of<NewsViewModel>(context);

    // Sort the newsList based on the current criteria
    List<News> sortedNewsList = List.from(widget.newsList);
    if (_currentSortCriteria == 'Date') {
      sortedNewsList.sort((a, b) => b.publishedAt.compareTo(a.publishedAt)); 
    } else if (_currentSortCriteria == 'Title') {
      sortedNewsList.sort((a, b) => a.title.compareTo(b.title)); 
    }

    return Column(
      children: [
        // Compact Sorting Dropdown
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5.0),
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          height: 40, // Reduced height for the bar
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 242, 239, 237),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Text(
                'Sort By:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown[700],
                ),
              ),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _currentSortCriteria,
                dropdownColor: Colors.brown[50], // Background for dropdown items
                style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                underline: Container(
                  height: 0, // Remove default underline
                ),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _currentSortCriteria = newValue; // Update sorting criteria
                    });
                  }
                },
                items: [
                  DropdownMenuItem(
                    value: 'Date',
                    child: Text('Date'),
                  ),
                  DropdownMenuItem(
                    value: 'Title',
                    child: Text('Title'),
                  ),
                ],
              ),
            ],
          ),
        ),
        // News List
        Expanded(
          child: ListView.builder(
            itemCount: sortedNewsList.length,
            itemBuilder: (context, index) {
              final news = sortedNewsList[index];
              bool isFavorite = newsViewModel.favoriteNews.contains(news);

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Card(
                  elevation: 4,
                  color: Colors.brown[50],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: () {
                      // Navigate to the NewsDetailScreen when a news item is tapped
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NewsDetailScreen(news: news),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Display the image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                          child: news.imageUrl.isNotEmpty
                              ? Image.network(
                                  news.imageUrl,
                                  height: 250,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  height: 150,
                                  color: Colors.brown[100],
                                  child: const Icon(Icons.image, size: 50, color: Colors.brown),
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display the title
                              Text(
                                news.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              // Display the published date
                              Text(
                                news.publishedAt,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.brown[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.brown,
                            ),
                            onPressed: () {
                              // Add or remove news from favorites
                              if (isFavorite) {
                                newsViewModel.removeFromFavorites(news);
                              } else {
                                newsViewModel.addToFavorites(news);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
