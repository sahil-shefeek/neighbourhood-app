import 'package:neighbourhood/models/product.dart';
import 'package:flutter/foundation.dart';

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final Map<Product, int> _cartItems = {};

  Map<Product, int> get cartItems => _cartItems;

  void addToCart(Product product) {
    if (_cartItems.containsKey(product)) {
      _cartItems[product] = _cartItems[product]! + 1;
    } else {
      _cartItems[product] = 1;
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity > 0) {
      _cartItems[product] = quantity;
    } else {
      removeFromCart(product);
    }
  }
}
