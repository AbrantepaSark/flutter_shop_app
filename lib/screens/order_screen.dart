import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Order.dart';

import '../widgets/order_item.dart';
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (ctx, i) => OrderSingleItem(orderData.orders[i])),
    );
  }
}
