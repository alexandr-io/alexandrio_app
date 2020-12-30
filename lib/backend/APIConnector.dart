import "dart:async";
import "dart:convert";
// import 'package:demo/backend/Connection.dart';
import "package:http/http.dart" as http;

import "User.dart";
import "Error.dart";

class APIConnector {
  var headers = {};
  var endpoint = "http://auth.preprod.alexandrio.cloud";

  User user;

  // AUTH RELATED CALLS

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

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
    );
  }

  Future<void> logout(String authToken) async {
    final response = await http.post(
      endpoint + '/logout',
      headers: {
        "Authorization": "Bearer" + authToken,
      },
    );

    if (response.statusCode != 204) {
      throw Exception(response.body);
    }
  } // POST

  Future<bool> checkReset(User user, String token) async {
    final response = await http.get(
      endpoint + '/password/reset',
      headers: {
        "Content-Type": "application/json",
      },
    );

    // send token in body 

    var decodedResponse = json.decode(response.body);

    if (user.username == decodedResponse['username'] && user.email == decodedResponse['email'])
      return true;
    return false;
  } // GET

  Future<void> askReset(String email) async {
    final response = await http.post(
      endpoint + '/password/reset',
      body: jsonEncode(
        {
          'email': email,
        },
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 204)
      throw Exception(response.body);
  } // POST

  Future<User> reset(String newPassword, String token) async {
    final response = await http.put(
      endpoint + '/password/reset',
      body: jsonEncode(
        {
          'new_password': newPassword,
          'token': token,
        },
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200)
      throw Exception(response.body);

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
    );
  } // PUT

  Future<User> refresh(String refreshToken) async {
    final response = await http.put(
      endpoint + '/password/reset',
      body: jsonEncode(
        {
          'refresh_token': refreshToken,
        },
      ),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 201)
      throw Exception(response.body);

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
    );
  } // POST

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

    if (response.statusCode != 201) {
      print(response.body);
      throw Exception(ErrorMessage(code: response.statusCode, message: response.body));
    }

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
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

    if (response.statusCode != 201)
      throw Exception(response.body);

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
    );
  }

  // USER RELATED CALLS

  Future<void> deleteUser(String authToken) async {
    final response = await http.delete(
      endpoint + '/user',
      headers: {
        "Authorization": "Bearer" + authToken,
      }
    );

    if (response.statusCode != 201)
      throw Exception(response.body);    
  }

  Future<User> getUser(String authToken) async {
    final response = await http.get(
      endpoint + '/user',
      headers: {
        "Authorization": "Bearer" + authToken,
      }
    );

    if (response.statusCode != 200)
      throw Exception(response.body);

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: decodedResponse['auth_token'],
      refreshToken: decodedResponse['refresh_token'], 
    );
  }

  Future<bool> updateUser(String email, String username, String authToken) async {
    final response = await http.put(
      endpoint + '/user',
      body: jsonEncode(
        {
          'username': username,
          'email': email,
        },
      ),
      headers: {
        "Authorization": "Bearer" + authToken,
      },
    );

    if (response.statusCode != 200)
      throw Exception(response.body);

    return true;
  }

  // LIBRARY RELATED CALLS

  Future<void> deleteBook(String bookId, String libraryId) async {

  } // DELETE

  Future<void> retrieveBook(String bookId, String libraryId) async {

  } // GET
  // to do: Add BOOK type

  Future<void> createBook(String author, String description, String libraryId, String publisher, List<String> tags, String title) async {

  } // POST
  // to do: Add BOOK type

  Future<void> retrieveLibraries(String authToken) async {

  } // GET
  // to do: Add LIBRARY type

  Future<void> deleteLibrary(String name) async {

  } // DELETE

  Future<void> retrieveLibrary(String name) async {

  } // GET
  // to do: Add LIBRARY type

  Future<void> createLibrary(String description, String name) async {

  } // POST
  // to do: Add LIBRARY type

  // MEDIA RELATED CALLS

  Future<void> download(String bookId) async {

  }

  Future<void> upload(String book, String bookId, String libraryId) async {

  }

}