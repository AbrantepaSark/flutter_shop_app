import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

import './Product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //     id: 'p1',
    //     title: 'Shirt',
    //     description: 'A very cute and nice shirt',
    //     price: 22.43,
    //     imageURL: 'assets/images/shirt.jpg'),
    // Product(
    //     id: 'p2',
    //     title: 'Bag',
    //     description: 'A very cute and nice bag',
    //     price: 32.93,
    //     imageURL: 'assets/images/bag.jpg'),
    // Product(
    //     id: 'p3',
    //     title: 'Office Wear',
    //     description: 'A very cute and nice office wear shoe',
    //     price: 92.23,
    //     imageURL: 'assets/images/office_wear.jpg'),
    // Product(
    //     id: 'p4',
    //     title: 'Sneaker',
    //     description: 'A very cute and nice sneaker',
    //     price: 54.43,
    //     imageURL: 'assets/images/shoes.png'),
  ];

  final String userToken;
  Products(this.userToken, this._items);
  // void update(String token) {
  //   userToken = token;
  // }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favorites {
    return items.where((product) => product.isFavorite).toList();
  }

  Product findProductById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  Future<void> getProducts() async {
    final url = Uri.https('shop-app-5bc2a-default-rtdb.firebaseio.com',
        '/products.json', {'auth': userToken});

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;

      if (responseData == null) {
        return;
      }
      final List<Product> data = [];
      responseData.forEach((prodId, prodData) {
        data.add(Product(
          id: prodId,
          title: prodData['title'],
          price: prodData['price'],
          description: prodData['description'],
          imageURL: prodData['imageURL'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = data;
    } catch (error) {
      print(error);
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https('shop-app-5bc2a-default-rtdb.firebaseio.com',
        '/products.json', {'auth': userToken});
    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'title': product.title,
          'price': product.price,
          'description': product.description,
          'imageURL': product.imageURL,
          'isFavorite': product.isFavorite,
        }),
      );

      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageURL: product.imageURL,
        id: jsonDecode(response.body)['name'],
      );

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final url = Uri.https('shop-app-5bc2a-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': userToken});
    try {
      await http.patch(url,
          body: jsonEncode({
            'title': product.title,
            'price': product.price,
            'description': product.description,
            'imageURL': product.imageURL,
          }));
      final productIndex = _items.indexWhere((prod) => prod.id == id);
      _items[productIndex] = product;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.https('shop-app-5bc2a-default-rtdb.firebaseio.com',
        '/products/$id.json', {'auth': userToken});
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      notifyListeners();
      throw HttpException('Something went wrong!');
    }
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
