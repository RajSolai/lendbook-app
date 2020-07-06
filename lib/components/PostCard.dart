import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lendbook/services/post/postdetails.dart';

class PostCard extends StatelessWidget {
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
        padding: EdgeInsets.all(10),
        width: double.maxFinite,
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
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              elevation: 5.0,
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
