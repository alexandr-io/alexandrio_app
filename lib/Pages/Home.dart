import 'package:flutter/material.dart';
import 'package:mobile/Theme/ThemeManager.dart';

import '../App.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: TabBar(
            tabs: [
              Ink(
                height: 46.0,
                child: Center(
                  child: Text('Tab Name'),
                ),
              ),
              Ink(
                height: 46.0,
                child: Center(
                  child: Text('Tab Name'),
                ),
              ),
              Ink(
                height: 46.0,
                child: Center(
                  child: Text('Tab Name'),
                ),
              ),
            ],
          ),
          appBar: AppBar(
            title: Text('Hello'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            // padding: EdgeInsets.all(8.0),
            children: [
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Ink(
                        width: 256,
                        height: 256,
                        child: Material(
                          child: GridView.extent(
                            maxCrossAxisExtent: 64.0,
                            children: [
                              for (var color in Colors.primaries)
                                InkWell(
                                  onTap: () async {
                                    ThemeManager.of(context).lightColors.accent = color[300];
                                    ThemeManager.of(context).darkColors.accent = color[200];
                                    App.rebuild(context);
                                  },
                                  child: Ink(
                                    color: color,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Text('Color'),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(32.0),
                          child: Container(
                            width: 32.0,
                            height: 32.0,
                            color: Theme.of(context).accentColor,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Color',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Change the primary color of the application',
                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  color: Theme.of(context).iconTheme.color,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Material(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 300,
                              child: InkWell(
                                onTap: () async => ThemeManager.of(context).mode = ThemeMode.system,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('System Theme'),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              child: InkWell(
                                onTap: () async => ThemeManager.of(context).mode = ThemeMode.light,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Light Theme'),
                                ),
                              ),
                            ),
                            Container(
                              width: 300,
                              child: InkWell(
                                onTap: () async => ThemeManager.of(context).mode = ThemeMode.dark,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text('Dark Theme'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Text('Color'),
                      Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          child: Center(
                            child: Icon(Icons.color_lens),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Theme',
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Text(
                            'Select the primary style of the theme',
                            style: Theme.of(context).textTheme.subtitle2.copyWith(
                                  color: Theme.of(context).iconTheme.color,
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox.fromSize(size: Size.fromHeight(256.0)),
              OutlineButton(
                child: Text('System Theme'),
                onPressed: () => ThemeManager.of(context).mode = ThemeMode.system,
              ),
              OutlineButton(
                child: Text('Dark Theme'),
                onPressed: () => ThemeManager.of(context).mode = ThemeMode.dark,
              ),
              OutlineButton(
                child: Text('Light Theme'),
                onPressed: () => ThemeManager.of(context).mode = ThemeMode.light,
              ),
              FlatButton(
                child: Text('Test'),
                onPressed: () => ThemeManager.of(context).mode = ThemeMode.light,
              ),
              ListTile(
                title: Text('================================='),
                onTap: () {
                  print(ThemeManager.of(context).mode);
                },
              ),
              SwitchListTile(
                value: true,
                onChanged: (value) {},
              ),
              Slider(
                onChanged: (double value) {},
                value: 50.0,
                min: 0.0,
                max: 100.0,
              ),
              TextField(
                decoration: InputDecoration(filled: true, hintText: 'Test', labelText: 'Test text'),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: Text('hai!'),
                ),
              ),
            ],
          ),
        ),
      );
}
