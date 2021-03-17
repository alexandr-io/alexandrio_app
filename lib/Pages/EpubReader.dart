import 'package:flutter/material.dart';

import '../App.dart';

class EpubReaderState extends State<EpubReader> {
  @override
  Widget build(BuildContext context) {
    List<Text> text = [];
    var epub = context.findAncestorStateOfType<AppState>().epub;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget> [
              ...widget.widgets,
            ]
          ),
        ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async => {
          text = await epub.getInfos(),
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => EpubReader(widgets: text),
            )
          ),
        }, 
        tooltip: 'Display Epub Content',
        child: Icon(Icons.add),
      ),
    );
  }
}

class EpubReader extends StatefulWidget {
  EpubReader({Key key, this.widgets}) : super(key: key);

  final List<Text> widgets;

  @override
  EpubReaderState createState() => EpubReaderState();
}