import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as _path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import 'package:image_cropper/image_cropper.dart';

class AddBook extends StatefulWidget {
  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  bool _isSchoolBook = false;
  String _bookImageUrl;
  File _rawImage;
  File _bookImage;
  String _bookName;
  String _bookAuthor;
  String _bookCondition;
  String _donorPickupLocation;
  String _uid;
  String _bookSchoolSubject;
  String _bookCollegeSubject;
  Map _userDetails;
  String _bookSubject;
  // TODO : Change to another image
  String _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  List<String> _bookConditions = [
    "New Book",
    "Good Condition",
    "Fair One",
    "Not Good"
  ];

  List<String> _bookGrades = ["School", "College"];

  List<String> _bookSchoolSubjects = [
    "Physics",
    "Chemistry",
    "ComputerScience",
    "Maths",
    "Language",
  ];

  List<String> _bookCollegeSubjects = [
    "Physics",
    "Chemistry",
    "ComputerScience",
    "Maths",
    "Medical",
    "Language",
    "Mechanical",
    "Electronics And Electrical"
  ];

  Future<void> _basicAlerts(String title, String content) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              CupertinoButton(
                  child: Text("Okay"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoButton(
                  child: Text("View Donations"),
                  onPressed: () {
                    Navigator.of(context).pushNamed("/posts");
                  }),
            ],
          );
        });
  }

  Future<void> getUserData() async {
    Firestore _firestore = Firestore.instance;
    _firestore.collection("userDetails").document(_uid).get().then((value) {
      setState(() {
        _userDetails = value.data;
      });
    });
  }

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = _prefs.get("uid");
    });
  }

  Future<void> _uploadBookImage() async {
    // ! pickImage is considered to be Depreciated :-/
    // ignore: deprecated_member_use
    await ImagePicker.pickImage(
            source: ImageSource.gallery, maxHeight: 500, maxWidth: 500)
        .then((temp) {
      setState(() {
        _rawImage = temp;
      });
    });
    await ImageCropper.cropImage(
      sourcePath: _rawImage.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Book Image',
          toolbarColor: Color(0xFFF2C94C),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
    ).then((value) {
      _bookImage = value;
    });
    String filename = _path.basename(_bookImage.path);
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child("/bookImages").child(filename);
    StorageUploadTask storageUploadTask = storageReference.putFile(_bookImage);
    if (storageUploadTask.isInProgress) {
      Toast.show("Book Image Uploading", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Duration.secondsPerHour);
    }
    await storageUploadTask.onComplete;
    storageReference.getDownloadURL().then((value) {
      setState(() {
        _bookImageUrl = value;
      });
      Toast.show("Image Uploaded !", context,
          backgroundColor: Color(0xFF9852f9),
          gravity: Toast.BOTTOM,
          duration: Toast.LENGTH_LONG);
    });
  }

  void _checkAndaddBook() {
    if (_bookName != null &&
        _bookAuthor != null &&
        _donorPickupLocation != null &&
        _bookCondition != null &&
        _bookImageUrl != null) {
      _addBook();
    } else {
      _basicAlerts("Values Not Filled 😕",
          "Hey! , It Seems you missed some fields without filling");
    }
  }

  Future<void> _addBook() async {
    Firestore _db = Firestore.instance;
    DateTime _date = DateTime.now();
    String _bookId = randomAlphaNumeric(10);
    _bookSubject =
        _bookSchoolSubject == null ? _bookCollegeSubject : _bookSchoolSubject;
    var _bookData = {
      'postedtime': _date.toString(),
      'bookid': _bookId,
      'bookname': _bookName.toUpperCase(),
      'bookauthor': _bookAuthor,
      'bookimage': _bookImageUrl,
      'bookcondition': _bookCondition,
      'booksubject': _bookSubject,
      'bookpickuplocation': _donorPickupLocation,
      'bookdonoruid': _uid,
      'bookdonorprofile': _userDetails['dpurl'],
      'bookdonor': _userDetails['displayname'],
      'bookdonorphone': _userDetails['phone'],
      'bookdonorwa': _userDetails['waphone']
    };
    await _db
        .collection("BookPosts")
        .document(_isSchoolBook ? "school" : "college")
        .collection(_bookSubject.toUpperCase())
        .document(_bookId)
        .setData(_bookData)
        .then((value) {
      _db
          .collection("userDetails")
          .document(_uid)
          .collection("bookposts")
          .document(_bookId)
          .setData(_bookData)
          .then((value) {
        _basicAlerts("Added Book 👍", "Book Successfully Posted for Donation");
      });
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  void initState() {
    super.initState();
    _getUID().then((value) {
      getUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: false,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomAppBar(
              title: "Donate Book",
              variant: "no-avatar",
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Book Name",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
                  Text(
                    "Book Pickup Location with LandMark",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText:
                              "eg : Near Phonix Mall , Velachery , Chennai"),
                      onChanged: (value) {
                        setState(() {
                          _donorPickupLocation = value;
                        });
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select Book Condition",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 70.0,
                    padding: EdgeInsets.all(10),
                    child: CupertinoPicker(
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int index) {
                          setState(() {
                            _bookCondition = _bookConditions[index];
                          });
                        },
                        children:
                            List.generate(_bookConditions.length, (int index) {
                          return new Center(
                            child: new Text(_bookConditions[index]),
                          );
                        })),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Select The Subject of Book",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: ListTile(
                      title: Text("Is this a School Book ?"),
                      trailing: CupertinoSwitch(
                          value: _isSchoolBook,
                          onChanged: (bool val) {
                            setState(() {
                              _isSchoolBook = val;
                            });
                          }),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  IndexedStack(
                    index: _isSchoolBook ? 0 : 1,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70.0,
                              padding: EdgeInsets.all(10),
                              child: AbsorbPointer(
                                  absorbing: false,
                                  child: CupertinoPicker(
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _bookSchoolSubject =
                                              _bookSchoolSubjects[index];
                                        });
                                      },
                                      children: List.generate(
                                          _bookSchoolSubjects.length,
                                          (int index) {
                                        return new Center(
                                          child: new Text(
                                              _bookSchoolSubjects[index]),
                                        );
                                      }))),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 70.0,
                              padding: EdgeInsets.all(10),
                              child: AbsorbPointer(
                                  absorbing: false,
                                  child: CupertinoPicker(
                                      itemExtent: 32.0,
                                      onSelectedItemChanged: (int index) {
                                        setState(() {
                                          _bookCollegeSubject =
                                              _bookCollegeSubjects[index];
                                        });
                                      },
                                      children: List.generate(
                                          _bookCollegeSubjects.length,
                                          (int index) {
                                        return new Center(
                                          child: new Text(
                                              _bookCollegeSubjects[index]),
                                        );
                                      }))),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Upload Image of Book",
                    textAlign: TextAlign.left,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 300,
                          width: 300,
                          padding: EdgeInsets.all(30),
                          child: Image.network(_bookImageUrl == null
                              ? _dpDefault
                              : _bookImageUrl),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            CupertinoButton(
                                child: Text(
                                  "Upload Image",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  _uploadBookImage();
                                }),
                            CupertinoButton(
                                child: Text(
                                  "Clear Image",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _bookImage = null;
                                    _bookImageUrl = null;
                                  });
                                }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: CupertinoButton(
                        color: Color(0xFFF2C94C),
                        borderRadius: BorderRadius.circular(10),
                        child: Text(
                          "Donate Book",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        onPressed: () {
                          _checkAndaddBook();
                        }),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
