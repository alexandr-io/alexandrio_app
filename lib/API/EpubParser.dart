import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart' as flutter hide Element;
import 'package:html/dom.dart';
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart' as html;
import 'package:alexandrio_app/Data/Epub.dart';

Future<BookInfos> fillTextList(flutter.BuildContext context, EpubBook epubBook) async {
  var bookInfos = BookInfos(widgets: []);

  epubBook.Chapters.forEach((EpubChapter chapter) async {
    var content = html.parse(chapter.HtmlContent);

    
    bookInfos.htmlContent.add(content.body);
    // if (infos != null && infos.htmlContent.isNotEmpty) {
    //   for (var i = 0; i < infos.htmlContent.length; ++i) {
    //     // bookInfos.widgets.add(infos.widgets[i]);
    //     bookInfos.htmlContent.add(infos.htmlContent[i]);
    //   }
    // }

    chapter.SubChapters.forEach((EpubChapter subchapter) async {
      var content = html.parse(subchapter.HtmlContent);
      
      bookInfos.htmlContent.add(content.body);
      // if (infos != null && infos.htmlContent.isNotEmpty) {
      //   for (var i = 0; i < infos.htmlContent.length; ++i) {
      //     // bookInfos.widgets.add(infos.widgets[i]);
      //     bookInfos.htmlContent.add(infos.htmlContent[i]);
      //   }
      // }

      if (subchapter.SubChapters.isNotEmpty) {
        subchapter.SubChapters.forEach((EpubChapter subsubchapter) async {
          var content = html.parse(subsubchapter.HtmlContent);

          bookInfos.htmlContent.add(content.body);
          // if (infos != null && infos.htmlContent.isNotEmpty) {
          //   for (var i = 0; i < infos.htmlContent.length; ++i) {
          //     // bookInfos.widgets.add(infos.widgets[i]);
          //     bookInfos.htmlContent.add(infos.htmlContent[i]);
          //   }
          // }
        });
      }
    });
  });

  return bookInfos;
}