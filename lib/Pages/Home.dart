import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/API/Epub.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:alexandrio_app/Pages/Settings.dart';
import 'package:alexandrio_app/Pages/EpubReader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';
import 'package:flutter_ui_tools/BottomModal.dart';

class Library2 {
  final String name;
  final List<Book> books;

  Library2({
    this.name,
    this.books,
  });
}

var libraries2 = [
  Library2(
    name: 'Library 1',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg',
      ),
      Book(
        name: 'Book 2',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Book 3',
        thumbnail: 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/action-thriller-book-cover-design-template-3675ae3e3ac7ee095fc793ab61b812cc_screen.jpg?ts=1588152105',
      ),
      Book(
        name: 'Book 4',
        thumbnail: 'https://static01.nyt.com/images/2014/02/05/books/05before-and-after-slide-T6H2/05before-and-after-slide-T6H2-superJumbo.jpg?quality=75&auto=webp&disable=upscale',
      ),
      Book(
        name: 'Book 1',
        thumbnail: 'https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg',
      ),
      Book(
        name: 'Book 2',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Book 3',
        thumbnail: 'https://d1csarkz8obe9u.cloudfront.net/posterpreviews/action-thriller-book-cover-design-template-3675ae3e3ac7ee095fc793ab61b812cc_screen.jpg?ts=1588152105',
      ),
      Book(
        name: 'Book 4',
        thumbnail: 'https://static01.nyt.com/images/2014/02/05/books/05before-and-after-slide-T6H2/05before-and-after-slide-T6H2-superJumbo.jpg?quality=75&auto=webp&disable=upscale',
      ),
    ],
  ),
  Library2(
    name: 'Library 2',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://static01.nyt.com/images/2014/02/05/books/05before-and-after-slide-T6H2/05before-and-after-slide-T6H2-superJumbo.jpg?quality=75&auto=webp&disable=upscale',
      ),
      Book(
        name: 'Book 2',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
    ],
  ),
  Library2(
    name: 'Library 3',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Haskell for novices',
        thumbnail: null, // 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
    ],
  ),
  Library2(
    name: 'Library 3',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Haskell for novices',
        thumbnail: null, // 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
    ],
  ),
  Library2(
    name: 'Library 3',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Haskell for novices',
        thumbnail: null, // 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
    ],
  ),
  Library2(
    name: 'Library 3',
    books: [
      Book(
        name: 'Book 1',
        thumbnail: 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
      Book(
        name: 'Haskell for novices',
        thumbnail: null, // 'https://edit.org/images/cat/book-covers-big-2019101610.jpg',
      ),
    ],
  ),
];

class HomePage extends StatefulWidget {
  final Credentials credentials;

  const HomePage({
    Key key,
    @required this.credentials,
  }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Library>> libraries;
  List<Text> widgets;

  @override
  void initState() {
    libraries = AlexandrioAPI().getLibraries(widget.credentials);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBarBlur(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Text('Alexandr.io'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.book),
                onPressed: () async => {
                  widgets = await getInfos(),
                  Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => EpubReaderPage(widgets: widgets),
                  )),
                }
              ),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () async => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => SettingsPage(),
                )),
              ),
            ],
          ),
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              BottomModal.push(
                context: context,
                child: BottomModal(
                  height: 64.0,
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Name',
                            isDense: true,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () async {},
                        icon: Icon(Icons.add),
                        label: Text('Create library'),
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Icon(Icons.add),
            tooltip: 'Create new library',
          ),
        ),
        body: RefreshIndicator(
          displacement: AppBar().preferredSize.height,
          onRefresh: () async {
            setState(() {
              libraries = AlexandrioAPI().getLibraries(widget.credentials);
            });
          },
          child: FutureBuilder<List<Library>>(
            future: libraries,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView(
                  children: [
                    for (var library in libraries2)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () async {},
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 4.0),
                                  child: Text(
                                    library.name,
                                    style: Theme.of(context).textTheme.headline6,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2.0, right: 16.0),
                                  child: Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 160.0,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                for (var book in library.books)
                                  Container(
                                    width: 160.0 * (10.0 / 16.0),
                                    child: Stack(
                                      children: [
                                        Container(
                                          width: 160.0 * (10.0 / 16.0),
                                          child: book.thumbnail != null
                                              ? Image.network(
                                                  book.thumbnail,
                                                  height: 160.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                      Icons.book,
                                                      size: 48.0,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 4.0),
                                                      child: Text(
                                                        book.name,
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                        ),
                                        Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            onTap: () async {},
                                            child: Container(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                );
              } else if (snapshot.hasError) {
                return SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SafeArea(
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Icon(
                                Icons.block,
                                size: 64.0,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            Text(
                              '${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
              return SafeArea(child: Center(child: CircularProgressIndicator.adaptive()));
            },
          ),
        ),
      );
}
