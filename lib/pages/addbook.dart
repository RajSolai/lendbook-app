import 'package:flutter/material.dart';
import 'package:lendbook/components/CustomAppBar.dart';

class AddBook extends StatefulWidget {
  AddBook({Key key}) : super(key: key);

  @override
  _AddBookState createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CustomAppBar(
                title: "Donate Now",
              )
            ],
          ),
        ),
      ),
    );
  }
}
