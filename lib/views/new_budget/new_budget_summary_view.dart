import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/widgets/app_bar_home_button.dart';
import 'package:cedi_budget_update/widgets/items_card_list.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/selected_dates.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:cedi_budget_update/widgets/total_budget_card.dart';
import 'package:cedi_budget_update/widgets/total_days_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewBudgetSummaryView extends StatelessWidget {
  final Budget budget;

  NewBudgetSummaryView({Key? key, required this.budget}) : super(key: key);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final String uid = context.read<AuthService>().getCurrentUser().uid;
    final DatabaseService databaseService = context.read<DatabaseService>();
    return Scaffold(
      key: _scaffoldKey,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: const Text('New Budget'),
            actions: [
              const AppBarHomeButton(),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: InkWell(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Text(
                          'Finish',
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () async {
                    showLoadingDialog(context);

                    await databaseService.saveBudgetToFirestore(budget, uid);
                    hideLoadingDialog(context);
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),
              ),
            ],
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Text(
                      'Budget Summary',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    ListTile(
                      title: SelectedDates(budget: budget),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: TotalDaysText(budget: budget),
                      ),
                    ),
                    const Divider(),
                    const SizedBox(height: 15),
                    budget.hasItems
                        ? ItemsCardList(budget: budget)
                        : Container(),
                    const SizedBox(height: 20),
                    TotalBudgetCard(budget: budget),
                    const SizedBox(height: 30),
                    RoundedButton(
                      color: Theme.of(context).colorScheme.secondary,
                      child: const Padding(
                        padding: EdgeInsets.only(
                          left: 30,
                          right: 30,
                          top: 10,
                          bottom: 10,
                        ),
                        child: Text(
                          'Finish',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        showLoadingDialog(context);

                        await databaseService.saveBudgetToFirestore(
                            budget, uid);
                        hideLoadingDialog(context);
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      },
                    ),
                    Container(height: 60),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
