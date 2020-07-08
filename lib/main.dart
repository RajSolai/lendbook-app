import 'package:flutter/material.dart';
import 'package:lendbook/pages/addbook.dart';
import 'package:lendbook/pages/myposts.dart';
import 'package:lendbook/pages/search.dart';
import 'package:lendbook/pages/splash.dart';
import 'package:lendbook/pages/login.dart';
import 'package:lendbook/pages/register.dart';
import 'package:lendbook/pages/home.dart';
import 'package:lendbook/services/chat/messages.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;

main(List<String> args) {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: const <Locale>[
        Locale('en', ''),
        Locale('ar', ''),
      ],
      debugShowCheckedModeBanner: false,
      title: "LendBook",
      home: Splash(),
      routes: {
        "/login": (context) => Login(),
        "/register": (context) => Register(),
        "/home": (context) => Home(),
        "/addbook": (context) => AddBook(),
        "/posts": (context) => MyPosts(),
        "/search": (context) => SearchPage(),
        "/allmessages": (context) => Messages()
      },
      theme: ThemeData(
          fontFamily: "Inter",
          primaryColor: Color(0xFFF2C94C),
          accentColor: Color(0xFFF2C94C),
          accentColorBrightness: Brightness.light),
    );
  }
}
