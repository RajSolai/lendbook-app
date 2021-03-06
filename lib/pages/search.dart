import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
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
  String _searchSubject = "Physics";
  String _userGrade = "";
  String _uid;
  bool _gradeSwitch = false;
  var brightness = SchedulerBinding.instance.window.platformBrightness;

  List<Map> _schoolData = [
    {"title": "Physics", "icon": FontAwesomeIcons.atom},
    {"title": "Chemistry", "icon": FontAwesomeIcons.flask},
    {"title": "ComputerScience", "icon": FontAwesomeIcons.laptop},
    {"title": "Maths", "icon": FontAwesomeIcons.divide},
    {"title": "Language", "icon": FontAwesomeIcons.language},
  ];

  List<Map> _universityData = [
    {"title": "Physics", "icon": FontAwesomeIcons.atom},
    {"title": "Chemistry", "icon": FontAwesomeIcons.flask},
    {"title": "ComputerScience", "icon": FontAwesomeIcons.laptop},
    {"title": "Maths", "icon": FontAwesomeIcons.divide},
    {"title": "Medical", "icon": FontAwesomeIcons.briefcaseMedical},
    {"title": "Language", "icon": FontAwesomeIcons.language},
    {"title": "Mechanical", "icon": FontAwesomeIcons.cogs},
    {"title": "Electronics And Electrical", "icon": FontAwesomeIcons.bolt},
  ];

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = _prefs.get("uid");
    });
  }

  Future<void> _getUserData() async {
    Firestore _db = Firestore.instance;
    await _db.collection("userDetails").document(_uid).get().then((value) {
      setState(() {
        _userGrade = value.data['grade'].toString().toLowerCase();
      });
    });
  }

  String _grade() {
    if (_gradeSwitch == true && _userGrade == "school") {
      return "college";
    } else if (_gradeSwitch == true && _userGrade == "college") {
      return "school";
    } else {
      return _userGrade;
    }
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
                  padding: EdgeInsets.all(8),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        height: 70,
                        child: IndexedStack(
                          index: _grade() == "school" ? 0 : 1,
                          children: <Widget>[
                            Container(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: _schoolData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      print(_schoolData[index]['title']);
                                      setState(() {
                                        _searchSubject =
                                            _schoolData[index]['title'];
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(2, 2),
                                                color: brightness ==
                                                        Brightness.light
                                                    ? Color.fromARGB(
                                                        50, 0, 0, 0)
                                                    : Color.fromARGB(
                                                        90, 0, 0, 0),
                                                blurRadius: 5),
                                            BoxShadow(
                                                offset: Offset(-2, -2),
                                                color: brightness ==
                                                        Brightness.light
                                                    ? Color.fromARGB(
                                                        150, 255, 255, 255)
                                                    : Color.fromARGB(
                                                        80, 0, 0, 0),
                                                blurRadius: 5)
                                          ],
                                          color: Color(0xFF9852f9),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      //width: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FaIcon(
                                            _schoolData[index]['icon'],
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _schoolData[index]['title'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Container(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: _universityData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        _searchSubject =
                                            _universityData[index]['title'];
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(2, 2),
                                                color: brightness ==
                                                        Brightness.light
                                                    ? Color.fromARGB(
                                                        50, 0, 0, 0)
                                                    : Color.fromARGB(
                                                        90, 0, 0, 0),
                                                blurRadius: 5),
                                            BoxShadow(
                                                offset: Offset(-2, -2),
                                                color: brightness ==
                                                        Brightness.light
                                                    ? Color.fromARGB(
                                                        150, 255, 255, 255)
                                                    : Color.fromARGB(
                                                        80, 0, 0, 0),
                                                blurRadius: 5)
                                          ],
                                          color: Color(0xFF9852f9),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      //width: 120,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          FaIcon(
                                            _universityData[index]['icon'],
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            _universityData[index]['title'],
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: ListTile(
                          title: Text(_userGrade == "school"
                              ? "Looking For College Books?"
                              : "Looking For School Books?"),
                          trailing: CupertinoSwitch(
                              value: _gradeSwitch,
                              onChanged: (bool val) {
                                setState(() {
                                  _gradeSwitch = val;
                                });
                              }),
                        ),
                      ),
                      Material(
                        borderRadius: BorderRadius.circular(20.0),
                        elevation: 5.0,
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
                                hintText: "Enter Book Name"),
                            onChanged: (value) {
                              setState(() {
                                _searchParam = value;
                              });
                            }),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(_grade()),
                          Text("  >  "),
                          Text(_searchSubject == null ? "" : _searchSubject),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _searchParam == null
                      ? Firestore.instance
                          .collection("BookPosts")
                          .document(_grade())
                          .collection(_searchSubject
                              .toUpperCase()
                              .replaceAll(new RegExp(r"\s+"), ""))
                          .orderBy("postedtime", descending: true)
                          .snapshots()
                      : _searchParam == ""
                          ? Firestore.instance
                              .collection("BookPosts")
                              .document(_grade())
                              .collection(_searchSubject
                                  .toUpperCase()
                                  .replaceAll(new RegExp(r"\s+"), ""))
                              .orderBy("postedtime", descending: true)
                              .snapshots()
                          : Firestore.instance
                              .collection("BookPosts")
                              .document(_grade())
                              .collection(_searchSubject
                                  .toUpperCase()
                                  .replaceAll(new RegExp(r"\s+"), ""))
                              .where("bookname",
                                  isLessThanOrEqualTo:
                                      _searchParam.toUpperCase(),
                                  isGreaterThanOrEqualTo:
                                      _searchParam.toUpperCase(),
                                  isEqualTo: _searchParam.toUpperCase())
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
                          return HomeCards(
                            imgurl: document['bookimage'],
                            bookname: document['bookname'],
                            bookauthor: document['bookauthor'],
                            donoruid: document['bookdonoruid'],
                            donorname: document['bookdonor'],
                            donorimg: document['bookdonorprofile'],
                            booksubject: document['booksubject'],
                            bookcondition: document['bookcondition'],
                            bookpickupaddress: document['bookpickuplocation'],
                            bookid: document['bookid'],
                            bookgrade: document['bookgrade'],
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              )
            ],
          )),
    );
  }
}
