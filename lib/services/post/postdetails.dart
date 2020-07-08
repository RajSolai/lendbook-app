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
      booksubject,
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
      this.donorimage,
      this.booksubject});

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
            variant: "no-avatar",
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
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
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: <Widget>[
                        Text(this.widget.bookname,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                        )
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
                    })
              ],
            ),
          ),
        ],
      ),
    );
  }
}
