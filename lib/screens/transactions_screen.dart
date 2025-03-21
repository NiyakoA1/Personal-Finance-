// transactions_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../transaction_provider.dart'; 

class TransactionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        return ListView.builder(
          itemCount: provider.transactions.length,
          itemBuilder: (context, index) {
            final transaction = provider.transactions[index];
            return ListTile(
              title: Text(transaction.type),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amount: ₹${transaction.amount}"),
                  Text("Category: ${transaction.category}",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
