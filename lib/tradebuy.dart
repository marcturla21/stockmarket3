import 'package:flutter/material.dart';

// Define a class to represent a transaction record
class TransactionRecord {
  final String companyName;
  final int quantity;
  final double totalPrice;

  TransactionRecord({
    required this.companyName,
    required this.quantity,
    required this.totalPrice,
  });
}

// Create a list to hold the transaction records
List<TransactionRecord> transactionRecords = [];

// Create a StatefulWidget for displaying the transaction records
class TradeBuy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buy Transactions'),
      ),
      body: ListView.builder(
        itemCount: transactionRecords.length,
        itemBuilder: (context, index) {
          // Display each transaction record in a ListTile
          return ListTile(
            title: Text(transactionRecords[index].companyName),
            subtitle: Text('Quantity: ${transactionRecords[index].quantity.toString()}'),
            trailing: Text('Total Price: P ${transactionRecords[index].totalPrice.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}