import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/widgets/app_bar_home_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllTimeDataView extends StatelessWidget {
  const AllTimeDataView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = context.read<AuthService>().getCurrentUser().uid;
    final DatabaseService databaseService = context.read<DatabaseService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('All-Time Budget Data'),
        actions: const [
          AppBarHomeButton(),
        ],
      ),
      body: FutureBuilder(
        future: databaseService.getAllBudgets(uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: buildAllTimmeTotals(snapshot),
              );
            } else {
              return Container();
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget buildAllTimmeTotals(snapshot) {
    double amountTotal = 0;
    double usedTotal = 0;
    double savedTotal = 0;

    for (int count = 0; count < snapshot.data.length; count++) {
      amountTotal =
          amountTotal + Budget.fromSnapshot(snapshot.data[count]).amount;
      usedTotal =
          usedTotal + Budget.fromSnapshot(snapshot.data[count]).amountUsed;
      savedTotal =
          savedTotal + Budget.fromSnapshot(snapshot.data[count]).amountSaved;
    }
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        const ListTile(
          title: Center(
            child: Text(
              'Financial Summary',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        ListTile(
          title: const Text(
            'Total Amount Set:',
          ),
          trailing: Text(
            'GH¢${(amountTotal).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'Total Amount Spent:',
          ),
          trailing: Text(
            'GH¢${(usedTotal).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'Total Amount Saved:',
          ),
          trailing: Text(
            'GH¢${(savedTotal).toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
      ],
    );
  }
}
