import 'dart:io';
import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:epub_view/epub_view.dart';
// import 'package:epub_view/epub_view.dart';
import 'package:epubx/epubx.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Epub.dart';
import 'package:alexandrio_app/API/EpubParser.dart';

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
  var _controller = ScrollController();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Epub Reader - Reading ${widget.book.name}'),
      ),
      body: Row(
        children: [
          Expanded(
            child: EpubView(
              controller: controller,
            ),
          ),
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 4 / 3 : 1 / 2,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollUpdateNotification) {
                      print(_controller.offset); // Current offset
                      print(_controller.position.maxScrollExtent); // Maximum offset
                      print((_controller.offset * 100) / _controller.position.maxScrollExtent); // Percentage readed
                    }
                    return;
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      SizedBox(height: 64.0),
                      FutureBuilder<BookInfos>(
                          future: _getInfos(context),
                          builder: (BuildContext context, AsyncSnapshot<BookInfos> snapshot) {
                            var content = <Widget>[];

                            if (snapshot.hasData) {
                              content = <Widget>[...snapshot.data.widgets];
                            } else if (snapshot.hasError) {
                              print(snapshot.error);
                            } else {
                              content = <Widget>[
                                SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircularProgressIndicator(),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text('Chargement...'),
                                )
                              ];
                            }
                            return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [...content]));
                          })
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<BookInfos> _getInfos(BuildContext context) async {
    // var book = await rootBundle.load('assets/samples/epub/test4.epub');
    var epubBook = await EpubReader.readBook(widget.bytes); // book.buffer.asUint8List());

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
}
