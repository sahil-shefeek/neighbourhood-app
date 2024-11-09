import 'package:neighbourhood/models/product.dart';

class CartService {
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
  }

  void removeFromCart(Product product) {
    _cartItems.remove(product);
  }

  void updateQuantity(Product product, int quantity) {
    if (quantity > 0) {
      _cartItems[product] = quantity;
    } else {
      removeFromCart(product);
    }
  }
}
