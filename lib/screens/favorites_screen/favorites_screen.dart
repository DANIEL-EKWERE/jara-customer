import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/favorites_screen/controller/favorites_controller.dart';
import '../../models/food_item.dart';
import '../../widgets/food_item_card.dart';
import '../../services/api_service.dart';
import '../../services/favorites_service.dart';
import '../../services/cart_service.dart';

FavoritesController controller = Get.put(FavoritesController());

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  // ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  // final FavoritesService _favoritesService = FavoritesService();
  // final CartService _cartService = CartService();



  void showMoreOptionsBottomSheet(BuildContext context, FoodItem item) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading:
                    const Icon(Icons.shopping_cart, color: Color(0xFFFFAA00)),
                title: const Text('Add to Cart'),
                onTap: () {
                  Navigator.pop(context);
                  controller.addToCart(item);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove from Favorites'),
                onTap: () async {
                  try {
                    await controller.removeFavorite(int.parse(item.id));
                    Navigator.pop(context);
                    controller.fetchFavorites(); // Refresh the list
                    // if (mounted) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     const SnackBar(
                    //       content: Text('Removed from favorites'),
                    //       duration: Duration(seconds: 1),
                    //     ),
                    //   );
                    // }
                  } catch (e) {
                    Navigator.pop(context);
                    // if (mounted) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('Failed to remove: $e'),
                    //       backgroundColor: Colors.red,
                    //     ),
                    //   );
                    // }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    controller.fetchFavorites();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: Icon(Icons.chevron_left_rounded),
        title: Text(
                  'Favorites',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                  textAlign: TextAlign.center,
                ),
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Color(0xFFFFAA00)),
                        ),
                      )
                    : controller.favourite.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No favorites yet',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Items you favorite will appear here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.favourite.length,
                            itemBuilder: (context, index) {
                              final item = controller.favouriteItems[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: FoodItemCard(
                                  item: item,
                                  onAddToCart: () => controller.addToCart(item),
                                  onMoreOptions: () {
                                    showMoreOptionsBottomSheet(context, item);
                                  },
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
