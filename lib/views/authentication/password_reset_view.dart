import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PasswordResetView extends StatefulWidget {
  @override
  _PasswordResetViewState createState() => _PasswordResetViewState();
}

class _PasswordResetViewState extends State<PasswordResetView> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        elevation: 0,
        bottomOpacity: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.red[900],
        child: Padding(
          padding: const EdgeInsets.only(right: 30, left: 30),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    'Password Reset',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 80,
                    right: 10,
                    left: 10,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AuthTextFormField(
                          controller: _emailController,
                          validator: (val) =>
                              !val!.contains('@') ? 'Invalid Email' : null,
                          hintText: 'Email',
                          autofocus: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: RoundedButton(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 50,
                                right: 50,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'Submit',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                showLoadingDialog(context);
                                String returnedString = await sendResetEmail();
                                hideLoadingDialog(context);
                                showMessageSnackBar(context, returnedString);
                              }
                            },
                            color: Colors.white,
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
      ),
    );
  }

  Future<String> sendResetEmail() async {
    final AuthService auth = context.read<AuthService>();
    try {
      await auth.sendPasswordResetEmail(_emailController.text.trim());
      return 'Password reset email sent';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      print(e);
      return 'Unknown Error';
    }
  }
}
