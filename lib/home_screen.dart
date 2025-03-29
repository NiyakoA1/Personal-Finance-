// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';
import 'category_breakdown_screen.dart';
import 'savings_goals_screen.dart';
import 'reports_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black, // sets text/icon color
        elevation: 0, // remove shadow if desired
        centerTitle: true,
        title: Text('Finance Tracker'),
      ),
      body: Column(
        children: [
          const BalanceSummary(),
          Expanded(
            child: DefaultTabController(
              length: 4,
              child: Column(
                children: [
                  TabBar(
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: const [
                      Tab(icon: Icon(Icons.list), text: 'Transactions'),
                      Tab(icon: Icon(Icons.pie_chart), text: 'Categories'),
                      Tab(icon: Icon(Icons.savings), text: 'Goals'),
                      Tab(icon: Icon(Icons.bar_chart), text: 'Reports'),
                    ],
                  ),
                  // Each tab below points to its own screen
                  Expanded(
                    child: TabBarView(
                      children: [
                        Consumer<TransactionProvider>(
                          builder: (context, provider, child) {
                            return ListView.builder(
                              itemCount: provider.transactions.length,
                              itemBuilder: (context, index) {
                                final transaction =
                                    provider.transactions[index];
                                return ListTile(
                                  leading: Icon(
                                    transaction.type == 'Income'
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color:
                                        transaction.type == 'Income'
                                            ? Colors.green
                                            : Colors.red,
                                  ),
                                  title: Text(
                                    transaction.type != 'Income'
                                        ? transaction.category
                                        : 'Income',
                                  ),
                                  subtitle: Text(
                                    '₹${transaction.amount}  ${transaction.type != 'Income' ? '• ' + transaction.type : ''}',
                                  ),
                                  trailing: Text(
                                    '${transaction.date.day}/${transaction.date.month}/${transaction.date.year}',
                                  ),
                                );
                              },
                            );
                          },
                        ),

                        CategoryBreakdownScreen(),

                        SavingsGoalsScreen(),

                        ReportsScreen(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // Same floating button to add new transaction
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addTransaction');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Same BalanceSummary widget with color-coded text
class BalanceSummary extends StatelessWidget {
  const BalanceSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Balance Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      const Text(
                        'Total Income',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${provider.totalIncome.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Total Expenses',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${provider.totalExpenses.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'Savings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${provider.totalSavings.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
