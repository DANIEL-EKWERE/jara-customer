import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import '../../screens/checkout_screen/checkout_screen.dart';
// import '../../models/cart_item.dart';

var controller = Get.find<CartController>();

class CheckoutButton extends StatelessWidget {
  final bool isEnabled;
  final double totalAmount;
  
  final bool loading;
  final List<CartItem> cartItems;

  const CheckoutButton(
      {super.key,
      required this.isEnabled,
      required this.totalAmount,
      required this.cartItems,
      
      required this.loading});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isEnabled
            ? 
            
            () async {
              //  Navigate to the CheckoutScreen
           var checkoutAddress = await controller.getCheckoutAddress();
//myLog.log('Checkout Address: ${checkoutAddress['data'][0]['contact_address']}');
           // Check if it's a non-empty list
if (checkoutAddress.isNotEmpty) {
  var data = checkoutAddress['data'][0];
  // Use `data` here
  myLog.log('Checkout Address first index data: $data');
  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      totalAmount: totalAmount,
                      cartItems: cartItems,
                      orderAddress: data,
                    ),
                  ),
                );
} else {
  // Handle empty state
  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CheckoutScreen(
                      totalAmount: totalAmount,
                      cartItems: cartItems,
                      orderAddress: {},
                    ),
                  ),
                );
}
// var data = checkoutAddress.isNotEmpty ? checkoutAddress[0] : [];
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => CheckoutScreen(
//                       totalAmount: totalAmount,
//                       cartItems: cartItems,
//                       orderAddress: data,
//                     ),
//                   ),
//                 );

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
        child: Text(
          loading ? "..." : 'Pay',
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
