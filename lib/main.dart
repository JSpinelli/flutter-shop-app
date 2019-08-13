import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/auth.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './providers/products.dart';
import './providers/user.dart';
import './screens/auth-screen.dart';
import './screens/cart_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/products_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/profile-screen.dart';
import './screens/splash-screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            builder: (ctx) => Auth(),
          ),
          ChangeNotifierProvider(
            builder: (ctx) => User(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            builder: (ctx,auth,prevProducts) => Products(auth.token,auth.userId,prevProducts==null? [] : prevProducts.items),
          ),
          ChangeNotifierProxyProvider<Auth, Cart>(
            builder: (ctx,auth,prevCart) => Cart(auth.token,prevCart==null? {} : prevCart.cart),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            builder: (ctx,auth,prevOrders) => Orders(auth.token,auth.userId,prevOrders==null? [] : prevOrders.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Generic Shop',
            theme: ThemeData(
                primarySwatch: Colors.red,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato'),
            home: auth.isAuth 
            ?ProductsOverviewScreen() 
            :FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (ctx, authResult) => authResult.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
            ) ,
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductsOverviewScreen.routeName: (ctx) =>
                  ProductsOverviewScreen(),
              ProductsDetailScreen.routeName: (ctx) => ProductsDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
            },
          ),
        ));
  }
}
