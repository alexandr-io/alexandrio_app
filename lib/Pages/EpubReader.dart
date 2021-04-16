import 'package:epub/epub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/API/Epub.dart';

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
      body: ListView(
        padding: EdgeInsets.all(32.0),
        children: [
          SizedBox(height: 64.0),
          FutureBuilder<WidgetInfos>(
            future: _getInfos(context),
            builder: (BuildContext context, AsyncSnapshot<WidgetInfos> snapshot) {

              var content = <Widget>[];

              if (snapshot.hasData) {
                content = <Widget> [
                  ...snapshot.data.widgets
                ];
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
                  children: [
                    ...content
                  ]
                )
              );
            }
          )
        ],
      ),
    );
  }
}

Future<WidgetInfos> _getInfos(BuildContext context) async {
  var book = await rootBundle.load('assets/samples/epub/test.epub');
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

  var widgets = fillTextList(context, epubBook);

  return widgets;
}


WidgetInfos fillTextList(BuildContext context, EpubBook epubBook) {
  var widgetsList = WidgetInfos(widgets: [], info: []);

  epubBook.Chapters.forEach((EpubChapter chapter) {
    var content = html.parse(chapter.HtmlContent);
    var infos = retrieveTextStyle(context, content.body.firstChild.nodes);

    if (infos != null && infos.widgets.isNotEmpty) {
      for (var i = 0; i < infos.widgets.length; ++i) {
        widgetsList.widgets.add(infos.widgets[i]);
        widgetsList.info.add(infos.info[i]);
      }
    }
    
  });

  return widgetsList;
}

WidgetInfos retrieveTextStyle(BuildContext context, List nodes) {
  var pageTexts = WidgetInfos(widgets: [], info: []);

  for (var i = 0; i < nodes.length; ++i) {
    if (nodes[i].localName == 'h1') {
      pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline1));
    } else if (nodes[i].localName == 'h2') {
      pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline2));
    } else if (nodes[i].localName == 'h3') {
      pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline3));
    } else if (nodes[i].localName == 'h4') {
      pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline4));
    } else if (nodes[i].localName == 'h5') {
      pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline5));
    } else {
      pageTexts.widgets.add(Text(nodes[i].text));
    }
    pageTexts.info.add(Text(nodes[i].localName));
  }
  return pageTexts;
}

