import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  //Get all items
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get getTotal {
    var total = 0.0;
    _items.forEach((key, cart) {
      total += cart.price * cart.quantity;
    });
    return total;
  }

  //Add new or update item in cart
  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCart) => CartItem(
                id: existingCart.id,
                title: existingCart.title,
                price: existingCart.price,
                quantity: existingCart.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  //delete cartItem on swipe
  void deleteItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  //delete cart after making order
  void clear() {
    _items = {};
    notifyListeners();
  }
}
