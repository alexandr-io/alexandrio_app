import 'package:epub/epub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';
import 'package:alexandrio_app/Pages/Settings.dart';

import 'package:alexandrio_app/API/Epub.dart';

class EpubReaderPage extends StatefulWidget {
  EpubReaderPage({Key key, this.widgets}) : super(key: key);

  final List<Text> widgets;

  @override
  _EpubReaderState createState() => _EpubReaderState();
}

class _EpubReaderState extends State<EpubReaderPage> {


  Widget build(BuildContext context) {

    List<Text> epub = [];

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBarBlur(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text('Alexandr.io'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage(),
                )),
              ),
            ],
          ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget> [
            ...widget.widgets
          ],
        )
      )
    );
  }
}