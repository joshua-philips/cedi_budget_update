import 'package:cedi_budget_update/models/budget.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/views/budget_details/budget_details_view.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:flutter/material.dart';

class EditNotesView extends StatefulWidget {
  final Budget budget;

  const EditNotesView({Key? key, required this.budget}) : super(key: key);
  @override
  EditNotesViewState createState() => EditNotesViewState();
}

class EditNotesViewState extends State<EditNotesView> {
  final TextEditingController _notesController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.budget.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              buildHeading(context),
              buildNotesText(),
              buildSubmitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeading(context) {
    // Using Material to prevent problems with the Hero transition
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Text(
            'Edit Budget Notes',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          TextButton(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).iconTheme.color!,
                  width: 2,
                ),
              ),
              child: Icon(
                Icons.close,
                size: 20,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Widget buildNotesText() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        maxLines: null,
        controller: _notesController,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 2,
            ),
          ),
          border: InputBorder.none,
        ),
        autofocus: true,
        textCapitalization: TextCapitalization.sentences,
      ),
    );
  }

  Widget buildSubmitButton(context) {
    final uid = AuthService().getCurrentUID();
    final databaseService = DatabaseService();
    return RoundedButton(
      color: Theme.of(context).colorScheme.secondary,
      child: const Padding(
        padding: EdgeInsets.only(
          left: 30,
          right: 30,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          'Save',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      onPressed: () async {
        showLoadingDialog(context);
        widget.budget.notes = _notesController.text;

        try {
          await databaseService.updateNotes(
              uid, _notesController.text.trim(), widget.budget);
          hideLoadingDialog(context);
        } catch (e) {
          hideLoadingDialog(context);
          // showMessageSnackBar(context, e.message);
        }
        Route route = MaterialPageRoute(
          builder: (context) => BudgetDetailsView(
            budget: widget.budget,
          ),
        );
        // Pop twice and then push the Detail Trip View to refresh
        Navigator.of(context).pop();
        Navigator.of(context).pop();
        Navigator.push(context, route);
      },
    );
  }
}
