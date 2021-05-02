import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;

class BookInfos {
  List<Widget> widgets = [];
  List<dom.Element> htmlContent = [];
  Image cover;

  BookInfos({
    this.widgets,
    this.cover
  });
}

