import 'package:cedi_budget_update/models/budget.dart';
import 'package:flutter/material.dart';

class TotalBudgetCard extends StatelessWidget {
  final Budget budget;

  const TotalBudgetCard({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).brightness != Brightness.dark
          ? Theme.of(context).colorScheme.secondary
          : Theme.of(context).cardColor,
      child: ListTile(
        title: const Text(
          'Total:',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          'GH¢' + budget.amount.toStringAsFixed(2),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
