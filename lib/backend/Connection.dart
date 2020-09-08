import "dart:async";
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class User {
  String username;
  String password;
  String authToken;
  String refreshToken;

  User(String username, String password, String authToken, String refreshToken) {
    this.username = username;
    this.password = password;
    this.authToken = authToken;
    this.refreshToken = refreshToken;
  }
}

Future<void> auth() async {
  const url = "http://prod.alexandrio.cloud:3000/auth";
  final request = await http.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'}
  );

  final response = json.decode(request.body);

  print(response);
}

Future<void> login(String username, String password) async {
  const url = "http://prod.alexandrio.cloud:3000/login";
  Map data = {
    'login': username,
    'password': password
  };
  
  var body = json.encode(data);

  final request = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body
  );

  print(json.decode(request.body));
}

Future<void> register(String username, String email, String password, String confirmPassword) async {
  const url = "http://prod.alexandrio.cloud:3000/register";
  Map data = {
    'username': username,
    'email': email,
    'password': password,
    'confirm_password': confirmPassword,
  };

  var body = json.encode(data);

  final request = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body
  );

  print(json.decode(request.body));
}

Future<void> refreshToken(User user) async {
  const url = "http://prod.alexandrio.cloud:3000/auth/refresh";
  final request = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer $user.authToken'
    }
  );

  print(json.decode(request.body));
}
