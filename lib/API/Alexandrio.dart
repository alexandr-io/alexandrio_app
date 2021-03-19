import 'dart:convert';

import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:http/http.dart' as http;

class AlexandrioAPI {
  String ms(String ms) {
    return 'http://$ms.preprod.alexandrio.cloud';
  }

  Future<Credentials> loginUser({String login, String password}) async {
    var response = await http.post(
      '${ms('auth')}/login',
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
      '${ms('auth')}/register',
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
    if (response.statusCode != 200) throw 'Invalid Credentials/Invitation Token';
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
      '${ms('library')}/libraries',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 200) throw 'Couldn\'t load library';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json['libraries'] == null) return [];
    return List<Library>.from(
      json['libraries'].map(
        (jsonEntry) => Library(
          id: jsonEntry['id'],
          name: jsonEntry['name'],
        ),
      ),
    );
  }
}
