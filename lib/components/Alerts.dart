/* import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Alerts extends AlertDialog {
  final variant, title, content;
  Alerts({this.variant, this.title, this.content}) : super();

  @override
  Widget build(BuildContext context) {
    if (variant == "email-verfication") {
      return AlertDialog(
        title: Text("Verification Email Sent! 📨"),
        content: Text(
            "Hey, Verification Email Has been sent to you, Please Verify your EmailID for further features like adding Favorites and Reseting Password"),
        actions: <Widget>[
          CupertinoButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          CupertinoButton(
              child: Text(
                "Nah",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              })
        ],
      );
    } else if (variant == "login-alert") {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
        ],
      );
    } else if (variant == "post-confirm-alert") {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          CupertinoButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.of(context).pop();
              }),
          CupertinoButton(
              child: Text(
                "View your posts",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed("/");
              })
        ],
      );
    }
  }
}
 */
