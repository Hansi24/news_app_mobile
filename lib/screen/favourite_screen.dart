import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/news_view_model.dart';
import '../models/news_model.dart';

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the NewsViewModel to get the list of favorite news
    final newsViewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 120, 93, 80),
        actions: [
          // Refresh action
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              newsViewModel.fetchAllNews();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(255, 185, 191, 164), const Color.fromARGB(255, 230, 233, 170)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: newsViewModel.favoriteNews.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/empty_favorites.png', // Use a friendly illustration for empty state
                      width: 200,
                      height: 200,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'No favorite articles yet!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  newsViewModel.fetchAllNews();
                },
                child: ListView.builder(
                  itemCount: newsViewModel.favoriteNews.length,
                  itemBuilder: (context, index) {
                    final News news = newsViewModel.favoriteNews[index];

                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      elevation: 8,
                      shadowColor: const Color.fromARGB(255, 53, 54, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16),
                        leading: news.imageUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  news.imageUrl,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) => Icon(
                                    Icons.image_not_supported,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Icon(Icons.image, size: 40, color: Colors.grey),
                        title: Text(
                          news.title,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            news.description,
                            style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.favorite,
                            color: Colors.red.shade400,
                          ),
                          onPressed: () {
                            // Confirm before removing from favorites
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Remove from Favorites'),
                                content: Text(
                                    'Are you sure you want to remove this article from your favorites?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      newsViewModel.removeFromFavorites(news);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
