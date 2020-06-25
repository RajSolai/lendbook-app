import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lendbook/pages/login.dart';

class CustomAppBar extends StatelessWidget {
  final title, variant;
  CustomAppBar({this.title, this.variant});

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
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: 80,
          ),
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
                      CupertinoPageRoute(builder: (context) => Login()));
                },
                child: CircleAvatar(
                    child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image(
                    image: AssetImage(
                      "./assets/avatar/cat-icon.png",
                    ),
                  ),
                )),
              )),
          SizedBox(
            width: 5,
          ),
          Container(
            margin: EdgeInsets.only(top: 40, bottom: 0),
            padding: EdgeInsets.all(10),
            child: Text(
              this.title,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
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
