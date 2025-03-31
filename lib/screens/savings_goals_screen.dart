// lib/screens/savings_goals_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../transaction_provider.dart';

class SavingsGoalsScreen extends StatefulWidget {
  const SavingsGoalsScreen({super.key});

  @override
  _SavingsGoalsScreenState createState() => _SavingsGoalsScreenState();
}

class _SavingsGoalsScreenState extends State<SavingsGoalsScreen> {
  final List<SavingsGoal> _goals = [
    SavingsGoal(
      title: 'Vacation',
      targetAmount: 10000,
      currentAmount: 0,
      deadline: DateTime(2025, 8, 1),
    ),
    SavingsGoal(
      title: 'Laptop',
      targetAmount: 60000,
      currentAmount: 0,
      deadline: DateTime(2025, 12, 31),
    ),
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _targetController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (context, provider, child) {
        final totalSavings = provider.totalSavings;
        final totalTarget =
            _goals.fold<double>(0, (sum, goal) => sum + goal.targetAmount);

        // Distribute savings proportionally to each goal
        final updatedGoals = _goals.map((goal) {
          // Avoid dividing by zero if totalTarget == 0
          if (totalTarget == 0) {
            return goal.copyWith(currentAmount: 0);
          } else {
            double allocated =
                (goal.targetAmount / totalTarget) * totalSavings;
            // Clamp below 0 to 0, so you never see negative amounts
            allocated = allocated.clamp(0, goal.targetAmount);
            return goal.copyWith(currentAmount: allocated);
          }
        }).toList();

        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Your Savings Goals',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                // If net savings <= 0, show a small note
                if (totalSavings <= 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'You currently have no net savings (₹0 or negative). '
                      'Add more income or reduce expenses to meet your goals!',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ),

                // Display the goals list
                Expanded(
                  child: ListView.builder(
                    itemCount: updatedGoals.length,
                    itemBuilder: (context, index) {
                      final goal = updatedGoals[index];
                      // Calculate progress (0..1)
                      final progress = (goal.currentAmount / goal.targetAmount)
                          .clamp(0.0, 1.0);

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(goal.title),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LinearProgressIndicator(
                                value: progress,
                                backgroundColor: Colors.grey[300],
                                color: Colors.green,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '₹${goal.currentAmount.toStringAsFixed(0)}'
                                ' / ₹${goal.targetAmount.toStringAsFixed(0)}',
                              ),
                              Text(
                                'Deadline: ${goal.deadline.day}'
                                '/${goal.deadline.month}'
                                '/${goal.deadline.year}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                          trailing: const Icon(Icons.flag, color: Colors.teal),
                        ),
                      );
                    },
                  ),
                ),

                ElevatedButton.icon(
                  onPressed: _showAddGoalDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Goal'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddGoalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Savings Goal'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Goal Title'),
            ),
            TextField(
              controller: _targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Amount'),
            ),
            TextField(
              controller: _deadlineController,
              decoration:
                  const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newGoal = SavingsGoal(
                title: _titleController.text,
                targetAmount:
                    double.tryParse(_targetController.text) ?? 0,
                currentAmount: 0, // Will be assigned proportionally
                deadline:
                    DateTime.tryParse(_deadlineController.text) ??
                        DateTime.now(),
              );

              setState(() {
                _goals.add(newGoal);
              });

              _titleController.clear();
              _targetController.clear();
              _deadlineController.clear();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class SavingsGoal {
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;

  SavingsGoal({
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
  });

  SavingsGoal copyWith({double? currentAmount}) {
    return SavingsGoal(
      title: title,
      targetAmount: targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      deadline: deadline,
    );
  }
}
