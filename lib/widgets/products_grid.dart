import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final productsData=Provider.of<Products>(context);
    final products = productsData.itemsFiltered;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index], //Neccessary because Flutter may recycle the wdiget and that can lead to wrong providers attached, this forces the pair between provider and widget
          child: ProductItem()
        );},
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2, //Amount of Columns to have
         childAspectRatio: 3/2,
         crossAxisSpacing: 10,
         mainAxisSpacing: 10,
       ),
    );
  }
}