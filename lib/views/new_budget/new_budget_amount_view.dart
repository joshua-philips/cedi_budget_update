import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:flutter/material.dart';

import 'new_budget_summary_view.dart';

enum AmountType { simple, complex }

class NewBudgetAmountView extends StatefulWidget {
  final Budget budget;

  const NewBudgetAmountView({Key? key, required this.budget}) : super(key: key);
  @override
  NewBudgetAmountViewState createState() => NewBudgetAmountViewState();
}

class NewBudgetAmountViewState extends State<NewBudgetAmountView> {
  AmountType _amountState = AmountType.simple;
  late String _switchButtonText;
  double _amountTotal = 0;

  final TextEditingController amountController = TextEditingController();
  // Items
  final TextEditingController _item1 = TextEditingController();
  final TextEditingController _item2 = TextEditingController();
  final TextEditingController _item3 = TextEditingController();
  final TextEditingController _item4 = TextEditingController();
  final TextEditingController _item5 = TextEditingController();

  // Prices
  final TextEditingController _itemPrice1 = TextEditingController();
  final TextEditingController _itemPrice2 = TextEditingController();
  final TextEditingController _itemPrice3 = TextEditingController();
  final TextEditingController _itemPrice4 = TextEditingController();
  final TextEditingController _itemPrice5 = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.addListener(_setTotalAmount);
    _itemPrice1.addListener(_setTotalAmount);
    _itemPrice2.addListener(_setTotalAmount);
    _itemPrice3.addListener(_setTotalAmount);
    _itemPrice4.addListener(_setTotalAmount);
    _itemPrice5.addListener(_setTotalAmount);

    _switchButtonText = _amountState == AmountType.simple
        ? 'Input each item'
        : 'Input total only';
  }

  _setTotalAmount() {
    double total = 0;
    if (_amountState == AmountType.simple) {
      total =
          amountController.text == '' ? 0 : double.parse(amountController.text);
      setState(() {
        _amountTotal = total;
      });
    } else {
      total += _itemPrice1.text == '' ? 0 : double.parse(_itemPrice1.text);
      total += _itemPrice2.text == '' ? 0 : double.parse(_itemPrice2.text);
      total += _itemPrice3.text == '' ? 0 : double.parse(_itemPrice3.text);
      total += _itemPrice4.text == '' ? 0 : double.parse(_itemPrice4.text);
      total += _itemPrice5.text == '' ? 0 : double.parse(_itemPrice5.text);
      setState(() {
        _amountTotal = total;
        amountController.text = _amountTotal.toStringAsFixed(2);
      });
    }
  }

  List<Widget> setAmountFields(amountController) {
    List<Widget> fields = [];
    if (_amountState == AmountType.simple) {
      fields.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: Text(
            'Input total budget for the period',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      fields.add(
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: MoneyTextField(
            controller: amountController,
            helperText: 'Total Budget',
            autofocus: true,
          ),
        ),
      );
    } else {
      fields.add(
        const Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Text(
            'Input cost of each item',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      fields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ItemTextField(controller: _item1),
            ),
            Expanded(
              child: MoneyTextField(
                controller: _itemPrice1,
              ),
            ),
          ],
        ),
      );
      fields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ItemTextField(controller: _item2),
            ),
            Expanded(
              child: MoneyTextField(
                controller: _itemPrice2,
              ),
            ),
          ],
        ),
      );
      fields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ItemTextField(controller: _item3),
            ),
            Expanded(
              child: MoneyTextField(
                controller: _itemPrice3,
              ),
            ),
          ],
        ),
      );
      fields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ItemTextField(controller: _item4),
            ),
            Expanded(
              child: MoneyTextField(
                controller: _itemPrice4,
              ),
            ),
          ],
        ),
      );
      fields.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: ItemTextField(controller: _item5),
            ),
            Expanded(
              child: MoneyTextField(
                controller: _itemPrice5,
              ),
            ),
          ],
        ),
      );
      fields.add(
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 10),
          child: Text(
            'Total: GH¢${_amountTotal.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 25),
          ),
        ),
      );
    }
    return fields;
  }

  /// Convert textfield items in complex mode.
  /// Also determines if Budget variable hasItems is true/false
  Map<String, double> changeItemsToMap() {
    Map<String, double> budgetItemsAndPrices = {};

    if (_amountState == AmountType.complex) {
      if (_item1.text != '' && _itemPrice1.text != '') {
        budgetItemsAndPrices
            .addAll({_item1.text: double.parse(_itemPrice1.text)});
        widget.budget.hasItems = true;
      }
      if (_item2.text != '' && _itemPrice2.text != '') {
        budgetItemsAndPrices
            .addAll({_item2.text: double.parse(_itemPrice2.text)});
        widget.budget.hasItems = true;
      }
      if (_item3.text != '' && _itemPrice3.text != '') {
        budgetItemsAndPrices
            .addAll({_item3.text: double.parse(_itemPrice3.text)});
        widget.budget.hasItems = true;
      }
      if (_item4.text != '' && _itemPrice4.text != '') {
        budgetItemsAndPrices
            .addAll({_item4.text: double.parse(_itemPrice4.text)});
        widget.budget.hasItems = true;
      }
      if (_item5.text != '' && _itemPrice5.text != '') {
        budgetItemsAndPrices
            .addAll({_item5.text: double.parse(_itemPrice5.text)});
        widget.budget.hasItems = true;
      }
    }

    return budgetItemsAndPrices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.only(right: 25, left: 25),
            ),
            onPressed: () {
              setState(() {
                _amountState = _amountState == AmountType.simple
                    ? AmountType.complex
                    : AmountType.simple;

                _switchButtonText = _amountState == AmountType.simple
                    ? 'Input each item'
                    : 'Input total only';
              });
            },
            icon: Icon(
              _amountState != AmountType.simple
                  ? Icons.add_circle_outline
                  : Icons.list_rounded,
            ),
            label: Text(
              _switchButtonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: InkWell(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    child: Text(
                      'Summary',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ),
                ],
              ),
              onTap: () {
                continueToSummary();
              },
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: setAmountFields(amountController) +
                  [
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: RoundedButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: const Text(
                          'Continue to summary',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          continueToSummary();
                        },
                      ),
                    ),
                  ],
            ),
          ),
        ),
      ),
    );
  }

  continueToSummary() {
    widget.budget.amount = _amountTotal.toDouble();
    widget.budget.items = changeItemsToMap();
    widget.budget.notes = '';

    Route route = MaterialPageRoute(
      builder: (context) => NewBudgetSummaryView(budget: widget.budget),
    );
    Navigator.push(context, route);
  }
}
