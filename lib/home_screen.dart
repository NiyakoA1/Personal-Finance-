import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Finance Tracker')),
      body: Column(
        children: [
          BalanceSummary(),
          Expanded(child: NavigationTabs()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Income: ₹50,000', style: TextStyle(color: Colors.green)),
              Text('Total Expenses: ₹30,000', style: TextStyle(color: Colors.red)),
              Text('Savings: ₹20,000', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }
}

class NavigationTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Column(
        children: [
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
                Center(child: Text('Transactions List Placeholder')),
                Center(child: Text('Category Breakdown Placeholder')),
                Center(child: Text('Savings Goals Placeholder')),
                Center(child: Text('Reports Placeholder')),
                Center(child: Text('Settings Placeholder')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
