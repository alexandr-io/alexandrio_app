import 'package:epub/epub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;

// List<TextStyle> styles = [
//   TextStyle(fontSize: 96, letterSpacing: -1.5),
//   TextStyle(fontSize: 60, letterSpacing: -0.5),
//   TextStyle(fontSize: 48, letterSpacing: 0),
//   TextStyle(fontSize: 16, letterSpacing: 0.5),
// ];

Future<List<Text>> getInfos() async {
  var book = await rootBundle.load('assets/test.epub');
  EpubBook epubBook = await EpubReader.readBook(book.buffer.asUint8List());

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

  var widgets = fillTextList(epubBook);
  return widgets;
}


List<Text> fillTextList(EpubBook epubBook) {
  List<Text> widgetsList = [];

  epubBook.Chapters.forEach((EpubChapter chapter) {
    var content = html.parse(chapter.HtmlContent);
    var text = retrieveTextStyle(content.body.firstChild.nodes);

    if (text != null && text.isNotEmpty) {
      for (var i = 0; i < text.length; ++i) {
        widgetsList.add(text[i]);
      }
    }
    
  });
  widgetsList.forEach((element) {
    print(element.data);
  });

  return widgetsList;
}

List<Text> retrieveTextStyle(List nodes) {
  List<Text> pageTexts = [];

  for (var i = 0; i < nodes.length; ++i) {
    print(nodes[i].text);
    pageTexts.add(Text(nodes[i].text));
  }
  return pageTexts;
}