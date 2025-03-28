// lib/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';

// The new or updated screens:
import 'screens/transaction_list_screen.dart';
import 'screens/category_breakdown_screen.dart';
import 'screens/savings_goals_screen.dart';
import 'screens/settings_screen.dart';
// Keep the original ReportsScreen (if it still exists):
import 'screens/reports_screen.dart';

class HomeScreen extends StatelessWidget {
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
          // Keep the same BalanceSummary from your original code
          BalanceSummary(),
          Expanded(
            child: DefaultTabController(
              length: 5, // We have five tabs
              child: Column(
                children: [
                  // The TabBar colors
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
                  // Each tab below points to its own screen
                  Expanded(
                    child: TabBarView(
                      children: [
                        // NEW: Uses TransactionListScreen
                        TransactionListScreen(),
                        // NEW: Uses CategoryBreakdownScreen (pie_chart-based)
                        CategoryBreakdownScreen(),
                        // NEW: Uses SavingsGoalsScreen
                        SavingsGoalsScreen(),
                        // Keep the existing ReportsScreen (if still in your project)
                        ReportsScreen(),
                        // NEW: Uses the updated SettingsScreen
                        SettingsScreen(),
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
        child: Icon(Icons.add),
      ),
    );
  }
}

// Same BalanceSummary widget with color-coded text
class BalanceSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Balance Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Consumer<TransactionProvider>(
            builder: (context, provider, child) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Total Income
                  Column(
                    children: [
                      Text(
                        'Total Income',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₹${provider.totalIncome.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Total Expenses
                  Column(
                    children: [
                      Text(
                        'Total Expenses',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₹${provider.totalExpenses.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // Savings (Income - Expenses)
                  Column(
                    children: [
                      Text(
                        'Savings',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '₹${provider.totalSavings.toStringAsFixed(2)}',
                        style: TextStyle(
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
