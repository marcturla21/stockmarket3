import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoserPage extends StatefulWidget {
  const LoserPage({Key? key}) : super(key: key);

  @override
  _LoserPageState createState() => _LoserPageState();
}

class _LoserPageState extends State<LoserPage> {
  List<Map<String, dynamic>> loserList = [];

  @override
  void initState() {
    super.initState();
    fetchLosers();
  }

  Future<void> fetchLosers() async {
    final response = await http.get(Uri.parse('https://www.alphavantage.co/query?function=TOP_GAINERS_LOSERS&apikey=demo'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        loserList = List<Map<String, dynamic>>.from(data['top_losers']);
      });
    } else {
      throw Exception('Failed to load losers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Losers'),
      ),
      body: ListView.builder(
        itemCount: loserList.length,
        itemBuilder: (BuildContext context, int index) {
          final loser = loserList[index];
          return Card(
            elevation: 2,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text(loser['ticker']),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Price: ${loser['price']}'),
                  Text('Change Amount: ${loser['change_amount']}'),
                  Text('Change Percentage: ${loser['change_percentage']}'),
                  Text('Volume: ${loser['volume']}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}