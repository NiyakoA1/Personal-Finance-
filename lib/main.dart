import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

void main() {
  runApp(FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  const FinanceTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider()..loadTransactions(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
      ),
    );
  }
}

class TransactionProvider with ChangeNotifier {
  final List<String> _transactions = [];

  List<String> get transactions => _transactions;

  void loadTransactions() {
    notifyListeners();
  }
}
