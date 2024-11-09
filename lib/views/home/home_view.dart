import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:neighbourhood/models/product.dart';
import 'package:neighbourhood/models/service.dart';
import 'package:neighbourhood/services/api_service.dart';
import 'package:go_router/go_router.dart';
import 'package:neighbourhood/services/cart_service.dart';
import 'package:neighbourhood/utils/glass_utils.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int? _expandedIndex;
  late Future<List<Product>> _productsFuture;
  late Future<List<Service>> _servicesFuture;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
    _updateCartCount();
    CartService().addListener(_updateCartCount);
  }

  @override
  void dispose() {
    CartService().removeListener(_updateCartCount);
    super.dispose();
  }

  void _updateCartCount() {
    setState(() {
      _cartItemCount = CartService().cartItems.length;
    });
  }

  void _loadData() {
    setState(() {
      _productsFuture = ApiService().fetchProducts();
      _servicesFuture = ApiService().fetchServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassAppBar(
        title: "Neighbourhood",
        gradientColor: Colors.orange.shade900,
        actions: [
          if (_cartItemCount > 0)
            GlassBadge(
              count: _cartItemCount.toString(),
              gradientColor: Colors.orange,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => context.push('/cart'),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () => context.push('/cart'),
            ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
          ),
        ],
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
        child: RefreshIndicator(
          onRefresh: () async {
            _loadData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Your Insights",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                CarouselSlider(
                  items: [1, 2, 3].map((i) {
                    return GlassCard(
                      gradientColor: Colors.orange,
                      elevation: 4,
                      child: Center(
                        child: Text(
                          "Product $i",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 150.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "New In Your Area",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<List<dynamic>>(
                  future: Future.wait([_productsFuture, _servicesFuture]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const GlassContainer(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return GlassContainer(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Colors.white,
                                size: 60,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Oops! Something went wrong',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 8),
                              GlassButton(
                                onPressed: _loadData,
                                gradientColor: Colors.orange,
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.refresh, color: Colors.white),
                                    SizedBox(width: 8),
                                    Text(
                                      'Retry',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SizedBox(
                        height: 200,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                color: Colors.orange,
                                size: 60,
                              ),
                              SizedBox(height: 16),
                              Text('No items available in your area'),
                            ],
                          ),
                        ),
                      );
                    } else {
                      List<Product> products = snapshot.data![0];
                      List<Service> services = snapshot.data![1];
                      List<dynamic> items = [...products, ...services];

                      return ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          bool isExpanded = _expandedIndex == index;
                          var item = items[index];

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: GlassCard(
                              gradientColor: Colors.orange,
                              child: GestureDetector(
                                onTap: () {
                                  context.push('/product', extra: item);
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.white.withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              item is Product
                                                  ? item.name
                                                  : item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          GlassButton(
                                            width: 40,
                                            height: 40,
                                            onPressed: () {
                                              setState(() {
                                                _expandedIndex =
                                                    isExpanded ? null : index;
                                              });
                                            },
                                            child: Icon(
                                              isExpanded
                                                  ? Icons.keyboard_arrow_up
                                                  : Icons.keyboard_arrow_down,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (isExpanded)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: Text(
                                            item is Product
                                                ? "Details for ${item.name}"
                                                : "Details for ${item.name}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
