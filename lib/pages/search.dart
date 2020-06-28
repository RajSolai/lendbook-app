import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/components/homecards.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchParam;
  String _searchSubject;
  String _userGrade;
  String _uid;
  List _searchRecords;

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = _prefs.get("uid");
    });
  }

  Future<void> _getUserData() async {
    Firestore _db = Firestore.instance;
    _db.collection("userDetails").document(_uid).get().then((value) {
      setState(() {
        _userGrade = value.data['grade'];
      });
    });
  }

  Future<void> _search() async {
    Firestore _firestore = Firestore.instance;
    await _firestore
        .collection("BookPosts")
        .document(_userGrade.toLowerCase())
        .collection(_searchSubject.toUpperCase())
        .where("bookname", isGreaterThanOrEqualTo: _searchParam.toUpperCase())
        .getDocuments()
        .then((value) {
      setState(() {
        _searchRecords = value.documents.toList();
      });
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
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomAppBar(
                title: "Search",
                variant: "no-avatar",
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Enter Subject"),
                          onChanged: (value) {
                            setState(() {
                              _searchSubject = value;
                            });
                          }),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              hintText: "Search By Book Name"),
                          onChanged: (value) {
                            setState(() {
                              _searchParam = value;
                            });
                          }),
                      SizedBox(
                        height: 15,
                      ),
                      ButtonTheme(
                          minWidth: 200,
                          height: 40,
                          child: FlatButton.icon(
                              hoverColor: Color(0xFFe1ae10),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0))),
                              color: Color(0xFFF2C94C),
                              padding: EdgeInsets.all(2),
                              icon: FaIcon(
                                FontAwesomeIcons.search,
                                size: 16,
                              ),
                              label: Text(
                                "Search",
                                style: TextStyle(fontSize: 16.0),
                              ),
                              onPressed: () {
                                _search();
                              }))
                    ],
                  )),
              // * Here goes the stream Builder
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount:
                        _searchRecords == null ? 0 : _searchRecords.length,
                    itemBuilder: (BuildContext context, int index) {
                      return HomeCards(
                          imgurl: _searchRecords[index]['bookimage'],
                          bookname: _searchRecords[index]['bookname'],
                          bookauthor: _searchRecords[index]['bookauthor'],
                          booksubject: _searchRecords[index]['booksubject']);
                    }),
              ),
            ],
          )),
    );
  }
}
