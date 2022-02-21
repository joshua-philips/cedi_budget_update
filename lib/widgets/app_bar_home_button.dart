import 'package:flutter/material.dart';

/// Return to the home screen no matter where you are in the app
class AppBarHomeButton extends StatelessWidget {
  const AppBarHomeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Home',
      padding: const EdgeInsets.only(right: 10),
      icon: const Icon(Icons.home_filled),
      onPressed: () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      },
    );
  }
}
