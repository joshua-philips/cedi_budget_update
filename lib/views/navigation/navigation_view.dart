import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/theme_provider.dart';
import 'package:cedi_budget_update/views/my_account/my_account_view.dart';
import 'package:cedi_budget_update/views/new_budget/new_budget_date_view.dart';
import 'package:cedi_budget_update/widgets/custom_navigation_bar.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'budget_history_view.dart';
import 'home_view.dart';
import 'settings_view.dart';

class NavigationView extends StatefulWidget {
  const NavigationView({Key? key}) : super(key: key);

  @override
  NavigationViewState createState() => NavigationViewState();
}

class NavigationViewState extends State<NavigationView> {
  final Budget budget = Budget.noArgument();
  int _currentNavigationIndex = 0;
  final List<Widget> _children = [
    const HomeView(),
    const BudgetHistoryView(),
    const SettingsView(),
  ];
  @override
  Widget build(BuildContext context) {
    bool darkTheme = context.watch<ThemeNotifier>().darkTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cedi Budget'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle),
                    const SizedBox(width: 5),
                    Text(
                      context
                              .watch<AuthService>()
                              .getCurrentUser()
                              .displayName ??
                          '',
                      style: TextStyle(
                        color: darkTheme ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                showModalBottomSheet(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  context: context,
                  builder: (context) => SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: Center(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RoundedButton(
                              color: Colors.green[900]!,
                              child: const Text(
                                'Account Info',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Route route = MaterialPageRoute(
                                    builder: (context) =>
                                        const MyAccountView());
                                Navigator.of(context).pop();
                                Navigator.push(context, route);
                              },
                            ),
                            RoundedButton(
                              color: Theme.of(context).colorScheme.secondary,
                              child: const Text(
                                'Logout',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                await context.read<AuthService>().signOut();
                                if (context.mounted) {
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const SizedBox(height: 5),
                            const Divider(thickness: 1.5),
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
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        heroTag: 'float',
        child: const Icon(Icons.add),
        onPressed: () {
          Route route = MaterialPageRoute(
            builder: (context) => NewBudgetDateView(
              budget: budget,
            ),
          );
          Navigator.push(context, route);
        },
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        backgroundColor: Theme.of(context).cardColor,
        currentIndex: _currentNavigationIndex,
        itemColor: Colors.black,
        children: [
          CustomBottomNavigationBarItem(
            icon: Icons.home,
            label: 'Home',
            color: Theme.of(context).iconTheme.color!,
          ),
          CustomBottomNavigationBarItem(
            icon: Icons.history,
            label: 'Past Budgets',
            color: Theme.of(context).iconTheme.color!,
          ),
          CustomBottomNavigationBarItem(
            icon: Icons.settings,
            label: 'Settings',
            color: Theme.of(context).iconTheme.color!,
          ),
        ],
        onChange: (index) {
          setState(() {
            _currentNavigationIndex = index;
          });
        },
      ),
      body: _children[_currentNavigationIndex],
    );
  }
}
