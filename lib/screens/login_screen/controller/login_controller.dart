import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/services/api_service.dart';

class LoginController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
RxBool isButtonEnabled = false.obs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

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
        final responseData = jsonDecode(response.body);

        // Save user data and token
       // await _saveUserData(responseData);
       var email = responseData['data']['email'];
        var token = responseData['token'];
        var userId = responseData['data']['user_id'];
        var firstName = responseData['data']['firstname'];
        var lastName = responseData['data']['lastname'];

        myLog.log('User Data: $responseData', name: 'LoginController');
        myLog.log('Email: $email', name: 'LoginController');
        myLog.log('Token: $token', name: 'LoginController');
        myLog.log('User ID: $userId', name: 'LoginController');
        myLog.log('First Name: $firstName', name: 'LoginController');
        myLog.log('Last Name: $lastName', name: 'LoginController');

        // Save token and user data to shared preferences
        await dataBase.saveToken(token);
        await dataBase.saveUserId(userId);
        await dataBase.saveEmail(email);
        await dataBase.saveFirstName(firstName);
        await dataBase.saveLastName(lastName);

          myLog.log(responseData.toString(), name: 'LoginController');
        // Navigate to home screen
        
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MainScreen()),
          // );

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