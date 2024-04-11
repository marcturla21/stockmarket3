import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BalanceProvider extends ChangeNotifier {
  double balance = 10000.0;

  void updateBalance(double newBalance) {
    balance = newBalance;
    notifyListeners();
  }
}

class TransactionProvider extends ChangeNotifier {
  List<TransactionRecord> transactions = [];

  void addTransaction(TransactionRecord transaction) {
    transactions.add(transaction);
    notifyListeners();
  }

  void removeTransaction(TransactionRecord transaction) {
    transactions.remove(transaction);
    notifyListeners();
  }
}

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
