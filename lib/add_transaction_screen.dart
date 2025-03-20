import 'package:flutter/material.dart';
import 'package:project1/transaction_model.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';  // Import the provider

class AddTransactionScreen extends StatelessWidget {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? transactionType = 'Income';
  String? category = 'Food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Amount Input
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            SizedBox(height: 10),

            // Transaction Type Dropdown
            DropdownButtonFormField<String>(
              value: transactionType,
              items: ['Income', 'Expense'].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                transactionType = value;
              },
              decoration: InputDecoration(labelText: 'Transaction Type'),
            ),
            SizedBox(height: 10),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: category,
              items: ['Food', 'Rent', 'Entertainment', 'Bills', 'Other'].map((String cat) {
                return DropdownMenuItem<String>(
                  value: cat,
                  child: Text(cat),
                );
              }).toList(),
              onChanged: (value) {
                category = value;
              },
              decoration: InputDecoration(labelText: 'Category'),
            ),
            SizedBox(height: 10),

            // Notes Input (Optional)
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes (Optional)'),
            ),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: () {
                // Process transaction and save it
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  // Create a new transaction and add it to the provider
                  TransactionModel newTransaction = TransactionModel(
                    amount: amount,
                    type: transactionType!,
                    category: category!,
                    date: DateTime.now(),
                    notes: notesController.text,
                  );

                  // Add the transaction to the provider
                  Provider.of<TransactionProvider>(context, listen: false)
                      .addTransaction(newTransaction);

                  Navigator.pop(context); // Return to previous screen after saving
                } else {
                  // Show error if amount is invalid
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
