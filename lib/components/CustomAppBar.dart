import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lendbook/pages/dash.dart';

class CustomAppBar extends StatelessWidget {
  final _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  final title, variant, dpurl;
  CustomAppBar({this.title, this.variant, this.dpurl});

  @override
  Widget build(BuildContext context) {
    if (variant == "no-avatar") {
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
                  Navigator.pop(context);
                },
                child: Icon(CupertinoIcons.back),
              )),
          SizedBox(
            width: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0),
            padding: EdgeInsets.all(10),
            child: Text(
              this.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
          ),
        ],
      ));
    } else if (variant == "search") {
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
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) => DashBoard()));
                  },
                  child: CircleAvatar(
                    backgroundImage:
                        NetworkImage(dpurl == null ? _dpDefault : dpurl),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  this.title,
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
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) => DashBoard()));
                },
                child: CircleAvatar(
                  backgroundImage:
                      NetworkImage(dpurl == null ? _dpDefault : dpurl),
                ),
              )),
          SizedBox(
            width: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0),
            padding: EdgeInsets.all(10),
            child: Text(
              this.title,
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
