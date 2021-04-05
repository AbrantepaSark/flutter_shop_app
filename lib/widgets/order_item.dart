import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/Order.dart';

class OrderSingleItem extends StatelessWidget {
  final OrderItem order;
  OrderSingleItem(this.order);
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyy hh:mm').format(order.dateTime),
            ),
            trailing: IconButton(
              icon: Icon(Icons.expand_more_rounded),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
