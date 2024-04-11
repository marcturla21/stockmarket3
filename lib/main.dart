import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'buysell.dart'; // Import buysell.dart
import 'balance_provider.dart'; // Import balance_provider.dart
import 'buysell.dart' as BuySell; // Import buysell.dart with alias
import 'homepage.dart' as Home; // Import buysell.dart with alias

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BalanceProvider()),
        ChangeNotifierProvider(create: (_) => BuySell.TransactionProvider()), // Use the alias to specify TransactionProvider from buysell.dart
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoadingScreen(),
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a 5-second delay before navigating to the home page
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home.HomePage()), // Use the alias to reference HomePage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://cdn.dribbble.com/users/116728/screenshots/3373498/slack_animation.gif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 20), // Add spacing between the image and text
            Text(
              'Loading Please Wait',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
