import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_screen/checkout_screen.dart';
import 'package:jara_market/screens/home_screen/models/food_model.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/widgets/cart_widgets/cart_ingredient.dart';
// import '../../models/cart_item.dart';
import '../../widgets/cart_widgets/cart_item_card.dart';
import '../../widgets/cart_widgets/checkout_button.dart';
import '../../widgets/cart_widgets/payment_methods.dart';
import '../../widgets/cart_widgets/cart_summary.dart';
import '../../services/cart_service.dart';
// import 'package:jara_market/screens/cart_screen/models/models.dart';

var controller = Get.find<CartController>();

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartService _cartService = CartService();
  List<CartItem> _cartItems = [];
  bool _isLoading = true;
  String? _errorMessage;
  int? _currentCartId;
  

  @override
  void initState() {
    super.initState();
   // _fetchCart();
  }

  // Future<void> _fetchCart() async {
  //   try {
  //     setState(() {
  //       _isLoading = true;
  //       _errorMessage = null;
  //     });

  //     final cart = await _cartService.getActiveCart();
  //     _currentCartId = cart['id'];

  //     setState(() {
  //       _isLoading = false;
  //       _cartItems = ((cart['items'] ?? []) as List).map((item) {
  //         final product = item['product'] ?? {};

  //         // Parse price values safely
  //         double parsePrice(dynamic value) {
  //           if (value == null) return 0.0;
  //           if (value is num) return value.toDouble();
  //           if (value is String) {
  //             try {
  //               return double.parse(value);
  //             } catch (e) {
  //               return 0.0;
  //             }
  //           }
  //           return 0.0;
  //         }

  //         return CartItem(
  //           ingredients: [],
  //           id: item.id,
  //           name: product['name']?.toString() ?? 'Unknown Product',
  //           description: product['description']?.toString() ?? '',
  //           price: parsePrice(item['price']),
  //           originalPrice: parsePrice(product['price']),
  //           quantity: item['quantity'] ?? 1,
  //         );
  //       }).toList();
  //     });
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorMessage = 'Error fetching cart: $e';
  //     });
  //     debugPrint(_errorMessage);
  //   }
  // }

  // Future<void> _updateQuantity(String itemId, int newQuantity) async {
  //   if (_currentCartId == null) return;

  //   try {
  //     await _cartService.updateCartItem(
  //       _currentCartId!,
  //       int.parse(itemId),
  //       newQuantity,
  //     );
  //     await _fetchCart(); // Refresh the cart
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to update quantity')),
  //     );
  //   }
  // }

  // Future<void> _removeItem(String itemId) async {
  //   if (_currentCartId == null) return;

  //   try {
  //     await _cartService.removeCartItem(
  //       _currentCartId!,
  //       int.parse(itemId),
  //     );
  //     await _fetchCart(); // Refresh the cart
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Failed to remove item')),
  //     );
  //   }
  // }

  // double get _totalAmount {
  //   return _cartItems.fold(
  //       0, (sum, item) => sum + (item.price * item.quantity.value));
  // }

  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = controller.cartItems.isEmpty;
    bool isCheckoutEnabled = !isCartEmpty && controller.total > 0;

    return SafeArea(
      child: Scaffold(
              body: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Poppins',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                          child: controller.cartItems.length == 0
                              ? const Center(
                                  child: Text(
                                    'Your cart is empty',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                )
                              : Obx(() {
                                  return ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    itemCount: controller.cartItems.length + 1,
                                    separatorBuilder: (context, index) =>
                                        const Divider(
                                      height: 0.5,
                                      color: Color.fromARGB(57, 228, 228, 228),
                                    ),
                                    itemBuilder: (context, index) {
                                      if (index ==
                                          controller.cartItems.length) {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Checkbox(
                                                activeColor: Colors.green,
                                                checkColor: Colors.white,
                                                side: const BorderSide(
                                                  color: Color(
                                                      0xff868D94), // Change this to your desired stroke color
                                                  width:
                                                      2, // Optional: stroke thickness
                                                ),
                                                value: controller.mealPrep.value,
                                                onChanged: (bool? value) {
                                                  //controller.toggleSelectAll(value!);
                                                  setState(() {
                                                    controller.mealPrep.value = value!;
                                                    print(value);
                                                    print(controller.mealPrep.value);
                                                  });
                                                },
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Meal Preparation',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey[400],
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                  Text(
                                                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit\ntempor incididunt ut labore et dolore magna aliqua.',
                                                    style: TextStyle(
                                                      fontSize: 9,
                                                      color: Colors.grey[400],
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      final item = controller.cartItems[index];
                                      final RxList<Ingredients> ingredients =
                                          controller
                                              .cartItems[index].ingredients;
                                      // return CartItemCard(
                                      //   name: item.name,
                                      //   unit: item.description,
                                      //   basePrice: item.price,
                                      //   quantity: item.quantity,
                                      //   // onQuantityChanged: (newQuantity) =>
                                      //   //     _updateQuantity(item.id.toString(), newQuantity),
                                      //   addQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value + 1),
                                      //   removeQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value - 1),
                                      //   onDeleteConfirmed: () => controller.removeFromCart(item.id),
                                      //   textController: TextEditingController(
                                      //       text: item.quantity.toString()),
                                      //   isSelected: false,
                                      //   onCheckboxChanged: (bool? value) {},
                                      // );
                                      return CartItemCard1(
                                        id: item.id,
                                        ingredients: ingredients,
                                        name: item.name,
                                        unit: item.description,
                                        basePrice: item.price.obs,
                                        quantity: item.quantity,
                                        addQuantity: () {
                                          controller.updateItemQuantity(
                                              item.id, item.quantity.value + 1);
                                        },
                                        removeQuantity: () {
                                          controller.updateItemQuantity(
                                              item.id, item.quantity.value - 1);
                                        },
                                        onDeleteConfirmed: () {
                                          controller.removeFromCart(item.id);
                                        },
                                        textController: TextEditingController(
                                            text: item.quantity.toString()),
                                        isSelected: false,
                                        onCheckboxChanged: (bool? value) {},
                                      );
                                    },
                                  );
                                })),
                      const Divider(height: 1),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CartSummary(
                              itemsCost: controller.totalIngredientPrice,
                              mealCost: controller.mealPrepPrice,
                              serviceCharge: controller.calculatedServiceCharge,
                              shippingCost: controller.shippingCost.value,
                              totalAmount: controller.total.obs,
                            ),
                            const SizedBox(height: 16),
                            Obx((){
                              return CheckoutButton(
                              isEnabled: isCheckoutEnabled,
                              totalAmount: controller.total,
                              cartItems: controller.cartItems,
                              loading: controller.isLoading.value,
                              // onPressed: () {
                              //   // Handle checkout button press
                              //   controller.getCheckoutAddress();
                              // },
                            );
                            }),
                            const SizedBox(height: 16),
                            const PaymentMethods(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
