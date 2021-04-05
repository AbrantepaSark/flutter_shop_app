import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Cart.dart';

class CartItems extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItems(
    this.id,
    this.productId,
    this.title,
    this.price,
    this.quantity,
  );
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: false);
    return Dismissible(
      key: Key(productId),
      direction: DismissDirection.startToEnd,
      onDismissed: (DismissDirection direction) {
        cart.deleteItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete_forever,
          size: 40,
          color: Colors.white,
        ),
        alignment: Alignment.centerLeft,
      ),
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: FittedBox(child: Text('\$$price')),
              ),
              radius: 25,
            ),
            title: Text(
              title,
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            subtitle: Text('Total: \$${(price * quantity)}'),
            trailing: Text('$quantity x'),
          ),
        ),
      ),
    );
  }
}
