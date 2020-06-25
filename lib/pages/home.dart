import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/components/menucards.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Map> _universityData = [
    {"title": "Name1", "icon": FontAwesomeIcons.book},
    {"title": "Name2", "icon": FontAwesomeIcons.book},
    {"title": "Name3", "icon": FontAwesomeIcons.book},
    {"title": "Name4", "icon": FontAwesomeIcons.book},
    {"title": "Name5", "icon": FontAwesomeIcons.book}
  ];

  List<Map> _schoolData = [
    {"title": "Name1", "icon": FontAwesomeIcons.book},
    {"title": "Name2", "icon": FontAwesomeIcons.book},
    {"title": "Name3", "icon": FontAwesomeIcons.book},
    {"title": "Name4", "icon": FontAwesomeIcons.book},
    {"title": "Name5", "icon": FontAwesomeIcons.book}
  ];

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
        maintainBottomViewPadding: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(0),
                margin: EdgeInsets.all(0),
                child: CustomAppBar(
                  title: "Home",
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // * Container for main view
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // * Container for University Books
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "University Books",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            margin: EdgeInsets.all(5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _universityData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuCards(
                                  name: _universityData[index]["title"],
                                  icon: _universityData[index]["icon"],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "School Books",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            margin: EdgeInsets.all(5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _schoolData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuCards(
                                  name: _schoolData[index]["title"],
                                  icon: _schoolData[index]["icon"],
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "School Books",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            margin: EdgeInsets.all(5),
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemCount: _schoolData.length,
                              itemBuilder: (BuildContext context, int index) {
                                return MenuCards(
                                  name: _schoolData[index]["title"],
                                  icon: _schoolData[index]["icon"],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
