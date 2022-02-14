import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData.light().copyWith(
  brightness: Brightness.light,
  primaryColor: Colors.grey[200],
  colorScheme: ColorScheme.fromSwatch(
    accentColor: Colors.redAccent[700],
    primarySwatch: Colors.red,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: Colors.grey[200],
  textTheme: GoogleFonts.quicksandTextTheme(
    TextTheme(
      bodyText2: TextStyle(color: Colors.black, fontFamily: 'Quicksand'),
    ),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.grey[200],
    titleTextStyle: TextStyle(
      color: Colors.black,
      fontSize: 20,
    ),
    iconTheme: IconThemeData(
      color: Colors.black,
    ),
    toolbarTextStyle: GoogleFonts.quicksand().copyWith(),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    elevation: 0,
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
  cardTheme: CardTheme(
    elevation: 0.5,
  ),
);

ThemeData dark = ThemeData.dark().copyWith(
  brightness: Brightness.dark,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.fromSwatch(
    accentColor: Colors.redAccent,
    primarySwatch: Colors.red,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: Colors.black,
  textTheme: GoogleFonts.quicksandTextTheme(
    TextTheme(
      bodyText2: TextStyle(color: Colors.white),
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    elevation: 0,
    toolbarTextStyle: GoogleFonts.quicksand().copyWith(),
  ),
  pageTransitionsTheme: PageTransitionsTheme(
    builders: {
      TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = 'theme';
  late SharedPreferences _pref;
  late bool _darkTheme;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  // toggle theme: if false change to true, if true change to false
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  /// Inititalize the _pref value
  Future<void> _initPrefs() async {
    _pref = await SharedPreferences.getInstance();
  }

  /// Get theme from SharedPreferences
  void _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _pref.getBool(key) ?? false;
    notifyListeners();
  }

  /// Save theme to SharedPreferences
  _saveToPrefs() async {
    await _initPrefs();
    _pref.setBool(key, _darkTheme);
  }
}
