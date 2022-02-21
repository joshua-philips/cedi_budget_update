import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/widgets/budget_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetHistoryView extends StatelessWidget {
  const BudgetHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String uid = context.read<AuthService>().getCurrentUser().uid;
    return StreamBuilder<QuerySnapshot>(
      stream: context.watch<DatabaseService>().getPastBudgetsStream(uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data!.docs.isNotEmpty) {
            return buildBudgetList(context, snapshot);
          } else if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return const Center(
              child: Text(
                'No Past Budgets',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
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
}
