import 'package:auto_size_text/auto_size_text.dart';
import 'package:cedi_budget_update/models/budget.dart';
import 'package:flutter/material.dart';

/// Total days of budget must be placed inside Flex Widget (Column/Row)
class TotalDaysText extends StatelessWidget {
  final Budget budget;

  const TotalDaysText({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: AutoSizeText(
        '${budget.getTotalDaysofBudget().toString()} ${budget.getTotalDaysofBudget() == 1 ? 'day' : 'days'}',
        maxLines: 1,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
