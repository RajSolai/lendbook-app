import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  String uid;
  Map _userDetails;
  String _userDpUrl;
  String _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.get("uid");
    });
  }

  Future<void> _getUserData() async {
    Firestore _db = Firestore.instance;
    _db.collection("userDetails").document(uid).get().then((value) {
      setState(() {
        _userDetails = value.data;
        _userDpUrl = value.data['dpurl'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUID().then((value) {
      _getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "Dashboard",
              variant: "no-avatar",
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                      child: Container(
                    height: 80,
                    width: 80,
                    child: CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                          _userDpUrl == null ? _dpDefault : _userDpUrl,
                          scale: 3.0),
                    ),
                  )),
                  SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(
                      "User Name",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(_userDetails == null
                        ? "Loading"
                        : _userDetails["displayname"]),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(
                      "State",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(_userDetails == null
                        ? "Loading"
                        : _userDetails["state"]),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(
                      "City",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(_userDetails == null
                        ? "Loading"
                        : _userDetails["city"]),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(
                      "Phone Number",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(_userDetails == null
                        ? "Loading"
                        : "(+91) " + _userDetails["phone"]),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 40),
                    title: Text(
                      "WhatsApp Number",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    trailing: Text(_userDetails == null
                        ? "Loading"
                        : "(+91) " + _userDetails["waphone"]),
                  )
                ],
              ),
            ),
            Center(
              child: CupertinoButton(
                  child: Text("View your Donations"),
                  onPressed: () {
                    Navigator.pushNamed(context, "/posts");
                  }),
            )
          ],
        ),
      ),
    ));
  }
}
