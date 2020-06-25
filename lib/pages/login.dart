import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _fireauth = FirebaseAuth.instance;
  String emailid;
  String password;
  String displayName;

  Future _setdata(key, data) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, data);
  }

  void _emailVerificationAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email not Verified !😕"),
            content: Text(
                "Hey, It seems Your EmailId is not verified. Please Verify your EmailID and Login again"),
            actions: <Widget>[
              CupertinoButton(
                  child: Text("Okay,I'll do it 👍"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _loginAlerts(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoButton(
                  child: Text("Okay 👍"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _login(email, pass) async {
    await _fireauth
        .signInWithEmailAndPassword(email: email, password: pass)
        .catchError((error) {
      if (error.message ==
          "The password is invalid or the user does not have a password.") {
        _loginAlerts(
            "Password Incorrect 😑", "Password Incorrect , Try Again ");
      } else if (error.message == "The email address is badly formatted.") {
        _loginAlerts("Bad Email ID 😕", "Please Type in the correct Email id ");
      } else if (error.message ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        _loginAlerts("No User Found 😅",
            "Oppsie , No User found for given Email id. Please Create a Account ");
      } else {
        Toast.show("Cant Reach Servers 😴", context,
            gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
      }
      print(error.message);
    }).then((res) {
      if (res.user.isEmailVerified) {
        _setdata("uid", res.user.uid);
        _setdata("username", res.user.displayName);
        Navigator.of(context).pushReplacementNamed("/home");
      } else {
        _emailVerificationAlert();
      }
    });
  }

  void _forgetPass(_email) async {
    if (_email == null) {
      Toast.show("Enter an email id to reset the password 🙄", context,
          duration: Toast.LENGTH_LONG);
    } else {
      await _fireauth.sendPasswordResetEmail(email: _email).then((res) {
        Toast.show("Check your Mail inbox to reset the password 💥", context,
            duration: Toast.LENGTH_LONG);
      }).catchError((err) {
        if (err.message == "The email address is badly formatted.") {
          Toast.show("Please Type in the correct Email id 😕", context,
              duration: Toast.LENGTH_LONG);
        } else if (err.message ==
            "There is no user record corresponding to this identifier. The user may have been deleted.") {
          Toast.show("Oppsie , No User found for given Email id 😅", context,
              duration: Toast.LENGTH_LONG);
        } else if (err.message == "Given String is empty or null") {
          Toast.show("Enter an email id to reset the password 🙄", context,
              duration: Toast.LENGTH_LONG);
        } else {
          Toast.show("Cant Reach Servers 😴", context,
              gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
        }
        print(err.message);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(top: 75),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Email Address",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText: "example : username@domain.com"),
                              onChanged: (value) {
                                setState(() {
                                  emailid = value;
                                });
                              }),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: null,
                          ),
                          Text(
                            "Password",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextField(
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  hintText:
                                      "must contain atleast 6 characters"),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              })
                        ],
                      ),
                    ),
                    CupertinoButton(
                        color: Color(0xFFF2C94C),
                        borderRadius: BorderRadius.circular(10),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () => _login(emailid, password)),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                        color: Color(0xFFF2C94C),
                        borderRadius: BorderRadius.circular(10),
                        child: Text("Create new Account",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/register");
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    CupertinoButton(
                      child: Text(
                        "Forgot password ?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        _forgetPass(emailid);
                      },
                    ),
                    // TODO : Remove this on Production
                    CupertinoButton(
                        borderRadius: BorderRadius.circular(10),
                        child: Text("SKIP_LOGIN",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, "/home");
                        }),
                  ],
                ))));
  }
}
