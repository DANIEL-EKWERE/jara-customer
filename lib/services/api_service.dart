import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:get/get_connect/connect.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // Import foundation for kDebugMode
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

const API_TIMEOUT_INT_SECONDS = 60 * 5;
const API_TIMEOUT_DURATION = const Duration(seconds: API_TIMEOUT_INT_SECONDS);


class ApiService extends GetConnect {
    Duration timeout = API_TIMEOUT_DURATION;

  ApiService(this.timeout) : super(timeout: timeout);

   var baseUrl = 'https://admin.jaramarket.com.ng/api/jaram';
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);

Future<String?> fn_getCurrentBearerToken() async {
    return await 'dataBase.getToken()';
  }

  fn_generateCacheBuster([int length = 30]) {
    // Define the set of characters to use for the string
    const String chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';

    // Create an instance of Random
    final Random randomizer = Random();

    // Generate the string by randomly selecting characters
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(randomizer.nextInt(chars.length))));
  }
  // Helper function for logging
  void _logRequest(String method, Uri url, {dynamic body}) {
    if (kDebugMode) {
      print('--- API Request ---');
      print('Method: $method');
      print('URL: $url');
      if (body != null) {
        print('Body: ${jsonEncode(body)}');
      }
      print('-------------------');
    }
  }

  void _logResponse(http.Response response) {
    if (kDebugMode) {
      print('--- API Response ---');
      print('Status Code: ${response.statusCode}');
      print('URL: ${response.request?.url}');
      try {
        // Attempt to decode and print if JSON, otherwise print raw body
        final decodedBody = jsonDecode(response.body);
        print('Body: ${jsonEncode(decodedBody)}'); // Pretty print JSON
      } catch (e) {
        print('Body: ${response.body}'); // Print as is if not JSON
      }
      print('--------------------');
    }
  }

  Future<http.Response> _retryRequest(
      Future<http.Response> Function() request) async {
    int attempts = 0;
    while (attempts < maxRetries) {
      try {
        final response = await request();
        return response;
      } catch (e) {
        attempts++;
        if (attempts == maxRetries) {
          rethrow;
        }
        if (kDebugMode) {
          print(
              'Request failed, retrying in ${retryDelay.inSeconds} seconds... (Attempt $attempts of $maxRetries)');
        }
        await Future.delayed(retryDelay);
      }
    }
    throw Exception('Failed after $maxRetries attempts');
  }

  // // Register a new user
  // Future<http.Response> registerCustomer(
  //     Map<String, dynamic> customerData) async {
  //   final url = Uri.parse('$baseUrl/registerUser');
  //   _logRequest('POST', url, body: customerData);
  //   final response = await http.post(
  //     url,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(customerData),
  //   );
  //   _logResponse(response);
  //   return response;
  // }

  Future<http.Response> registerCustomer(
    Map<String, dynamic> customerData) async {
  final url = Uri.parse('$baseUrl/register');
  _logRequest('POST', url, body: customerData);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(customerData),
  );
  _logResponse(response);
  return response;
}



Future<http.Response> resendOtp(
    Map<String, dynamic> customerData) async {
  final url = Uri.parse('$baseUrl/resend-otp');
  _logRequest('POST', url, body: customerData);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(customerData),
  );
  _logResponse(response);
  return response;
}

Future<http.Response> forgotPassword(
    Map<String, dynamic> customerData) async {
  final url = Uri.parse('$baseUrl/forgot-password');
  _logRequest('POST', url, body: customerData);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(customerData),
  );
  _logResponse(response);
  return response;
}


Future<http.Response> resetPassword(
    Map<String, dynamic> customerData) async {
  final url = Uri.parse('$baseUrl/reset-password');
  _logRequest('POST', url, body: customerData);
  final response = await http.post(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
    },
    body: jsonEncode(customerData),
  );
  _logResponse(response);
  return response;
}

Future<http.Response> fetchCountry() async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/country');
  _logRequest('GET', url);
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}

Future<http.Response> fetchState() async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/states');
  _logRequest('GET', url);
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}


Future<http.Response> fetchLgas(String name) async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/lgas?state=$name');
  _logRequest('GET', url);
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}

