import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';

import './cart_screen.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum SelectOptions { All, Favorites }

class ProductsScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _showFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MyShop'),
          actions: [
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                child: child,
                value: cart.itemCount.toString(),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: Icon(Icons.shopping_cart),
              ),
            ),
            PopupMenuButton(
                onSelected: (SelectOptions option) {
                  setState(() {
                    if (option == SelectOptions.Favorites) {
                      _showFavorite = true;
                    } else {
                      _showFavorite = false;
                    }
                  });
                },
                child: Icon(Icons.more_vert),
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: Text('Show Favorite'),
                        value: SelectOptions.Favorites,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: SelectOptions.All,
                      ),
                    ])
          ],
        ),
        drawer: AppDrawer(),
        body: ProductsGrid(_showFavorite));
  }
}
