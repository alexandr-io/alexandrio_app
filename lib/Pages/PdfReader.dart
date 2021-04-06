import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:flutter/material.dart';

class PdfReaderPage extends StatefulWidget {
  final Book book;
  final Uint8List bytes;

  const PdfReaderPage({
    Key key,
    @required this.book,
    @required this.bytes,
  }) : super(key: key);

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('PDF Reader - Reading ${widget.book.name}'),
        ),
        body: ListView(
          padding: EdgeInsets.all(32.0),
          children: [
            SizedBox(height: 64.0),
            Icon(
              Icons.search,
              size: 128.0,
              color: Theme.of(context).primaryColor,
            ),
            Text(
              'There should be a book here, but instead it seems we are lost right now...',
              style: Theme.of(context).textTheme.headline5,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 64.0),
            Text(
              '${widget.bytes}',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}
