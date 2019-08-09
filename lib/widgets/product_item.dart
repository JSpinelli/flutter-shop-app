import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Product.dart';
import '../providers/cart.dart';
import '../screens/products_detail_screen.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prod = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          child: Image.network(
            prod.imageUrl,
            fit: BoxFit.cover,
          ),
          onTap: () {
            Navigator.of(context)
                .pushNamed(ProductsDetailScreen.routeName, arguments: prod.id);
          },
        ),
        footer: GridTileBar(
          leading: Consumer<Product>( //Provides the ability to listen to changes in only one part of the widget, avoiding unneccesary rebuilds
            builder: (ctx, prod, child) => IconButton(
              icon: Icon(
                  prod.isFavorite ? Icons.favorite : Icons.favorite_border),
              onPressed: () {
                prod.toggleFavorite();
              },
              color: Theme.of(context).accentColor,
            ),
            child: Text('Something that never changes that could be passed to the widget builder'),
          ),
          backgroundColor: Colors.black54,
          title: Text(
            '${prod.title}',
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              cart.addItem(prod.id, prod.price, prod.title, 1);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Added item to cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeSingleItem(prod.id);
                    },
                  ),
                ));
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
