import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/screens/profile_screen/models/model.dart';
import 'package:jara_market/services/api_service.dart';

class ProfileController extends GetxController {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));

  RxBool isLoading = false.obs;
  ProfileModel profileModel = ProfileModel(status: true, message: '', data: ProfileData());
  ProfileData data = ProfileData();

  Future<void> fetchUserProfile() async {
    isLoading.value = true;
    try {
      // Replace fetchUserProfile with getUser
      final response = await _apiService.getUser();

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = false;
        profileModel = profileModelFromJson(response.body);
        data = profileModel.data;
      } else {
        isLoading.value = false;

        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${response.body}')),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');

      isLoading.value = false;

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }finally{
isLoading.value = false;
    }
  }

  Future<void> updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      isLoading.value = true;
      var email = await dataBase.getEmail();
      final response = await _apiService.editUserProfile(email, updatedData);

      isLoading.value = false;

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh profile data
        fetchUserProfile();
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(Get.context!).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      isLoading.value = false;

      ScaffoldMessenger.of(Get.context!).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
