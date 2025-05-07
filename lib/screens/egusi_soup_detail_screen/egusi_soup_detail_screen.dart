// lib/screens/egusi_soup_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/cart_screen.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/controller/egusi_soup_detail_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/rating_display.dart';

FoodDetailController controller = Get.put(FoodDetailController());

class FoodDetailScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const FoodDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int currentImageIndex = 0;

  final List<bool> ingredientSelected = List<bool>.filled(16, false);
  final TextEditingController ingredientController = TextEditingController();

  void addIngredient() {
    if (ingredientController.text.isNotEmpty) {
      setState(() {
        ingredientSelected.add(false);
        ingredientController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int selectedCount = ingredientSelected.where((selected) => selected).length;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: widget.item['name'],
        titleColor: Colors.orange,
        onBackPressed: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            SizedBox(
              height: 300,
              child: PageView.builder(
                itemCount: 5,
                onPageChanged: (index) {
                  setState(() {
                    currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    widget.item['image_url'],
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            // Carousel indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentImageIndex == index
                        ? Colors.blue
                        : Colors.grey[300],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.item['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      RatingDisplay(
                          rating:
                              double.parse(widget.item['rating'].toString()),
                          reviews: 0),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Ingredients',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 4.2,
                      mainAxisSpacing: 0,
                      crossAxisSpacing: 0,
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.item['ingredients'].length,
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${widget.item['ingredients'][index]['name']}',
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          // Checkbox(
                          //   value: ingredientSelected[index],
                          //   onChanged: (bool? value) {
                          //     setState(() {
                          //       ingredientSelected[index] = value ?? false;
                          //     });
                          //   },
                          // ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: TextField(
                  //         controller: ingredientController,
                  //         decoration: const InputDecoration(
                  //           hintText: 'Add new ingredient',
                  //           border: OutlineInputBorder(),
                  //         ),
                  //       ),
                  //     ),
                  //     const SizedBox(width: 8),
                  //     ElevatedButton(
                  //       onPressed: addIngredient,
                  //       child: const Text('Add'),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement video playback
                          },
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text('Watch Video'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey[300],
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: selectedCount >= 5
                              ? () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CartScreen()),
                                  );
                                }
                              : null,
                          child: const Text('Get Ingredients'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
