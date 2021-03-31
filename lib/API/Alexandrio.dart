import 'dart:convert';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:http/http.dart' as http;

class AlexandrioAPI {
  String ms(String ms) {
    return 'https://$ms.preprod.alexandrio.cloud';
  }

  Future<Credentials> loginUser({String login, String password}) async {
    var response = await http.post(
      Uri.parse('${ms('auth')}/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'login': login,
        'password': password,
      }),
    );
    if (response.statusCode != 200) throw 'Invalid Credentials';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    return Credentials(
      login: json['username'],
      email: json['email'],
      token: json['auth_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Future<Credentials> registerUser({String invitationToken, String login, String email, String password}) async {
    var response = await http.post(
      Uri.parse('${ms('auth')}/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'invitation_token': invitationToken,
        'username': login,
        'password': password,
        'confirm_password': password,
        'email': email,
      }),
    );
    if (response.statusCode != 201) throw 'Invalid Credentials/Invitation Token';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    return Credentials(
      login: json['username'],
      email: json['email'],
      token: json['auth_token'],
      refreshToken: json['refresh_token'],
    );
  }

  Future<List<Library>> getLibraries(Credentials credentials) async {
    var response = await http.get(
      Uri.parse('${ms('library')}/library/list'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 200) throw 'Couldn\'t load library';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json == null) return [];
    return List<Library>.from(
      json.map(
        (jsonEntry) => Library(
          id: jsonEntry['id'],
          name: jsonEntry['name'],
        ),
      ),
    );
  }

  Future<void> createLibrary(Credentials credentials, {String name, String description}) async {
    var response = await http.post(
      Uri.parse('${ms('library')}/library'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
      }),
    );
    if (response.statusCode != 201) throw 'Couldn\'t create library';
    // var json = jsonDecode(utf8.decode(response.bodyBytes));
    // if (json == null || json['libraries'] == null) return [];
    // return List<Library>.from(
    //   json['libraries'].map(
    //     (jsonEntry) => Library(
    //       id: jsonEntry['id'],
    //       name: jsonEntry['name'],
    //     ),
    //   ),
    // );
  }

  Future<List<Book>> getBooksForLibrary(Credentials credentials, {Library library}) async {
    var response = await http.get(
      Uri.parse('${ms('library')}/library/${library.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 200) throw 'Couldn\'t get books';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json == null || json['books'] == null) return [];
    return List<Book>.from(
      json['books'].map(
        (jsonEntry) => Book(
          name: jsonEntry['name'],
        ),
      ),
    );
  }
}
