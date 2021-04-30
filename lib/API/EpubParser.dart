import 'package:flutter/material.dart' as flutter hide Element;
import 'package:html/dom.dart';
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart' as html;
import 'package:alexandrio_app/Data/Epub.dart';

BookInfos fillTextList(flutter.BuildContext context, EpubBook epubBook) {
  var bookInfos = BookInfos(widgets: []);

  epubBook.Chapters.forEach((EpubChapter chapter) {
    var content = html.parse(chapter.HtmlContent);
    var infos = retrieveTextStyle(context, content.body);

    if (infos != null && infos.widgets.isNotEmpty) {
      for (var i = 0; i < infos.widgets.length; ++i) {
        bookInfos.widgets.add(infos.widgets[i]);
      }
    }

    chapter.SubChapters.forEach((EpubChapter subchapter) {
      var content = html.parse(subchapter.HtmlContent);
      var infos = retrieveTextStyle(context, content.body);

      if (infos != null && infos.widgets.isNotEmpty) {
        for (var i = 0; i < infos.widgets.length; ++i) {
          bookInfos.widgets.add(infos.widgets[i]);
        }
      }

      if (subchapter.SubChapters.isNotEmpty) {
        subchapter.SubChapters.forEach((EpubChapter subsubchapter) {
          var content = html.parse(subsubchapter.HtmlContent);
          var infos = retrieveTextStyle(context, content.body);

          if (infos != null && infos.widgets.isNotEmpty) {
            for (var i = 0; i < infos.widgets.length; ++i) {
              bookInfos.widgets.add(infos.widgets[i]);
            }
          }
        });
      }
    });
  });

  return bookInfos;
}

BookInfos retrieveTextStyle(flutter.BuildContext context, dynamic nodes) {
  var pageTexts = BookInfos(widgets: []);
  var tmp = nodes;

  while (nodes.localName != 'body') {
    tmp = tmp.children;
  }

  for (var i = 0; i < tmp.nodes.length; ++i) {
    if (tmp.nodes[i].runtimeType == Element) {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text));
    } else {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text));
    }
  }
  // for (var i = 0; i < nodes.length; ++i) {
  //   if (nodes[i].firstChild != null && nodes[i].localName == 'h1') {
  //     pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline1));
  //   } else if (nodes[i].firstChild != null && nodes[i].localName == 'h2') {
  //     pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline2));
  //   } else if (nodes[i].firstChild != null && nodes[i].localName == 'h3') {
  //     pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline3));
  //   } else if (nodes[i].firstChild != null && nodes[i].localName == 'h4') {
  //     pageTexts.widgets.add(Text(nodes[i].text));
  //   } else if (nodes[i].firstChild != null && nodes[i].localName == 'h5') {
  //     pageTexts.widgets.add(Text(nodes[i].text, style: Theme.of(context).textTheme.headline5));
  //   } else {
  //     pageTexts.widgets.add(Text(nodes[i].text));
  //   }
  // }

  return pageTexts;
}
