import 'package:auto_size_text/auto_size_text.dart';
import 'package:cedi_budget_update/services/auth_service.dart';
import 'package:cedi_budget_update/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../my_account/update_user_account_info_view.dart';
import 'change_password_view.dart';

class MyAccountView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = context.watch<AuthService>();
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account'),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  displayUserInformation(context, auth),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => UpdateUserAccountInfoView(),
                      );
                      Navigator.push(context, route);
                    },
                    icon: Icon(Icons.account_circle),
                    label: Text(
                      'Update Account Info',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      primary: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      Route route = MaterialPageRoute(
                        builder: (context) => ChangePasswordView(),
                      );
                      Navigator.push(context, route);
                    },
                    icon: Icon(Icons.lock_rounded),
                    label: Text(
                      'Change Password',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 10),
                  RoundedButton(
                    color: Theme.of(context).colorScheme.secondary,
                    child: Padding(
                      padding: const EdgeInsets.only(
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
                      try {
                        await auth.signOut();
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
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
          SizedBox(height: 10),
          displayName(auth),
          SizedBox(height: 10),
          displayEmail(auth),
          SizedBox(height: 10),
          displayPhoneNumber(auth),
          SizedBox(height: 5),
          displayDateCreated(auth, context),
        ],
      ),
    );
  }

  Widget displayEmail(AuthService auth) {
    return Text(
      auth.getCurrentUser().email!,
      style: TextStyle(fontSize: 20),
    );
  }

  Widget displayDateCreated(AuthService auth, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.17,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('member since'),
            SizedBox(height: 10),
            Flexible(
              child: AutoSizeText(
                '${DateFormat('EEE, MMM dd, yyyy').format(auth.getCurrentUser().metadata.creationTime!)}',
                maxLines: 1,
                style: TextStyle(fontSize: 35),
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
        style: TextStyle(fontSize: 20),
      );
    } else {
      return Container();
    }
  }

  Widget displayPhoneNumber(AuthService auth) {
    if (auth.getCurrentUser().phoneNumber != null) {
      return Text(auth.getCurrentUser().phoneNumber!);
    } else {
      return Text('');
    }
  }

  Widget displayImage(AuthService auth, context) {
    if (auth.getProfileImageUrl() != null) {
      return CircleAvatar(
        radius: 70,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        backgroundImage: NetworkImage(
          auth.getProfileImageUrl(),
        ),
      );
    } else {
      return Icon(
        Icons.account_circle,
        size: 150,
      );
    }
  }
}
