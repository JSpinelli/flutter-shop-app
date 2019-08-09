import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart';

class OrderItemW extends StatefulWidget {
  
  final OrderItem item;

  OrderItemW(this.item);

  @override
  _OrderItemWState createState() => _OrderItemWState();
}

class _OrderItemWState extends State<OrderItemW> {

  bool _expanded=false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Total: \$${widget.item.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy - hh:mm').format(widget.item.dateTime)),
            trailing: IconButton(
              icon: Icon( _expanded? Icons.expand_more: Icons.expand_more),
              onPressed: () {
               setState(() {
                  _expanded = !_expanded;
               });
              },
            ),
          ),
          if (_expanded) Container(
            height: min((widget.item.products.length * 10.0 + 100) , 100),
            child: ListView.builder(
              itemCount: widget.item.products.length,
              itemBuilder: (ctx, index) {
                return Container(
                  margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                    Text(
                      widget.item.products[index].title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),),
                    Spacer(),
                    Text(
                      '\$${widget.item.products[index].price}  (${widget.item.products[index].quantity})',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey
                      ),),]
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}