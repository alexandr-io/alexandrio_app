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
          actions: [
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await AlexandrioAPI().deleteLibrary(widget.credentials, libraryId: widget.library.id);
              },
            ),
          ],
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

            return ListView(
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
            );
          },
        ),
      );
}
