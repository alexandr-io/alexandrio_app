import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import 'RegisterInfo.dart';

class Register extends StatelessWidget {
  @override
  Widget build(BuildContext context) { 
    var firstnameController = TextEditingController();
    var lastnameController = TextEditingController();

      return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 48.0, bottom: 8.0),
                  child: Logo(),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Create an Alexandrio Account",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 32.0,
                  ),
                  child: Text(
                    "Enter your name",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "First name",
                    ),
                    controller: firstnameController,
                  ),
                ),
                SizedBox.fromSize(size: Size.fromHeight(24.0)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Last name",
                    ),
                    controller: lastnameController,
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                RaisedButton(
                  child: Text("Next"),
                  onPressed: () async => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => RegisterInfo(
                        login: firstnameController.text + lastnameController.text,
                      ),
                    ),
                  ),
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      );
  }
}
