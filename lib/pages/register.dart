import 'dart:io';
import 'package:lendbook/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as _path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _fireauth = FirebaseAuth.instance;
  File _dpImage;
  String _dpImageUrl;
  String emailid;
  String password;
  String displayName;
  String dp;
  String _city;
  String _state;
  String _phoneno;
  String _waphoneno;
  String userState;
  String _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";
  bool _isSchool = false;

  Future<void> _setdata(key, data) async {
    final _prefs = await SharedPreferences.getInstance();
    _prefs.setString(key, data);
  }

  Future<void> _emailVerificationAlert() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("Verification Email Sent! 📨"),
            content: Text(
                "Hey, Verification Email Has been sent to you, Please Verify your EmailID for further features like adding Favorites and Reseting Password"),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                  textStyle: TextStyle(color: Colors.red),
                  child: Text("Nah"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> _uploadDP() async {
    // ! pickImage is considered to be Depreciated :-/
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _dpImage = value;
      });
    });
    String filename = _path.basename(_dpImage.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("/profilePics").child(filename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_dpImage);
    if (storageUploadTask.isInProgress) {
      Toast.show("Uploading Profile Picture", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Duration.hoursPerDay);
      print("File Uploading");
    }
    await storageUploadTask.onComplete;
    storageReference.getDownloadURL().then((value) {
      print("VALUE RETURN" + value);
      setState(() {
        _dpImageUrl = value;
      });
      _setdata("dpurl", value);
      Toast.show("Image Uploaded !", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
    });
  }

  Future<void> _loginAlerts(String title, String content) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoDialogAction(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void _checkValuesAndSignUp(email, pass, displayname) {
    if (email != null &&
        pass != null &&
        displayname != null &&
        _city != null &&
        _state != null &&
        _isSchool != null &&
        _phoneno != null &&
        _waphoneno != null) {
      _signUp(email, pass, displayname);
    } else {
      print("Fill all the Values");
      _loginAlerts("Values Not Filled 😕",
          "Hey! , It Seems you missed some fields without filling");
    }
  }

  Future<void> _signUp(email, pass, displayname) async {
    await _fireauth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .catchError((error) {
      if (error.message ==
          "The given password is invalid. [ Password should be at least 6 characters ]") {
        _loginAlerts(
            "Weak Password 😕", "Password must contain alteast 6 character ");
      } else if (error.message == "The email address is badly formatted.") {
        _loginAlerts("Bad EmailID 😕", "Please Type in the correct Email id");
      } else if (error.message ==
          "The email address is already in use by another account.") {
        _loginAlerts("Email in USE 🙅", error.message);
      } else {
        _loginAlerts("Error", "Cant Reach Servers 😴");
      }
      print(error.message);
    }).then((res) {
      // * user update info
      res.user.sendEmailVerification().then((value) {
        _emailVerificationAlert();
        print("Email for verification sent");
      });
      UserUpdateInfo info = new UserUpdateInfo();
      info.displayName = displayname;
      info.photoUrl = _dpImageUrl == null ? _dpDefault : _dpImageUrl;
      Firestore _db = Firestore.instance;
      res.user.updateProfile(info);
      var data = {
        'displayname': displayName,
        'email': emailid,
        'dpurl': _dpImageUrl == null ? _dpDefault : _dpImageUrl,
        'city': _city.toUpperCase(),
        'state': _state.toUpperCase(),
        'phone': _phoneno,
        'waphone': _waphoneno,
        'grade': _isSchool ? "School" : "College"
      };
      _db.collection('userDetails').document(res.user.uid).setData(data);
      _loginAlerts("Cheers 🍷", "your account is created, Now you can Login");
      Navigator.of(context).pushReplacementNamed("/login");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 50),
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 75),
                      child: Text(
                        "Welcome To LendBook !",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      padding: EdgeInsets.all(50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Nick Name",
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
                                  hintText: "Provide your Name"),
                              onChanged: (value) {
                                setState(() {
                                  displayName = value;
                                });
                              }),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: null,
                          ),
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
                                  hintText: "eg: username@domain.com"),
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
                                      'Must contain atleast 6 characters'),
                              onChanged: (value) {
                                setState(() {
                                  password = value;
                                });
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "State",
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
                                  hintText: "eg: Karnataka"),
                              onChanged: (value) {
                                setState(() {
                                  _state = value;
                                });
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "City",
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
                                  hintText: 'eg : Bengaluru'),
                              onChanged: (value) {
                                setState(() {
                                  _city = value;
                                });
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "Phone Number (without +91)",
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
                                  hintText: 'eg : 9984452254'),
                              onChanged: (value) {
                                setState(() {
                                  _phoneno = value;
                                });
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            "WhatsApp Number (without +91)",
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
                                  hintText: 'eg : 9984452254'),
                              onChanged: (value) {
                                setState(() {
                                  _waphoneno = value;
                                });
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Select Profile Picture",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    height: 70,
                                    width: 70,
                                    child: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          _dpImageUrl == null
                                              ? _dpDefault
                                              : _dpImageUrl),
                                    )),
                                SizedBox(
                                  width: 40,
                                ),
                                Container(
                                  child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Text(
                                      "Upload",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      _uploadDP();
                                    },
                                  ),
                                ),
                                Container(
                                  child: CupertinoButton(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Text(
                                      "Clear",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _dpImage = null;
                                        _dpImageUrl = _dpDefault;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            child: ListTile(
                              title: Text("Are you a School Student ?"),
                              trailing: CupertinoSwitch(
                                  value: _isSchool,
                                  onChanged: (bool val) {
                                    setState(() {
                                      _isSchool = val;
                                    });
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoButton(
                      color: Color(0xFFF2C94C),
                      borderRadius: BorderRadius.circular(10),
                      child: Text(
                        "Create Account",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w500),
                      ),
                      onPressed: () {
                        _checkValuesAndSignUp(emailid, password, displayName);
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    CupertinoButton(
                      child: Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) => Login()));
                      },
                    ),
                  ],
                ))));
  }
}
