import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/views/new_budget/new_budget_date_view.dart';
import 'package:cedi_budget_update/widgets/budget_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = context.read<AuthService>().getCurrentUser().uid;
    return StreamBuilder<QuerySnapshot>(
      stream:
          context.watch<DatabaseService>().getUsersBudgetStreamSnapshot(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return buildBudgetList(context, snapshot);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Center(
              child: noData(context),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget buildBudgetList(BuildContext context, AsyncSnapshot snapshot) {
    return Scrollbar(
      thickness: 2,
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: snapshot.data.docs.length,
        padding: const EdgeInsets.only(top: 10, bottom: 70),
        itemBuilder: (context, int index) {
          return BudgetCard(documentSnapshot: snapshot.data.docs[index]);
        },
      ),
    );
  }

  Widget noData(context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Welcome to Cedi Budget.\nYou do not have a budget at this time. Press the button below to add your new budget.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Text(
                'Create new budget',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {
              Route route = MaterialPageRoute(
                builder: (context) => NewBudgetDateView(
                  budget: Budget.noArgument(),
                ),
              );
              Navigator.push(context, route);
            },
          ),
        ],
      ),
    );
  }
}
