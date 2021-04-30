import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';

class EpubReaderPage extends StatefulWidget {
  final Book book;
  final Uint8List bytes;

  const EpubReaderPage({
    Key key,
    @required this.book,
    @required this.bytes,
  }) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  EpubController controller;

  @override
  void initState() {
    controller = EpubController(
      // Load document
      document: EpubReader.readBook(widget.bytes),
      // Set start point
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Epub Reader - Reading ${widget.book.name}'),
        ),
        // body: ListView(
        //   padding: EdgeInsets.all(32.0),
        //   children: [
        //     SizedBox(height: 64.0),
        //     Icon(
        //       Icons.search,
        //       size: 128.0,
        //       color: Theme.of(context).primaryColor,
        //     ),
        //     Text(
        //       'There should be a book here, but instead it seems we are lost right now...',
        //       style: Theme.of(context).textTheme.headline5,
        //       textAlign: TextAlign.center,
        //     ),
        //     SizedBox(height: 64.0),
        //     Text(
        //       '${widget.bytes}',
        //       textAlign: TextAlign.center,
        //     ),
        //   ],
        // ),
        body: EpubView(
          controller: controller,
        ),
      );
}
