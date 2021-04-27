import 'package:flutter/material.dart';
import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class BookInfos {
  List<Widget> widgets = [];
  Image cover;

  BookInfos({this.widgets, this.cover});
}

class PdfContent {
  List<TextGlyph> content;
  List<TextLine> allLine;
  String allText;
  PdfContent(String path) {
    var document = PdfDocument(inputBytes: File(path).readAsBytesSync());
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
