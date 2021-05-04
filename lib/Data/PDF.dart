import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BookInfos {
  List<Widget> widgets = [];
  List<dom.Element> htmlContent = [];
  Image cover;

  BookInfos({this.widgets, this.cover});
}

class PdfContent {
  List<TextGlyph> content;
  List<TextLine> allLine;
  String allText;

  PdfContent(Uint8List bytes) {
    var document = PdfDocument(inputBytes: bytes);
    allLine = PdfTextExtractor(document).extractTextLines();
    allText = PdfTextExtractor(document).extractText();
    _createTextGlyphList();
  }

  void _createTextGlyphList() {
    for (var line in allLine) {
      var textWordLine = line.wordCollection;
      for (var j = 0; j < textWordLine.length; j++) {
        if (content == null) {
          content = textWordLine[j].glyphs;
        } else {
          content += textWordLine[j].glyphs;
        }
      }
    }
  }
}
