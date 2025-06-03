import 'package:get/get.dart';

class CheckoutController extends GetxController {

 RxString selectedAddress = ''.obs;
 RxString selectedLga = ''.obs;
 RxString selectedCountry = ''.obs;
 RxString selectedState = ''.obs;
RxString number = ''.obs;
 RxString address = ''.obs;
 RxString contactName = ''.obs;
 RxBool isDefault = false.obs;

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

  Future<void> initializeCheckout() async {
    // Perform any necessary initialization for the checkout process
    // This could include fetching user data, addresses, etc.
    // For example:
    // await fetchUserAddresses();
  }
}