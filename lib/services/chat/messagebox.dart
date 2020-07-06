import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageBox extends StatefulWidget {
  final message, peeruid;
  const MessageBox({Key key, this.message, this.peeruid});

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  String uid;

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.get("uid");
    });
  }

  @override
  void initState() {
    super.initState();
    _getUID();
  }

  @override
  Widget build(BuildContext context) {
    if (uid != widget.peeruid) {
      return Container(
        height: 50,
        child: Card(
          color: Color(0xFFF2C94C),
          elevation: 10,
          child: Text(
            widget.message,
            textAlign: TextAlign.start,
          ),
        ),
      );
    } else {
      return Container(
        height: 50,
        child: Card(
          color: Color(0xFFcfe5cf),
          elevation: 10,
          child: Text(
            widget.message,
            textAlign: TextAlign.start,
          ),
        ),
      );
    }
  }
}
