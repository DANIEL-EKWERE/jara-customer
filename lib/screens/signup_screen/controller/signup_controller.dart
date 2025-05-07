import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/email_verification/email_verification.dart';
import 'package:jara_market/services/api_service.dart';

class SignupController extends GetxController {
  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) => _isLoading.value = value;
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

  Future<void> registerCustomer() async {
    isLoading = true;

    try {
      final customerData = {
        'firstname': firstNameController.text,
        'lastname': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'referral_code': referralCodeController.text, // Add referral code to customer data
      };
myLog.log('Customer Data: $customerData', name: 'SignupController');
      final response = await _apiService.registerCustomer(customerData);

  isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Navigator.push(
        //   Get.context!,
        //   MaterialPageRoute(
           //  builder: (context) => EmailVerificationScreen(email: emailController.text),
        //   ),
        // );
        Get.toNamed('/emailVerificationScreen', arguments: {
          'email': emailController.text,
        });
      } else {
      var  responseBody = jsonDecode(response.body);
         var message = responseBody['message'] ?? 'something went wrong';
        ScaffoldMessenger.of(Get.context!).showSnackBar(
         
          SnackBar(content: Text('Registration failed: ${message}')),
        );
      }
    } catch (e) {
    isLoading = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
        
      );
      myLog.log('Error: $e', name: 'SignupController');
    }
  }
}