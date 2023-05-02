import 'package:auth_buttons/auth_buttons.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/views/authentication/sign_in_view.dart';
import 'package:cedi_budget_update/widgets/form_fields.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:cedi_budget_update/widgets/snackbar_and_loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  SignUpViewState createState() => SignUpViewState();
}

class SignUpViewState extends State<SignUpView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                    MaterialPageRoute(builder: (context) => const SignInView());
                Navigator.of(context).pushReplacement(route);
              },
              child: const Text(
                'Login',
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
            physics: const BouncingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Create your account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    right: 10,
                    left: 10,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AuthTextFormField(
                          controller: _nameController,
                          hintText: 'Name',
                        ),
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
                            child: const Padding(
                              padding: EdgeInsets.only(
                                left: 75,
                                right: 75,
                                top: 10,
                                bottom: 10,
                              ),
                              child: Text(
                                'Sign Up',
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
                                String returnedString = await signUp();

                                if (context.mounted) {
                                  hideLoadingDialog(context);
                                  if (returnedString != 'Success') {
                                    showMessageSnackBar(
                                        context, returnedString);
                                  } else {
                                    Navigator.popUntil(context,
                                        (_) => !Navigator.canPop(context));
                                  }
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'OR',
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 20),
                        GoogleAuthButton(
                          style: const AuthButtonStyle(
                            borderRadius: 20,
                          ),
                          onPressed: () async {
                            String returnedString = await googleSignIn();

                            if (context.mounted) {
                              if (returnedString != 'Success') {
                                showMessageSnackBar(context,
                                    'Error signing in with Google. Please try again');
                              } else {
                                Navigator.popUntil(
                                    context, (_) => !Navigator.canPop(context));
                              }
                            }
                          },
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

  Future<String> googleSignIn() async {
    final AuthService auth = context.read<AuthService>();

    try {
      await auth.signInWithGoogle();
      return 'Success';
    } catch (e) {
      return 'Error';
    }
  }

  Future<String> signUp() async {
    final AuthService auth = context.read<AuthService>();

    try {
      await auth.createUserWithEmailAndPassword(_emailController.text.trim(),
          _passwordController.text, _nameController.text);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return 'Unknown Error';
    }
  }
}
