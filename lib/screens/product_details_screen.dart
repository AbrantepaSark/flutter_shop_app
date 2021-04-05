import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/Products.dart';

class ProductDetails extends StatelessWidget {
  static const routeName = '/product_details';
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(context, listen: false)
        .findProductById(productId);

    return Scaffold(
        appBar: AppBar(
          title: Text(loadedProduct.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                child: Image.asset(
                  loadedProduct.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Chip(
                backgroundColor: Colors.pink,
                label: Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              Container(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.all(10),
                  elevation: 4,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Description',
                            style: TextStyle(fontSize: 20),
                          ),
                          Divider(),
                          Text(
                            loadedProduct.description,
                            softWrap: true,
                          ),
                        ],
                      )),
                ),
              )
            ],
          ),
        ));
  }
}
