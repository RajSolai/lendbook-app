import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  String uid;
  bool connection = true;

  _navigator() async {
    await Future.delayed(Duration(seconds: 3));
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    uid = _prefs.getString("uid");
    if (uid == null) {
      Navigator.pushReplacementNamed(context, "/register");
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  _checkConnection() async {
    var res = await Connectivity().checkConnectivity();
    if (res == ConnectivityResult.none) {
      setState(() {
        connection = false;
      });
    } else {
      _navigator();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkConnection();
  }

  @override
  Widget build(BuildContext context) {
    if (connection) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(top: 400),
          child: Center(
            child: Column(
              children: <Widget>[
                Text(
                  "LendBook",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 200,
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(top: 300),
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: 200,
                child: Center(
                  child: Image.asset("./assets/icons/no-connection-logo.png"),
                ),
              ),
              Center(
                child: Text(
                  "Lost Connection 😴",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Center(
                child: Text(
                  "Try Restarting the App !",
                  style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.italic),
                ),
              )
            ],
          ),
        )),
      );
    }
  }
}
