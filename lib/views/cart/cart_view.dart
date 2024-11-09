import 'package:flutter/material.dart';
import 'package:neighbourhood/models/product.dart';
import 'package:neighbourhood/services/cart_service.dart';
import 'package:go_router/go_router.dart';
import 'package:neighbourhood/common/glass_container.dart';
import 'dart:ui';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  _CartViewState createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final Map<Product, int> _cartItems = CartService().cartItems;

  void _removeFromCart(Product product) {
    setState(() {
      CartService().removeFromCart(product);
    });
  }

  void _updateQuantity(Product product, int quantity) {
    setState(() {
      CartService().updateQuantity(product, quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
              ),
            ),
          ),
        ),
        title: const Text("Cart"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange.shade200,
              Colors.orange.shade100,
              Colors.orange.shade50,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 32),
          child: Column(
            children: [
              Expanded(
                child: _cartItems.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GlassContainer(
                            child: SizedBox(
                              height: size.height * 0.50,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.shopping_cart_outlined,
                                      size: 64,
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Your cart is waiting to be filled",
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.black.withOpacity(0.6),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: _cartItems.length,
                        itemBuilder: (context, index) {
                          final product = _cartItems.keys.elementAt(index);
                          final quantity = _cartItems[product]!;
                          return GlassContainer(
                            padding: const EdgeInsets.all(8),
                            child: Card(
                              child: ListTile(
                                title: Text(product.name),
                                subtitle: Text("\$${product.price}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        if (quantity > 1) {
                                          _updateQuantity(
                                              product, quantity - 1);
                                        }
                                      },
                                    ),
                                    Text(quantity.toString()),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        _updateQuantity(product, quantity + 1);
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _removeFromCart(product);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              if (_cartItems.isNotEmpty)
                GlassContainer(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Text(
                        'Total: \$${_calculateTotal()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            context.go('/buy', extra: _cartItems);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            "Buy Now",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateTotal() {
    return _cartItems.entries
        .map((e) => e.key.price * e.value)
        .fold(0, (prev, amount) => prev + amount);
  }
}
