import 'dart:convert';
import 'dart:developer';
import 'dart:math';

import 'package:demo/Components/UI/AppBarBlur.dart';
import 'package:demo/Pages/Test.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Components/Logo.dart';
import '../Components/UI/AppBarPadding.dart';
import '../App.dart';
import '../ThemeBuilder.dart';
import '../Components/Book.dart';
import '../backend/User.dart';

import 'Profile.dart';
import 'Login.dart';

import 'package:http/http.dart' as http;
import 'package:http/src/multipart_file.dart' as http;
import 'package:http/src/multipart_request.dart' as http;

AppBarPadding searchAppBar(bool tabletMode) => AppBarPadding(
      padding: EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 16.0,
      ),
      appBarFactor: 0.9,
      appBar: AppBar(
        elevation: tabletMode ? 1.0 : 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        titleSpacing: 0.0,
        leading: tabletMode ? Icon(Icons.search) : null,
        title: TextField(
          decoration: InputDecoration(
            border: InputBorder.none,
            filled: false,
            hintText: "Search books",
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () async {},
          )
        ],
      ),
    );

class DesktopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final PreferredSizeWidget appBar;
  final Function onMenuTap;

  const DesktopAppBar({
    Key key,
    @required this.appBar,
    @required this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData currentTheme = Theme.of(context);

    return Container(
      color: currentTheme.appBarTheme.color,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 304.0,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: onMenuTap,
                            ),
                          ),
                          Logo(),
                        ],
                      ),
                    ),
                    Expanded(
                      child: appBar,
                    ),
                  ],
                ),
              ),
            ),
            Divider(
              height: 0.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => appBar == null ? 0.0 : Size(appBar.preferredSize.width, appBar.preferredSize.height * 0.9 + 5.6);
}

class AppDrawer extends StatelessWidget {
  final bool tabletMode;
  final User user;

  const AppDrawer({
    Key key,
    @required this.tabletMode,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var api = context.findAncestorStateOfType<AppState>().api;

    return Drawer(
      elevation: tabletMode ? 0.0 : 16.0,
      child: ListView(
        children: [
          if (!tabletMode)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Logo(),
                  Text("developer preview r1"),
                ],
              ),
            ),
          if (!tabletMode)
            Divider(
              height: 0.0,
            ),
          SwitchListTile(
            value: ThemeBuilder.of(context).themeMode == ThemeMode.light,
            onChanged: (bool newValue) {
              var opposite = (ThemeBuilder.of(context).themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
              App.setState(context, () {
                ThemeBuilder.of(context).themeMode = opposite;
              });
            },
            title: Text("Test"),
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text("Votre profil"),
            onTap: () async => Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                user: user,
              ),
            )),
          ),
          // ListTile(
          //   leading: Icon(Icons.book),
          //   title: Text("Book test"),
          //   onTap: () async => Navigator.of(context).push(
          //     MaterialPageRoute(
          //       builder: (BuildContext context) => TestPage(),
          //     ),
          //   ),
          // ),
          ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Deconnexion"),
              onTap: () async {
                await api.logout(user.authToken).then((response) => {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Login(),
                  ))
                });
              })
        ],
      ),
    );
  }
}

class HomeState extends State<Home> {
  bool drawerOpen = true;

  Future<String> test() async {
    var test2 = http.put(
      'http://library.preprod.alexandrio.cloud/library', // John: test
      headers: {
        'Authorization': 'Bearer ${widget.user.authToken}',
      },
    );
    // var headers = {'Authorization': 'Bearer ${widget.user.authToken}', 'Content-Type': 'application/json'};
    // var request = http.Request('GET', 'http://library.preprod.alexandrio.cloud/library');
    // request.body = '''{"name": "Bookshelf"}''';
    // request.headers.addAll(headers);

    // http.StreamedResponse response = await request.send();

    // if (response.statusCode == 200) {
    //   return await response.stream.bytesToString();
    // } else {
    //   print(response.reasonPhrase);
    // }
  }

