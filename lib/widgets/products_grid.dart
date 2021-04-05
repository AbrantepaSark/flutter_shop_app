import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Products.dart';
import './product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFav;
  ProductsGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = showFav ? productsData.favorites : productsData.items;
    return GridView.builder(
        padding: EdgeInsets.all(10),
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10),
        //links Product provider to each product
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
              value: products[i],
              child: ProductItem(),
            ));
  }
}
