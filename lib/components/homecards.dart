import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/services/post/postdetails.dart';

class HomeCards extends StatelessWidget {
  final String imgurl,
      bookname,
      bookauthor,
      booksubject,
      bookcondition,
      bookpickupaddress,
      donoruid,
      donorimg,
      donorname;
  HomeCards(
      {@required this.imgurl,
      @required this.bookname,
      @required this.bookauthor,
      @required this.booksubject,
      this.donoruid,
      @required this.donorname,
      this.donorimg,
      @required this.bookcondition,
      @required this.bookpickupaddress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return PostDetails(
                bookauthor: bookauthor,
                bookcondition: bookcondition,
                booksubject: booksubject,
                bookimgurl: imgurl,
                bookpickupaddress: bookpickupaddress,
                donorname: donorname,
                donoruid: donoruid,
                bookname: bookname,
                donorimage: donorimg);
          }));
        },
        child: Container(
          padding: EdgeInsets.all(0),
          height: 200,
          margin: EdgeInsets.all(2),
          child: Card(
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          bookname.length <= 11
                              ? bookname
                              : bookname.substring(0, 11) + "..",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "By : " + bookauthor,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Subject : " + booksubject,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0)),
                  child: CachedNetworkImage(
                    //height: 190,
                    // width: 190,
                    imageUrl: imgurl,
                    placeholder: (context, url) => Text("Loading Image"),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
