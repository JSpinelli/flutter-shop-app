import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItemW extends StatelessWidget {
  
  final CartItem item;
  final String id;
  CartItemW(this.item,this.id);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
         margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size:40
        ),
      ),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => 
            AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text('Do you want remove this stack from the cart?'),
              actions: <Widget>[
                FlatButton(child: const Text('Yes'), onPressed: () {
                  Navigator.of(ctx).pop(true);
                },),
                FlatButton(child: const Text('No'), onPressed: () {
                  Navigator.of(ctx).pop(false);
                },),
              ],
            )
        );
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).deleteItem(id);
        
      },
      direction: DismissDirection.endToStart,
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: FittedBox(child: Text('${item.price}'))),
            ),
            title: Text('${item.title}'),
            subtitle: Text('${(item.price * item.quantity)}'),
            trailing: Text('${item.quantity} x'),
          ),
        ),
      ),
    );
  }
}
