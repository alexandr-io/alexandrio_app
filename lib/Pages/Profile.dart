// import 'package:demo/Components/Logo.dart';
import 'package:flutter/material.dart';

import '../backend/Connection.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ListView(
        children: [
          Icon(
            Icons.account_box,
            color: Colors.blue,
            size: 36.0,
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text("Nom"),
            onTap: () async {
              print('Name');
            }
          ),
          ListTile(
            leading: Icon(Icons.arrow_right),
            title: Text("Email"),
            onTap: () async {
              print('Email');
            }
          ),
          RaisedButton(
            onPressed: () async {
             auth();
            },
            child: Text('Test connection')
          ),
          RaisedButton(
            onPressed: () async {
             login('test', 'coucou');
            },
            child: Text('Test login')
          ),
          RaisedButton(
            onPressed: () async {
             register('test', 'email@gmail.com', 'coucou', 'coucou');
            },
            child: Text('Test register')
          ),
        ],
      ),
    )
  );
}