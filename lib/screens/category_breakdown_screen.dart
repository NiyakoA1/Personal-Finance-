// lib/screens/category_breakdown_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../transaction_provider.dart';
import '../transaction_model.dart';

class CategoryBreakdownScreen extends StatelessWidget {
  const CategoryBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final expenses = provider.transactions.where((tx) => tx.type == 'Expense').toList();

        if (expenses.isEmpty) {
          return Center(child: Text('No expense data available'));
        }

        final Map<String, double> categoryTotals = {};
        for (var tx in expenses) {
          categoryTotals[tx.category] = (categoryTotals[tx.category] ?? 0) + tx.amount;
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Expense Breakdown by Category', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  dataMap: categoryTotals,
                  chartType: ChartType.ring,
                  chartRadius: MediaQuery.of(context).size.width / 2, // Make it smaller
                  baseChartColor: Colors.grey[200]!,
                  chartValuesOptions: ChartValuesOptions(
                    showChartValuesInPercentage: false,
                    showChartValuesOutside: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: categoryTotals.entries.map((entry) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.primaries[categoryTotals.keys.toList().indexOf(entry.key) % Colors.primaries.length],
                      ),
                      title: Text(entry.key),
                      trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
