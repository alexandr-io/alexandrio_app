import 'package:flutter/material.dart' as flutter hide Element;
import 'package:flutter/widgets.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart' as html;
import 'package:alexandrio_app/Data/PDF.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

BookInfos fillPDFList(PdfContent book) {
  var bookInfos = BookInfos(widgets: []);
  var contentPDF = PdfToHtml(book.allLine);
  var content = html.parse(contentPDF.finalString);
  var infos = retrieveTextStyle(content.body, contentPDF.finalBaseList);

  bookInfos.htmlContent.add(content.body);
  if (infos != null && infos.widgets.isNotEmpty) {
    for (var i = 0; i < infos.widgets.length; ++i) {
      bookInfos.widgets.add(infos.widgets[i]);
    }
  }
  return (bookInfos);
}

BookInfos retrieveTextStyle(dynamic nodes, List<double> baseList) {
  var pageTexts = BookInfos(widgets: []);
  var tmp = nodes;

  while (nodes.localName != 'body') {
    tmp = tmp.children;
  }

  // for (var i = 0; i < tmp.nodes.length; ++i) {
  //   pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text));
  for (var i = 0; i < tmp.nodes.length; ++i) {
    if (tmp.nodes[i].firstChild != null && tmp.nodes[i].localName == 'h1') {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[0])));
    } else if (tmp.nodes[i].firstChild != null &&
        tmp.nodes[i].localName == 'h2') {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[1])));
    } else if (tmp.nodes[i].firstChild != null &&
        tmp.nodes[i].localName == 'h3') {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[2])));
    } else if (tmp.nodes[i].firstChild != null &&
        tmp.nodes[i].localName == 'h4') {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[3])));
    } else if (tmp.nodes[i].firstChild != null &&
        tmp.nodes[i].localName == 'h5') {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[4])));
    } else {
      pageTexts.widgets.add(flutter.Text(tmp.nodes[i].text,
          style: TextStyle(fontSize: baseList[5])));
    }
  }
  return pageTexts;
}

String replaceCharAt(String oldString, int index, String newChar, int size) {
  return oldString.substring(0, index) +
      newChar +
      oldString.substring(index + size);
}

class PdfToHtml {
  var finalString = '<body>';
  final tab = ['<h1>', '<h2>', '<h3>', '<h4>', '<h5>', '<p>'];
  final endtab = ['</h1>', '</h2>', '</h3>', '</h4>', '</h5>', '</p>'];
  var finalBaseList;

  PdfToHtml(List<TextLine> allLine) {
    var base = _getFirstValue(allLine);
    var baseList = [base];
    for (var line in allLine) {
      var tmpValue = getLineValue(line);
      if (base != tmpValue && !baseList.contains(tmpValue)) {
        if (baseList.length == 6 && tmpValue > baseList[5]) {
          baseList[5] = tmpValue;
          _uppersize(_sortList(baseList));
        } else if (baseList.length != 6) {
          if (baseList[baseList.length - 1] > tmpValue) {
            addOneSize(baseList.length - 1);
            baseList.add(tmpValue);
          } else {
            baseList.add(tmpValue);
            _uppersize(_sortList(baseList));
          }
        }
      }
      base = tmpValue;
      _addbalise(base, baseList, false);
      for (var word in line.wordCollection) {
        var content = word.glyphs;
        tmpValue = content[0].fontSize;
        if (base != tmpValue) {
          _addbalise(base, baseList, true);
          if (!baseList.contains(tmpValue)) {
            if (baseList.length == 6 && tmpValue > baseList[5]) {
              baseList[5] = tmpValue;
              _uppersize(_sortList(baseList));
            } else if (baseList.length != 6) {
              if (baseList[baseList.length - 1] > tmpValue) {
                addOneSize(baseList.length - 1);
                baseList.add(tmpValue);
              } else {
                baseList.add(tmpValue);
                _uppersize(_sortList(baseList));
              }
            }
          }
          base = tmpValue;
          _addbalise(base, baseList, false);
        }
        for (var i = 0; i < content.length; ++i) {
          finalString += content[i].text;
        }
      }
      _addbalise(base, baseList, true);
    }
    finalString += '</body>';
    finalBaseList = baseList;
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
    for (var i = 0; i < finalString.length - 4; ++i) {
      for (var j = 0; j < subtab.length - 1; ++j) {
        var tmp = finalString.substring(i, subtab[j].length + i);
        if (tmp == subtab[j]) {
          finalString =
              replaceCharAt(finalString, i, subtab[j + 1], subtab[j].length);
        } else if (finalString.substring(i, endsubtab[j].length + i) ==
            endsubtab[j]) {
          finalString = replaceCharAt(
              finalString, i, endsubtab[j + 1], endsubtab[j].length);
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

  void addOneSize(int length) {
    for (var i = 0; i < finalString.length - 3; ++i) {
      if (finalString.substring(i, 3 + i) == '<p>') {
        finalString = replaceCharAt(finalString, i, tab[length], 3);
      } else if (finalString.substring(i, 4 + i) == '</p>') {
        finalString = replaceCharAt(finalString, i, endtab[length], 4);
      }
    }
  }
}
