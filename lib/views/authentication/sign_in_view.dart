import 'package:auth_buttons/auth_buttons.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'password_reset_view.dart';
import 'sign_up_view.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  final formKey = new GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[900],
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        elevation: 0,
        bottomOpacity: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => SignUpView());
                Navigator.of(context).pushReplacement(route);
              },
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
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
                    'Log in to your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 30,
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
                        ),
                        AuthTextFormField(
                          controller: _passwordController,
                          validator: (val) =>
                              val!.length < 6 ? '6 or more characters' : null,
                          hintText: 'Password',
                          obscureText: true,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: RoundedButton(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 82,
                                right: 82,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'Login',
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
                                String returnedString = await signIn();
                                hideLoadingDialog(context);
                                if (returnedString != 'Success') {
                                  showMessageSnackBar(context, returnedString);
                                } else {
                                  Navigator.popUntil(context,
                                      (_) => !Navigator.canPop(context));
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => PasswordResetView());
                    Navigator.of(context).push(route);
                  },
                  child: Text(
                    'Forgotten Password?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'OR',
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                GoogleAuthButton(
                  style: AuthButtonStyle(
                    borderRadius: 20,
                  ),
                  onPressed: () async {
                    String returnedString = await googleSignIn();
                    if (returnedString != 'Success') {
                      showMessageSnackBar(context,
                          'Error signing in with Google. Please try again');
                    } else {
                      Navigator.popUntil(
                          context, (_) => !Navigator.canPop(context));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> googleSignIn() async {
    final AuthService auth = context.read<AuthService>();

    try {
      await auth.signInWithGoogle();
      return 'Success';
    } catch (e) {
      print(e);
      return 'Error';
    }
  }

  Future<String> signIn() async {
    final AuthService auth = context.read<AuthService>();

    try {
      await auth.signInWithEmailAndPassword(
          _emailController.text.trim(), _passwordController.text);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      print(e);
      return 'Unknown Error';
    }
  }
}
