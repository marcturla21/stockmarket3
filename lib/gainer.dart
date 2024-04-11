import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';

class GainerPage extends StatefulWidget {
  final List<Map<String, dynamic>> gainerList;
  const GainerPage({Key? key, required this.gainerList}) : super(key: key);

  @override
  _GainerPageState createState() => _GainerPageState();
}

class _GainerPageState extends State<GainerPage> {
  List<Map<String, dynamic>> gainerList = [];

  @override
  void initState() {
    super.initState();
    fetchGainers();
  }

  Future<void> fetchGainers() async {
    final response = await http.get(Uri.parse('https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=demo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        gainerList = List<Map<String, dynamic>>.from(data['top_gainers']);
      });
    } else {
      throw Exception('Failed to load gainers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gainers'),
      ),
      body: ListView.builder(
        itemCount: gainerList.length,
        itemBuilder: (BuildContext context, int index) {
          final gainer = gainerList[index];
          return Card( // Wrap the ListTile with a Card
            elevation: 2, // Add some elevation for a shadow effect
            margin: EdgeInsets.all(8), // Add margin around the Card
            child: ListTile(
              title: Text(gainer['ticker']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${gainer['price']}'),
                  Text('Change Amount: ${gainer['change_amount']}'),
                  Text('Change Percentage: ${gainer['change_percentage']}'),
                  Text('Volume: ${gainer['volume']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}