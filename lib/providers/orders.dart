import 'package:flutter/material.dart';

import '../providers/cart.dart' show CartItem;

class OrderItem{
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
   @required this.id,
   @required this.amount,
   @required this.products,
   @required this.dateTime});
}


class Orders with ChangeNotifier{

  List<OrderItem> _order = [];

  List<OrderItem> get orders{
    return [..._order];
  }

  int get count{
    return _order.length;
  }

  void addOrder(List<CartItem> cartProducts, double total){
    _order.insert(0, OrderItem(
      id: DateTime.now().toString(),
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    ));
    notifyListeners();
  }


}