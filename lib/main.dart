import 'package:cedi_budget_update/services/database_service.dart';
import 'package:cedi_budget_update/services/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'views/authentication/firstview.dart';
import 'views/authentication/sign_in_view.dart';
import 'views/authentication/sign_up_view.dart';
import 'views/navigation/navigation_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
        ),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<DatabaseService>(
          create: (_) => DatabaseService(),
        )
      ],
      builder: (context, child) {
        return MaterialApp(
          title: 'Cedi Budget',
          debugShowCheckedModeBanner: false,
          theme: context.watch<ThemeNotifier>().darkTheme ? dark : light,
          home: const HomeController(),
          routes: <String, WidgetBuilder>{
            '/home': (BuildContext context) => const HomeController(),
            '/signUp': (BuildContext context) => const SignUpView(),
            '/signIn': (BuildContext context) => const SignInView(),
          },
        );
      },
    );
  }
}

class HomeController extends StatelessWidget {
  const HomeController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.watch<AuthService>().onAuthStateChanged,
      builder: (context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? const NavigationView() : const FirstView();
        }
        return const Scaffold(
          body: Center(),
        );
      },
    );
  }
}
