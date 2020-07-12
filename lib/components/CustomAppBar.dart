import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lendbook/animations/slidepageroute.dart';
import 'package:lendbook/pages/dash.dart';
import 'package:lendbook/services/chat/messages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:badges/badges.dart';

class CustomAppBar extends StatefulWidget {
  final title, variant, dpurl, bookid, bookgrade, donorid;
  CustomAppBar(
      {this.title,
      this.variant,
      this.dpurl,
      this.bookid,
      this.donorid,
      this.bookgrade});

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  String uid;
  String _dpurl, chatbadges;

  final _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.get("uid");
    });
  }

  Future<void> _getUserData() async {
    Firestore _db = Firestore.instance;
    await _db.collection("userDetails").document(uid).get().then((value) {
      setState(() {
        _dpurl = value.data['dpurl'];
      });
    });
  }

  String _getInboxcount() {
    Firestore _db = Firestore.instance;
    _db
        .collection('userDetails')
        .document(uid)
        .collection('chat-request')
        .getDocuments()
        .then((value) {
      setState(() {
        chatbadges = value.documentChanges.toList().length.toString();
      });
    });
    return chatbadges;
  }

  @override
  void initState() {
    super.initState();
    _getUID().then((value) {
      _getUserData();
      _getInboxcount();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.variant == "no-avatar") {
      return Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
                margin: EdgeInsets.only(top: 40),
                height: 40,
                width: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(CupertinoIcons.back),
                )),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0),
            padding: EdgeInsets.all(10),
            child: Text(
              this.widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
          ),
        ],
      ));
    } else if (widget.variant == "chat") {
      //* if the user is the donor
      if (widget.donorid == uid) {
        return Container(
            child: Row(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            /* SizedBox(
              width: 20,
            ), */
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.back),
                  )),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 0),
              padding: EdgeInsets.all(10),
              child: Text(
                this.widget.title + "Donor",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            /* SizedBox(
              width: 80,
            ), */
            Container(
                margin: EdgeInsets.only(top: 40, bottom: 0, right: 10),
                child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.search),
                    tooltip: "Mark book as Donated and Delete it",
                    onPressed: () {
                      Firestore()
                          .collection("BookPosts")
                          .document("bookgrade")
                          .collection("booksubject")
                          .document("bookid")
                          .delete()
                          .whenComplete(() => {print("Document Deleted")});
                    }))
          ],
        ));
      } else {
        //* if the user is not the donor
        return Container(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: EdgeInsets.only(top: 40),
                  height: 40,
                  width: 40,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(CupertinoIcons.back),
                  )),
            ),
            SizedBox(
              width: 5,
            ),
            Container(
              margin: EdgeInsets.only(top: 40, bottom: 0),
              padding: EdgeInsets.all(10),
              child: Text(
                this.widget.title + " not donor",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              width: 80,
            ),
          ],
        ));
      }
    } else if (widget.variant == "search") {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0, left: 10),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SlideRightRoute(page: DashBoard()));
                  },
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        _dpurl == null ? _dpDefault : _dpurl),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  this.widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 40, bottom: 0, right: 10),
              child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, "/search");
                  }))
        ],
      ));
    } else if (widget.variant == "search,msgs") {
      return Container(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0, left: 10),
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.push(context, SlideRightRoute(page: DashBoard()));
                  },
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        _dpurl == null ? _dpDefault : _dpurl),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  this.widget.title,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(top: 40, bottom: 0, left: 90),
              child: IconButton(
                  icon: FaIcon(FontAwesomeIcons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, "/search");
                  })),
          Container(
              margin: EdgeInsets.only(top: 40, bottom: 0, right: 25),
              child: Badge(
                elevation: 5,
                toAnimate: true,
                animationType: BadgeAnimationType.fade,
                badgeContent: Text(
                  _getInboxcount() == null ? '0' : _getInboxcount(),
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
                child: IconButton(
                    icon: FaIcon(FontAwesomeIcons.inbox),
                    onPressed: () {
                      // Navigator.pushNamed(context, "/allmessages");
                      Navigator.push(context, SlideLeftRoute(page: Messages()));
                    }),
              ))
        ],
      ));
    } else {
      return Container(
          child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Container(
              margin: EdgeInsets.only(top: 40),
              height: 40,
              width: 40,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, SlideRightRoute(page: DashBoard()));
                },
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(
                      _dpurl == null ? _dpDefault : _dpurl),
                ),
              )),
          SizedBox(
            width: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0),
            padding: EdgeInsets.all(10),
            child: Text(
              this.widget.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
          ),
        ],
      ));
    }
  }
}
