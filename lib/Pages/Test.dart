import 'package:flutter/material.dart';
import 'package:native_pdf_view/native_pdf_view.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: PdfView(
          controller: PdfController(
            document: PdfDocument.openAsset("assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf"),
          ),
        ),
      );
}
