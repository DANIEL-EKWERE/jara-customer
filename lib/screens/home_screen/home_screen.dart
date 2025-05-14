import 'dart:developer' as myLog;
// lib/screens/home_screen.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/local_storage.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/services/api_service.dart';
import 'package:jara_market/widgets/snacknar.dart';
import '../../widgets/category_item.dart';
import '../soup_list_screen/soup_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

HomeController controller = Get.put(HomeController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  List<dynamic> _foodCategories = [];
  List<dynamic> _ingredients = [];
  List<dynamic> _foods = [];
  bool _isLoading = true;
  late Map<String, dynamic> userData;

  String? name;

  // Add search controller and filtered lists
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _filteredFoodCategories = [];
  List<dynamic> _filteredIngredients = [];
  List<dynamic> _filteredFoods = [];

  void getUserName() async {
    var name1 = await dataBase.getFirstName() ?? 'N/A';
    if (mounted) {  // Added mounted check
      setState(() {
        name = name1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    controller.fetchFoodCategories();
    // Uncomment this when you implement filtering
    // _searchController.addListener(_filterItems);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        body: SafeArea(
          child: Obx(() {
            return controller.isLoading.value
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      // Header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello ${name ?? "User"},',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                      // Uncomment when implemented
                                      // _filterItems();
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
                      
                      // Category sections inside ListView
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.categories.length, // Only one section for now, you can add more sections as needed
                          separatorBuilder: (context, index) => const Divider(height: 24),

                          itemBuilder: (context, sectionIndex) {
                            
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    controller.categories[sectionIndex].name.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                        fontFamily: 'Mont',

                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // Fixed height container for the grid
                                SizedBox(
                                  // Calculate height based on number of rows needed
                                  height: (controller.categories[sectionIndex].products!.length / 4).ceil() * 100.0,
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(), // Disable grid scrolling
                                    itemCount: controller.categories[sectionIndex].products!.length,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemBuilder: (context, index) {
                                      final category = controller.categories[sectionIndex].products;
                                      return GestureDetector(
                                        onTap: () {
                                          // Handle category tap
                                          print('Tapped on category: $category');
                                          myLog.log('product image ${category[sectionIndex].imageUrl}');
                                        //  Get.toNamed('/soupList_screen');
                                         // CupertinoPageRoute(builder: (context) => const SoupListScreen(item: {}),);
                                           
                              //       Navigator.push(
                              // Get.context!,
                              // CupertinoPageRoute(
                              //   builder: (context) => const SoupListScreen(item: {}),
                              // ),);
                                        },
                                        child: Column(
                                          
                                          children: [
                                            Container(
                                            //  margin: EdgeInsets.all(5),
                                              padding: EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey[200],
                                               // borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: 
                                              
                                              Center(
                                                child: category![index].imageUrl != null ? Image.network(
                                                  category[index].imageUrl,
                                                  fit: BoxFit.contain,
                                                  
                                                ): SvgPicture.asset('assets/images/product_image.svg'),
                                              ),
                                            ),
                                            SizedBox(height: 5,),
                                            Text(category[index].name.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.w600,fontFamily: 'Mont'),)
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  );
          }),
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
}