import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'buysell.dart';
import 'package:provider/provider.dart';


class StockChart extends StatefulWidget {
  final List<Map<String, dynamic>> allHistoricalData;
  final String companySymbol;
  final String companyName;
  final String latestPrice;

  StockChart({
    required this.allHistoricalData,
    required this.companySymbol,
    required this.companyName,
    required this.latestPrice,
  });

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  late List<Map<String, dynamic>> historicalData = [];

  @override
  void initState() {
    super.initState();
    _fetchHistoricalData();
  }

  Future<void> _fetchHistoricalData() async {
    try {
      final Uri uri = Uri.parse(
          'https://api.iex.cloud/v1/data/core/historical_prices/${widget.companySymbol}?range=2m&token=sk_59a3217b8d144a2995e9df47b7675b32');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        setState(() {
          historicalData =
          List<Map<String, dynamic>>.from(jsonDecode(response.body));
          historicalData = historicalData.reversed.toList(); // Reverse the list
        });
      } else {
        throw Exception('Failed to load historical data');
      }
    } catch (e) {
      print('Error: $e');
      // You can handle the error here, such as showing a snackbar or retry option.
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Line Chart'),
      ),
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, _) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: EdgeInsets.all(16.0),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Company: ${widget.companyName}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Latest Price: ${widget.latestPrice}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16.0), // Add some spacing below the latest price
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuySell(
                              companyName: widget.companyName,
                              latestPrice: widget.latestPrice,
                            ),
                          ),
                        );
                      },
                      child: Text('Trade'),
                    ),
                    SizedBox(height: 16.0), // Add some spacing below the trade button
                    Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.white10,
                      child: Text('Bought Stocks: ${_getBoughtStocks(transactionProvider)}'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: historicalData.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(show: true),
                      titlesData: FlTitlesData(
                        bottomTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTextStyles: (BuildContext context, double value) => const TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          getTitles: (double value) {
                            int index = value.toInt();
                            if (index >= 0 && index < historicalData.length) {
                              DateTime date = DateTime.parse(historicalData[index]['priceDate']);
                              return '${date.month.toString().padLeft(2, '0')}/\n${date.day.toString().padLeft(2, '0')}/${date.year.toString().substring(2)}';
                            }
                            return '';
                          },
                          margin: 8,
                        ),
                        leftTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 28,
                          getTextStyles: (BuildContext context, double value) => const TextStyle(
                            color: Color(0xff68737d),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          getTitles: (double value) {
                            return value.toStringAsFixed(2);
                          },
                          margin: 8,
                        ),
                      ),
                      borderData: FlBorderData(show: true),
                      lineBarsData: _generateLineBarsData(historicalData),
                      minX: 0,
                      maxX: historicalData.length.toDouble(),
                      minY: 0,
                      maxY: _findMaxY(historicalData) ?? 0,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<LineChartBarData> _generateLineBarsData(List<Map<String, dynamic>> data) {
    List<LineChartBarData> lineBarsData = [];
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
      dynamic price = data[i]['close']; // Price can be either int or double
      spots.add(FlSpot(i.toDouble(), price.toDouble())); // Convert to double
    }

    spots = spots.reversed.toList(); // Reverse the list of spots

    List<Color> colors = [];

    for (int i = 1; i < spots.length; i++) {
      if (spots[i].y > spots[i - 1].y) {
        colors.add(Colors.green); // Color green for upward movement
      } else {
        colors.add(Colors.red); // Color red for downward movement
      }
    }

    LineChartBarData lineChartBarData = LineChartBarData(
      spots: spots,
      isCurved: true,
      colors: colors,
      barWidth: 4,
      belowBarData: BarAreaData(show: false),
    );

    lineBarsData.add(lineChartBarData);

    return lineBarsData;
  }


  double? _findMaxY(List<Map<String, dynamic>> data) {
    double? maxY;
    for (var entry in data) {
      dynamic price = entry['close'];
      if (price is num && (maxY == null || price > maxY)) {
        maxY = price.toDouble(); // Convert to double
      }
    }
    return maxY;
  }

  int _getBoughtStocks(TransactionProvider transactionProvider) {
    List<TransactionRecord>? transactions = transactionProvider.companyTransactions[widget.companyName];
    if (transactions != null && transactions.isNotEmpty) {
      int boughtStocks = 0;
      for (var transaction in transactions) {
        if (transaction.quantity > 0) {
          boughtStocks += transaction.quantity;
        }
      }
      return boughtStocks;
    } else {
      return 0;
    }
  }
}