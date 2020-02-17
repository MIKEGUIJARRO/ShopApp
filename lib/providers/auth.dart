import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  /*
  Url documentacion firebase:
    https://firebase.google.com/docs/reference/rest/auth
  Endpoints:
    signup:
      https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
    signin:
      https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
  */

  bool get isAuth {
    //If we have a token and the token did not expire, then user is Auth
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCBZ2PhtwPUCpnHcpxNsi7NqZZ6LyoGqjA";

    try {
      final response = await http.post(url,
          body: json.encode({
            "email": email,
            "password": password,
            "returnSecureToken": true,
          }));
      final responseData = json.decode(response.body);
      print(responseData);
      if (responseData["error"] != null) {
        print("responseData[error]");
        /* print("Before throw: ${responseData["error"]["message"]}"); */
        throw HttpException(responseData["error"]["message"]);
      }

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
          seconds: int.parse(
        responseData["expiresIn"],
      )));
      notifyListeners();

    } catch (error) {
      print("error comun: $error");
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    return _authenticate(email, password, "signUp");
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password, "signInWithPassword");
  }
}
