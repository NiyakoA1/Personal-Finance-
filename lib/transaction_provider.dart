import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'transaction_model.dart';  // Assuming you have this file for TransactionModel

class TransactionProvider with ChangeNotifier {
  List<TransactionModel> _transactions = [];
  final String _boxName = 'transactions';

  List<TransactionModel> get transactions => _transactions;

  // Load transactions from Hive
  Future<void> loadTransactions() async {
    var box = await Hive.openBox<TransactionModel>(_boxName);
    _transactions = box.values.toList();
    notifyListeners();
  }

  // Add a new transaction to the list and store it in Hive
  Future<void> addTransaction(TransactionModel transaction) async {
    var box = await Hive.openBox<TransactionModel>(_boxName);
    await box.add(transaction);
    _transactions.add(transaction); // Update local state
    notifyListeners();
  }

  // Delete a transaction by index and remove it from Hive
  Future<void> deleteTransaction(int index) async {
    var box = await Hive.openBox<TransactionModel>(_boxName);
    await box.deleteAt(index);
    _transactions.removeAt(index); // Update local state
    notifyListeners();
  }

  // Calculate total income
  double get totalIncome {
    return _transactions
        .where((transaction) => transaction.type == 'Income')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate total expenses
  double get totalExpenses {
    return _transactions
        .where((transaction) => transaction.type == 'Expense')
        .fold(0.0, (sum, transaction) => sum + transaction.amount);
  }

  // Calculate savings (Income - Expenses)
  double get totalSavings {
    return totalIncome - totalExpenses;
  }
}
