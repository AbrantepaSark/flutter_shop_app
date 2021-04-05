import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/Order.dart';

import '../providers/Cart.dart';
import '../providers/Order.dart';

import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final myCart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).primaryColor),
                  ),
                  Chip(
                    label: Text(
                      '\$${myCart.getTotal.toStringAsFixed(2)}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .primaryTextTheme
                              .headline6
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  TextButton(
                      onPressed: () {
                        Provider.of<Orders>(context, listen: false).addOrder(
                            myCart.items.values.toList(), myCart.getTotal);

                        myCart.clear();
                      },
                      child: Text(
                        'Order Now',
                      ))
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
                itemCount: myCart.itemCount,
                itemBuilder: (ctx, i) => CartItems(
                    myCart.items.values.toList()[i].id,
                    myCart.items.keys.toList()[i],
                    myCart.items.values.toList()[i].title,
                    myCart.items.values.toList()[i].price,
                    myCart.items.values.toList()[i].quantity)),
          )
        ],
      ),
    );
  }
}
