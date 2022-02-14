import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/theme_provider.dart';
import 'package:cedi_budget_update/views/my_account/my_account_view.dart';
import 'package:cedi_budget_update/views/settings/about_view.dart';
import 'package:cedi_budget_update/views/settings/all_time_data_view.dart';
import 'package:cedi_budget_update/views/settings/help_and_feedback_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthService auth = context.read<AuthService>();
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 70),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Card(
                child: ListTile(
                  leading: notifier.darkTheme
                      ? Icon(Icons.wb_sunny)
                      : Icon(Icons.nights_stay),
                  subtitle: Text('App will reload'),
                  title: Text(
                    '${notifier.darkTheme ? 'Switch to light mode' : 'Switch to dark mode'}',
                  ),
                  trailing: Switch(
                    value: notifier.darkTheme,
                    activeColor: Theme.of(context).colorScheme.secondary,
                    onChanged: (value) {
                      notifier.toggleTheme();
                    },
                  ),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Route route =
                      MaterialPageRoute(builder: (context) => MyAccountView());
                  Navigator.of(context).push(route);
                },
                child: ListTile(
                  title: Text('My account'),
                  subtitle: Text('${auth.getCurrentUser().email}'),
                  leading: Icon(Icons.account_circle),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                    builder: (context) => HelpAndFeedback(),
                  );
                  Navigator.of(context).push(route);
                },
                child: ListTile(
                  title: Text('Help & Feedback'),
                  subtitle: Text(''),
                  leading: Icon(Icons.help),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                      builder: (context) => AllTimeDataView());
                  Navigator.of(context).push(route);
                },
                child: ListTile(
                  title: Text('All-Time User Budget Data'),
                  subtitle: Text('Financial statisics'),
                  leading: Icon(Icons.analytics),
                ),
              ),
            ),
            Card(
              child: InkWell(
                onTap: () {
                  Route route = MaterialPageRoute(
                    builder: (context) => AboutView(),
                  );
                  Navigator.of(context).push(route);
                },
                child: ListTile(
                  title: Text('About'),
                  subtitle: Text('www.cedibudget.com'),
                  leading: Icon(Icons.info),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
