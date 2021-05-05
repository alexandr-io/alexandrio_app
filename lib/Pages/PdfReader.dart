import 'dart:io';
import 'dart:typed_data';
import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/API/PDFParser.dart';
import 'package:alexandrio_app/Data/PDF.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:flutter/material.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:alexandrio_app/Data/Credentials.dart';

class PdfReaderPage extends StatefulWidget {
  final Book book;
  final Uint8List bytes;
  final Library library;
  final Credentials credentials;
  final String progression;

  const PdfReaderPage(
      {Key key,
      @required this.book,
      @required this.bytes,
      @required this.credentials,
      @required this.library,
      @required this.progression})
      : super(key: key);

  @override
  _PdfReaderPageState createState() => _PdfReaderPageState();
}

class _PdfReaderPageState extends State<PdfReaderPage> {
  final _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Reader - Reading ${widget.book.name}'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio:
              (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                  ? 4 / 3
                  : 1 / 2,
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollEndNotification) {
                // print(_controller.offset); // Current offset
                // print(_controller.position.maxScrollExtent); // Maximum offset
                // print((_controller.offset * 100) /
                //     _controller.position.maxScrollExtent); // Percentage readed
                var progress = (_controller.offset * 100) /
                    _controller.position.maxScrollExtent;
                AlexandrioAPI().updateBookProgress(widget.credentials,
                    widget.library, widget.book, progress.toString());
              }
              return true;
            },
            child: ListView(
              controller: _controller,
              children: [
                SizedBox(height: 64.0),
                FutureBuilder<BookInfos>(
                    future: _getInfos(context),
                    builder: (BuildContext context,
                        AsyncSnapshot<BookInfos> snapshot) {
                      var content = <Widget>[];
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        var offset = (double.parse(widget.progression ?? '0') *
                                _controller.position.maxScrollExtent) /
                            100;
                        _controller.jumpTo(offset);
                      });
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
      ),
    );
  }

  Future<BookInfos> _getInfos(BuildContext context) async {
    // var book = PdfContent('assets/samples/pdf/Document10.pdf');
    var book = PdfContent(widget.bytes);

    return fillPDFList(book);
  }
}
