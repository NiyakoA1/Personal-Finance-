import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'add_transaction_screen.dart';
import 'transaction_provider.dart'; // Import the provider for transaction management

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finance Tracker')),
      body: Column(
        children: [
          BalanceSummary(),
          Expanded(
            child: DefaultTabController(
              length: 5, // Number of tabs
              child: Column(
                children: [
                  // TabBar to switch between different views
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.list), text: 'Transactions'),
                      Tab(icon: Icon(Icons.pie_chart), text: 'Categories'),
                      Tab(icon: Icon(Icons.savings), text: 'Goals'),
                      Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
                      Tab(icon: Icon(Icons.settings), text: 'Settings'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Transaction List Screen
                        Consumer<TransactionProvider>(
                          builder: (context, provider, child) {
                            return ListView.builder(
                              itemCount: provider.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction = provider.transactions[index];
                                return ListTile(
                                  title: Text(transaction.type), // Transaction Type
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Amount: ₹${transaction.amount}"), // Display amount
                                      Text("Category: ${transaction.category}", style: TextStyle(color: Colors.grey)), // Display category
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        // Placeholder for Category Breakdown
                        Center(child: Text('Category Breakdown Placeholder')),
                        // Placeholder for Savings Goals
                        Center(child: Text('Savings Goals Placeholder')),
                        // Placeholder for Reports
                        Center(child: Text('Reports Placeholder')),
                        // Placeholder for Settings
                        Center(child: Text('Settings Placeholder')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Add Transaction Screen
          Navigator.pushNamed(context, '/addTransaction');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BalanceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Balance Summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Income Column
                  Column(
                    children: [
                      Text('Total Income', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('₹${provider.totalIncome.toStringAsFixed(2)}', style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Total Expenses Column
                  Column(
                    children: [
                      Text('Total Expenses', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('₹${provider.totalExpenses.toStringAsFixed(2)}', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  // Savings Column
                  Column(
                    children: [
                      Text('Savings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                      Text('₹${provider.totalSavings.toStringAsFixed(2)}', style: TextStyle(color: Colors.blue, fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
