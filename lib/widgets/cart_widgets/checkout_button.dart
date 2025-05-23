import 'package:flutter/material.dart';
import '../../screens/checkout_screen/checkout_screen.dart';
import '../../models/cart_item.dart';

class CheckoutButton extends StatelessWidget {
  final bool isEnabled;
  final double totalAmount;
  final List<CartItem> cartItems;

  const CheckoutButton(
      {super.key,
      required this.isEnabled,
      required this.totalAmount,
      required this.cartItems});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled
            ? () {
                // Navigate to the CheckoutScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      totalAmount: totalAmount,
                      cartItems: cartItems,
                    ),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled ? const Color(0xFFFF9800) : Colors.grey,
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Pay',
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
