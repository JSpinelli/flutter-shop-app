import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  final String urlSignUp =
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAMKjC_TV6lTKCq_sm3NdbchTAyMcdDBkg';
  final String urlSignIn =
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAMKjC_TV6lTKCq_sm3NdbchTAyMcdDBkg';

  _authenticate(String email, String password, url) async {
    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'expirydate': _expiryDate.toIso8601String(),
        'userId':_userId 
      });
      prefs.setString('userdata', userData);
    } catch (err) {
      throw (err);
    }
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')){
      return false;
    }
    final extractedUserData =  prefs.getString('userData') as Map<String,Object>;
    final expiryDate = DateTime.parse(extractedUserData['expirydate']);
    if (expiryDate.isAfter(DateTime.now())){
      return false;
    }
    _token=extractedUserData['token'];
    _userId=extractedUserData['userId'];
    _expiryDate=extractedUserData['expirydate'];
    notifyListeners();
    return true;
  }

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, urlSignUp);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, urlSignIn);
  }

  void logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
  }
}
