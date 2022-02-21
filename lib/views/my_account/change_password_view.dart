import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/widgets/alert_dialog.dart';
import 'package:cedi_budget_update/widgets/app_bar_home_button.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  _ChangePasswordViewState createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
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
                        controller: _oldPasswordController,
                        helperText: 'Old Password',
                        obscureText: true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please enter old password';
                          } else {
                            return null;
                          }
                        },
                      ),
                      UpdateTextFormField(
                        controller: _newPasswordController,
                        validator: (val) {
                          if (val!.length < 6) {
                            return 'New password must have 6 or more characters';
                          } else if (val != _confirmPasswordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                        helperText: 'New Password',
                        obscureText: true,
                      ),
                      UpdateTextFormField(
                        controller: _confirmPasswordController,
                        validator: (val) {
                          if (val!.length < 6) {
                            return 'New password must have 6 or more characters';
                          } else if (val != _newPasswordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                        helperText: 'Confirm Password',
                        obscureText: true,
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
                              'Change',
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
                              String returnedString = await changePassword();
                              if (returnedString == 'Success') {
                                hideLoadingDialog(context);
                                showAlertDialog(context, 'Success!',
                                    'Password succesfully changed');
                                setState(() {
                                  _confirmPasswordController.clear();
                                  _newPasswordController.clear();
                                  _oldPasswordController.clear();
                                });
                              } else {
                                hideLoadingDialog(context);
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

  Future<String> changePassword() async {
    AuthService auth = context.read<AuthService>();
    try {
      await auth.changePassword(
          _oldPasswordController.text, _newPasswordController.text);
      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return 'Unknown Error';
    }
  }
}
