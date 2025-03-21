// lib/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pie_chart/pie_chart.dart';

import '../transaction_provider.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        // 1) Sum only the expenses by category
        final expensesByCategory = <String, double>{};
        for (final txn in provider.transactions) {
          if (txn.type == 'Expense') {
            expensesByCategory[txn.category] =
                (expensesByCategory[txn.category] ?? 0) + txn.amount;
          }
        }

        // If no expense data, show a message
        if (expensesByCategory.isEmpty) {
          return Center(child: Text('No expense data available.'));
        }

        // 2) Build the pie chart using the map
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: PieChart(
            dataMap: expensesByCategory,
            chartType: ChartType.ring,
            chartRadius: MediaQuery.of(context).size.width / 2,      
            baseChartColor: Colors.grey[200]!,
            chartValuesOptions: ChartValuesOptions(
              showChartValuesInPercentage: false,
              showChartValuesOutside: true,
            ),
          ),
        );
      },
    );
  }
}
