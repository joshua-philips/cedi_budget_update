import 'package:cedi_budget_update/models/budget.dart';
import 'package:flutter/material.dart';

class ItemsCardList extends StatelessWidget {
  final Budget budget;

  const ItemsCardList({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<String> items = budget.items.keys.toList();
    List<double> prices = budget.items.values.toList();
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(items[index]),
            trailing: Text(
              'GH¢' + prices[index].toStringAsFixed(2),
            ),
          ),
        );
      },
    );
  }
}
