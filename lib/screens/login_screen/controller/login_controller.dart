import 'package:jara_market/main.dart';
import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/login_screen/models/models.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/services/api_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  RxBool isButtonEnabled = false.obs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  LoginModel loginModel = LoginModel(status: true, message: '', data: LoginData());
LoginData data = LoginData();

  set isLoading(bool value) {
    _isLoading = value;
    update();
  }

  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

  Future<void> login() async {
    // if (!_formKey.currentState!.validate()) {
    //   return;
    // }

    isLoading = true;

    try {
      final response = await _apiService.login({
        'email': emailController.text,
        'password': passwordController.text,
      });

      isLoading = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        loginModel = loginModelFromJson(response.body);
        data = loginModel.data;

        // Save token and user data to shared preferences
        await dataBase.saveToken(data.token ?? 'N/A');         
        await dataBase.saveUserId(data.id!.toInt()); //data.id is int ? data.id as int : 0
        await dataBase.saveFirstName(data.firstname ?? 'N/A');
        await dataBase.saveLastName(data.lastname ?? 'N/A');
        await dataBase.saveFullName(data.name ?? 'N/A');
        await dataBase.saveEmail(data.email ?? 'N/A');
        await dataBase.savePhoneNumber(data.phoneNumber ?? 'N/A');
        await dataBase.saveRole(data.role ?? 'N/A');
        await dataBase.saveReferalCode(data.referralCode ?? 'N/A');
        await dataBase.saveReferalCount(data.referralCount ?? 'N/A');
        await dataBase.saveRefererId(data.referrerId ?? 'N/A');

         emailController.dispose();
    passwordController.dispose();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Success: ${loginModel.message}'),
            backgroundColor: Colors.green,
          ),
        );
        Get.offAllNamed('/main_screen');
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(
            content: Text('Login failed: ${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      isLoading = false;

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(
          content: Text('Error during login: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
