import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_screen/atomicWebViewScreen/atomic_webview_screen.dart';
import 'package:jara_market/screens/checkout_screen/models/models.dart';
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
    try {
      var checkoutData = {
        "amount": amount,
        "currency": "NGN",
        "callback_url": "http://127.0.0.1:8000",
        "metadata": {
          "notes": "This is a sample payment"
        },
        "payment_gateway": "paystack"
      };
      var response = await _apiService.getCheckoutData();
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Handle successful response
        checkoutModel = checkoutModelFromJson(response.body);
        print('Checkout initialized successfully: ${checkoutModel.data?.url}');
        CupertinoPageRoute(
          builder: (context) =>
              AtomicWebViewScreen(url: checkoutModel.data?.url ?? ''),
        );
      }
    } catch (e) {
      print('Error initializing checkout: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
