import 'dart:math';
import 'package:http/http.dart' as http;

import 'package:EIP_Alexandrio_Flutter/Components/UI/AppBarBlur.dart';
import 'package:EIP_Alexandrio_Flutter/Components/UI/WidgetBlur.dart';
import 'package:flutter/material.dart';

class Book {
  final String title;
  final String image;

  Book({
    @required this.title,
    @required this.image,
  });
}

List<Book> test = [
  Book(
    image: "https://i.imgur.com/NuXeMyR.png",
    title: "Gratitude Journal",
  ),
  Book(
    image: "https://www.booktopia.com.au/blog/wp-content/uploads/2018/12/the-arsonist.jpg",
    title: "Semen♂Arsonist",
  ),
  Book(
    image: "https://www.designforwriters.com/wp-content/uploads/2017/10/design-for-writers-book-cover-tf-2-a-million-to-one.jpg",
    title: "A Million to One",
  ),
  Book(
    image: "https://cdn.pastemagazine.com/www/system/images/photo_albums/best-book-covers-fall-2019/large/bbcdune.jpg?1384968217",
    title: "DUNE",
  ),
  Book(
    image: "https://static.wixstatic.com/media/9c4410_876c178659774d75aa6d9ec9fadfa4a2~mv2_d_1650_2550_s_2.jpg/v1/fill/w_270,h_412,al_c,q_80,usm_0.66_1.00_0.01/WILD%20LIGHT%20EBOOK.webp",
    title: "Wild Light",
  ),
  // Book(
  //   image: "https://preview.redd.it/4lg1th3359121.jpg?width=544&auto=webp&s=b930c87f1f34da1629a31d206969bc3fb9c1fb36",
  //   title: "Billy Herringt♂n",
  // ),
];

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({
    Key key,
    @required this.book,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6.0),
          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  color: Colors.red,
                  child: Image.network(
                    book.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    WidgetBlur(
                      widget: Container(
                        color: Colors.transparent.withAlpha(100),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(book.title),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  // Card(
  //       child: Stack(
  //         children: [
  //           Image.network(
  //             "https://www.booktopia.com.au/blog/wp-content/uploads/2018/12/the-arsonist.jpg",
  //           ),
  //         ],
  //       ),
  //     );
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: Icon(Icons.file_upload),
        ),
        appBar: AppBarBlur(
          theme: ThemeData.dark(),
          appBar: AppBar(
            title: Text("Home"),
            backgroundColor: Colors.transparent.withAlpha(100),
          ),
        ),
        body: GridView.extent(
          maxCrossAxisExtent: 175,
          childAspectRatio: 9.0 / 16.0,
          children: List.generate(
            100,
            (index) => Padding(
              padding: const EdgeInsets.all(0.0),
              child: BookCard(
                book: test[Random().nextInt(test.length)],
              ),
            ),
          ),
        ),
        bottomNavigationBar: WidgetBlur(
          widget: Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FutureBuilder(
                future: http.get('http://back.alexandrio.cloud:9180/'),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasError) {
                    return Text("An error has occured!");
                  } else if (snapshot.hasData) {
                    return Text(snapshot.data.body);
                  }
                  return Text("Loading from API...");
                },
              ),
            ),
          ),
        ),
      );
}
