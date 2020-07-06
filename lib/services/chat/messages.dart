import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/components/messageRq.dart';
import 'package:lendbook/services/chat/messagebox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
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
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(
            title: "Messages",
            variant: "no-avatar",
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
                stream: Firestore.instance
                    .collection("userDetails")
                    .document(uid)
                    .collection("chat-request")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      padding: EdgeInsets.all(10),
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return MsgReq(
                            image: document['senderimg'],
                            name: document['sendername'],
                            chatdoc: document['chatdoc'],
                            chatcoll: document['chatcoll'],
                            sendername: document['sendername']);
                      }).toList(),
                    );
                  }
                }),
          )),
        ],
      ),
    );
  }
}
