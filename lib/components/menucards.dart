import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuCards extends StatefulWidget {
  final name, icon;
  MenuCards({this.name, this.icon});

  @override
  _MenuCardsState createState() => _MenuCardsState();
}

class _MenuCardsState extends State<MenuCards> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            padding: EdgeInsets.only(top: 70),
            height: 180,
            width: 180,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FaIcon(this.widget.icon , size: 25),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    this.widget.name,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),
            decoration: BoxDecoration(
                color: Color(0xFFF2C94C),
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    spreadRadius: 2.0,
                    blurRadius: 10.0,
                  ),
                ]),
          ),
        ));
  }
}
