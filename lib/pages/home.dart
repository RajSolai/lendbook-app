import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/components/PostCard.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lendbook/components/homecards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _uid;
  String _dpurl;
  String _userFavSub;
  String _userGrade;

  Future<void> _getdata() async {
    final _prefs = await SharedPreferences.getInstance();
    setState(() {
      _dpurl = _prefs.getString("dpurl");
      _uid = _prefs.getString("uid");
    });
  }

  // TODO : Complete the Algorithm !
  Future<void> _displayAlgorithm() async {
    /* THis is the Main algorithm of displaying the books needed for the
      users */
    Firestore _db = Firestore.instance;
    _db.collection("userDetails").document(_uid).get().then((value) {
      setState(() {
        _userFavSub = value.data['userinterest'];
        _userGrade = value.data['grade'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getdata().then((value) {
      _displayAlgorithm();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.pushNamed(context, "/addbook");
          },
          icon: FaIcon(
            FontAwesomeIcons.plus,
            color: Colors.white,
          ),
          label: Text(
            "Donate Now",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF9852f9)),
      body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomAppBar(
                title: "Home",
                dpurl: _dpurl,
                variant: "search",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Books Based on your Favorite Subject !",
                  style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
                ),
              ),
              // * Here goes the stream Builder
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection("BookPosts")
                        .document(_userGrade.toLowerCase())
                        .collection(_userFavSub.toUpperCase())
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
                            return HomeCards(
                                imgurl: document['bookimage'],
                                bookname: document['bookname'],
                                bookauthor: document['bookauthor'],
                                booksubject: document['booksubject']);
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
