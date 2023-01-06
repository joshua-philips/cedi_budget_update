import 'package:auto_size_text/auto_size_text.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../my_account/update_user_account_info_view.dart';
import 'change_password_view.dart';

class MyAccountView extends StatelessWidget {
  const MyAccountView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Account'),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                displayUserInformation(context, auth),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => const UpdateUserAccountInfoView(),
                    );
                    Navigator.push(context, route);
                  },
                  icon: const Icon(Icons.account_circle),
                  label: const Text(
                    'Update Account Info',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    Route route = MaterialPageRoute(
                      builder: (context) => const ChangePasswordView(),
                    );
                    Navigator.push(context, route);
                  },
                  icon: const Icon(Icons.lock_rounded),
                  label: const Text(
                    'Change Password',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
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
                      'Logout',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  onPressed: () async {
                    await auth.signOut();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayUserInformation(context, AuthService auth) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          displayImage(auth, context),
          const SizedBox(height: 10),
          displayName(auth),
          const SizedBox(height: 10),
          displayEmail(auth),
          const SizedBox(height: 10),
          displayPhoneNumber(auth),
          const SizedBox(height: 5),
          displayDateCreated(auth, context),
        ],
      ),
    );
  }

  Widget displayEmail(AuthService auth) {
    return Text(
      auth.getCurrentUser().email!,
      style: const TextStyle(fontSize: 20),
    );
  }

  Widget displayDateCreated(AuthService auth, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.17,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('member since'),
            const SizedBox(height: 10),
            Flexible(
              child: AutoSizeText(
                DateFormat('EEE, MMM dd, yyyy')
                    .format(auth.getCurrentUser().metadata.creationTime!),
                maxLines: 1,
                style: const TextStyle(fontSize: 35),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget displayName(AuthService auth) {
    if (auth.getCurrentUser().displayName != null) {
      return Text(
        auth.getCurrentUser().displayName!,
        style: const TextStyle(fontSize: 20),
      );
    } else {
      return Container();
    }
  }

  Widget displayPhoneNumber(AuthService auth) {
    if (auth.getCurrentUser().phoneNumber != null) {
      return Text(auth.getCurrentUser().phoneNumber!);
    } else {
      return const Text('');
    }
  }

  Widget displayImage(AuthService auth, context) {
    return const Icon(
      Icons.account_circle,
      size: 150,
    );
  }
}
