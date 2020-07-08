import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuCards extends StatefulWidget {
  final name, icon;
  MenuCards({this.name, this.icon});

  @override
  _MenuCardsState createState() => _MenuCardsState();
}

class _MenuCardsState extends State<MenuCards> {
  Color _normalcolor = new Color(0xFF9852f9);
  Color _color;

  @override
  void initState() {
    super.initState();
    setState(() {
      _color = _normalcolor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: _color, borderRadius: BorderRadius.all(Radius.circular(8))),
        width: 120,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FaIcon(
              widget.icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              widget.name,
              style: TextStyle(fontSize: 14, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
