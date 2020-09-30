import "dart:async";
import "dart:convert";
import "package:http/http.dart" as http;

import "User.dart";

class APIConnector {
  var headers = {};
  var endpoint = "http://prod.alexandrio.cloud:3000";

  User user;

  Future<void> auth() async {
    final response = await http.get(
      endpoint + '/auth',
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      print(json.decode(response.body));
    } else {
      print(json.decode(response.body));
    }
  }

  Future<User> login( String username,  String password) async {
    final response = await http.post(
      endpoint + '/login',
      body: jsonEncode(
        {
          'login': username,
          'password': password,
        },
      ),
      headers: {
        "Content-Type": "application/json",
      }
    );


    print(json.decode(response.body));
    return User(
      username: 'username',
      authToken: 'authToken',
      refreshToken: 'refreshToken', 
    );
  }

  Future<User> register( String username,  String email,  String password,  String confirmPassword) async {
    final response = await http.post(
      endpoint + '/register',
      body: jsonEncode(
        {
          'username': username,
          'email': email,
          'password': password,
          'confirm_password': confirmPassword,
        },
      ),
      headers: {
        "Content-Type": "application/json",
      }
    );

    print(json.decode(response.body));
    return User(
      username: 'username',
      authToken: 'authToken',
      refreshToken: 'refreshToken', 
    );
  }

  Future<void> refreshToken( User user) async {
    final response = await http.post(
      endpoint + '/auth/refresh',
      headers: {
        "Contentr-Type": "application/json",
        "Authorization": "Bearer" + user.authToken,
      },
    );

    print(json.decode(response.body));
  }
}