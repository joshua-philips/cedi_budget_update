import 'package:cedi_budget_update/lorem.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/widgets/alert_dialog.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HelpAndFeedback extends StatefulWidget {
  const HelpAndFeedback({Key? key}) : super(key: key);

  @override
  HelpAndFeedbackState createState() => HelpAndFeedbackState();
}

class HelpAndFeedbackState extends State<HelpAndFeedback> {
  final TextEditingController _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String uid = context.read<AuthService>().getCurrentUser().uid;
    final DatabaseService databaseService = context.read<DatabaseService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Feedback'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ExpansionTile(
            title: const Text('Guidelines'),
            childrenPadding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            children: [
              Text(
                shortLorem,
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Privacy Policy'),
            childrenPadding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            children: [
              Text(
                shortLorem,
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Contributors'),
            childrenPadding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            children: [
              Row(
                children: [
                  Text(contributors),
                ],
              ),
            ],
          ),
          ExpansionTile(
            title: const Text('Feedback'),
            initiallyExpanded: true,
            childrenPadding:
                const EdgeInsets.only(left: 30, right: 30, bottom: 20),
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                    'Ideas and suggestions to make this app better.\n\nFeedback:'),
              ),
              TextFormField(
                maxLines: 5,
                controller: _feedbackController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(width: 10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              RoundedButton(
                color: Theme.of(context).colorScheme.secondary,
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () async {
                  if (_feedbackController.text.trim().isNotEmpty) {
                    String suggestion = _feedbackController.text;
                    showAlertDialog(
                      context,
                      'Thank You',
                      'Your feedback and suggestions have been sent to the developers. Expect to hear from us soon',
                    );
                    setState(() {
                      _feedbackController.clear();
                    });
                    await databaseService.uploadFeeback(uid, suggestion);
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
