import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class TestPage extends StatefulWidget {
  final Uint8List content;

  const TestPage({
    Key key,
    @required this.content,
  }) : super(key: key);

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {
  Future<List<Widget>> getPages() async {
    List<Widget> images = [];
    await for (final page in Printing.raster(widget.content)) {
      images.add(
        AspectRatio(
          aspectRatio: page.width / page.height,
          child: Image(
            image: PdfRasterImage(page),
            fit: BoxFit.cover,
          ),
        ),
      );
    }
    return images;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () async => Navigator.of(context).pop(),
          child: Icon(Icons.chevron_left),
          mini: true,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.miniStartTop,
        body: FutureBuilder(
          future: getPages(),
          builder: (context, state) {
            if (state.hasData) {
              return Container(
                color: Colors.white,
                child: ListView(
                  children: state.data,
                ),
              );
            }
            return Center(
              child: const CircularProgressIndicator(),
            );
          },
        ),
      );
}

class TestPage2 extends StatelessWidget {
  final Uint8List bytes;

  var pages = <PdfPreviewPage>[];

  TestPage2({
    Key key,
    @required this.bytes,
  }) : super(key: key);

  Future<bool> _raster() async {
    Uint8List _doc = bytes;
    //(await rootBundle.load('assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf')).buffer.asUint8List();

    var pageNum = 0;
    await for (final PdfRaster page in Printing.raster(
      _doc,
      dpi: 300.0,
      // dpi: dpi,
      // pages: widget.pages,
    )) {
      print('PAGEPAGE');

      pages.add(PdfPreviewPage(
        page: page,
        // pdfPreviewPageDecoration: widget.pdfPreviewPageDecoration,
      ));

      // if (!mounted) {
      // return false;
      // }
      // setState(() {
      //   if (pages.length <= pageNum) {
      //     pages.add(PdfPreviewPage(
      //       page: page,
      //       // pdfPreviewPageDecoration: widget.pdfPreviewPageDecoration,
      //     ));
      //   } else {
      //     pages[pageNum] = PdfPreviewPage(
      //       page: page,
      //       // pdfPreviewPageDecoration: widget.pdfPreviewPageDecoration,
      //     );
      //   }
      // });

      pageNum++;
    }

    // pages.removeRange(pageNum, pages.length);
    return true;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Stack(
            children: [
              FutureBuilder(
                future: _raster(),
                builder: (context, state) {
                  if (state.hasData) {
                    return ListView(
                      children: pages,
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
              OutlineButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Back'),
              ),
            ],
          ),
        ),
      );
}
