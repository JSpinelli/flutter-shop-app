import 'package:flutter/material.dart';

class User with ChangeNotifier{

  String name;
  String surname;
  String profileImage;
  List<String> favoriteCategories = ['Gym','Food'];

  bool isFavorite(String cat){
    return favoriteCategories.contains(cat);
  }
}