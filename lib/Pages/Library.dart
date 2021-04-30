import 'dart:typed_data';

import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:file_picker/file_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/BottomModal.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'Book.dart';

class LibraryPage extends StatefulWidget {
  final Credentials credentials;
  final Library library;
  final Function reload;

  const LibraryPage({
    Key key,
    @required this.credentials,
    @required this.library,
    @required this.reload,
  }) : super(key: key);

  @override
  _LibraryPageState createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  Future<List<Book>> books;

  @override
  void initState() {
    books = AlexandrioAPI().getBooksForLibrary(widget.credentials, library: widget.library);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.library.name),
          actions: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.delete),
                tooltip: AppLocalizations.of(context).deleteLibrary,
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
                              AppLocalizations.of(context).confirmLibraryDeletionDescription,
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
                                    await AlexandrioAPI().deleteLibrary(widget.credentials, libraryId: widget.library.id);
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    widget.reload();
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
            ),
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) => FloatingActionButton(
            onPressed: () async {
              var file = await FilePickerCross.importFromStorage(
                type: FileTypeCross.custom,
                fileExtension: 'epub, pdf',
              );
              if (file == null) return;

              await BottomModal.push(
                context: context,
                child: UploadModal(
                  bytes: file.toUint8List(),
                  update: () {
                    books = AlexandrioAPI().getBooksForLibrary(widget.credentials, library: widget.library);
                    setState(() {});
                  },
                  credentials: widget.credentials,
                  library: widget.library,
                ),
              );
            },
            tooltip: AppLocalizations.of(context).createBook,
            child: Icon(Icons.upload_file),
          ),
        ),
        body: FutureBuilder(
          future: books,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator.adaptive());
            }

            return Row(
              children: [
                Expanded(
                  // Container(
                  // width: 512.0,
                  child: Scrollbar(
                    child: RefreshIndicator(
                      onRefresh: () async {
                        books = AlexandrioAPI().getBooksForLibrary(widget.credentials, library: widget.library);
                        setState(() {});
                      },
                      child: ListView(
                        children: [
                          for (var book in snapshot.data)
                            InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (BuildContext context) => BookPage(
                                      book: book,
                                      credentials: widget.credentials,
                                      library: widget.library,
                                      refresh: () async {
                                        books = AlexandrioAPI().getBooksForLibrary(widget.credentials, library: widget.library);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
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
                                            book.name,
                                            style: Theme.of(context).textTheme.headline6,
                                          ),
                                          if (book.author != null)
                                            Text(
                                              book.author,
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
                ),
              ],
            );
          },
        ),
      );
}

class UploadModal extends StatefulWidget {
  final Credentials credentials;
  final Function update;
  final Library library;
  final Uint8List bytes;

  const UploadModal({
    Key key,
    @required this.update,
    @required this.credentials,
    @required this.library,
    @required this.bytes,
  }) : super(key: key);

  @override
  _UploadModalState createState() => _UploadModalState();
}

class _UploadModalState extends State<UploadModal> {
  TextEditingController titleController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomModal(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                filled: true,
                labelText: AppLocalizations.of(context).titleField,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: authorController,
              decoration: InputDecoration(
                filled: true,
                labelText: AppLocalizations.of(context).authorField,
              ),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                filled: true,
                labelText: AppLocalizations.of(context).descriptionField,
              ),
            ),
            SizedBox(height: 8.0),
            TextButton.icon(
              icon: Icon(Icons.add),
              label: Text(AppLocalizations.of(context).createBook),
              onPressed: () async {
                var book = await AlexandrioAPI().createBook(
                  widget.credentials,
                  library: widget.library,
                  title: titleController.text,
                  description: descriptionController.text.isEmpty ? null : descriptionController.text,
                  author: authorController.text.isEmpty ? null : authorController.text,
                );

                await AlexandrioAPI().uploadBook(
                  widget.credentials,
                  library: widget.library,
                  book: book,
                  bytes: widget.bytes,
                );

                widget.update();
                titleController.clear();
                descriptionController.clear();
                authorController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}

/*
if (false) ...[
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
*/
