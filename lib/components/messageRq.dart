import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lendbook/services/chat/sendmessage.dart';

class MsgReq extends StatelessWidget {
  final name, image, chatdoc, chatcoll, sendername, senderuid;
  MsgReq(
      {Key key,
      this.name,
      this.image,
      this.chatdoc,
      this.chatcoll,
      this.sendername,
      this.senderuid});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              );
            }));
          },
          child: Card(
            elevation: 3.0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
