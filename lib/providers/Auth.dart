import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String userId;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAsVhvkaMxr85yuawkt8R6TQH4majnK1nM');

    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (e) {
      throw e;
    }
    // print(json.decode(response.body));
  }

  // Future<void> tryRoute() async {
  //   final url = Uri.parse('https://10.0.2.2:8000');
  //   final response = await http.get(url);
  //   if (response.statusCode != 200) {
  //     print('Your try route didnt work');
  //     return;
  //   }
  //   print(response.body);
  // }

  Future<void> signIn(String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAsVhvkaMxr85yuawkt8R6TQH4majnK1nM');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );
      autoLogout();
      notifyListeners();
      final userData = jsonEncode({
        'token': _token,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('dataKey', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<bool> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('datakey')) {
      return false;
    }
    final extractedData =
        jsonDecode(prefs.getString('dataKey')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(extractedData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedData['token'];
    _expiryDate = extractedData['expiryDate'];
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    userId = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}

//https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=API_KEY
//AIzaSyAsVhvkaMxr85yuawkt8R6TQH4majnK1nM
