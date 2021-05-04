import 'dart:convert';
import 'dart:typed_data';

import 'package:alexandrio_app/Data/Book.dart';
import 'package:alexandrio_app/Data/BookData.dart';
import 'package:alexandrio_app/Data/Credentials.dart';
import 'package:alexandrio_app/Data/Library.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http;

class AlexandrioAPI {
  String ms(String ms) {
    return 'https://$ms.preprod.alexandrio.cloud';
  }

  AlexandrioAPI() {
    print('Looking if we gotta refresh the token.');
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
      Uri.parse('${ms('library')}/libraries'),
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

  // TODO: Return library
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

  Future<void> deleteLibrary(Credentials credentials, {String libraryId}) async {
    var response = await http.delete(
      Uri.parse('${ms('library')}/library/$libraryId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 204) throw 'Couldn\'t destroy library';
  }

  Future<List<Book>> getBooksForLibrary(Credentials credentials, {Library library}) async {
    var response = await http.get(
      Uri.parse('${ms('library')}/library/${library.id}/books'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 200) throw 'Couldn\'t get books';
    var jsonr = jsonDecode(utf8.decode(response.bodyBytes));
    if (jsonr == null) return [];
    return List<Book>.from(
      jsonr.map(
        (jsonEntry) => Book(
          name: jsonEntry['title'] ?? jsonEntry['Title'],
          author: jsonEntry['author'] ?? jsonEntry['Author'],
          description: jsonEntry['description'] ?? jsonEntry['Description'],
          id: jsonEntry['id'],
        ),
      ),
    );
  }

  Future<Book> createBook(
    Credentials credentials, {
    Library library,
    String title,
    String author,
    String description,
  }) async {
    var response = await http.post(
      Uri.parse('${ms('library')}/library/${library.id}/book'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
      body: jsonEncode({
        'title': title,
        'author': author,
        'description': description,
      }),
    );
    if (response.statusCode != 201) throw 'Couldn\'t create book';
    var json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json == null) return null;
    return Book(
      name: json['title'] ?? json['Title'],
      author: json['author'] ?? json['Author'],
      description: json['description'] ?? json['Description'],
      id: json['id'],
    );
  }

  Future<void> deleteBook(
    Credentials credentials, {
    Library library,
    Book book,
  }) async {
    var response = await http.delete(
      Uri.parse('${ms('library')}/library/${library.id}/book/${book.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 204) throw 'Couldn\'t delete book';
  }

  Future<void> requestRecoveryEmail({String email}) async {
    var response = await http.post(
      Uri.parse('${ms('auth')}/password/reset'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
      }),
    );
    if (response.statusCode != 204) throw 'Couldn\'t request recovery email';
  }

  Future<void> accountRecovery({String email, String code, String password}) async {
    var response = await http.put(
      Uri.parse('${ms('auth')}/password/reset'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'new_password': password,
        'token': code,
      }),
    );
    if (response.statusCode != 200) throw 'Couldn\'t recover account';
  }

  Future<BookData> downloadBook(
    Credentials credentials, {
    Book book,
  }) async {
    var response = await http.get(
      Uri.parse('${ms('media')}/book/${book.id}/download'),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}',
      },
    );
    if (response.statusCode != 200) throw 'Couldn\'t download book';
    return BookData(
      bytes: response.bodyBytes,
      mime: response.headers['content-type'],
    );
  }

  Future<void> uploadBook(
    Credentials credentials, {
    Library library,
    Book book,
    Uint8List bytes,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ms('media')}/book/upload'),
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'book',
        // 'assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf',
        bytes,
        filename: 'file.epub',
        contentType: http.MediaType.parse('application/epub'),
      ),
    );
    // request.fields['book'] = bytes.toString(); // (await rootBundle.load('assets/THE_CARNIVALESQUE_GRIEFING_BEHAVIOUR_OF_BRAZILIAN_ONLINE_GAMERS.pdf')).buffer.asUint8List().toString();
    request.fields['book_id'] = book.id;
    request.fields['library_id'] = library.id;
    request.headers['Authorization'] = 'Bearer ${credentials.token}';
    var res = await request.send();
    var wow = res.toString();
    print(res);
  }

  Future<void> updateBookProgress(Credentials credentials, Library library, Book book,  String progress) async {
    var response = await http.post(
      Uri.parse('${ms('library')}/library/${library.id}/book/${book.id}/progress'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}'
      },
      body: jsonEncode({
        'progress': progress
      }),
    );

    if (response.statusCode != 200) throw 'Couldn\'t update progress';
    // print(response);
  }

  Future<String> getBookProgress(Credentials credentials, Library library, Book book) async {
    var response = await http.get(
      Uri.parse('${ms('library')}/library/${library.id}/book/${book.id}/progress'),
      headers: {
        // 'Content-Type': 'application/json',
        'Authorization': 'Bearer ${credentials.token}'
      },
    );

    if (response.statusCode != 200) return '0';

    print(response);
    var json = jsonDecode(utf8.decode(response.bodyBytes));

    return json['progress'] ?? '0';
  }
}
