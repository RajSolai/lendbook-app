import 'package:flutter/material.dart';
import 'package:lendbook/pages/addbook.dart';
import 'package:lendbook/pages/splash.dart';
import 'package:lendbook/pages/login.dart';
import 'package:lendbook/pages/register.dart';
import 'package:lendbook/pages/home.dart';

main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LendBook",
      home: Splash(),
      routes: {
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/home": (context) => Home(),
        "/addbook": (context) => AddBook()
      },
      theme: ThemeData(
          fontFamily: "Inter",
          primaryColor: Color(0xFFF2C94C),
          accentColor: Color(0xFFF2C94C),
          accentColorBrightness: Brightness.light),
    );
  }
}
