import 'package:auto_size_text/auto_size_text.dart';
import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/views/budget_details/budget_details_view.dart';
import 'package:cedi_budget_update/widgets/date_field.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditBudgetDatesView extends StatefulWidget {
  final Budget budget;

  const EditBudgetDatesView({Key? key, required this.budget}) : super(key: key);
  @override
  _EditBudgetDatesViewState createState() => _EditBudgetDatesViewState();
}

class _EditBudgetDatesViewState extends State<EditBudgetDatesView> {
  late DateTime _startDate;
  late DateTime _endDate;
  late int _totalDays;

  @override
  void initState() {
    super.initState();
    _startDate = widget.budget.startDate;
    _endDate = widget.budget.endDate;
    _totalDays = widget.budget.getTotalDaysofBudget();
  }

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              'Change Dates',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          DateField(
            label: 'Start Date',
            date: _startDate,
            icon: Icons.arrow_drop_down_rounded,
            onIconPressed: () async {
              DateTime selectedDate =
                  await displayDatePicker(context, _startDate);

              setState(() {
                _startDate = selectedDate;
                _totalDays = _endDate.difference(_startDate).inDays;
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
                _totalDays = _endDate.difference(_startDate).inDays;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              children: [
                Flexible(
                  child: AutoSizeText(
                    '${_totalDays.toString()} ${_totalDays == 1 ? 'day' : 'days'}',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          buildButtons(context, widget.budget),
        ],
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
            'Update',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            showLoadingDialog(context);
            widget.budget.startDate = _startDate;
            widget.budget.endDate = _endDate;
            final uid = context.read<AuthService>().getCurrentUser().uid;
            Route route = MaterialPageRoute(
                builder: (context) => BudgetDetailsView(
                      budget: widget.budget,
                    ));
            try {
              await context
                  .read<DatabaseService>()
                  .updateDates(uid, widget.budget);
              hideLoadingDialog(context);
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.of(context).push(route);
            } catch (e) {
              hideLoadingDialog(context);
              // showMessageSnackBar(context, e.message);
            }
          },
        ),
        const SizedBox(height: 2),
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
