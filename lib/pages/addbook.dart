import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lendbook/components/CustomAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart' as _path;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:random_string/random_string.dart';
import 'package:toast/toast.dart';
import 'package:android_intent/android_intent.dart';
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
  String _bookCondition = "New Book";
  String _donorPickupLocation;
  String _uid;
  num _pickupLat;
  num _pickupLong;
  String _bookSchoolSubject = "Physics";
  String _bookCollegeSubject = "Physics";
  Map _userDetails;
  String _bookSubject;
  // TODO : Change to another image
  String _dpDefault =
      "https://firebasestorage.googleapis.com/v0/b/lendbook-5b2b7.appspot.com/o/profilePics%2Fcat-icon.png?alt=media&token=98ddcd8e-a584-4488-b115-32c2b0ac39e1";

  TextEditingController _booknamectrl = new TextEditingController();
  TextEditingController _bookauthctrl = new TextEditingController();
  TextEditingController _bookpickctrl = new TextEditingController();
  FocusNode _booknamefocus = new FocusNode();
  FocusNode _bookauthfocus = new FocusNode();
  FocusNode _bookpickfocus = new FocusNode();

  List<String> _bookConditions = [
    "New Book",
    "Good Condition",
    "Fair One",
    "Not Good"
  ];

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

  Future<void> _customProgressDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Posting New Donation !",
                  textAlign: TextAlign.center,
                )
              ],
            ),
          );
        });
  }

  Future<void> _gpsDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0))),
            content:
                Text("For Presice location you need to turn on GPS service"),
            actions: <Widget>[
              CupertinoButton(
                  child: Text(
                    "Okay !",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    openLocationSetting();
                    Navigator.of(context).pop();
                  }),
              CupertinoButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  })
            ],
          );
        });
  }

  Future<void> _basicAlerts(
      String title, String content, String variant) async {
    if (variant == "error") {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                CupertinoButton(
                    child: Text("Okay"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
    } else {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0))),
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
  }

  Future<void> getUserData() async {
    Firestore _firestore = Firestore.instance;
    _firestore.collection("userDetails").document(_uid).get().then((value) {
      setState(() {
        _userDetails = value.data;
      });
    });
  }

  void _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  Future<void> _getUID() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    setState(() {
      _uid = _prefs.get("uid");
    });
  }

  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }

  Future<void> _getLocationViaGmaps() async {
    await Permission.location.request().whenComplete(() => {_gpsDialog()});
    await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((value) {
      Coordinates location = new Coordinates(value.latitude, value.longitude);
      Geocoder.local.findAddressesFromCoordinates(location).then((res) => {
            setState(() {
              _donorPickupLocation = res.first.addressLine;
              _pickupLat = value.latitude;
              _pickupLong = value.longitude;
            })
          });
    });
  }

  Future<void> _uploadBookImage() async {
    // ! pickImage is considered tos be Depreciated :-/
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

  void _checkAndaddBook(BuildContext _context) {
    if (_bookName != null &&
        _bookAuthor != null &&
        _donorPickupLocation != null &&
        _bookCondition != null &&
        _bookImageUrl != null) {
      _addBook(_context);
    } else {
      _basicAlerts("Values Not Filled 😕",
          "Hey! , It Seems you missed some fields without filling", "error");
    }
  }

  Future<void> _addBook(BuildContext _context) async {
    _customProgressDialog();
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
      'booksubject': _bookSubject.replaceAll(new RegExp(r"\s+"), ""),
      'bookpickuplocation': _donorPickupLocation,
      'bookpickuplat': _pickupLat,
      'bookgrade': _isSchoolBook ? "school" : "college",
      'bookpicklong': _pickupLong,
      'bookdonoruid': _uid,
      'bookdonorprofile': _userDetails['dpurl'],
      'bookdonor': _userDetails['displayname'],
      'bookdonorcity': _userDetails['city'],
      'bookdonorphone': _userDetails['phone'],
      'bookdonorwa': _userDetails['waphone'],
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
        Navigator.of(context, rootNavigator: true).pop('dialog');
        _basicAlerts("Added Book 👍", "Book Successfully Posted for Donation",
            "success");
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
                    controller: _booknamectrl,
                    focusNode: _booknamefocus,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "eg: Operating Systems"),
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      setState(() {
                        _bookName = value;
                      });
                    },
                    onSubmitted: (term) {
                      _fieldFocusChange(
                          context, _booknamefocus, _bookauthfocus);
                    },
                  ),
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
                    controller: _bookauthctrl,
                    focusNode: _bookauthfocus,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: "eg: DM Dhamdhere"),
                    onChanged: (value) {
                      setState(() {
                        _bookAuthor = value;
                      });
                    },
                    onSubmitted: (term) {
                      _fieldFocusChange(
                          context, _bookauthfocus, _bookpickfocus);
                    },
                  ),
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
                    controller: _bookpickctrl,
                    focusNode: _bookpickfocus,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText:
                            "eg : Near Phonix Mall , Velachery , Chennai"),
                    onChanged: (value) {
                      setState(() {
                        _donorPickupLocation = value;
                      });
                    },
                    onSubmitted: (value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                  ),
                  Center(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CupertinoButton(
                          borderRadius: BorderRadius.circular(10),
                          child: Text(
                            "Choose Current Location",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          onPressed: () {
                            _getLocationViaGmaps();
                            //test();
                            //_customProgressDialog();
                          }),
                      Tooltip(
                        message: "Note: The location is Approximate",
                        child: Icon(Icons.info),
                      )
                    ],
                  )),
                  Center(
                    child: Text(
                      _donorPickupLocation == null ? "" : _donorPickupLocation,
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                          _checkAndaddBook(context);
                          //_customProgressDialog();
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
