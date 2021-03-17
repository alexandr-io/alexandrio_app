import 'package:epub/epub.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as html;



class EpubLogic {
  
  List<TextStyle> styles = [
    TextStyle(fontSize: 96, letterSpacing: -1.5),
    TextStyle(fontSize: 60, letterSpacing: -0.5),
    TextStyle(fontSize: 48, letterSpacing: 0),
  ];

  Future<List<Text>> getInfos() async {
    var book = await rootBundle.load('assets/c.epub');
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
      var firstChild = content.body.firstChild;
      var contentStyle = getTextStyle(firstChild);

      Text tmp = Text(content.body.text, style: contentStyle);
      if (tmp != null)
        widgetsList.add(tmp);
      
    });
    widgetsList.forEach((element) {
      print(element.data);
    });

    return widgetsList;
  }

  TextStyle getTextStyle(currentNode) {

    if (currentNode.localName == 'div' || (currentNode.localName != 'h1' && currentNode.localName != 'h2' && currentNode.localName != 'h3'))
      return getTextStyle(currentNode.firstChild);
    
    if (currentNode.localName == 'h1')
      return styles[0];
    else if (currentNode.localName == 'h2')
      return styles[1];
    else if (currentNode.localName == 'h3')
      return styles[2];
    else
      return null;
  }
}
