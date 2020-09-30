import "dart:async";
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class User {
  final String username;
  final String authToken;
  final String refreshToken;

  User({this.username, this.authToken, this.refreshToken});
}

class ApiResponse {
  final int status;
  final Map body;

  ApiResponse._(this.status, this.body);

  factory ApiResponse(int status, Map body) {
    return new ApiResponse._(status, body);
  }
}

Future<void> auth() async {
  const url = "http://prod.alexandrio.cloud:3000/auth";
  final request = await http.get(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'}
  );

  if (request.statusCode == 200) {
    final response = json.decode(request.body);
    print(response);
  } else {
    print(json.decode(request.body));
  }
}

Future<ApiResponse> login(String username, String password) async {
  const url = "http://prod.alexandrio.cloud:3000/login";
  
  var body = json.encode({
    'login': username,
    'password': password,
  });

  final request = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body
  );

  if (request.statusCode == 200) {
    print(json.decode(request.body));
    return ApiResponse(request.statusCode, json.decode(request.body));
  }
  return ApiResponse(request.statusCode, json.decode(request.body));
}

Future<void> register(String username, String email, String password, String confirmPassword) async {
  const url = "http://prod.alexandrio.cloud:3000/register";

  var body = json.encode({
    'username': username,
    'email': email,
    'password': password,
    'confirm_password': confirmPassword,
  });

  final request = await http.post(
    url,
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: body
  );

  if (request.statusCode == 200) {
    print(json.decode(request.body));
    return request;
  } else {
    print(json.decode(request.body));
  }
}

Future<void> refreshToken(User user) async {
  const url = "http://prod.alexandrio.cloud:3000/auth/refresh";
  final request = await http.post(
    url,
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: 'Bearer ${user.authToken}'
    }
  );

  if (request.statusCode == 200) {
    print(json.decode(request.body));
    return request;
  } else {
    print(json.decode(request.body));
  }

}
