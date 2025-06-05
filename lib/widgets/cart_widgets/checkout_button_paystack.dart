import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
// import '../../models/cart_item.dart';

CheckoutController checkoutController = Get.find<CheckoutController>();
class CheckoutButtonPaystack extends StatelessWidget {
 final String title;
 final double amount;
 final Color? color;

  const CheckoutButtonPaystack(
      {super.key,required this.title, required this.amount, this.color
      });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the CheckoutScreen
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => CheckoutScreen(
               
          //     ),
          //   ),
          // );

        //  checkoutController.initializeCheckout(amount);
        checkoutController.createOrder();
          print('paystack calling here');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFFFF9800),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
