// lib/add_transaction_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';
import 'transaction_model.dart';

class AddTransactionScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String transactionType = 'Income';
  String category = 'Food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 10),
            // Transaction Type
            DropdownButtonFormField<String>(
              value: transactionType,
              items: ['Income', 'Expense'].map((type) {
                return DropdownMenuItem<String>(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => transactionType = value ?? 'Income',
              decoration: InputDecoration(labelText: 'Transaction Type'),
            ),
            SizedBox(height: 10),
            // Category
            DropdownButtonFormField<String>(
              value: category,
              items: ['Food', 'Rent', 'Entertainment', 'Bills', 'Other'].map((cat) {
                return DropdownMenuItem<String>(value: cat, child: Text(cat));
              }).toList(),
              onChanged: (value) => category = value ?? 'Food',
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 10),
            // Notes
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes (Optional)'),
            ),
            SizedBox(height: 20),
            // Save Button
            ElevatedButton(
              onPressed: () {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  final newTransaction = TransactionModel(
                    amount: amount,
                    type: transactionType,
                    category: category,
                    date: DateTime.now(),
                    notes: notesController.text,
                  );
                  Provider.of<TransactionProvider>(context, listen: false)
                      .addTransaction(newTransaction);

                  Navigator.pop(context); // Go back after saving
                } else {
                  // Show error for invalid amount
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid amount')),
                  );
                }
              },
              child: Text('Save Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}
