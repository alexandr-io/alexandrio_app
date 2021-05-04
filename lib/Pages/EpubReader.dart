import 'dart:io';
import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:epub_view/epub_view.dart' hide Image;
import 'package:epubx/epubx.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:alexandrio_app/Data/Epub.dart';
import 'package:alexandrio_app/API/EpubParser.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:flutter_html/flutter_html.dart';

class EpubReaderPage extends StatefulWidget {
  final Book book;
  final Library library;
  final Credentials credentials;
  final Uint8List bytes;

  const EpubReaderPage({Key key, @required this.book, @required this.bytes, @required this.credentials, @required this.library}) : super(key: key);

  @override
  _EpubReaderPageState createState() => _EpubReaderPageState();
}

class _EpubReaderPageState extends State<EpubReaderPage> {
  bool compatibility = true;
  EpubController controller;
  ScrollController _controller;
  EpubBook _doc;

  @override
  void initState() {
    controller = EpubController(
      document: EpubReader.readBook(widget.bytes),
      // epubCfi: 'epubcfi(/6/6[chapter-2]!/4/2/1612)',
    );
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.name),
        actions: [
          IconButton(
            icon: Icon(Icons.compare),
            onPressed: () async => setState(() {
              compatibility = !compatibility;
            }),
          ),
        ],
      ),
      body: compatibility
          ? EpubView(controller: controller)
          : Center(
              child: AspectRatio(
                aspectRatio: (Platform.isWindows || Platform.isLinux || Platform.isMacOS) ? 4 / 3 : 1 / 2,
                child: NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollEndNotification) {
                      print(_controller.offset); // Current offset
                      print(_controller.position.maxScrollExtent); // Maximum offset
                      print((_controller.offset * 100) / _controller.position.maxScrollExtent); // Percentage readed
                      // var progress = (_controller.offset * 100) / _controller.position.maxScrollExtent;
                      // AlexandrioAPI().updateBookProgress(widget.credentials, widget.library, widget.book, progress.toString());
                    }
                    return true;
                  },
                  child: ListView(
                    controller: _controller,
                    children: [
                      SizedBox(height: 64.0),
                      FutureBuilder<BookInfos>(
                        future: _getInfos(context),
                        builder: (BuildContext context, AsyncSnapshot<BookInfos> snapshot) {
                          if (snapshot.hasData) {
                            var content = snapshot.data;
                            return Center(
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                              for (var html in content.htmlContent)
                                Html(data: html.outerHtml, customRender: {
                                  'img': (context, child, attributes, node) {
                                    final url = attributes['src'].replaceAll('../', '');
                                    return Image(
                                        image: MemoryImage(
                                      Uint8List.fromList(_doc.Content.Images[url].Content),
                                    ));
                                  }
                                })
                            ]));
                          } else if (snapshot.hasError) {
                            print(snapshot.error);
                          } else {
                            return const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Chargement...'),
                            );
                          }
                          return null;
                          // children: List.generate(content.length, (index) {
                          //   return Html(data: );
                          //}
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Future<BookInfos> _getInfos(BuildContext context) async {
    // var book = await rootBundle.load('assets/samples/epub/test4.epub');
    var epubBook = await EpubReader.readBook(widget.bytes); // book.buffer.asUint8List());
    _doc = epubBook;
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
