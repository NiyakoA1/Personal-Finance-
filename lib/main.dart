import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project1/add_transaction_screen.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import 'transaction_provider.dart';
import 'transaction_model.dart'; // Assuming you have this file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Initialize Hive
  Hive.registerAdapter(TransactionModelAdapter()); // Register the adapter for TransactionModel
  
  runApp(FinanceTrackerApp());
}

class FinanceTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TransactionProvider()..loadTransactions(), // Load transactions from Hive on start
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Finance Tracker',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: HomeScreen(),
        routes: {
          '/addTransaction': (context) => AddTransactionScreen(),
        },
      ),
    );
  }
}
