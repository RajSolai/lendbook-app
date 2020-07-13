import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lendbook/services/chat/sendmessage.dart';

class MsgReq extends StatelessWidget {
  final brightness = SchedulerBinding.instance.window.platformBrightness;

  final name,
      image,
      chatdoc,
      chatcoll,
      sendername,
      senderuid,
      interestedbook,
      bookgrade,
      booksub,
      interestedbookdonor;
  MsgReq(
      {Key key,
      this.name,
      this.image,
      this.chatdoc,
      this.chatcoll,
      this.sendername,
      this.senderuid,
      this.interestedbook,
      this.interestedbookdonor,
      this.bookgrade,
      this.booksub});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 15.0, left: 5.0, right: 5.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: brightness == Brightness.light
                  ? Color.fromARGB(255, 238, 238, 238)
                  : Color(0xFF161a20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(3, 3),
                    color: brightness == Brightness.light
                        ? Color.fromARGB(50, 0, 0, 0)
                        : Color.fromARGB(30, 0, 0, 0),
                    blurRadius: 15),
                BoxShadow(
                    offset: Offset(-3, -3),
                    color: brightness == Brightness.light
                        ? Color.fromARGB(130, 255, 255, 255)
                        : Color.fromARGB(35, 0, 0, 0),
                    blurRadius: 15)
              ]),
          margin: EdgeInsets.all(1),
          height: 150,
          child: InkWell(
            onTap: () {
              Navigator.push(context, CupertinoPageRoute(builder: (context) {
                return SendMessage(
                  variant: "rqmsg",
                  chatdoc: chatdoc,
                  chatcoll: chatcoll,
                  sendername: sendername,
                  senderuid: senderuid,
                  interestedbook: interestedbook,
                  interestedbooksub: booksub,
                  donoruid: interestedbookdonor,
                  bookgrade: bookgrade,
                );
              }));
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(18),
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(image),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Click to Chat",
                      style: TextStyle(fontWeight: FontWeight.w200),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
