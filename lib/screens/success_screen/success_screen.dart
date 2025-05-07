import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/success_screen/controller/success_controller.dart';
import '../../widgets/cart_product_card.dart';

SuccessController controller = Get.put(SuccessController());

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFFE6F9F1),
              child: Icon(
                Icons.check,
                size: 40,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Successful',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  CartProductCard(
                    imageUrl: 'assets/images/rice.png',
                    title: 'Rice',
                    price: 25000.0,
                    originalPrice: 2199.99,
                    rating: 4.5,
                    reviews: 100,
                    isFavorite: false,
                    onFavoritePressed: () {},
                    onTap: () {},
                    quantity: 1,
                    onQuantityChanged: (qty) {},
                  ),
                  // Add more CartProductCards
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    'N85,000',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const Text('Total Amount'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          child: const Text('Continue Shopping'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('Track My Order'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}