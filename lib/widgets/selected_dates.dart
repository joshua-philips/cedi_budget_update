import 'package:auto_size_text/auto_size_text.dart';
import 'package:cedi_budget_update/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelectedDates extends StatelessWidget {
  final Budget budget;

  const SelectedDates({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dateColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Text(
                'Start Date',
                style: TextStyle(color: dateColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('EEE, dd/MM').format(budget.startDate).toString(),
                  style: TextStyle(fontSize: 25, color: dateColor),
                ),
              ),
              Text(
                DateFormat('yyyy').format(budget.startDate).toString(),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: dateColor),
              ),
            ],
          ),
          Container(
            padding:
                const EdgeInsets.only(left: 10, right: 10, bottom: 0, top: 15),
            child: Icon(
              Icons.arrow_forward,
              size: 30,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.green[800]
                  : Theme.of(context).colorScheme.secondary,
            ),
          ),
          Column(
            children: [
              Text(
                'End Date',
                style: TextStyle(color: dateColor),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('EEE, dd/MM').format(budget.endDate).toString(),
                  style: TextStyle(fontSize: 25, color: dateColor),
                ),
              ),
              Text(
                DateFormat('yyyy').format(budget.endDate).toString(),
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: dateColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LargeSelectedDates extends StatelessWidget {
  final Budget budget;

  const LargeSelectedDates({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        children: [
          Column(
            children: [
              const Text(
                'Start Date',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('EEE, dd/MM').format(budget.startDate).toString(),
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Text(
                DateFormat('yyyy').format(budget.startDate).toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: const Icon(
              Icons.arrow_downward,
              size: 45,
            ),
          ),
          Column(
            children: [
              const Text(
                'End Date',
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('EEE, dd/MM').format(budget.endDate).toString(),
                  style: const TextStyle(
                    fontSize: 35,
                  ),
                ),
              ),
              Text(
                DateFormat('yyyy').format(budget.endDate).toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FullDates extends StatelessWidget {
  final Budget budget;

  const FullDates({Key? key, required this.budget}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color dateColor = Theme.of(context).textTheme.bodyMedium!.color!;
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                DateFormat('MMM d, yyyy').format(budget.startDate).toString(),
                maxLines: 1,
                style: TextStyle(
                  color: dateColor,
                  fontSize: 40,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              budget.endDate.isBefore(DateTime.now())
                  ? const Icon(Icons.check_box_outlined, size: 30)
                  : Container(),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'to',
                style: TextStyle(color: dateColor, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              SizedBox(
                height: 30,
                child: AutoSizeText(
                  DateFormat('EEEE, MMM d, yyyy')
                      .format(budget.endDate)
                      .toString(),
                  maxLines: 1,
                  style: TextStyle(
                    color: dateColor,
                    fontSize: 25,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
