// lib/screens/transaction_list_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../transaction_provider.dart';
import '../transaction_model.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({Key? key}) : super(key: key);

  String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final aDate = DateTime(date.year, date.month, date.day);

    if (aDate == today) return 'Today';
    if (aDate == today.subtract(Duration(days: 1))) return 'Yesterday';
    return DateFormat.yMMMMd().format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;

        if (transactions.isEmpty) {
          return Center(child: Text('No transactions yet'));
        }

        // Group transactions by date
        final grouped = <String, List<TransactionModel>>{};
        for (var tx in transactions) {
          final key = formatDate(tx.date);
          if (!grouped.containsKey(key)) {
            grouped[key] = [];
          }
          grouped[key]!.add(tx);
        }

        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 8),
          children: grouped.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    entry.key,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                  ),
                ),
                ...entry.value.asMap().entries.map((entryItem) {
                  final index = provider.transactions.indexOf(entryItem.value);
                  final transaction = entryItem.value;
                  return Dismissible(
                    key: Key('${transaction.date.toIso8601String()}_$index'),
                    background: Container(
                      color: Colors.red,
                      padding: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (_) => provider.deleteTransaction(index),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          transaction.type == 'Income' ? Icons.arrow_downward : Icons.arrow_upward,
                          color: transaction.type == 'Income' ? Colors.green : Colors.red,
                        ),
                        title: Text(
                          '${transaction.type}: ₹${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Category: ${transaction.category}'),
                            if (transaction.notes != null && transaction.notes!.isNotEmpty)
                              Text('Notes: ${transaction.notes}'),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
