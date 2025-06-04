import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/wallet_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';

class WalletController extends GetxController {
ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;
WalletModel walletModel = WalletModel(status: false,message: 'error retrieving balance', data: Data(id:0,balance: 'N/A'));

@override
onInit(){
super.onInit();
fetchWallet();
}
  Future<void> fetchWallet() async{
    isLoading.value = true;

    var response = await apiService.fetchWallet();

    if (response.statusCode == 200 || response.statusCode == 201){
      isLoading.value = false;
        walletModel = walletModelFromJson(response.body);
        Get.snackbar('Success', 'Wallet updated successfully', colorText: Colors.white, backgroundColor: Colors.green,icon: Icon(Icons.check,color: Colors.white,));
    }
  }
}