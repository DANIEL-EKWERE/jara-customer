import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/home_screen/models/food_model.dart';
import 'package:jara_market/widgets/cart_widgets/cart_ingredient.dart';
import '../../models/cart_item.dart';
import '../../widgets/cart_widgets/cart_item_card.dart';
import '../../widgets/cart_widgets/checkout_button.dart';
import '../../widgets/cart_widgets/payment_methods.dart';
import '../../widgets/cart_widgets/cart_summary.dart';
import '../../services/cart_service.dart';

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
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final cart = await _cartService.getActiveCart();
      _currentCartId = cart['id'];

      setState(() {
        _isLoading = false;
        _cartItems = ((cart['items'] ?? []) as List).map((item) {
          final product = item['product'] ?? {};

          // Parse price values safely
          double parsePrice(dynamic value) {
            if (value == null) return 0.0;
            if (value is num) return value.toDouble();
            if (value is String) {
              try {
                return double.parse(value);
              } catch (e) {
                return 0.0;
              }
            }
            return 0.0;
          }

          return CartItem(
            id: (item['id'] ?? '').toString(),
            name: product['name']?.toString() ?? 'Unknown Product',
            description: product['description']?.toString() ?? '',
            price: parsePrice(item['price']),
            originalPrice: parsePrice(product['price']),
            quantity: item['quantity'] ?? 1,
          );
        }).toList();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error fetching cart: $e';
      });
      debugPrint(_errorMessage);
    }
  }

  Future<void> _updateQuantity(String itemId, int newQuantity) async {
    if (_currentCartId == null) return;

    try {
      await _cartService.updateCartItem(
        _currentCartId!,
        int.parse(itemId),
        newQuantity,
      );
      await _fetchCart(); // Refresh the cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update quantity')),
      );
    }
  }

  Future<void> _removeItem(String itemId) async {
    if (_currentCartId == null) return;

    try {
      await _cartService.removeCartItem(
        _currentCartId!,
        int.parse(itemId),
      );
      await _fetchCart(); // Refresh the cart
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to remove item')),
      );
    }
  }

  double get _totalAmount {
    return _cartItems.fold(
        0, (sum, item) => sum + (item.price * item.quantity));
  }

  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = _cartItems.isEmpty;
    bool isCheckoutEnabled = !isCartEmpty && _totalAmount > 0;

    return SafeArea(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null && _cartItems.isEmpty
              ? Center(child: Text(_errorMessage!))
              : Scaffold(
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
                            : Obx((){
                              return ListView.separated(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: controller.cartItems.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 0.5,color: Color.fromARGB(57, 228, 228, 228),),
                                itemBuilder: (context, index) {
                                  final item = controller.cartItems[index];
                                  final ingredient = controller.cartItems[index].ingredients;
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
                                    ingredients: ingredient,
                                    name: item.name,
                                    unit: item.description,
                                    basePrice: item.price,
                                    quantity: item.quantity,
                                    // onQuantityChanged: (newQuantity) =>
                                    //     _updateQuantity(item.id.toString(), newQuantity),
                                    addQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value + 1),
                                    removeQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value - 1),
                                    onDeleteConfirmed: () => controller.removeFromCart(item.id),
                                    textController: TextEditingController(
                                        text: item.quantity.toString()),
                                    isSelected: false,
                                    onCheckboxChanged: (bool? value) {},
                                  );
                                },
                              );
                            })
                      ),
                      const Divider(height: 1),
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            CartSummary(
                              itemsCost: controller.cartItems.fold(
                                  0.0,
                                  (sum, item) =>
                                      sum + (item.price * item.quantity.value)),
                              mealCost: 0.00,
                              serviceCharge: 0.00,
                              shippingCost: 0.00,
                              totalAmount: _totalAmount,
                            ),
                            const SizedBox(height: 16),
                            CheckoutButton(
                              isEnabled: isCheckoutEnabled,
                              totalAmount: _totalAmount,
                              cartItems: _cartItems,
                            ),
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
