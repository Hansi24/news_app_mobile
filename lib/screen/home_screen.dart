import 'package:flutter/material.dart';
import 'package:news_app/screen/favourite_screen.dart';
import 'package:provider/provider.dart';
import '../view_models/news_view_model.dart';
import 'widgets/news_list.dart';
import 'category_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {"name": "All", "icon": Icons.article},
    {"name": "Business", "icon": Icons.business},
    {"name": "Entertainment", "icon": Icons.movie},
    {"name": "Health", "icon": Icons.health_and_safety},
    {"name": "Science", "icon": Icons.science},
    {"name": "Sports", "icon": Icons.sports},
    {"name": "Technology", "icon": Icons.devices},
  ];

  int selectedCategoryIndex = 0; 
  @override
  void initState() {
    super.initState();
    final newsViewModel = Provider.of<NewsViewModel>(context, listen: false);
    newsViewModel.fetchAllNews(); 
  }

  @override
  Widget build(BuildContext context) {
    final newsViewModel = Provider.of<NewsViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Top News...',
          style: TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.bold, 
            color: Colors.white, 
            fontFamily: 'Roboto', // Use a custom font (if added to your project)
            letterSpacing: 1.2, // Add some spacing between letters
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 120, 93, 80),
        actions: [
          // Search bar in the app bar
                    IconButton(
            icon: const Icon(
              Icons.search,
              size: 28, // Slightly larger icon size
              color: Colors.white, // White color for better visibility
            ),
            onPressed: () {
              showSearch(
                context: context,
                delegate: NewsSearch(newsViewModel: newsViewModel),
              );
            },
            tooltip: 'Search News', 
          ),
          

          // Favorite button to open the favorite screen
          IconButton(
            icon: Icon(Icons.favorite_border,
            size: 28, 
              color: Colors.white, 
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Categories Horizontal List with active category indicator
          Container(
            color: const Color.fromARGB(255, 4, 19, 44).withOpacity(0.1),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategoryIndex = index;
                      });
                      if (category['name'] == "All") {
                        // Fetch all news when "All" category is selected
                        newsViewModel.fetchAllNews();
                      } else {
                        // Navigate to the CategoryScreen when a specific category is selected
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(category: category['name']),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: selectedCategoryIndex == index
                                ? const Color.fromARGB(255, 219, 101, 66)
                                : const Color.fromARGB(255, 91, 36, 2).withOpacity(0.2),
                            child: Icon(category['icon'],
                                color: selectedCategoryIndex == index
                                    ? Colors.white
                                    : const Color.fromARGB(255, 20, 8, 1)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            category['name'],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: selectedCategoryIndex == index
                                  ? const Color.fromARGB(255, 65, 17, 2)
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Pull to Refresh functionality for News List
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                newsViewModel.fetchAllNews(); // Refresh the news list
              },
              child: newsViewModel.isLoading
                  ? Center(child: CircularProgressIndicator())
                  : newsViewModel.newsList.isEmpty
                      ? Center(child: Text('No news available.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                      : NewsList(newsList: newsViewModel.newsList),
            ),
          ),
        ],
      ),
      // Floating Action Button for quick actions like refreshing the news
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add any action here, for example, refreshing the news list
          newsViewModel.fetchAllNews();
        },
        child: Icon(Icons.refresh),
        backgroundColor:  Color.fromARGB(255, 221, 165, 109),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        ],
        onTap: (index) {
          // Handle bottom navigation actions
          if (index == 0) {
            // Navigate to Home Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          } else if (index == 1) {
            // Navigate to Favorite Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FavoriteScreen()),
            );
          }
        },
      ),
    );
  }
}

class NewsSearch extends SearchDelegate {
  final NewsViewModel newsViewModel;

  NewsSearch({required this.newsViewModel});

  @override
  String get searchFieldLabel => 'Search News...';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredNews = newsViewModel.newsList
        .where((article) => article.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return filteredNews.isEmpty
        ? Center(child: Text('No results found.'))
        : NewsList(newsList: filteredNews);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // You can add a custom suggestion widget if needed
  }
}
