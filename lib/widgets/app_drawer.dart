import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
import '../screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import '../screens/profile-screen.dart';
import '../screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Hello Frind!'),
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text('Shop'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.payment),
            title: const Text('Orders'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Your Products'),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.portrait),
            title: const Text('Profile'),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(ProfileScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Logout'),
            onTap: () {
              Provider.of<Auth>(context,listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
    );
  }
}