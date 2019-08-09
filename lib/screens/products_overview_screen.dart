import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {

  bool _isLoading=false;

  @override
  void initState() {
    setState(() {
      _isLoading=true;
    });
    Future.delayed(Duration.zero).then(
      (_){
        Provider.of<Products>(context).fetchAndSetProducts().then(
          (_){
            setState(() {
              _isLoading=false;
            });
          }
        );
      }
    );    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prodsData = Provider.of<Products>(context);
    var scaffold = Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cartData, cl) => Badge(
              child: cl,
              value: cartData.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions selectValue) {
              if (selectValue == FilterOptions.All) {
                prodsData.ShowAll();
              } else {
                prodsData.ShowFavorites();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              )
            ],
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading? Center(child: CircularProgressIndicator(),) : ProductsGrid(),
    );
    return scaffold;
  }
}
