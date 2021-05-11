import 'package:flutter/material.dart';

import './Product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
        id: 'p1',
        title: 'Shirt',
        description: 'A very cute and nice shirt',
        price: 22.43,
        imageURL: 'assets/images/shirt.jpg'),
    Product(
        id: 'p2',
        title: 'Bag',
        description: 'A very cute and nice bag',
        price: 32.93,
        imageURL: 'assets/images/bag.jpg'),
    Product(
        id: 'p3',
        title: 'Office Wear',
        description: 'A very cute and nice office wear shoe',
        price: 92.23,
        imageURL: 'assets/images/office_wear.jpg'),
    Product(
        id: 'p4',
        title: 'Sneaker',
        description: 'A very cute and nice sneaker',
        price: 54.43,
        imageURL: 'assets/images/shoes.png'),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
      title: product.title,
      price: product.price,
      description: product.description,
      imageURL: product.imageURL,
      id: product.id,
    );
    _items.add(newProduct);
    notifyListeners();
  }
}
