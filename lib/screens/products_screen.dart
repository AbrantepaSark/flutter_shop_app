import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';
import '../providers/Products.dart';

import './cart_screen.dart';

import '../widgets/badge.dart';
import '../widgets/products_grid.dart';
import '../widgets/app_drawer.dart';

enum SelectOptions { All, Favorites }

class ProductsScreen extends StatefulWidget {
  static const routeName = '/products';

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  var _showFavorite = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

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
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showFavorite));
  }
}
