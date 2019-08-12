import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.price,
      @required this.description,
      @required this.imageUrl,
      this.isFavorite = false});

  void toggleFavorite(String tokenId,String userId) async {
    isFavorite = !isFavorite;
    notifyListeners();
    try {
      final response = await http.put(
          'https://flutter-app-16bce.firebaseio.com/usersFavorites/$userId/$id.json?auth=$tokenId',
          body: json.encode(isFavorite));
          print(response.body);
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (err) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }
}
