import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/services/chat/messagebox.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class SendMessage extends StatefulWidget {
  final donoruid,
      donorname,
      donorimg,
      bookgrade,
      variant,
      chatdoc,
      chatcoll,
      bookid,
      senderuid,
      interestedbook,
      interestedbooksub,
      sendername;
  SendMessage({
    this.donoruid,
    this.donorname,
    this.donorimg,
    this.variant,
    this.chatdoc,
    this.chatcoll,
    this.sendername,
    this.senderuid,
    this.interestedbook,
    this.bookgrade,
    this.bookid,
    this.interestedbooksub,
  });

  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  ScrollController _scrollController = new ScrollController();
  TextEditingController _messageCtrl = new TextEditingController();
  var brightness = SchedulerBinding.instance.window.platformBrightness;

  String uid, _username, _userdp;
  String _message;

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
        _username = value.data['displayname'];
        _userdp = value.data['dpurl'];
      });
    });
  }

  Future<void> _sendMessage() async {
    _messageCtrl.clear();
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
      'senderimg': _userdp,
      'sendername': _username,
      'senderuid': uid,
      'interestedbookdonor': widget.donoruid,
      'interestedinbook': widget.interestedbook,
      'interestedbookgrade': widget.bookgrade,
      'interestedbooksub': widget.interestedbooksub,
    };
    await _db
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
          .setData(chatRequest)
          .then((value) {
        _messageCtrl.clear();
      });
    });
  }

  Future<void> _sendRes() async {
    _messageCtrl.clear();
    DateTime _date = DateTime.now();
    final _db = Firestore.instance;
    var data = {
      'message': _message,
      'timestamp': _date.toString(),
      'peer-send': uid,
    };
    var chatRequest = {
      'chatdoc': this.widget.chatdoc,
      'chatcoll': this.widget.chatdoc,
      'senderimg': _userdp,
      'sendername': _username,
      'senderuid': uid,
      'interestedbookdonor': uid,
      'interestedinbook': widget.interestedbook,
      'interestedbookgrade': widget.bookgrade,
      'interestedbooksub': widget.interestedbooksub,
    };
    await _db
        .collection("chats")
        .document(this.widget.chatdoc)
        .collection(this.widget.chatcoll)
        .document(_date.toString())
        .setData(data)
        .then((value) {
      _db
          .collection("userDetails")
          .document(widget.senderuid)
          .collection("chat-request")
          .document(this.widget.chatcoll) //* same as chatID
          .setData(chatRequest);
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
    if (this.widget.variant == "rqmsg") {
      Timer(Duration(milliseconds: 300), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
      return Scaffold(
        body: Column(
          children: <Widget>[
            CustomAppBar(
              title: this.widget.sendername,
              variant: "chat",
              bookid: widget.interestedbook,
              booksub: widget.interestedbooksub,
              bookgrade: widget.bookgrade,
              donorid: this.widget.donoruid,
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
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return MessageBox(
                              message: document['message'],
                              peeruid: document['peer-send']);
                        }).toList(),
                      );
                    }
                  }),
            )),
            Container(
                padding: EdgeInsets.only(bottom: 10.0, left: 12.0, right: 12.0),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      child: TextField(
                          decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              fillColor: brightness == Brightness.dark
                                  ? Color(0xFF666a6d)
                                  : Color(0xFFd8dcd6),
                              hintText: "Enter your Message"),
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
                              if (_message != null) {
                                _sendRes();
                              } else {
                                Toast.show("Type in a Message to Send", context,
                                    backgroundColor: Color(0xFF9852f9));
                              }
                            }),
                      ),
                    )
                  ],
                )),
          ],
        ),
      );
    } else {
      Timer(Duration(milliseconds: 300), () {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      });
      return Scaffold(
        body: Column(
          children: <Widget>[
            CustomAppBar(
              title: this.widget.donorname,
              variant: "no-avatar",
              bookid: widget.bookid,
              bookgrade: widget.bookgrade,
              donorid: this.widget.donoruid,
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
                        controller: _scrollController,
                        padding: EdgeInsets.all(10),
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return MessageBox(
                            message: document['message'],
                            peeruid: document['peer-send'],
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
                          controller: _messageCtrl,
                          decoration: InputDecoration(
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              fillColor: brightness == Brightness.dark
                                  ? Color(0xFF666a6d)
                                  : Color(0xFFd8dcd6),
                              hintText: "Enter your Message"),
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
                              if (_message != null) {
                                _sendMessage();
                              } else {
                                Toast.show("Type in a Message to Send", context,
                                    backgroundColor: Color(0xFF9852f9));
                              }
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
