import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/products_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          builder: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Generic Shop',
        theme: ThemeData(
            primarySwatch: Colors.red,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductsDetailScreen.routeName: (ctx) => ProductsDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => EditProductScreen(),
        },
      ),
    );
  }
}
