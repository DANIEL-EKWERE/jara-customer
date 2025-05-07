// lib/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/services/api_service.dart';
import '../../widgets/category_item.dart';
// import '../../widgets/promo_banner.dart';
// import '../../widgets/custom_bottom_nav.dart';
import '../soup_list_screen/soup_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import '../cart_screen/cart_screen.dart';

HomeController controller = Get.put(HomeController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //int _currentIndex = 0;
  final ApiService _apiService = ApiService();
  List<dynamic> _foodCategories = [];
  List<dynamic> _ingredients = [];
  List<dynamic> _foods = [];
  bool _isLoading = true;
  late Map<String, dynamic> userData;

  // Add search controller and filtered lists
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredFoodCategories = [];
  List<dynamic> _filteredIngredients = [];
  List<dynamic> _filteredFoods = [];

  @override
  void initState() {
    super.initState();
    try {
      _fetchFoodCategories();
      _fetchIngredients();
      _fetchFoods();
      _getPrefs();

      // Add listener for search
      _searchController.addListener(_filterItems);
    } catch (e, stackTrace) {
      print('Error in initState: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Failed to initialize: $e');
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Add filter function
  void _filterItems() {
    final String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredFoodCategories = _foodCategories.where((category) {
        final name = category['name']?.toString().toLowerCase() ?? '';
        final products = (category['products'] as List?)?.map(
                (product) => product['name']?.toString().toLowerCase() ?? '') ??
            [];
        return name.contains(query) ||
            products.any((product) => product.contains(query));
      }).toList();

      _filteredIngredients = _ingredients.where((ingredient) {
        final name = ingredient['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();

      _filteredFoods = _foods.where((food) {
        final name = food['name']?.toString().toLowerCase() ?? '';
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _getPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    userData = jsonDecode(prefs.getString('user_data') ?? '{}');
  }

  void _showErrorSnackBar(String message) {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Dismiss',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error showing snackbar: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  Future<void> _fetchFoodCategories() async {
    try {
      final response = await _apiService.fetchFoodCategory();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          setState(() {
            _foodCategories = decodedData;
            _filteredFoodCategories = decodedData; // Initialize filtered list
            _isLoading = false;
          });
        } catch (e, stackTrace) {
          print('Error decoding food categories: $e');
          print('Stack Trace: $stackTrace');
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('Failed to parse food categories data');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load categories: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching food categories: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading categories: $e');
    }
  }

  Future<void> _fetchIngredients() async {
    try {
      final response = await _apiService.fetchIngredients();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          setState(() {
            _ingredients = decodedData;
            _filteredIngredients = decodedData; // Initialize filtered list
            _isLoading = false;
          });
        } catch (e, stackTrace) {
          print('Error decoding ingredients: $e');
          print('Stack Trace: $stackTrace');
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('Failed to parse ingredients data');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load ingredients: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching ingredients: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading ingredients: $e');
    }
  }

  Future<void> _fetchFoods() async {
    try {
      final response = await _apiService.fetchFood();
      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final decodedData = jsonDecode(response.body);
          setState(() {
            _foods = decodedData;
            _filteredFoods = decodedData; // Initialize filtered list
            _isLoading = false;
          });
        } catch (e, stackTrace) {
          print('Error decoding foods: $e');
          print('Stack Trace: $stackTrace');
          setState(() {
            _isLoading = false;
          });
          _showErrorSnackBar('Failed to parse foods data');
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        _showErrorSnackBar('Failed to load foods: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('Error fetching foods: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Error loading foods: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Hello ${userData['name']},',
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: _searchController,
                                decoration: InputDecoration(
                                  hintText: 'Search foods, ingredients...',
                                  prefixIcon: const Icon(Icons.search),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: const Icon(Icons.clear),
                                          onPressed: () {
                                            _searchController.clear();
                                            _filterItems();
                                          },
                                        )
                                      : null,
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                           
                            _buildSection(
                              'Food & Recipes',
                              _filteredFoodCategories.map((category) {
                                try {
                                  return CategoryItem(
                                    title: category['name']?.toString() ??
                                        'Unnamed Category',
                                    imageUrl: category['products'][0]
                                                ['image_url']
                                            ?.toString() ??
                                        '',
                                    onTap: () {
                                      try {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SoupListScreen(
                                                      item: category)),
                                        );
                                      } catch (e, stackTrace) {
                                        print(
                                            'Error navigating to soup list: $e');
                                        print('Stack Trace: $stackTrace');
                                        _showErrorSnackBar(
                                            'Failed to open soup list');
                                      }
                                    },
                                  );
                                } catch (e, stackTrace) {
                                  print('Error building category item: $e');
                                  print('Stack Trace: $stackTrace');
                                  return const SizedBox.shrink();
                                }
                              }).toList(),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(bottom: 16.0),
                            //   child: _buildSection(
                            //     'Available Foods',
                            //     _foods.map((food) {
                            //       try {
                            //         return CategoryItem(
                            //           title: food['name']?.toString() ??
                            //               'Unnamed Food',
                            //           imageUrl:
                            //               food['image_url']?.toString() ?? '',
                            //           backgroundColor: Colors.orange[50]!,
                            //           onTap: () {
                            //             // TODO: Navigate to food detail page
                            //           },
                            //         );
                            //       } catch (e, stackTrace) {
                            //         print('Error building food item: $e');
                            //         print('Stack Trace: $stackTrace');
                            //         return const SizedBox.shrink();
                            //       }
                            //     }).toList(),
                            //   ),
                            // ),

                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                color: Colors.grey,
                                height: 24,
                              ),
                            ),

                            _buildSection(
                              'Popular Ingredients',
                              _filteredIngredients.map((ingredient) {
                                try {
                                  return CategoryItem(
                                    title: ingredient['name']?.toString() ??
                                        'Unnamed Ingredient',
                                    imageUrl:
                                        ingredient['image_url']?.toString() ??
                                            '',
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SoupListScreen(
                                                    item: ingredient)),
                                      );
                                    },
                                  );
                                } catch (e, stackTrace) {
                                  print('Error building ingredient item: $e');
                                  print('Stack Trace: $stackTrace');
                                  return const SizedBox.shrink();
                                }
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    } catch (e, stackTrace) {
      print('Error building home screen: $e');
      print('Stack Trace: $stackTrace');
      return Scaffold(
        body: Center(
          child: Text('Error loading screen: $e'),
        ),
      );
    }
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF333333),
            ),
          ),
        ),
        SizedBox(
          height: 120,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.5,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.vertical,
            itemCount: items.length,
            itemBuilder: (context, index) {
              return items[index];
            },
          ),
        ),
      ],
    );
  }
}
