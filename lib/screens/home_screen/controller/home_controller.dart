import 'dart:convert';
import 'dart:developer' as myLog;
import 'package:get/get.dart';
import 'package:jara_market/screens/home_screen/models/food_model.dart';
import 'package:jara_market/screens/home_screen/models/models.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/widgets/snacknar.dart';

class HomeController extends GetxController {

ApiService apiService = ApiService(Duration(seconds: 60 * 5));
List<Categories> categories = <Categories>[];
RxList<Product> product = <Product>[].obs;

List<Food> foods = <Food>[];
RxList<Ingredient> ingredient = <Ingredient>[].obs;


  // List<dynamic> _foodCategories = [];
  // List<dynamic> get foodCategories => _foodCategories;
  // List<dynamic> _filteredFoodCategories = [];
  //List<dynamic> get filteredFoodCategories => _filteredFoodCategories;
  RxBool _isLoading = false.obs;
  RxBool isLoading1 = false.obs;
  RxBool get isLoading => _isLoading;

  @override
  void onInit() {
    super.onInit();
    fetchFoodCategories();
  //  fetchFoods();
  }

  // void filterFoodCategories(String query) {
  //   if (query.isEmpty) {
  //     _filteredFoodCategories = _foodCategories; // Reset to original list
  //   } else {
  //     _filteredFoodCategories = _foodCategories.where((category) {
  //       return category['name'].toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //   update(); // Notify listeners to update the UI
  // }



 Future<void> fetchFoodCategories() async {
      isLoading.value = true;
    try {
      final response = await apiService.fetchFoodCategory();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          
        categories = categoriesFromJson(response.body);
          myLog.log('Decoded Data: $decodedData', name: 'HomeController');
        
          // setState(() {
          //   _foodCategories = decodedData;
          //   _filteredFoodCategories = decodedData; // Initialize filtered list
            isLoading.value = false;
          // });
        } catch (e, stackTrace) {
          print('Error decoding food categories: $e');
          print('Stack Trace: $stackTrace');
          
            isLoading.value = false;
          
          showErrorSnackBar('Failed to parse food categories dataxxx');
        }
      } else {
        
          isLoading.value = false;
        
        showErrorSnackBar('Failed to load categories: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching food categories: $e');
      print('Stack Trace: $stackTrace');
      
        isLoading.value = false;
      
      showErrorSnackBar('Error loading categories: $e');
    }
  }

  // Future<void> fetchIngredients() async {
  //   try {
  //     final response = await apiService.fetchIngredients();
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       try {
  //         final decodedData = jsonDecode(response.body);
  //         // setState(() {
  //         //   ingredients = decodedData;
  //         //   filteredIngredients = decodedData; // Initialize filtered list
  //           isLoading1.value = false;
  //         // });
  //       } catch (e, stackTrace) {
  //         print('Error decoding ingredients: $e');
  //         print('Stack Trace: $stackTrace');
          
  //           isLoading1.value = false;
          
  //         showErrorSnackBar('Failed to parse ingredients data');
  //       }
  //     } else {
        
  //         isLoading1.value = false;
        
  //       showErrorSnackBar('Failed to load ingredients: ${response.body}');
  //     }
  //   } catch (e, stackTrace) {
  //     print('Error fetching ingredients: $e');
  //     print('Stack Trace: $stackTrace');
      
  //       isLoading1.value = false;
      
  //     showErrorSnackBar('Error loading ingredients: $e');
  //   }
  // }

  Future<void> fetchFoods() async {
    try {
      final response = await apiService.fetchFood();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          myLog.log('Decoded Data: $decodedData', name: 'HomeController');
          foods = foodFromJson(response.body);
          myLog.log('Foods: $foods', name: 'HomeController');
            // _foods = decodedData;
            // _filteredFoods = decodedData; // Initialize filtered list
            isLoading1.value = false;
          
        } catch (e, stackTrace) {
          print('Error decoding foods: $e');
          print('Stack Trace: $stackTrace');
          
            isLoading1.value = false;
          
          showErrorSnackBar('Failed to parse foods data');
        }
      } else {
        
          isLoading1.value = false;
        
        showErrorSnackBar('Failed to load foods: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching foods: $e');
      print('Stack Trace: $stackTrace');
      
        isLoading1.value = false;
      
      showErrorSnackBar('Error loading foods: $e');
    }
  }


}