import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lendbook/pages/addbook.dart';
import 'package:lendbook/pages/myposts.dart';
import 'package:lendbook/pages/search.dart';
import 'package:lendbook/pages/splash.dart';
import 'package:lendbook/pages/login.dart';
import 'package:lendbook/pages/register.dart';
import 'package:lendbook/pages/home.dart';
import 'package:lendbook/services/chat/messages.dart';

main(List<String> args) {
  runApp(App());
  var brightness = SchedulerBinding.instance.window.platformBrightness;
  if (brightness == Brightness.dark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light
        .copyWith(systemNavigationBarColor: Colors.black));
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
          scaffoldBackgroundColor: Color.fromARGB(255, 238, 238, 238),
          fontFamily: "Inter",
          primaryColor: Color(0xFFF2C94C),
          accentColor: Color(0xFFF2C94C),
          accentColorBrightness: Brightness.light),
      darkTheme: ThemeData(
          scaffoldBackgroundColor: Color.fromARGB(255, 34, 40, 49),
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(color: Color(0xFFd8dcd6))),
          cardColor: Color(0xFF30475e),
          cupertinoOverrideTheme: CupertinoThemeData(
              textTheme: CupertinoTextThemeData(primaryColor: Colors.white))),
    );
  }
}
