import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/views/my_account/my_account_view.dart';
import 'package:cedi_budget_update/widgets/app_bar_home_button.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UpdateUserAccountInfoView extends StatefulWidget {
  const UpdateUserAccountInfoView({Key? key}) : super(key: key);

  @override
  _UpdateUserAccountInfoViewState createState() =>
      _UpdateUserAccountInfoViewState();
}

class _UpdateUserAccountInfoViewState extends State<UpdateUserAccountInfoView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = AuthService().getCurrentUser().displayName!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Update My Account'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: const [AppBarHomeButton()],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 30,
                  left: 30,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      UpdateTextFormField(
                        controller: _nameController,
                        helperText: 'Name',
                        validator: (val) {
                          if (val!.length < 2) {
                            return 'Name must have 2+ characters';
                          } else {
                            return null;
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: RoundedButton(
                          color: Theme.of(context).colorScheme.secondary,
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 50,
                              right: 50,
                              top: 10,
                              bottom: 10,
                            ),
                            child: Text(
                              'Update',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              showLoadingDialog(context);
                              String returnedString = await changeUserInfo();
                              hideLoadingDialog(context);

                              if (returnedString == 'Success') {
                                showMessageSnackBar(
                                    context, 'User info updated');
                                Navigator.pop(context);
                                Navigator.pop(context);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const MyAccountView(),
                                  ),
                                );
                              } else {
                                showMessageSnackBar(context, returnedString);
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> changeUserInfo() async {
    final AuthService auth = context.read<AuthService>();
    try {
      await auth.updateUserInfo(_nameController.text);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      print(e);
      return 'Unknown Error';
    }
  }
}
