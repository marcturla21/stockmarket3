import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'stockchart.dart';

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  final Map<String, String> companyNames = {
    'AAPL': 'Apple Inc.',
    'ACGL': 'Arch Capital Group Ltd.',
    'GOOGL': 'Alphabet Inc. (Google)',
    'MSFT': 'Microsoft Corporation',
    'TSLA': 'Tesla, Inc.',
    'NFLX': 'Netflix, Inc.',
    'NVDA': 'NVIDIA Corporation',
    'META:NASDAQ': 'Meta Platforms, Inc.',
    'AMD:NASDAQ': 'Advanced Micro Devices, Inc.',
    'ASAN:NYSE': 'Asana, Inc.',
    'ARW:NYSE': 'Arrow Electronics, Inc.',
    'ADBE:NASDAQ': 'Adobe Inc.',
    'NKE:NYSE': 'Nike, Inc.',
    'PINS:NYSE': 'Pinterest, Inc.',
  };

  List<Map<String, dynamic>> stockData = [];

  Future<Map<String, dynamic>> fetchData(String symbol, String token) async {
    final response = await http.get(
      Uri.parse('https://api.iex.cloud/v1/data/CORE/HISTORICAL_PRICES/$symbol?token=$token'),
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(response.body);
      if (responseData.isNotEmpty) {
        List<Map<String, dynamic>> typedData = responseData.cast<Map<String, dynamic>>();
        return {
          'symbol': symbol,
          'data': typedData,
        };
      } else {
        throw Exception('No data available for symbol $symbol');
      }
    } else {
      throw Exception('Failed to load data for symbol $symbol');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final String token = 'sk_59a3217b8d144a2995e9df47b7675b32'; // Your IEX Cloud API token here
    try {
      for (String symbol in companyNames.keys) {
        Map<String, dynamic> data = await fetchData(symbol, token);
        setState(() {
          stockData.add(data);
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: ListView.builder(
        itemCount: stockData.length,
        itemBuilder: (context, index) {
          final data = stockData[index];
          final symbol = data['symbol'];
          final companyData = data['data'];
          final latestData = companyData.isNotEmpty ? companyData[0] : {};
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    final companyName = companyNames[symbol] ?? '';
                    final latestPrice = latestData['close'].toString() ?? '';
                    return StockChart(
                      allHistoricalData: companyData,
                      companySymbol: symbol,
                      companyName: companyName,
                      latestPrice: latestPrice,
                    );
                  },
                ),
              );
            },

            child: Container(
              margin: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data['symbol'] ?? ''}',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${companyNames[symbol] ?? ''}',
                      style: TextStyle(fontSize: 14),
                    ),
                    Text(
                      'Price: ${latestData['close'] ?? ''}',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'High: ${latestData['high'] ?? ''}',
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      'Low: ${latestData['low'] ?? ''}',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
