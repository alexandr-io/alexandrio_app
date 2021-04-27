import 'package:flutter/material.dart' as flutter hide Element;
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:alexandrio_app/Data/PDF.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

BookInfos fillPDFList(PdfContent book) {
  var bookInfos = BookInfos(widgets: []);
  var contentPDF = PdfToHtml(book.allLine);
  var content = html.parse(contentPDF.finalString);
  var infos = retrieveTextStyle(content.body);

  if (infos != null && infos.widgets.isNotEmpty) {
    for (var i = 0; i < infos.widgets.length; ++i) {
      bookInfos.widgets.add(infos.widgets[i]);
    }
  }
  return (bookInfos);
}

BookInfos retrieveTextStyle(dynamic nodes) {
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
  return pageTexts;
}

String replaceCharAt(String oldString, int index, String newChar) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + 1);
}

class PdfToHtml {
  var finalString = '<body>';
  final tab = ['<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<p>'];
  final endtab = ['</h1>', '</h2>', '</h3>', '</h4>', '</h5>', '</p>'];

  PdfToHtml(List<TextLine> allLine) {
    var base = _getFirstValue(allLine);
    var baseList = [base];
    for (var line in allLine) {
      var tmpValue = getLineValue(line);
      // if (base != tmpValue) {
      //   if (baseList.length == 6 && tmpValue < baseList[5]) {
      //     baseList[5] = tmpValue;
      //     _uppersize(_sortList(baseList));
      //   } else if (baseList.length != 6) {
      //     baseList.add(tmpValue);
      //     _uppersize(_sortList(baseList));
      //   }
      // }
      base = tmpValue;
      _addbalise(base, baseList, false);
      for (var word in line.wordCollection) {
        var content = word.glyphs;
        for (var i = 0; i < content.length; ++i) {
          finalString += content[i].text;
        }
        finalString += ' ';
      }
      finalString = finalString.substring(0, finalString.length - 1);
      _addbalise(base, baseList, true);
    }
    finalString += '</body>';
  }

  List<int> _sortList(List<double> baseList) {
    var value = baseList[baseList.length - 1];
    var j = 0;
    for (var i = 0; i < baseList.length; ++i) {
      if (baseList[i] < value) {
        j = i;
        while (i < baseList.length - 1) {
          baseList[i + 1] = baseList[i];
          i += 1;
        }
        baseList[j] = value;
      }
    }
    return ([j, baseList.length]);
  }

  void _uppersize(List<int> change) {
    var subtab = tab.sublist(change[0], change[1]);
    subtab[subtab.length - 1] = '<p>';
    var endsubtab = endtab.sublist(change[0], change[1]);
    endsubtab[endsubtab.length - 1] = '</p>';
    for (var i = 0; i < finalString.length; ++i) {
      for (var j = 0; j < subtab.length - 1; ++j) {
        if (finalString.substring(i, subtab[j].length) == subtab[j]) {
          finalString = replaceCharAt(finalString, i, subtab[j + 1]);
        } else if (finalString.substring(i, endsubtab[j].length) ==
            endsubtab[j]) {
          finalString = replaceCharAt(finalString, i, endsubtab[j + 1]);
        }
      }
    }
  }

  void _addbalise(double base, List<double> baseList, bool end) {
    if (!baseList.contains(base) ||
        baseList.indexOf(base) == baseList.length - 1) {
      if (end) {
        finalString += '</p>';
      } else {
        finalString += '<p>';
      }
    } else if (!end) {
      finalString += tab[baseList.indexOf(base)];
    } else {
      finalString += endtab[baseList.indexOf(base)];
    }
  }

  double _getFirstValue(List<TextLine> allLine) {
    if (allLine.isNotEmpty &&
        allLine[0].wordCollection.isNotEmpty &&
        allLine[0].wordCollection[0].glyphs.isNotEmpty) {
      return (allLine[0].wordCollection[0].glyphs[0].fontSize);
    }
    return (0.0);
  }

  double getLineValue(TextLine line) {
    if (line.wordCollection.isNotEmpty &&
        line.wordCollection[0].glyphs.isNotEmpty) {
      return (line.wordCollection[0].glyphs[0].fontSize);
    }
    return (0.0);
  }
}
