import 'package:flutter/material.dart';
import 'package:slide_to_act/slide_to_act.dart';

class BuyView extends StatelessWidget {
  final dynamic items;

  const BuyView({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy"),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items.keys.elementAt(index);
                  final quantity = items[item]!;
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Quantity: $quantity"),
                    trailing: Text("\$${item.price * quantity}"),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SlideAction(
              onSubmit: () {
                // Handle checkout functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Order Placed")),
                );
                return null;
              },
              outerColor: Colors.orange,
              innerColor: Colors.white,
              elevation: 4,
              height: 60,
              sliderButtonIcon: const Icon(
                Icons.arrow_forward,
                color: Colors.orange,
              ),
              text: "Slide to place order",
              textStyle: const TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
