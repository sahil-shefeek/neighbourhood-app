import 'package:flutter/material.dart';
import 'package:neighbourhood/models/product.dart';
import 'package:neighbourhood/models/service.dart';
import 'package:go_router/go_router.dart';
import 'package:neighbourhood/services/cart_service.dart';
import 'package:neighbourhood/utils/glass_utils.dart';

class ProductPage extends StatelessWidget {
  final dynamic item;

  const ProductPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isProduct = item is Product;
    final name = isProduct ? (item as Product).name : (item as Service).name;
    final price = isProduct ? (item as Product).price : (item as Service).price;

    return WillPopScope(
      onWillPop: () async {
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        } else {
          context.go('/home');
        }
        return false;
      },
      child: Scaffold(
        appBar: GlassAppBar(
          title: name,
          gradientColor: Colors.orange,
          onLeading: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.orange.shade900,
                Colors.orange.shade800,
                Colors.orange.shade600,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GlassCard(
                    gradientColor: Colors.orange,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://via.placeholder.com/300x300'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    gradientColor: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "\$$price",
                          style: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    gradientColor: Colors.orange,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Product Description",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "This is a detailed description of the product...",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (isProduct) ...[
                    GlassButton(
                      width: double.infinity,
                      gradientColor: Colors.orange,
                      onPressed: () {
                        CartService().addToCart(item as Product);
                        context.go('/cart');
                      },
                      child: const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GlassButton(
                      width: double.infinity,
                      gradientColor: Colors.orange.withOpacity(0.5),
                      onPressed: () {
                        context.go('/buy', extra: item);
                      },
                      child: const Text(
                        "Buy Now",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ] else
                    GlassButton(
                      width: double.infinity,
                      gradientColor: Colors.orange,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Service booking coming soon")),
                        );
                      },
                      child: const Text(
                        "Book Service",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
