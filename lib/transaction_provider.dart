// lib/transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'transaction_model.dart';

class TransactionProvider with ChangeNotifier {
  final String _boxName = 'transactions';
  List<TransactionModel> _transactions = [];

  List<TransactionModel> get transactions => _transactions;

  Future<void> loadTransactions() async {
    final box = await Hive.openBox<TransactionModel>(_boxName);
    _transactions = box.values.toList();
    notifyListeners();
  }

  Future<void> addTransaction(TransactionModel transaction) async {
    final box = await Hive.openBox<TransactionModel>(_boxName);
    await box.add(transaction);
    _transactions.add(transaction);
    notifyListeners();
  }

  Future<void> deleteTransaction(int index) async {
    final box = await Hive.openBox<TransactionModel>(_boxName);
    await box.deleteAt(index);
    _transactions.removeAt(index);
    notifyListeners();
  }

  double get totalIncome => _transactions
      .where((t) => t.type == 'Income')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalExpenses => _transactions
      .where((t) => t.type == 'Expense')
      .fold(0.0, (sum, t) => sum + t.amount);

  double get totalSavings => totalIncome - totalExpenses;
}
