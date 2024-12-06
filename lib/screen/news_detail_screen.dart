import 'package:flutter/material.dart';
import '../../models/news_model.dart';

class NewsDetailScreen extends StatefulWidget {
  final News news;

  NewsDetailScreen({required this.news});

  @override
  _NewsDetailScreenState createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  int likeCount = 0; // Counter for likes
  int dislikeCount = 0; // Counter for dislikes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("News Details"),
        backgroundColor: const Color.fromARGB(255, 120, 93, 80),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Text(
                widget.news.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 10),
              // Author and Date Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.news.author.isNotEmpty
                        ? "By ${widget.news.author}"
                        : "Unknown Author",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Colors.brown,
                    ),
                  ),
                  Text(
                    widget.news.publishedAt,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Like, Dislike, and Share Buttons in Left Corner
              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    // Like Button
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_up,
                            color: likeCount > 0 ? Colors.green : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              likeCount++;
                            });
                          },
                        ),
                        Text(
                          "$likeCount",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Dislike Button
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.thumb_down,
                            color: dislikeCount > 0 ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              dislikeCount++;
                            });
                          },
                        ),
                        Text(
                          "$dislikeCount",
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    // Share Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Add functionality for sharing
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 215, 161, 134),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      icon: const Icon(Icons.share, color: Colors.white),
                      label: const Text(
                        "Share",
                        style: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              // News Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: widget.news.imageUrl.isNotEmpty
                    ? Image.network(widget.news.imageUrl, fit: BoxFit.cover)
                    : Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
              ),
              const SizedBox(height: 16),
              // Divider
              const Divider(thickness: 1.5),
              const SizedBox(height: 8),
              // Content Section
              Text(
                widget.news.content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5, // Adjust line spacing
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
