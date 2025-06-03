import 'package:flutter/material.dart';
// import '../../models/cart_item.dart';

class CheckoutButtonPaystack extends StatelessWidget {
 final String title;

  const CheckoutButtonPaystack(
      {super.key,required this.title
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
          
          print('paystack calling here');
              }
          ,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFF9800),
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
          ),
        ),
      ),
    );
  }
}
