import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/grains_screen/controller/grains_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/product_card.dart';
import '../grains_detailed_screen/grains_detailed_screen.dart'; // Import GrainsDetailedScreen
import '../../services/favorites_service.dart'; // Import FavoritesService

GrainsController controller = Get.put(GrainsController());

class GrainsScreen extends StatefulWidget {
  const GrainsScreen({Key? key}) : super(key: key);

  @override
  State<GrainsScreen> createState() => _GrainsScreenState();
}

class _GrainsScreenState extends State<GrainsScreen> {
  // List to track favorite status of products
  final List<bool> _favorites = List.generate(6, (_) => false);

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load saved favorites from service
  Future<void> _loadFavorites() async {
    for (int i = 0; i < _favorites.length; i++) {
      final productId = 'grain_$i'; // Create unique product IDs
      // final isFavorite = await FavoritesService().isFavorite(productId);
      if (mounted) {
        setState(() {
          _favorites[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Grains',
        titleColor: Colors.orange,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return ProductCard(
            imageAsset: 'assets/images/mama-gold-rice.jpg',
            title: index % 2 == 0 ? 'Rice' : 'Beans',
            rating: 4.3,
            reviews: 41,
            isMostOrdered: index == 0,
            isFavorite: _favorites[index], // Pass current favorite status
            onFavoritePressed: () {
              // Implement favorite toggle
              final productId = 'grain_$index';
              setState(() {
                _favorites[index] = !_favorites[index];
              });

              // Update favorite status in service
              if (_favorites[index]) {
                FavoritesService().addToFavorites(int.parse(productId));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Added ${index % 2 == 0 ? 'Rice' : 'Beans'} to favorites'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        setState(() {
                          _favorites[index] = false;
                        });
                        FavoritesService()
                            .removeFromFavorites(int.parse(productId));
                      },
                    ),
                  ),
                );
              } else {
                FavoritesService().removeFromFavorites(int.parse(productId));
              }
            },
            onTap: () {
              if (index % 2 == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GrainsDetailedScreen()),
                );
              }
            },
            price: 85000.0,
            originalPrice: 90000.0,
            isTopSeller: true,
          );
        },
      ),
    );
  }
}
