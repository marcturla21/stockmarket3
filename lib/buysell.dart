import 'tradebuy.dart';
import 'balance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

class TransactionProvider extends ChangeNotifier {
  Map<String, List<TransactionRecord>> companyTransactions = {};

  void addTransaction(TransactionRecord transaction) {
    if (!companyTransactions.containsKey(transaction.companyName)) {
      companyTransactions[transaction.companyName] = [];
    }
    companyTransactions[transaction.companyName]!.add(transaction);
    notifyListeners();
  }

  void removeTransaction(TransactionRecord transaction) {
    if (companyTransactions.containsKey(transaction.companyName)) {
      companyTransactions[transaction.companyName]!.remove(transaction);
      notifyListeners();
    }
  }
}


class BuySell extends StatefulWidget {
  final String companyName;
  final String latestPrice;

  BuySell({
    required this.companyName,
    required this.latestPrice,
  });

  @override
  _BuySellState createState() => _BuySellState();
}

class _BuySellState extends State<BuySell> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade'),
      ),
      body: Consumer2<BalanceProvider, TransactionProvider>(
        builder: (context, balanceProvider, transactionProvider, _) {
          double balance = balanceProvider.balance;
          List<TransactionRecord>? companyTransactions = transactionProvider.companyTransactions[widget.companyName];

          return Center( // Wrap the Column with Center widget
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align the items to center
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Balance: P ${balance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Company: ${widget.companyName}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Latest Price: ${widget.latestPrice}'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) => BuyFormModal(
                        companyName: widget.companyName,
                        latestPrice: widget.latestPrice,
                        balanceProvider: balanceProvider,
                        onBuy: (TransactionRecord transaction) {
                          transactionProvider.addTransaction(transaction);
                        },
                      ),
                    );
                  },
                  child: Text('Buy'),
                ),
                ElevatedButton(
                  onPressed: companyTransactions != null && companyTransactions.isNotEmpty ? () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) => SellFormModal(
                        companyName: widget.companyName,
                        latestPrice: widget.latestPrice,
                        balanceProvider: balanceProvider,
                        transactionProvider: transactionProvider,
                      ),
                    );
                  } : null,
                  child: Text('Sell'),
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}



class BuyFormModal extends StatefulWidget {
  final String companyName;
  final String latestPrice;
  final BalanceProvider balanceProvider;
  final Function(TransactionRecord) onBuy;

  const BuyFormModal({
    Key? key,
    required this.companyName,
    required this.latestPrice,
    required this.balanceProvider,
    required this.onBuy,
  });

  @override
  _BuyFormModalState createState() => _BuyFormModalState();
}

class _BuyFormModalState extends State<BuyFormModal> {
  int _selectedQuantity = 1;

  double calculateTotalPrice(double price, int quantity) {
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    double price = double.parse(widget.latestPrice);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Align the items to center
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Company: ${widget.companyName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Latest Price: ${widget.latestPrice}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Balance: P ${widget.balanceProvider.balance.toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Align the items to center
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedQuantity > 1) {
                        _selectedQuantity--;
                      }
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                SizedBox(width: 10.0),
                Text(
                  '$_selectedQuantity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _selectedQuantity++;
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Price: P ${calculateTotalPrice(price, _selectedQuantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                double totalPrice = calculateTotalPrice(price, _selectedQuantity);
                if (totalPrice <= widget.balanceProvider.balance) {
                  double newBalance = widget.balanceProvider.balance - totalPrice;
                  widget.balanceProvider.updateBalance(newBalance);
                  TransactionRecord newTransaction = TransactionRecord(
                    companyName: widget.companyName,
                    quantity: _selectedQuantity,
                    totalPrice: totalPrice,
                  );
                  widget.onBuy(newTransaction);
                  Navigator.pop(context, _selectedQuantity);
                } else {
                  print('Insufficient balance');
                }
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}

class SellFormModal extends StatefulWidget {
  final String companyName;
  final String latestPrice;
  final BalanceProvider balanceProvider;
  final TransactionProvider transactionProvider;

  const SellFormModal({
    Key? key,
    required this.companyName,
    required this.latestPrice,
    required this.balanceProvider,
    required this.transactionProvider,
  });

  @override
  _SellFormModalState createState() => _SellFormModalState();
}

class _SellFormModalState extends State<SellFormModal> {
  int _selectedQuantity = 1;
  late int availableQuantity;

  @override
  void initState() {
    super.initState();
    _calculateAvailableQuantity();
  }

  void _calculateAvailableQuantity() {
    List<TransactionRecord>? companyTransactions = widget.transactionProvider.companyTransactions[widget.companyName];
    if (companyTransactions != null && companyTransactions.isNotEmpty) {
      int totalBought = 0;
      int totalSold = 0;
      for (TransactionRecord transaction in companyTransactions) {
        if (transaction.quantity > 0) {
          totalBought += transaction.quantity;
        } else {
          totalSold += transaction.quantity.abs();
        }
      }
      setState(() {
        availableQuantity = totalBought - totalSold;
      });
    } else {
      setState(() {
        availableQuantity = 0;
      });
    }
  }

  double calculateTotalPrice(double price, int quantity) {
    return price * quantity;
  }

  @override
  Widget build(BuildContext context) {
    double price = double.parse(widget.latestPrice);
    _calculateAvailableQuantity();

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Company: ${widget.companyName}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Latest Price: ${widget.latestPrice}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Available Quantity to Sell: $availableQuantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Select Quantity to Sell',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedQuantity > 1) {
                        _selectedQuantity--;
                      }
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: TextFormField(
                    initialValue: '1', // Initialize with 1
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Quantity',
                    ),
                    onChanged: (value) {
                      setState(() {
                        _selectedQuantity = int.tryParse(value) ?? 0;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10.0),
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (_selectedQuantity < availableQuantity) {
                        _selectedQuantity++;
                      }
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text(
              'Total Price for Selling: P ${calculateTotalPrice(price, _selectedQuantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                double totalPrice = calculateTotalPrice(price, _selectedQuantity);
                if (_selectedQuantity > 0 && totalPrice > 0) {
                  double newBalance = widget.balanceProvider.balance + totalPrice;
                  widget.balanceProvider.updateBalance(newBalance);
                  TransactionRecord sellTransaction = TransactionRecord(
                    companyName: widget.companyName,
                    quantity: -_selectedQuantity, // Negative quantity for selling
                    totalPrice: totalPrice,
                  );
                  widget.transactionProvider.addTransaction(sellTransaction);
                  setState(() {
                    availableQuantity -= _selectedQuantity;
                  });
                  Navigator.pop(context);
                } else {
                  print('Invalid quantity or price');
                }
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}