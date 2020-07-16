import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/scheduler.dart';
import 'package:lendbook/services/post/postdetails.dart';

class PostCard extends StatelessWidget {
  final brightness = SchedulerBinding.instance.window.platformBrightness;

  final defaultImage =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fimage_picker1760171017670769672.jpg?alt=media&token=813ad095-ee58-41bc-b7a9-b031a3582bd9";
  final bookName,
      bookSubject,
      bookImageUrl,
      postedDate,
      donoruid,
      donorname,
      donorimg,
      donorph,
      donorwa;
  PostCard(
      {this.bookName,
      this.bookImageUrl,
      this.bookSubject,
      this.postedDate,
      this.donorname,
      this.donorimg,
      this.donorph,
      this.donorwa,
      this.donoruid});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(5.0),
        child: Container(
            padding: EdgeInsets.all(10),
            width: double.maxFinite,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: brightness == Brightness.light
                  ? Color.fromARGB(255, 238, 238, 238)
                  : Color(0xFF181b20),
              boxShadow: <BoxShadow>[
                brightness == Brightness.light
                    ? BoxShadow(
                        offset: Offset(1, 1),
                        color: Color.fromARGB(80, 0, 0, 0),
                        blurRadius: 5)
                    : BoxShadow(
                        offset: Offset(1, 1),
                        color: Color.fromARGB(100, 0, 0, 0),
                        blurRadius: 15)
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    CupertinoPageRoute(builder: (BuildContext context) {
                  return PostDetails(
                    donorname: this.donorname,
                    donorph: this.donorph,
                    donoruid: this.donoruid,
                    donorwa: this.donorwa,
                    bookname: this.bookName,
                    bookimgurl: this.bookImageUrl,
                    bookdonorimgurl: this.donorimg,
                  );
                }));
              },
              child: Column(
                children: <Widget>[
                  Container(
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      child: CachedNetworkImage(
                          imageUrl: bookImageUrl == null
                              ? defaultImage
                              : bookImageUrl,
                          placeholder: (context, url) =>
                              Text("Loading Image...")),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(
                            "Book Name :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing:
                              Text(bookName == null ? "No Name" : bookName),
                        ),
                        ListTile(
                          title: Text(
                            "Book Subject :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(
                              bookSubject == null ? "No Subject" : bookSubject),
                        ),
                        ListTile(
                          title: Text(
                            "Posted on :",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Text(postedDate == null
                              ? "No data"
                              : postedDate.toString().substring(0, 10)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }
}
