import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';

class ReferralController extends GetxController {
  RxBool isLoading = false.obs;
ReferalModel referalModel = ReferalModel();
RxList<Data> data = <Data>[].obs;
  ApiService apiClient = ApiService(const Duration(seconds: 60 * 5));

  Future<void> fetchReferals() async {
    isLoading.value = true;

    try {
      var response = await apiClient.fetchReferal();

      if (response.statusCode == 200 || response.statusCode == 201) {
        isLoading.value = true;
        referalModel = referalModelFromJson(response.body);
        data.value = referalModel.data!;
        
      } else {
        isLoading.value = true;
        myLog.log(jsonDecode(response.body));
      }
    } catch (e) {
      isLoading.value = true;
      myLog.log(e.toString());
    } finally {
      isLoading.value = true;
    }
  }
}
