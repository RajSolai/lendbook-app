import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:lendbook/services/chat/sendmessage.dart';

class PostDetails extends StatefulWidget {
  final donoruid,
      donorname,
      donorph,
      donorwa,
      donorimage,
      bookname,
      bookimgurl,
      bookauthor,
      bookdonorimgurl,
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
      this.donorimage});

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          CustomAppBar(
            title: "Book Details",
          ),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                    height: 200,
                    child:
                        CachedNetworkImage(imageUrl: this.widget.bookimgurl)),
                Container(
                    child: Column(
                  children: <Widget>[Text(this.widget.bookname)],
                )),
                CupertinoButton(
                    color: Color(0xFFF2C94C),
                    borderRadius: BorderRadius.circular(10),
                    child: Text(
                      "Chat with donor",
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
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
