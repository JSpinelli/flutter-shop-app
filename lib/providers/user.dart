import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class User with ChangeNotifier {
  String name;
  String surname;
  String profileImage;
  String adress;
  List<String> favoriteCategories = ['Gym', 'Food'];
  String authToken;
  String userId;

  User(this.authToken, this.userId, this.name, this.surname, this.profileImage,
      this.favoriteCategories) {
    if (name == null) {
      if (authToken != null) {
        _getUserInfo();
      }
    }
  }

  bool isFavorite(String cat) {
    return favoriteCategories.contains(cat);
  }

  Future<void> updateuser(String new_name, String new_surname,
      String new_adress, String new_image, List<String> new_favCat) async {
    try {
      final response = await http.patch(
          'https://flutter-app-16bce.firebaseio.com/users/$userId.json?auth=$authToken',
          body: json.encode({
            'name': new_name,
            'surname': new_surname,
            'profileImage': new_image,
            'favoriteCategories': new_favCat,
            'adress': new_adress
          }));
      if (response.statusCode >= 400) {
        throw 'Error in Firebase';
      }
    } catch (err) {
        print(err);
    }
  }

  // void toogleFavorite(String cat) async {
  //   var index = favoriteCategories.indexWhere((elem) {
  //     return elem == cat;
  //   });
  //   if (index == -1) {
  //     favoriteCategories.add(cat);
  //   } else {
  //     favoriteCategories.removeAt(index);
  //   }
  //   notifyListeners();
  //   try {
  //     final response = await http.put(
  //         'https://flutter-app-16bce.firebaseio.com/users/$userId/favoriteCat/$cat.json?auth=$authToken');
  //     if (response.statusCode >= 400) {
  //       throw 'Error in Firebase';
  //     }
  //   } catch (err) {
  //     print(err);
  //     if (index == -1) {
  //       favoriteCategories.removeLast();
  //     } else {
  //       favoriteCategories.add(cat);
  //     }
  //     notifyListeners();
  //   }
  // }

  void _getUserInfo() async {
    try {
      final userResponse = await http.get(
          'https://flutter-app-16bce.firebaseio.com/users/$userId.json?auth=$authToken');
      final userData = json.decode(userResponse.body);
      if (userData != null) {
        name = userData['name'];
        surname = userData['surname'];
        profileImage = userData['profileImage'];
        adress = userData['adress'];
        favoriteCategories = (userData['favoriteCategories'] as List<dynamic>).map((item){return (item as String);}).toList();
      }
      //.map((item)=> favoriteCategories.add(item)).toList();
    } catch (error) {
      print(error);
    }
  }
}
