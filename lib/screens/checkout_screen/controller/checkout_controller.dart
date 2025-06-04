import 'dart:developer' as myLog;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_screen/atomicWebViewScreen/atomic_webview_screen.dart';
import 'package:jara_market/screens/checkout_screen/models/buildOrderPayload.dart';
import 'package:jara_market/screens/checkout_screen/models/models.dart';
import 'package:jara_market/screens/checkout_screen/models/ordersuccess.dart';
import 'package:jara_market/screens/success_screen/success_screen.dart';
import 'package:jara_market/services/api_service.dart';

class CheckoutController extends GetxController {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  RxString selectedAddress = ''.obs;
  RxString selectedLga = ''.obs;
  RxString selectedCountry = ''.obs;
  RxString selectedState = ''.obs;
  RxString number = ''.obs;
  RxString address = ''.obs;
  RxString contactName = ''.obs;
  RxBool isDefault = false.obs;
  RxBool isLoading = false.obs;
  OrderSuccessModel orderSuccessModel = OrderSuccessModel();
  CheckoutModel checkoutModel = CheckoutModel(
    status: false,
    message: '',
    data: Data(url: ''),
  );
  @override
  void onInit() {
    super.onInit();
    // Initialize any necessary data or state here
  }

  void updateAddress(String newAddress) {
    selectedAddress.value = newAddress;
  }

  void updateLga(String newLga) {
    selectedLga.value = newLga;
  }

  void updateCountry(String newCountry) {
    selectedCountry.value = newCountry;
  }

  void updateState(String newState) {
    selectedState.value = newState;
  }

  void updateNumber(String newNumber) {
    number.value = newNumber;
  }

  void updateContactName(String newName) {
    contactName.value = newName;
  }

  void toggleDefault() {
    isDefault.value = !isDefault.value;
  }

  Future<void> initializeCheckout(double amount) async {
    isLoading.value = true;
    print('Initializing checkout with amount: $amount');
    try {
      var checkoutData = {
        "amount": amount,
        "currency": "NGN",
        "callback_url": "http://127.0.0.1:8000",
        "metadata": {"notes": "This is a sample payment"},
        "payment_gateway": "paystack"
      };
      var response = await _apiService.getCheckoutData(checkoutData);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        // Handle successful response
        checkoutModel = checkoutModelFromJson(response.body);
        print('Checkout initialized successfully: ${checkoutModel.data?.url}');
        Navigator.push(
          Get.context!,
          CupertinoPageRoute(
            builder: (context) => AtomicWebViewScreen(
              url: checkoutModel.data?.url ?? '',
            ),
          ),
        );
      }
    } catch (e) {
      print('Error initializing checkout: $e');
      isLoading.value = false;
    } finally {
      isLoading.value = false;
    }
  }

  CartController cartController = Get.find<CartController>();

  Future<void> createOrder() async {
    isLoading.value = true;

    try {
      final payload = buildOrderPayload(
        cartItems: cartController.cartItems,
        orderDate: DateTime.now().toIso8601String(),
        addressId: 1,
        deliveryType: 'pickup',
        shippingFee: 2000,
        serviceCharge: 1000,
        vat: 0,
      );

// Send payload to backend
      var response = await apiService.createOrder(payload); // Example API call
      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        myLog.log(response.body, name:'Order body');
        orderSuccessModel = orderSuccessModelFromJson(response.body);
        Get.snackbar('Success', orderSuccessModel.message.toString(),
            colorText: Colors.white, backgroundColor: Colors.green);
            Navigator.pushAndRemoveUntil(
              Get.context!,
              MaterialPageRoute(builder: (context) => SuccessScreen()), // Replace with your target screen and URL
              (route) => false,
            );
      } else {
        Get.snackbar('Success', orderSuccessModel.message.toString(),
            colorText: Colors.white, backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString(),
          colorText: Colors.white, backgroundColor: Colors.red);
    } finally {
      isLoading.value = false;
    }
  }
}
