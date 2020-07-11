import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageBox extends StatefulWidget {
  final message, peeruid;
  const MessageBox({Key key, this.message, this.peeruid});

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  var brightness = SchedulerBinding.instance.window.platformBrightness;

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
    if (uid == widget.peeruid) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Color(0xFFF2C94C), //0xFF9852f9
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            child: Text(widget.message,
                style: TextStyle(
                    fontSize: 14,
                    color: brightness == Brightness.dark
                        ? Color(0xFF000000)
                        : Color(0xFF000000))),
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              color: Color(0xFF9852f9),
            ),
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.all(5),
            child: Text(widget.message,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )
        ],
      );
    }
  }
}
