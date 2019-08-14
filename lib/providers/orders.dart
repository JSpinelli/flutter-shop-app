import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../providers/cart.dart' show CartItem;

class OrderItem {
  String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _order = [];
  final String authToken;
  final String userId;

  Orders(this.authToken,this.userId, this._order);

  List<OrderItem> get orders {
    return [..._order];
  }

  int get count {
    return _order.length;
  }
  
  Future<void> fetchAndsetOrder() async {
    http.Response response;
    try {
      response = await http.get(
        'https://flutter-app-16bce.firebaseio.com/orders/$userId.json?auth=$authToken',
      );
      final List<OrderItem> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
      extractedData.forEach(
        (orderId, order){
         loadedOrders.add(OrderItem(
            id:orderId, 
            amount: order['amount'], 
            dateTime:DateTime.parse(order['dateTime']), 
            products: (order['products'] as List<dynamic>)
              .map((item)=>CartItem(
                  id:item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title']
              )).toList()
            ));
        }
      );
      _order = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (err) {
      
      throw('Error re-try');
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    
    OrderItem newOrder = OrderItem(
      id: null,
      amount: total,
      dateTime: DateTime.now(),
      products: cartProducts,
    );

    var response;
    try {
      response = await http.post(
        'https://flutter-app-16bce.firebaseio.com/orders/$userId.json?auth=$authToken',
        body: json.encode({
          'amount': newOrder.amount,
          'dateTime': newOrder.dateTime.toIso8601String(),
          'products': newOrder.products.map((cp) => {
            'id':cp.id,
            'title': cp.title,
            'quantity': cp.quantity,
            'price': cp.price
          }
          ).toList(),
        }),
      );
    } catch (err) {
      throw('Error re-try');
    }
    newOrder.id=json.decode(response.body)['name'];
    _order.insert(0, newOrder);
    notifyListeners();
    return;
  }
}
