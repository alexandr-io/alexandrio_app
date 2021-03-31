import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:io';

class TmpPdfContent {
  List<TextGlyph> content;
  String allText;
  TmpPdfContent(String path) {
    var document = PdfDocument(inputBytes: File(path).readAsBytesSync());
    final textLine = PdfTextExtractor(document).extractTextLines();
    allText = PdfTextExtractor(document).extractText();
    _createTextGlyphList(textLine);
  }

  void _createTextGlyphList(List<TextLine> textLine) {
    for (var i; i < textLine.length; i++) {
      var textWordLine = textLine[i].wordCollection;
      for (var j; j < textWordLine.length; j++) {
        content += textWordLine[j].glyphs;
      }
    }
  }

  String getAllText() {
    return (allText);
  }

  List<TextGlyph> getAllChar() {
    return (content);
  }
}

class TmpHtml {
  String body = '<!DOCTYPE HTML>\n<head><title>Test html pdf</title></head>\n';
  TmpPdfContent pdfObject;
  TmpHtml(String path) {
    pdfObject = TmpPdfContent(path);
    body += '<p>"';
    body += pdfObject.getAllText();
    body += '"<p>';
  }
  String getBody() {
    return (body);
  }
}
