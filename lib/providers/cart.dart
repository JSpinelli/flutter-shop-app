import 'package:flutter/material.dart';

class CartItem{
  
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.price});
}

class Cart with ChangeNotifier{
  Map<String, CartItem> _cart={};
  final String authToken;

  Cart(this.authToken,this._cart);

  Map<String,CartItem> get cart{
    return {..._cart};
  }
  int get itemCount{
    return _cart!=null? _cart.length : 0;
  }

  double get totalAmount{
    double total=0;
    _cart.forEach((key,item){
      total+=(item.price*item.quantity);
    });
    return total; 
  }

  void deleteItem(String prodId){
    _cart.remove(prodId);
    notifyListeners();
  }

  void clear(){
    _cart.clear();
    notifyListeners();
  }

  void removeSingleItem(String prodId){
    if (!_cart.containsKey(prodId)){
      return;
    }
    if (_cart[prodId].quantity>1){
      _cart.update(
        prodId, 
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity-1,
          price: existing.price
        ));
    }else{
      _cart.remove(prodId);
    }
  }

  void addItem(String productId, double price, String title, int quantity){
    if (_cart.containsKey(productId)){
      _cart.update(
        productId, 
        (existing) => CartItem(
          id: existing.id,
          title: existing.title,
          quantity: existing.quantity+quantity,
          price: existing.price
        ));
    }else{
      _cart.putIfAbsent(
        productId, 
        () => CartItem(
          id:DateTime.now().toString(),
          title:title,
          quantity:quantity,
          price:price)
      );
    }
    notifyListeners();
  }
}