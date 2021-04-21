import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  final Credentials credentials;
  final Library library;

  const LibraryPage({
    Key key,
    @required this.credentials,
    @required this.library,
  }) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.library.name),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {},
          tooltip: 'Upload a book',
          child: Icon(Icons.upload_file),
        ),
        body: FutureBuilder(
          future: AlexandrioAPI().getBooksForLibrary(widget.credentials, library: widget.library),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            return Row(
              children: [
                Container(
                  width: 512.0,
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        for (var book in snapshot.data)
                          InkWell(
                            onTap: () async {},
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Container(
                                        width: 160.0 * (10.0 / 16.0) / 1.5,
                                        child: Image.network(
                                          'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
                                          height: 160.0 / 1.5,
                                          fit: BoxFit.cover,
                                          filterQuality: FilterQuality.high,
                                          isAntiAlias: true,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${book.name}',
                                          style: Theme.of(context).textTheme.headline6,
                                        ),
                                        Text(
                                          'by Your Mom',
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
                Expanded(
                  child: Scrollbar(
                    child: ListView(
                      children: [
                        Container(
                          height: 400.0,
                          child: Stack(
                            children: [
                              Image.network(
                                'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                                filterQuality: FilterQuality.high,
                                isAntiAlias: true,
                              ),
                              Container(
                                color: Colors.black.withAlpha(192),
                                width: double.infinity,
                                height: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.all(48.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'OpenOffice for dummies',
                                                style: Theme.of(context).textTheme.headline4,
                                              ),
                                              Text(
                                                'by Your Mom',
                                                style: Theme.of(context).textTheme.headline5,
                                              ),
                                            ],
                                          ),
                                          OutlinedButton.icon(
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all(EdgeInsets.all(24.0)),
                                            ),
                                            onPressed: () async {},
                                            icon: Icon(Icons.read_more),
                                            label: Text('Resume reading'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24.0, top: 24.0, left: 24.0),
                          child: Text(
                            'Synopsis',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent ac volutpat arcu. Mauris pharetra ac mauris ac vehicula. Donec vehicula nisl vel sapien finibus, non hendrerit libero pharetra. Suspendisse ac pretium quam. Sed auctor nulla placerat nibh venenatis, bibendum porttitor lorem facilisis. Integer a ex eget elit tincidunt euismod non vitae nibh. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. In semper odio quis gravida ornare. Etiam at sem ornare, ultrices orci eu, gravida mauris. Pellentesque quis pretium ex. Praesent condimentum porta arcu, vitae pretium libero bibendum eu. Phasellus bibendum sodales ipsum, sed scelerisque velit lacinia ut. Nam mattis leo varius, cursus neque ac, tincidunt tortor. Quisque non laoreet diam, elementum dictum dui. Donec varius mi justo, ac auctor felis pellentesque eu. In ut elit vel leo posuere facilisis nec faucibus lectus.',
                            style: Theme.of(context).textTheme.headline5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
}
