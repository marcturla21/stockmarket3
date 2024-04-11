import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';


class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<Map<String, dynamic>>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = _fetchNews();
  }

  Future<List<Map<String, dynamic>>> _fetchNews() async {
    final response = await http.get(Uri.parse(NewsAPI.newsSentimentURL));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> feed = data['feed'];
      return List<Map<String, dynamic>>.from(feed);
    } else {
      throw Exception('Failed to load news');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Market News'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final news = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    // Show message box
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(news['title']),
                          content: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Summary: ${news['summary']}'),
                              SizedBox(height: 10),
                              Text('Source: ${news['source']}'),
                              SizedBox(height: 10),
                              Text('Published Time: ${news['time_published']}'),
                              SizedBox(height: 10),
                              Text('Overall Sentiment: ${news['overall_sentiment_label']}'),
                              SizedBox(height: 10),
                              Text('Authors: ${news['authors'].join(', ')}'),
                              SizedBox(height: 10),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click, // Change cursor to indicate clickable
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      margin: EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                          news['title'],
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          news['summary'],
                          style: TextStyle(fontSize: 14),
                        ),
                        trailing: Text(
                          news['authors'].join(', '),
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class NewsAPI {
  static const String newsSentimentURL =
      'https://www.alphavantage.co/query?function=NEWS_SENTIMENT&tickers=AAPL&apikey=demo';
}