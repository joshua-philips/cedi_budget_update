import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/widgets/app_bar_home_button.dart';
import 'package:cedi_budget_update/widgets/date_field.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/selected_dates.dart';
import 'package:cedi_budget_update/widgets/total_days_text.dart';
import 'package:flutter/material.dart';
import 'new_budget_amount_view.dart';

class NewBudgetDateView extends StatefulWidget {
  final Budget budget;

  const NewBudgetDateView({Key? key, required this.budget}) : super(key: key);

  @override
  NewBudgetDateViewState createState() => NewBudgetDateViewState();
}

class NewBudgetDateViewState extends State<NewBudgetDateView> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  Future<DateTime> displayDatePicker(
      BuildContext context, DateTime initialDate) async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 50)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 50)),
    );
    return newDate ?? initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Date'),
        actions: const [
          AppBarHomeButton(),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Card(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10),
                      child: FullDates(budget: widget.budget),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TotalDaysText(budget: widget.budget),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              DateField(
                label: 'Start Date',
                date: _startDate,
                icon: Icons.arrow_drop_down_rounded,
                onIconPressed: () async {
                  DateTime selectedDate =
                      await displayDatePicker(context, _startDate);

                  setState(() {
                    _startDate = selectedDate;
                    widget.budget.startDate = _startDate;
                  });
                },
              ),
              DateField(
                label: 'End Date',
                date: _endDate,
                icon: Icons.arrow_drop_down_rounded,
                onIconPressed: () async {
                  DateTime selectedDate =
                      await displayDatePicker(context, _endDate);

                  setState(() {
                    _endDate = selectedDate;
                    widget.budget.endDate = _endDate;
                  });
                },
              ),
              buildButtons(context, widget.budget),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildButtons(BuildContext context, Budget budget) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        RoundedButton(
          color: Theme.of(context).colorScheme.secondary,
          child: const Text(
            'Continue',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            widget.budget.startDate = _startDate;
            widget.budget.endDate = _endDate;
            Route route = MaterialPageRoute(
              builder: (context) => NewBudgetAmountView(budget: widget.budget),
            );
            Navigator.of(context).push(route);
          },
        ),
        const SizedBox(height: 5),
        RoundedButton(
          color: Colors.deepPurple,
          child: const Text(
            'Cancel',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
