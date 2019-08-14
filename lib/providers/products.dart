import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  List<Product> _userItems = [];
  final String authToken;
  final String userId;

  Products(this.authToken,this.userId,this._items);



  bool _showFavoritesOnly = false;

  void ShowFavorites() {
    _showFavoritesOnly = true;
    notifyListeners();
  }

  void ShowAll() {
    _showFavoritesOnly = false;
    notifyListeners();
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get itemsFiltered {
    if (_showFavoritesOnly) {
      return _items.where((prod) {
        return prod.isFavorite;
      }).toList();
    }
    return [..._items];
  }

  Product finById(String id) {
    return _items.firstWhere((product) {
      return product.id == id;
    });
  }

  Future<void> addProduct(Product prod) {
    return http
        .post('https://flutter-app-16bce.firebaseio.com/products.json?auth=$authToken',
            body: json.encode({
              'title': prod.title,
              'description': prod.description,
              'price': prod.price,
              'imageUrl': prod.imageUrl,
              'creatorId': userId,
            }))
        .then((response) {
      _items.add(Product(
          id: json.decode(response.body)['name'],
          title: prod.title,
          description: prod.description,
          price: prod.price,
          imageUrl: prod.imageUrl));
      notifyListeners();
    });
  }

  Future<void> updateProduct(Product product) {
    final index = _items.indexWhere((prod) {
      return prod.id == product.id;
    });
    return http
        .patch(
      'https://flutter-app-16bce.firebaseio.com/products/${product.id}.json?auth=$authToken',
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
      }),
    )
        .then((_) {
      _items[index] = product;
      notifyListeners();
    });
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    try{
      String url = !filterByUser 
      ?'https://flutter-app-16bce.firebaseio.com/products.json?auth=$authToken'
      :'https://flutter-app-16bce.firebaseio.com/products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
      final responseData = await http.get(url);
      final extractedData = json.decode(responseData.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null){
        return;
      }
      final favoritesResponse = await http.get('https://flutter-app-16bce.firebaseio.com/users/$userId/favoriteProducts.json?auth=$authToken');
      final favoriteData = json.decode(favoritesResponse.body);

      extractedData.forEach((id, prod) {
        loadedProducts.add(Product(
          id: id,
          title: prod['title'],
          description: prod['description'],
          price: prod['price'],
          imageUrl: prod['imageUrl'],
          isFavorite: favoriteData == null ? false : favoriteData[id] ?? false,
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch(error) {;
      throw (error);
    }
  }

  Future<void> deleteProduct(String id) {
    return http
        .delete('https://flutter-app-16bce.firebaseio.com/products/${id}.json?auth=$authToken')
        .then((code) {
          if (code.statusCode>= 400){
            throw HttpException('Could not delete product');
          }else{
            items.removeWhere((prod) {return prod.id == id;});
            notifyListeners();
          }
    });
  }
}
