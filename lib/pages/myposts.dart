import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/components/PostCard.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPosts extends StatefulWidget {
  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
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
      body: SafeArea(
          top: false,
          child: Column(
            children: <Widget>[
              CustomAppBar(
                title: "My Donations",
                variant: "no-avatar",
              ),
              // * Here goes the stream Builder
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("userDetails")
                        .document(uid)
                        .collection("bookposts")
                        .orderBy('postedtime')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        print(snapshot.error);
                        return Text("Errot in Snapshot");
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return SingleChildScrollView(
                            child: Container(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: 100,
                                width: 100,
                                child: Image.asset(
                                    "./assets/icons/loading-logo.png"),
                              ),
                              Center(
                                child: Text(
                                  "Fetching your Favorites!",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  "This might take a second",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic),
                                ),
                              )
                            ],
                          ),
                        ));
                      } else {
                        return ListView(
                          padding: EdgeInsets.all(10),
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            return PostCard(
                              bookImageUrl: document['bookimage'],
                              bookName: document['bookname'],
                              bookSubject: document['booksubject'],
                              postedDate: document['postedtime'],
                            );
                          }).toList(),
                        );
                      }
                    }),
              ),
            ],
          )),
    );
  }
}
