import "dart:async";
import "dart:convert";
// import 'package:demo/backend/Connection.dart';
import "package:http/http.dart" as http;

import "User.dart";
import "Error.dart";

class APIConnector {
  var headers = {};
  List<String> endpoints = [
    "http://auth.preprod.alexandrio.cloud",
    "http://user.preprod.alexandrio.cloud",
    "http://library.preprod.alexandrio.cloud",
    "http://media.preprod.alexandrio.cloud",
    "http://auth.alexandrio.cloud",
    "http://user.alexandrio.cloud",
    "http://library.alexandrio.cloud",
    "http://media.alexandrio.cloud",
  ];

  User user;

  // AUTH RELATED CALLS

  Future<void> auth() async {
    final response = await http.get(
      endpoints[0] + '/auth',
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
      endpoints[0] + '/login',
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
      endpoints[0] + '/logout',
      headers: {
        "Authorization": "Bearer " + authToken,
      },
    );

    if (response.statusCode != 204) {
      throw Exception(response.body);
    }
  } // POST

  Future<bool> checkReset(User user, String token) async {
    final response = await http.get(
      endpoints[0] + '/password/reset',
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
      endpoints[0] + '/password/reset',
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
      endpoints[0] + '/password/reset',
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
      endpoints[0] + '/password/reset',
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

  Future<User> register( String username,  String email,  String password,  String confirmPassword, String invitation) async {
    final response = await http.post(
      endpoints[0] + '/register',
      body: jsonEncode(
        {
          'username': username,
          'email': email,
          'invitation_token': invitation,
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
      endpoints[0] + '/auth/refresh',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + user.authToken,
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
      endpoints[1] + '/user',
      headers: {
        "Authorization": "Bearer " + authToken,
      }
    );

    if (response.statusCode != 204)
      throw Exception(response.body);    
  }

  Future<User> getUser(User user) async {
    final response = await http.get(
      endpoints[1] + '/user',
      headers: {
        "Authorization": "Bearer " + user.authToken,
      }
    );

    if (response.statusCode != 200)
      throw Exception(response.body);

    var decodedResponse = json.decode(response.body);

    return User(
      username: decodedResponse['username'],
      email: decodedResponse['email'],
      authToken: user.authToken,
      refreshToken: user.refreshToken, 
    );
  }

  Future<bool> updateUser(String email, String username, String authToken) async {
    final response = await http.put(
      endpoints[1] + '/user',
      body: jsonEncode(
        {
          'username': username,
          'email': email,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + authToken,
      },
    );

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception(response.body);
    }

    print("Update success");
    return true;
  }

  // LIBRARY RELATED CALLS

  // Future<void> deleteBook(String authToken, String bookId, String libraryId) async {
  //   final response = await http.delete(
  //     endpoints[2] + '/book',
  //     // body: jsonEncode(
  //     //   {
  //     //     'book_id': bookId,
  //     //     'library_id': libraryId,
  //     //   },
  //     // ),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer" + authToken,
  //     }
  //   );

  //   if (response.statusCode != 200)
  //     throw Exception(response.body);

  // } // DELETE

  // Future<void> retrieveBook(String authToken, String bookId, String libraryId) async {
  //   final response = await http.get(
  //     endpoints[2] + '/book',
  //     body: jsonEncode(
  //       {
  //         'book_id': bookId,
  //         'library_id': libraryId,
  //       },
  //     ),
  //     headers: {
  //       "Content-Type": "application/json",
  //       "Authorization": "Bearer" + authToken,
  //     }
  //   );
  // } // GET
  // to do: Add BOOK type

  Future<void> createBook(String authToken, String author, String description, String libraryId, String publisher, List<String> tags, String title) async {
    final response = await http.post(
      endpoints[2] + '/book',
      body: jsonEncode(
        {
          'author': author,
          'description': description,
          'library_id': libraryId,
          'publisher': publisher,
          'tags': tags,
          'title': title,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer" + authToken,
      }
    );

    if (response.statusCode != 200)
      throw Exception(response.body);
  } // POST
  // to do: Add BOOK type

  Future<void> retrieveLibraries(String authToken) async {
    final response = await http.get(
      endpoints[2] + '/libraries',
      headers: {
        "Authorization": "Bearer" + authToken,
      }
    );

    if (response.statusCode != 200)
      throw Exception(response.body);
  } // GET
  // to do: Add LIBRARY type

  // Future<void> deleteLibrary(String name) async {

  // } // DELETE

  // Future<void> retrieveLibrary(String name) async {

  // } // GET
  // // to do: Add LIBRARY type

  Future<void> createLibrary(String authToken, String description, String name) async {
    final response = await http.post(
      endpoints[2] + '/libraries',
      body: jsonEncode(
        {
          'name': name,
          'description': description,
        },
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer" + authToken,
      }
    );

    if (response.statusCode != 200)
      throw Exception(response.body);    
  } // POST
}