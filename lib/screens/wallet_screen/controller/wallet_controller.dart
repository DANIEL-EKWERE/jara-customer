import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/wallet_screen/models/models.dart';
import 'package:jara_market/screens/wallet_screen/models/single_transaction_model.dart';
import 'package:jara_market/screens/wallet_screen/models/transaction_model.dart';
import 'package:jara_market/screens/wallet_screen/receipt.dart';
import 'package:jara_market/services/api_service.dart';
import 'dart:developer' as myLog;

import 'package:overlay_kit/overlay_kit.dart';

class WalletController extends GetxController {
  ApiService apiService = ApiService(Duration(seconds: 60 * 5));
  RxBool isLoading = false.obs;
  RxBool isTransactionLoading = false.obs;
  RxBool isTransactionLoading1 = false.obs;
  WalletModel walletModel = WalletModel(
      status: false,
      message: 'error retrieving balance',
      data: Data(id: 0, balance: 'N/A'));
  TransactionModel transactionModel = TransactionModel(data: []);
  SingleTransactionModel singleTransactionModel = SingleTransactionModel();
  SingleTransactionData? singleTransactionData;
  RxList<TransactionData> transactions = <TransactionData>[].obs;
  TransactionData transactionData = TransactionData(
      id: 1,
      txnRef: '',
      amount: '0',
      userName: '',
      transactionMode: '',
      gatewayResponse: '',
      provider: '',
      status: 'failed',
      createdAt: '');
  @override
  onInit() {
    super.onInit();
    fetchWallet();
    fetchTransactions();
  }

  Future<void> fetchWallet() async {
    isLoading.value = true;

    var response = await apiService.fetchWallet();

    if (response.statusCode == 200 || response.statusCode == 201) {
      isLoading.value = false;
      walletModel = walletModelFromJson(response.body);
      Get.snackbar('Success', 'Wallet updated successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ));
    }
  }

  Future<double> fetchBalance() async {
    isLoading.value = true;

    var response = await apiService.fetchWallet();

    if (response.statusCode == 200 || response.statusCode == 201) {
      isLoading.value = false;
      walletModel = walletModelFromJson(response.body);
      Get.snackbar('Success', 'Wallet updated successfully',
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: Icon(
            Icons.check,
            color: Colors.white,
          ));
          return double.tryParse(walletModel.data!.balance.toString()) ?? 0.0;
    }
    return -1;
  }

  Future<void> fetchTransactions() async {
    isTransactionLoading.value = true;
    try {
      var response = await apiService.fetchTransactions();
      if (response.statusCode == 200 || response.statusCode == 201) {
        isTransactionLoading.value = false;
        myLog.log(response.body);
        transactionModel = transactionModelFromJson(response.body);
        transactions.value = transactionModel.data;
        myLog.log('printing Transactions: ${transactions.length}',
            name: 'Transaction Data List');
      }
      ;
    } catch (e) {
      isTransactionLoading.value = false;
      myLog.log(e.toString());
    } finally {
      isTransactionLoading.value = false;
    }
  }

  Future<void> fetchTransaction(int id) async {
    OverlayLoadingProgress.start(circularProgressColor: Colors.amber);
    isTransactionLoading1.value = true;
    try {
      var response = await apiService.fetchTransaction(id);
      if (response.statusCode == 200 || response.statusCode == 201) {
        isTransactionLoading1.value = false;
        OverlayLoadingProgress.stop();
        myLog.log(response.body);
        singleTransactionModel = singleTransactionModelFromJson(response.body);
        singleTransactionData = singleTransactionModel.data;
        myLog.log('printing Transactions: ${transactions.length}',
            name: 'Transaction Data List');
            Navigator.of(Get.context!).push(CupertinoPageRoute(builder: (context)=> Receipt(singleTransactionData: singleTransactionData!)));
      }
      ;
    } catch (e) {
      isTransactionLoading1.value = false;
      OverlayLoadingProgress.stop();
      myLog.log(e.toString());
    } finally {
      isTransactionLoading1.value = false;
      OverlayLoadingProgress.stop();
    }
  }
}
