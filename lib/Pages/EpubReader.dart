import 'dart:io';

import 'package:epub/epub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Epub.dart';
import 'package:alexandrio_app/API/EpubParser.dart';

class EpubReaderPage extends StatefulWidget {
  final Book book;

  const EpubReaderPage({
    Key key,
    @required this.book,
  }) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epub Reader - Reading ${widget.book.name}'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio:
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  ? 4 / 3
                  : 1 / 2,
          child: ListView(
            children: [
              SizedBox(height: 64.0),
              FutureBuilder<BookInfos>(
                  future: _getInfos(context),
                  builder: (BuildContext context,
                      AsyncSnapshot<BookInfos> snapshot) {
                    var content = <Widget>[];

                    if (snapshot.hasData) {
                      content = <Widget>[...snapshot.data.widgets];
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                    } else {
                      content = <Widget>[
                        SizedBox(
                          child: CircularProgressIndicator(),
                          width: 60,
                          height: 60,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('Chargement...'),
                        )
                      ];
                    }
                    return Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [...content]));
                  })
            ],
          ),
        ),
      ),
    );
  }
}

Future<BookInfos> _getInfos(BuildContext context) async {
  var book = await rootBundle.load('assets/samples/epub/test3.epub');
  var epubBook = await EpubReader.readBook(book.buffer.asUint8List());

  // print(epubBook.Title);
  // print(epubBook.Author);
  // print(epubBook.AuthorList);
  // print(epubBook.CoverImage);

  // epubBook.Chapters.forEach((EpubChapter chapter) {
  //   print(chapter.Title);
  //   var content = html.parse(chapter.HtmlContent);
  //   print(content.body.text);
  //   print(chapter.SubChapters);
  // });

  return fillTextList(context, epubBook);
}
