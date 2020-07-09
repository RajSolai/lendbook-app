import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/services/chat/sendmessage.dart';
import 'package:geocoder/geocoder.dart';
import 'package:url_launcher/url_launcher.dart';

class PostDetails extends StatefulWidget {
  final donoruid,
      donorname,
      donorph,
      donorwa,
      donorimage,
      bookname,
      bookimgurl,
      booksubject,
      bookpickupaddress,
      bookauthor,
      bookdonorimgurl,
      lat,
      lon,
      bookcondition;
  PostDetails(
      {this.donoruid,
      this.donorname,
      this.donorph,
      this.donorwa,
      this.bookimgurl,
      this.bookauthor,
      this.bookdonorimgurl,
      this.bookcondition,
      this.bookname,
      this.donorimage,
      this.booksubject,
      this.bookpickupaddress,
      this.lat,
      this.lon});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Future<void> _openGMaps() async {
    if (widget.lat == null && widget.lat == null) {
      await Geocoder.local
          .findAddressesFromQuery(widget.bookpickupaddress)
          .then((value) {
        print(value.first.coordinates.toString());
        String lat = value.first.coordinates.latitude.toString();
        String lon = value.first.coordinates.longitude.toString();
        final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
        launch(url);
      });
    } else {
      print(widget.lat + "  " + widget.lon);
      String lat = widget.lat;
      String lon = widget.lon;
      final url = 'https://www.google.com/maps/search/?api=1&query=$lat,$lon';
      launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: "Book Details",
              variant: "no-avatar",
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: this.widget.bookimgurl,
                height: 300,
                width: 300,
              ),
            )),
            SizedBox(
              height: 20,
            ),
            Text(this.widget.bookname,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListTile(
                      title: Text("Book Author",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      trailing: Text(widget.bookauthor,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w200)),
                    ),
                    ListTile(
                      title: Text("Book Subject",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      trailing: Text(widget.booksubject,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w200)),
                    ),
                    ListTile(
                      title: Text("Book Condition",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      trailing: Text(widget.bookcondition,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w200)),
                    ),
                    ListTile(
                      title: Text("Donated By",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      trailing: Text(widget.donorname,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w200)),
                    ),
                    Container(
                      padding: EdgeInsets.all(12.0),
                      child: Text("Pickup Address",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    CupertinoButton(
                        child: Text(widget.bookpickupaddress == null
                            ? ""
                            : widget.bookpickupaddress),
                        onPressed: () {
                          _openGMaps();
                        }),
                  ],
                )),
            CupertinoButton(
                color: Color(0xFFF2C94C),
                borderRadius: BorderRadius.circular(10),
                child: Text(
                  "Chat with" + " " + widget.donorname,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (BuildContext context) {
                    return SendMessage(
                        donorname: this.widget.donorname,
                        donoruid: this.widget.donoruid,
                        donorimg: this.widget.donorimage);
                  }));
                }),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
