import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';
import 'transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';

class CategoryBreakdownScreen extends StatelessWidget {
  const CategoryBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final expenses =
            provider.transactions.where((tx) => tx.type == 'Expense').toList();

        if (expenses.isEmpty) {
          return Center(child: Text('No expense data available'));
        }

        final Map<String, double> categoryTotals = {};
        for (var tx in expenses) {
          categoryTotals[tx.category] =
              (categoryTotals[tx.category] ?? 0) + tx.amount;
        }

        final List<PieChartSectionData> pieSections =
            categoryTotals.entries.map((entry) {
              final color =
                  Colors.primaries[categoryTotals.keys.toList().indexOf(
                        entry.key,
                      ) %
                      Colors.primaries.length];
              return PieChartSectionData(
                value: entry.value,
                title: entry.key,
                color: color,
                radius: 60,
                titleStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }).toList();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Expense Breakdown by Category',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: PieChart(
                  PieChartData(
                    sections: pieSections,
                    centerSpaceRadius: 40,
                    sectionsSpace: 4,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children:
                      categoryTotals.entries.map((entry) {
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                Colors.primaries[categoryTotals.keys
                                        .toList()
                                        .indexOf(entry.key) %
                                    Colors.primaries.length],
                          ),
                          title: Text(entry.key),
                          trailing: Text('₹${entry.value.toStringAsFixed(2)}'),
                        );
                      }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
