import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/services/post/postdetails.dart';

class HomeCards extends StatelessWidget {
  final String imgurl,
      bookname,
      bookauthor,
      booksubject,
      donoruid,
      donorimg,
      donorname;
  HomeCards(
      {@required this.imgurl,
      @required this.bookname,
      @required this.bookauthor,
      @required this.booksubject,
      this.donoruid,
      this.donorname,
      this.donorimg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(context, CupertinoPageRoute(builder: (context) {
            return PostDetails(
                bookimgurl: imgurl,
                donorname: donorname,
                donoruid: donoruid,
                bookname: bookname,
                donorimage: donorimg);
          }));
        },
        child: Container(
          height: 200,
          child: Card(
            elevation: 6.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        bookname,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "By : " + bookauthor,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Subject : " + booksubject,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w200),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    child: CachedNetworkImage(
                      height: 170,
                      imageUrl: imgurl,
                      placeholder: (context, url) => Text("Loading Image"),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
