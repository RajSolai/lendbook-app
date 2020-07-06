import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/services/chat/messagebox.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendMessage extends StatefulWidget {
  final donoruid, donorname, donorimg, variant, chatdoc, chatcoll, sendername;
  SendMessage({
    this.donoruid,
    this.donorname,
    this.donorimg,
    this.variant,
    this.chatdoc,
    this.chatcoll,
    this.sendername,
  });

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  String uid = "";
  String _message;

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = _prefs.get("uid");
    });
  }

  Future<void> _sendMessage() async {
    DateTime _date = DateTime.now();
    final _db = Firestore.instance;
    var data = {
      'message': _message,
      'timestamp': _date.toString(),
      'peer-send': uid,
    };
    var chatID = uid + '-' + this.widget.donoruid;
    var chatRequest = {
      'chatdoc': chatID,
      'chatcoll': chatID,
      'senderimg': this.widget.donorimg,
      'sendername': this.widget.donorname,
      'senderuid': this.widget.donoruid
    };
    _db
        .collection("chats")
        .document(chatID)
        .collection(chatID)
        .document(_date.toString())
        .setData(data)
        .then((value) {
      _db
          .collection("userDetails")
          .document(this.widget.donoruid)
          .collection("chat-request")
          .document(chatID)
          .setData(chatRequest);
    });
  }

  Future<void> _sendRes() async {
    DateTime _date = DateTime.now();
    final _db = Firestore.instance;
    var data = {
      'message': _message,
      'timestamp': _date.toString(),
      'peer-send': uid,
    };
    _db
        .collection("chats")
        .document(this.widget.chatdoc)
        .collection(this.widget.chatcoll)
        .document(_date.toString())
        .setData(data);
  }

  @override
  void initState() {
    super.initState();
    _getUID();
    print(this.widget.donoruid);
  }

  @override
  Widget build(BuildContext context) {
    print(this.widget.chatcoll + "  " + this.widget.chatdoc);
    if (this.widget.variant == "rqmsg") {
      return Scaffold(
        body: Column(
          children: <Widget>[
            CustomAppBar(
              title: this.widget.sendername,
              variant: "no-avatar",
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('chats')
                      .document(this.widget.chatdoc)
                      .collection(this.widget.chatcoll)
                      .orderBy('timestamp')
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
                          return MessageBox(
                            message: document['message'],
                            peeruid: uid,
                          );
                        }).toList(),
                      );
                    }
                  }),
            )),
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Type in Your Message"),
                          onChanged: (value) {
                            setState(() {
                              _message = value;
                            });
                          }),
                    ),
                    Container(
                      child: Ink(
                        child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              _sendRes();
                            }),
                      ),
                    )
                  ],
                )),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: Column(
          children: <Widget>[
            CustomAppBar(
              title: this.widget.donorname,
              variant: "no-avatar",
            ),
            Expanded(
                child: Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                  stream: Firestore.instance
                      .collection("chats")
                      .document(uid + '-' + this.widget.donoruid)
                      .collection(uid + '-' + this.widget.donoruid)
                      .orderBy('timestamp')
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
                          return MessageBox(
                            message: document['message'],
                          );
                        }).toList(),
                      );
                    }
                  }),
            )),
            Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Type in Your Message"),
                          onChanged: (value) {
                            setState(() {
                              _message = value;
                            });
                          }),
                    ),
                    Container(
                      child: Ink(
                        child: IconButton(
                            icon: Icon(Icons.send),
                            onPressed: () {
                              _sendMessage();
                            }),
                      ),
                    )
                  ],
                )),
          ],
        ),
      );
    }
  }
}
