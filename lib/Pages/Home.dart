import 'dart:developer';
import 'dart:math';

import 'package:demo/Components/UI/AppBarBlur.dart';
import 'package:flutter/material.dart';

import '../Components/Logo.dart';
import '../Components/UI/AppBarPadding.dart';
import '../App.dart';
import '../ThemeBuilder.dart';
import '../Components/Book.dart';
import '../backend/User.dart';

import 'Profile.dart';
import 'Login.dart';

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
              onTap: ()
                async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Profile(
                      user: user,
                    ),
                  )
                ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Deconnexion"),
              onTap: () async {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(
                      showError: false,
                    ),
                  )
                );
              }
            )
          ],
        ),
      );
  }
}

class HomeState extends State<Home> {
  bool drawerOpen = true;

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
        onPressed: () async {},
      ),
      body: Row(
        children: [
          if (tabletMode && drawerOpen)
            AppDrawer(
              tabletMode: tabletMode,
              user: widget.user,
            ),
          Expanded(
            child: GridView.extent(
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
