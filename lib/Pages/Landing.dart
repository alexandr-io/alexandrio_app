import 'package:demo/Pages/Login.dart';
import 'package:flutter/material.dart';

import '../ThemeBuilder.dart';
import 'Home.dart';

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: Icon(
              Icons.book,
              size: 128 * 1.25,
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 48.0,
            horizontal: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  "Your books, anywhere",
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  "Read your books on the go while offline and synchronize your progress while online!",
                  textAlign: TextAlign.center,
                  // style: Theme.of(context).textTheme.headline6,
                ),
              ),
              RaisedButton(
                child: Text("Get started"),
                onPressed: () async => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(
                      showError: false
                    ),
                  ),
                ),
                elevation: 0.0,
              ),
            ],
          ),
        ),
      );
}
