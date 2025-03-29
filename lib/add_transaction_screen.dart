import 'package:flutter/material.dart';
import 'package:project1/transaction_model.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController categoryController = TextEditingController(
    text: 'Food',
  );

  String transactionType = 'Income';
  String category = 'Food';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: transactionType,
              items:
                  ['Income', 'Expense'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  transactionType = value!;

                  if (transactionType == 'Income') category = 'Income';
                });
              },
              decoration: InputDecoration(labelText: 'Transaction Type'),
            ),
            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: category,
              items:
                  ['Food', 'Rent', 'Entertainment', 'Bills', 'Other'].map((
                    String cat,
                  ) {
                    return DropdownMenuItem<String>(
                      value: cat,
                      child: Text(cat),
                    );
                  }).toList(),
              onChanged:
                  transactionType == 'Expense'
                      ? (value) {
                        setState(() {
                          category = value!;
                        });
                      }
                      : null,
              decoration: InputDecoration(
                labelText: 'Category',
                helperText:
                    transactionType == 'Income'
                        ? 'Category not required for income'
                        : 'Choose expense category',
              ),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes (Optional)'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(amountController.text) ?? 0.0;
                if (amount > 0) {
                  final newTransaction = TransactionModel(
                    amount: amount,
                    type: transactionType,
                    category: transactionType == 'Income' ? 'Income' : category,
                    date: DateTime.now(),
                    notes: notesController.text,
                  );

                  Provider.of<TransactionProvider>(
                    context,
                    listen: false,
                  ).addTransaction(newTransaction);

                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter a valid amount'),
                    ),
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