Future<http.Response> updateCheckoutAddress(Map<String, dynamic> addressData) async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/addresses/1');
  _logRequest('PUT', url, body: addressData);
  final response = await http.put(
    url,
    body: jsonEncode(addressData),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}

Future<http.Response> addCheckoutAddress(Map<String, dynamic> addressData) async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/addresses');
  _logRequest('POST', url, body: addressData);
  final response = await http.post(
    url,
    body: jsonEncode(addressData),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}

Future<http.Response> getCheckoutAddress() async {
  var token = await dataBase.getToken();
  final url = Uri.parse('$baseUrl/addresses');
  _logRequest('GET', url);
  final response = await http.get(
    url,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  _logResponse(response);
  return response;
}

  // Validate user signup OTP
  Future<http.Response> validateUserSignupOtp(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }


  // Validate user signup Email
  Future<http.Response> validateUserSignupEmail(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-email');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Login user
  Future<http.Response> login(Map<String, dynamic> loginData) async {
    final url = Uri.parse('$baseUrl/login');
    _logRequest('POST', url, body: loginData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(loginData),
    );
    _logResponse(response);
    return response;
  }

  // Validate user login OTP
  Future<http.Response> validateUserLoginOtp(
      Map<String, dynamic> otpData) async {
    final url = Uri.parse('$baseUrl/validate-otp');
    _logRequest('POST', url, body: otpData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      },
      body: jsonEncode(otpData),
    );
    _logResponse(response);
    return response;
  }

  // Fetch food categories
  Future<http.Response> fetchFoodCategory() async {
    //final url = Uri.parse('$baseUrl/fetch-ProductCategory');
    //final url = Uri.parse('$baseUrl/fetch/categories-limit-products');
    final url = Uri.parse('$baseUrl/fetch/categories-all-products');
    
    _logRequest('GET', url);
    // final prefs = await SharedPreferences.getInstance();
    // final token = prefs.getString('token');
    var token = await dataBase.getToken();
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json;',
          'Authorization': 'Bearer $token',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // Fetch food products
  Future<http.Response> fetchFood() async {
    final url = Uri.parse('$baseUrl/fetch/categories-limit-products');
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // Fetch ingredients
  Future<http.Response> fetchIngredients() async {
    final url = Uri.parse('$baseUrl/fetch-product?type=ingredient');
    _logRequest('GET', url);
    return _retryRequest(() async {
      final response = await http.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw TimeoutException('Request timed out');
        },
      );
      _logResponse(response);
      return response;
    });
  }

  // Create order (used in checkout_screen.dart)
  Future<http.Response> createOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/create-order');
    _logRequest('POST', url, body: orderData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Fetch user profile
  Future<http.Response> fetchUserProfile(String email) async {
    final url = Uri.parse('$baseUrl/fetchUserProfile/$email');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Edit user profile
  Future<http.Response> editUserProfile(
      String email, Map<String, dynamic> profileData) async {
    final url = Uri.parse('$baseUrl/edit-user-profile/$email');
    _logRequest('POST', url, body: profileData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(profileData),
    );
    _logResponse(response);
    return response;
  }

  // Get current user
  Future<http.Response> getUser() async {
    final email = await dataBase.getEmail(); 
    final url = Uri.parse('$baseUrl/fetch-user/${email}');
    _logRequest('GET', url);
    //final prefs = await SharedPreferences.getInstance();
    final token = await dataBase.getToken();  //prefs.getString('token');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new order
  Future<http.Response> postOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('POST', url, body: orderData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Get all orders
  Future<http.Response> getOrders() async {
    final url = Uri.parse('$baseUrl/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Cancel an order
  Future<http.Response> cancelOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/cancel');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get cart by ID
  Future<http.Response> getCart(String cartId) async {
    final url = Uri.parse('$baseUrl/carts/$cartId');
    _logRequest('GET', url);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order by ID
  Future<http.Response> getOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update order by ID
  Future<http.Response> updateOrder(
      String orderId, Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('PUT', url, body: orderData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(orderData),
    );
    _logResponse(response);
    return response;
  }

  // Delete order by ID
  Future<http.Response> deleteOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get order receipt
  Future<http.Response> getOrderReceipt(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/receipt');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Track order
  Future<http.Response> trackOrder(String orderId) async {
    final url = Uri.parse('$baseUrl/orders/$orderId/track');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get orders for a specific user
  Future<http.Response> getUserOrders(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new payment
  Future<http.Response> createPayment(Map<String, dynamic> paymentData) async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('POST', url, body: paymentData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(paymentData),
    );
    _logResponse(response);
    return response;
  }

  // Get all payments
  Future<http.Response> getPayments() async {
    final url = Uri.parse('$baseUrl/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Handle payment callback
  Future<http.Response> handlePaymentCallback(
      Map<String, dynamic> callbackData) async {
    final url = Uri.parse('$baseUrl/payments/callback');
    _logRequest('GET', url); // Assuming GET, adjust if needed
    final response = await http.get(
      url, // Assuming query parameters are handled elsewhere or not needed for logging body
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Fund wallet
  Future<http.Response> fundWallet(Map<String, dynamic> fundData) async {
    final url = Uri.parse('$baseUrl/wallets/fund');
    _logRequest('POST', url, body: fundData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(fundData),
    );
    _logResponse(response);
    return response;
  }

  // Get all franchises
  Future<http.Response> getFranchises() async {
    final url = Uri.parse('$baseUrl/franchises');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get all users
  Future<http.Response> getUsers() async {
    final url = Uri.parse('$baseUrl/users');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Update a user
  Future<http.Response> updateUser(
      String userId, Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('PUT', url, body: userData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(userData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a user
  Future<http.Response> deleteUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Toggle user status
  Future<http.Response> toggleUserStatus(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId/toggle-status');
    _logRequest('PATCH', url); // Assuming PATCH, adjust if needed
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Add body here if the PATCH request sends data
    );
    _logResponse(response);
    return response;
  }

  // Get all settings
  Future<http.Response> getSettings() async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create or update settings
  Future<http.Response> updateSettings(
      Map<String, dynamic> settingsData) async {
    final url = Uri.parse('$baseUrl/settings');
    _logRequest('POST', url,
        body: settingsData); // Assuming POST for create/update
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(settingsData),
    );
    _logResponse(response);
    return response;
  }

  // Get all categories
  Future<http.Response> getCategories() async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new category
  Future<http.Response> createCategory(
      Map<String, dynamic> categoryData) async {
    final url = Uri.parse('$baseUrl/categories');
    _logRequest('POST', url, body: categoryData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Update a category
  Future<http.Response> updateCategory(
      String categoryId, Map<String, dynamic> categoryData) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('PUT', url, body: categoryData);
    final response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(categoryData),
    );
    _logResponse(response);
    return response;
  }

  // Delete a category
  Future<http.Response> deleteCategory(String categoryId) async {
    final url = Uri.parse('$baseUrl/categories/$categoryId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Create a new food item
  Future<http.Response> createFood(Map<String, dynamic> foodData) async {
    final url = Uri.parse('$baseUrl/foods');
    _logRequest('POST', url, body: foodData);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(foodData),
    );
    _logResponse(response);
    return response;
  }

  // Get order reports
  Future<http.Response> getOrderReports() async {
    final url = Uri.parse('$baseUrl/reports/orders');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get payment reports
  Future<http.Response> getPaymentReports() async {
    final url = Uri.parse('$baseUrl/reports/payments');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    _logResponse(response);
    return response;
  }

  // Get user's favorites
  Future<http.Response> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('GET', url);
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  // Add to favorites
  Future<http.Response> addToFavorites(int productId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'product_id': productId}),
    );
    _logResponse(response);
    return response;
  }

  // Remove from favorites
  Future<http.Response> removeFromFavorites(int favoriteId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/favorites/$favoriteId');
    _logRequest('DELETE', url);
    final response = await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  addFavorite() {}

  logOut() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/logout');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }

  getCheckoutData(Map<String, dynamic> checkoutData) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse('$baseUrl/payments/initialize-transaction');
    _logRequest('POST', url);
    final response = await http.post(
      url,
      body: jsonEncode(checkoutData),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
    );
    _logResponse(response);
    return response;
  }
}
ApiService apiService = ApiService(API_TIMEOUT_DURATION);