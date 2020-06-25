import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as _path;
import 'package:toast/toast.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  String _bookImageUrl;
  String _bookType;
  File _bookImage;
  String _bookName;
  String _bookAuthor;
  String _bookCondition;
  String _donorName;
  String _donorPickupLocation;
  String _donorPhonenumber;
  String _donorWhatsapp;
  String _donorMail;

  List<String> _bookConditions = [
    "New Book",
    "Good Condition",
    "Fair One",
    "Not Good"
  ];

  void _basicAlerts(String title, String content) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoButton(
                  child: Text("Okay 👍"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  Future<void> _uploadBookImage() async {
    // ! pickImage is considered to be Depreciated :-/
    await ImagePicker.pickImage(source: ImageSource.gallery).then((value) {
      setState(() {
        _bookImage = value;
      });
    });
    String filename = _path.basename(_bookImage.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("/bookImages").child(filename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_bookImage);
    if (storageUploadTask.isInProgress) {
      Toast.show("Book Image Uploading", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
      print("File Uploading");
    }
    await storageUploadTask.onComplete;
    storageReference.getDownloadURL().then((value) {
      print("VALUE RETURN" + value);
      setState(() {
        _bookImageUrl = value;
      });
      Toast.show("Image Uploaded !", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
    });
  }

  Future<void> _addBook() async {
    Firestore _db = Firestore.instance;
    Map _data = {};
    await _db
        .collection("books")
        .document(_bookType)
        .setData(_data)
        .then((value) {
      _basicAlerts("Added Book", "Book Successfully Posted for Donation");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          top: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomAppBar(
                title: "Donate Book",
                variant: "no-avatar",
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Book Name",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "eg: Operating Systems"),
                        onChanged: (value) {
                          setState(() {
                            _bookName = value;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Book Author",
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            hintText: "eg: DM Dhamdhere"),
                        onChanged: (value) {
                          setState(() {
                            _bookAuthor = value;
                          });
                        }),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50.0,
                      child: CupertinoPicker(
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _bookCondition = _bookConditions[index];
                            });
                          },
                          children: List.generate(_bookConditions.length,
                              (int index) {
                            return new Center(
                              child: new Text(_bookConditions[index]),
                            );
                          })),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50.0,
                      child: CupertinoPicker(
                          itemExtent: 32.0,
                          onSelectedItemChanged: (int index) {
                            setState(() {
                              _bookCondition = _bookConditions[index];
                            });
                          },
                          children: List.generate(_bookConditions.length,
                              (int index) {
                            return new Center(
                              child: new Text(_bookConditions[index]),
                            );
                          })),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                        child: CupertinoButton(
                            color: Color(0xFFF2C94C),
                            child: Text(
                              "Test Upload",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            onPressed: () {
                              _uploadBookImage();
                            })),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
