// import 'package:epub/epub.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_ui_tools/AppBarBlur.dart';
// import 'package:alexandrio_app/Pages/Settings.dart';

// import 'package:alexandrio_app/API/Epub.dart';

// class EpubReaderPage extends StatefulWidget {
//   EpubReaderPage({Key key, this.widgets}) : super(key: key);

//   final List<Text> widgets;

//   @override
//   _EpubReaderState createState() => _EpubReaderState();
// }

// class _EpubReaderState extends State<EpubReaderPage> {


//   Widget build(BuildContext context) {

//     List<Text> epub = [];

//     return Scaffold(
//       extendBody: true,
//       extendBodyBehindAppBar: true,
//       appBar: AppBarBlur(
//           child: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0.0,
//             title: Text('Alexandr.io'),
//             centerTitle: true,
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.settings),
//                 onPressed: () async => Navigator.of(context).push(MaterialPageRoute(
//                   builder: (BuildContext context) => SettingsPage(),
//                 )),
//               ),
//             ],
//           ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: <Widget> [
//             ...widget.widgets
//           ],
//         )
//       )
//     );
//   }
// }

import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
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
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Epub Reader - Reading ${widget.book.name}'),
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
