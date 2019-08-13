import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart';

import '../providers/cart.dart' show Cart;
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  const Text(
                    'Total',
                    style: const TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('${cart.totalAmount}'),
                    backgroundColor: Theme.of(context).accentColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
              child: ListView.builder(
            itemCount: cart.itemCount,
            itemBuilder: (ctx, index) {
              return CartItemW(cart.cart.values.toList()[index],
                  cart.cart.keys.toList()[index]);
            },
          )),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return _isLoading 
    ?  Container (
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: CircularProgressIndicator()
      )
    : FlatButton(
      child: const Text('Order Now'),
      onPressed: (widget.cart.totalAmount > 0 && !_isLoading)
          ? () {
              setState(() {
                _isLoading = true;
              });
              Provider.of<Orders>(context, listen: false)
                  .addOrder(
                      widget.cart.cart.values.toList(), widget.cart.totalAmount)
                  .then((_) {
                    setState(() {
                      _isLoading = false;
                    });
                    widget.cart.clear();})
                  .catchError((_){
                    setState(() {
                      _isLoading = false;
                    });
                  });
            }
          : null,
      textColor: Theme.of(context).primaryColor,
    );
  }
}
