import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'transaction_provider.dart';
import 'transaction_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class ReportsScreen extends StatelessWidget {
  String _formatYAxisLabel(double value) {
    if (value >= 1000000) return '${(value ~/ 1000000)}M';
    if (value >= 1000) return '${(value ~/ 1000)}K';
    return value.toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final transactions = provider.transactions;
        if (transactions.isEmpty) {
          return Center(child: Text('No data to display'));
        }

        final Map<String, double> incomeByMonth = {};
        final Map<String, double> expenseByMonth = {};

        for (var tx in transactions) {
          final month = DateFormat('MMM yyyy').format(tx.date);
          if (tx.type == 'Income') {
            incomeByMonth[month] = (incomeByMonth[month] ?? 0) + tx.amount;
          } else {
            expenseByMonth[month] = (expenseByMonth[month] ?? 0) + tx.amount;
          }
        }

        final allMonths =
            {...incomeByMonth.keys, ...expenseByMonth.keys}.toList()..sort(
              (a, b) => DateFormat(
                'MMM yyyy',
              ).parse(a).compareTo(DateFormat('MMM yyyy').parse(b)),
            );

        final maxY =
            ((provider.totalIncome > provider.totalExpenses
                        ? provider.totalIncome
                        : provider.totalExpenses) *
                    1.2)
                .ceilToDouble();

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Income vs Expense (Monthly)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Expanded(
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    groupsSpace: 20,
                    maxY: maxY,
                    barGroups:
                        allMonths.map((month) {
                          final index = allMonths.indexOf(month);
                          return BarChartGroupData(
                            x: index,
                            barsSpace: 6,
                            barRods: [
                              BarChartRodData(
                                toY: incomeByMonth[month] ?? 0,
                                color: Colors.green,
                                width: 7,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              BarChartRodData(
                                toY: expenseByMonth[month] ?? 0,
                                color: Colors.red,
                                width: 7,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                            showingTooltipIndicators: [0, 1],
                          );
                        }).toList(),
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < allMonths.length) {
                              return SideTitleWidget(
                                meta: meta,
                                child: Text(
                                  allMonths[index],
                                  style: TextStyle(fontSize: 10),
                                ),
                              );
                            }
                            return Container();
                          },
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            final label = _formatYAxisLabel(value);
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                label,
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          },
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
