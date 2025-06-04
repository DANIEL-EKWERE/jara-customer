import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/success_screen/controller/success_controller.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary_card.dart';
// import '../../widgets/cart_product_card.dart';

SuccessController controller = Get.put(SuccessController());
var cartController = Get.find<CartController>();

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  void initState() {
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            SvgPicture.asset('assets/images/check.svg'),
            const SizedBox(height: 20),
            const Text(
              'Successful',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView(padding: const EdgeInsets.all(16), children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: cartController.cartItems.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    final ingredients = item.ingredients;
                    return CartItemCard2(
                      id: item.id,
                      ingredients: ingredients,
                      name: item.name,
                      unit: item.description,
                      basePrice: item.price,
                      quantity: item.quantity,
                      textController: TextEditingController(
                        text: (item.quantity).toString(),
                      ),
                      isSelected: false,
                    );
                  },
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CartSummary(
                    itemsCost: cartController.totalIngredientPrice,
                    mealCost: cartController.mealPrepPrice,
                    serviceCharge: cartController.calculatedServiceCharge,
                    shippingCost: cartController.shippingCost.value,
                    totalAmount: cartController.total.obs,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Tracking ID: YT87FE63IH29',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            cartController.cartItems.clear();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MainScreen()),
                            );
                          },
                          icon: null,
                          label: const Text(
                            'Continue Shopping',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff666666)),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(
                                    width: 1, color: Color(0xff9F9F9F))),
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      SizedBox(
                        height: 40,
                        width: 150,
                        child: ElevatedButton(
                          onPressed: () {
                            // to implement tracking my order here
                            cartController.cartItems.clear();
                          },
                          //   : null,
                          child: const Text(
                            'Track My Order',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff090909)),
                          ),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
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
