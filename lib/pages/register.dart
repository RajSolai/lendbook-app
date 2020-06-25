import 'dart:io';
import 'package:lendbook/pages/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as _path;
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
  String _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  void _emailVerificationAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Email not Verified !😕"),
            content: Text(
                "Hey, It seems Your EmailId is not verified. Please Verify your EmailID for further features like adding Favorites and Reseting Password"),
            actions: <Widget>[
              CupertinoButton(
                  child: Text("Okay,I'll do it 👍"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoButton(
                  child: Text("Nah 😑"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> _uploadDP() async {
    // ! pickImage is considered to be Depreciated :-/
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
          duration: Toast.LENGTH_LONG);
      print("File Uploading");
    }
    await storageUploadTask.onComplete;
    storageReference.getDownloadURL().then((value) {
      print("VALUE RETURN" + value);
      setState(() {
        _dpImageUrl = value;
      });
      Toast.show("Image Uploaded !", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
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

  void _signUp(email, pass, displayname) async {
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
        'name': displayName,
        'email': emailid,
        'dp': _dpImageUrl == null ? _dpDefault : _dpImageUrl
      };
      _db.collection('userDetails').document(email).setData(data);
      _loginAlerts("Cheers 🍷", "your account is created, Now you can Login");
      Navigator.of(context).pushReplacementNamed("/login");
    });
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
                            height: 20,
                          ),
                          Text(
                            "Select Profile Picture",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          SizedBox(
                            height: 10,
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
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                        _signUp(emailid, password, displayName);
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
