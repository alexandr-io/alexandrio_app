import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ui_tools/BottomModal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'EpubReader.dart';
import 'PdfReader.dart';

class BookPage extends StatelessWidget {
  final Book book;
  final Library library;
  final Credentials credentials;
  final Function refresh;

  const BookPage({
    Key key,
    @required this.book,
    @required this.library,
    @required this.credentials,
    @required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            var bookData = await AlexandrioAPI().downloadBook(
              credentials,
              book: book,
            );
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => bookData.mime == 'application/pdf'
                  ? PdfReaderPage(
                      book: book,
                      bytes: bookData.bytes,
                    )
                  : EpubReaderPage(
                      book: book,
                      bytes: bookData.bytes,
                      credentials: credentials,
                      library: library
                    ),
            ));
          },
          tooltip: AppLocalizations.of(context).readBook,
          child: Icon(Icons.chrome_reader_mode_rounded),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              actions: [
                IconButton(
                  icon: Icon(Icons.edit),
                  tooltip: AppLocalizations.of(context).updateBook,
                  onPressed: null, // () async {},
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  tooltip: AppLocalizations.of(context).deleteBook,
                  onPressed: () async {
                    await BottomModal.push(
                      child: BottomModal(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context).confirmDeletion,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                AppLocalizations.of(context).confirmBookDeletionDescription,
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () async => Navigator.of(context).pop(),
                                    child: Text(AppLocalizations.of(context).cancelButton),
                                  ),
                                  SizedBox(width: 8.0),
                                  TextButton.icon(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      await AlexandrioAPI().deleteBook(
                                        credentials,
                                        library: library,
                                        book: book,
                                      );
                                      refresh();
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                      foregroundColor: MaterialStateProperty.all(Colors.red),
                                    ),
                                    icon: Icon(Icons.delete),
                                    label: Text(AppLocalizations.of(context).deleteButton),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      context: context,
                    );
                  },
                ),
              ],
              expandedHeight: 400.0,
              // floating: false,
              // pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
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
                      color: Theme.of(context).appBarTheme.backgroundColor.withAlpha(196),
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(48.0 * 0.75),
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
                                      book.name,
                                      style: Theme.of(context).textTheme.headline5,
                                    ),
                                    if (book.author != null)
                                      Text(
                                        book.author,
                                        style: Theme.of(context).textTheme.headline6,
                                      ),
                                    // SizedBox(height: 8.0),
                                    // OutlinedButton.icon(
                                    //   // style: ButtonStyle(
                                    //   //   padding: MaterialStateProperty.all(EdgeInsets.all(24.0)),
                                    //   // ),
                                    //   onPressed: () async {},
                                    //   icon: Icon(Icons.read_more),
                                    //   label: Text('Start reading'),
                                    // ),
                                  ],
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
            ),
          ],
          body: ListView(
            padding: EdgeInsets.all(20.0), // + MediaQuery.of(context).viewPadding,
            children: [
              if (book.description != null) ...[
                Text(
                  AppLocalizations.of(context).descriptionField,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 8.0),
                Text(book.description),
              ],
            ],
          ),
        ),
      );
}