  @override
  Widget build(BuildContext context) {
    bool tabletMode = MediaQuery.of(context).size.width > 700;

    return Scaffold(
      extendBodyBehindAppBar: true, //!tabletMode,
      drawer: tabletMode
          ? null
          : AppDrawer(
              tabletMode: tabletMode,
              user: widget.user,
            ),
      appBar: tabletMode
          ? AppBarBlur(
              appBar: DesktopAppBar(
                appBar: searchAppBar(tabletMode),
                onMenuTap: () async {
                  setState(() {
                    drawerOpen = !drawerOpen;
                  });
                },
              ),
            )
          : searchAppBar(tabletMode),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.file_upload),
        label: Text("Upload"),
        onPressed: () async {
          // var req = await http.post(
          //   'http://auth.preprod.alexandrio.cloud/book/upload',
          //   body: {
          //     book:
          //   },
          // );

          var req = await http.post(
            'http://library.preprod.alexandrio.cloud/book',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${widget.user.authToken}',
            },
            body: jsonEncode({
              // 'author': null,
              // 'description': null,
              'library_id': '5fe1f538131c113239b9c46d',
              // 'publisher': null,
              // 'tags': null,
              'title': 'THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf',
            }),
          );

          print(jsonDecode(req.body));

          var request = http.MultipartRequest(
            'POST',
            Uri.parse('http://media.preprod.alexandrio.cloud/book/upload'),
          );
          request.files.add(
            await http.MultipartFile.fromPath(
              'book',
              'assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf',
            ),
          );
          request.fields['book'] = (await rootBundle.load('assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf')).buffer.asUint8List().toString();
          request.fields['book_id'] = jsonDecode(req.body)['id'];
          request.fields['library_id'] = '5fe1f538131c113239b9c46d';
          request.headers['Authorization'] = 'Bearer ${widget.user.authToken}';
          var res = await request.send();
          var wow = res.toString();
          print(res);
        },
      ),
      body: Row(
        children: [
          if (tabletMode && drawerOpen)
            AppDrawer(
              tabletMode: tabletMode,
              user: widget.user,
            ),
          Expanded(
            child: FutureBuilder<http.Response>(
              future: http.get(
                'http://library.preprod.alexandrio.cloud/libraries', // John: test
                headers: {
                  'Authorization': 'Bearer ${widget.user.authToken}',
                },
              ),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.hasData) {
                  var jsonResponse = jsonDecode(snapshot.data.body);
                  return ListView(
                    children: [
                      for (var library in jsonResponse['libraries'])
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(library['name']),
                            Text(library['id']),
                            FutureBuilder<http.Response>(
                              future: http.put(
                                'http://library.preprod.alexandrio.cloud/library', // John: test
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Authorization': 'Bearer ${widget.user.authToken}',
                                },
                                body: jsonEncode({
                                  'Name': library['name'],
                                }),
                              ),
                              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                                var jsonResponse = jsonDecode(snapshot.data.body);
                                if (snapshot.hasData) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (var book in jsonResponse['books'])
                                        InkWell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${book['title']} : ${book['id']}'),
                                          ),
                                          onTap: () async {
                                            var response = await http.put(
                                              'http://media.preprod.alexandrio.cloud/book/download', // John: test
                                              headers: {
                                                'Content-Type': 'application/json',
                                                'Authorization': 'Bearer ${widget.user.authToken}',
                                              },
                                              body: jsonEncode({
                                                'book_id': book['id'].toString(),
                                              }),
                                            );

                                            print('${response.body}');

                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (BuildContext context) => TestPage(
                                                  content: response.bodyBytes,
                                                ),
                                              ),
                                            );
                                            // print('${response.body}');
                                          },
                                        ),
                                    ],
                                  );
                                }
                                return Text('Loading..');
                              },
                            ),
                          ],
                        ),
                    ],
                  );
                }
                return Text('Loading...');
              },
            ),
            // child: GridView.extent(
            //   maxCrossAxisExtent: 175,
            //   childAspectRatio: 9.0 / 16.0,
            //   children: List.generate(
            //     100,
            //     (index) => Padding(
            //       padding: const EdgeInsets.all(0.0),
            //       child: BookCard(
            //         book: test[Random().nextInt(test.length)],
            //       ),
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    );
  }
}

class Home extends StatefulWidget {
  final User user;

  const Home({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  HomeState createState() => HomeState();
}
