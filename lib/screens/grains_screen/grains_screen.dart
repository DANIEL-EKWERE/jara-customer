import 'dart:developer' as myLog;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/grains_screen/controller/grains_controller.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/custom_app_bar.dart';
import '../grains_detailed_screen/grains_detailed_screen.dart'; // Import GrainsDetailedScreen
import 'package:jara_market/screens/cart_screen/models/models.dart';
// import 'package:jara_market/screens/cart_screen/models/models.dart';

GrainsController controller = Get.put(GrainsController());
CartController cartController = Get.find<CartController>();
class GrainsScreen extends StatefulWidget {
  const GrainsScreen({Key? key, required this.forProduct, this.ingredients}) : super(key: key);
  final bool forProduct;
  final List<Ingredients>? ingredients;
  @override
  State<GrainsScreen> createState() => _GrainsScreenState();
}

class _GrainsScreenState extends State<GrainsScreen> {
// List<Ingredients> ingredients = [];
List<Ingredients> ingredientShoping = [];
  @override
  void initState() {
    super.initState();
    //controller.fetchIngredients();
    controller.fetchIngredientByCondition();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onrefresh() {
    controller.fetchIngredients();
  }


  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Ingredients',
        titleColor: Colors.orange,
        onBackPressed: () {
          Navigator.pop(context);
          myLog.log(widget.ingredients.toString());
          if(Navigator.canPop(context)){
            myLog.log('i can pop');
            // Navigator.pop(context, {
            //   "result":ingredients
            // });
          }else{
            myLog.log('i can\'t pop');
          }
    print('object');
        },
      ),
      body: SmartRefresher(
        onRefresh: _onrefresh,
        controller: _refreshController,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search ingredients...',
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
            Expanded(
              child:
                 
                  Obx((){
                    return controller.isLoading.value ? Center(child: CircularProgressIndicator(color: Colors.amber,),) : GridView.builder(
                physics:
                    NeverScrollableScrollPhysics(), // Disable grid scrolling
                itemCount:
                    // controller.category[sectionIndex].products!.length - 1 > 8
                    //     ? 8
                    //     :
                    controller.dataList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 7.0,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final ingredient = controller.dataList[index];
                  return GestureDetector(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                insetPadding: EdgeInsets.zero,
                                contentPadding: EdgeInsets.only(
                                    right: 16, left: 24, top: 0, bottom: 16),
                                backgroundColor: Colors.grey[100],
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        ingredient.name.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Icon(Icons
                                                .cancel_presentation_rounded))),
                                  ],
                                ),
                                content:
                                    // Text(
                                    //     "This is a popup modal!"),
                                    Container(
                                  height: 273,
                                  decoration: BoxDecoration(
                                      //  color: Colors.grey[400]
                                      ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "\u20A6${ingredient.price}",
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontFamily: 'Roboto',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            ' Per Portion',
                                            style: TextStyle(
                                                color: Colors.grey[400],
                                                fontSize: 10),
                                          ),
                                          Spacer(),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () async {
                                                },
                                                icon:
                                                    Icon(Icons.favorite_border_rounded)),
                                          )
                                        ],
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "${ingredient.unit} unit of measurement",
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                            fontFamily: 'Roboto',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 150,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20)),
                                            border: Border.all(
                                                width: 10,
                                                color: Colors.white)),
                                        child: Container(
                                          // widthFactor: 10.5,
                                          // heightFactor: 10.5,
                                          child: ingredient.imageUrl != null
                                              ?
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ingredient
                                                        .imageUrl
                                                        .toString(),
                                                    placeholder:
                                                        (context, url) =>
                                                            const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: Center(
                                                        child:
                                                            const SpinKitPulse(
                                                          color: Colors
                                                              .amber, // You can use any color
                                                          size:
                                                              24.0, // Customize size
                                                        ),
                                                      ),
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                    width: context.width * 0.6,
                                                    height: 40,
                                                    fit: BoxFit.cover,
                                                  ))
                                              : SvgPicture.asset(
                                                  'assets/images/product_image.svg'),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        height: 53,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12)),
                                            color: Colors.amber[50]),
                                        child: Text(
                                            '*${ingredient.description}\n We also Offer meal prep as well!!!'),
                                      )
                                    ],
                                  ),
                                ),
                                actions: [
                                  Row(
                                    spacing: context.width * 0.02,
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                            height: 40,
                                         //   width: 110,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  elevation: 0,
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 8, vertical: 6),
                                                  backgroundColor: Colors.white,
                                                  foregroundColor:
                                                      Color(0xffffffff),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(4),
                                                    side: BorderSide(
                                                        color: Colors.blueGrey),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // Navigator.of(context).pop();
                                                  // Navigator.of(context).push(CupertinoPageRoute(
                                                  //     builder: (context) => FoodDetailScreen(
                                                  //           item: category[index],
                                                  //         )));
                                                  print(
                                                      'Add to cart pressed ${ingredient.name}');
                                                  //TODO: implemet popping back to ingredient in food or just ingredient
                                                  // cartController.addToCart(CartItem(
                                                  //   id: category[index].id!,
                                                  //   name: category[index].name!,
                                                  //   description: category[index]
                                                  //           .description ??
                                                  //       'N/A',
                                                  //   price: double.tryParse(
                                                  //           category[index]
                                                  //               .price!
                                                  //               .toString()) ??
                                                  //       0.0,
                                                  //   originalPrice: double.tryParse(
                                                  //           category[index]
                                                  //               .price!
                                                  //               .toString()) ??
                                                  //       0.0,
                                                  //   ingredients: category[index]
                                                  //       .ingredients!
                                                  //       .map((ingredient) =>
                                                  //           Ingredients(
                                                  //             id: ingredient.id!,
                                                  //             name: ingredient.name,
                                                  //             description:
                                                  //                 ingredient
                                                  //                     .description,
                                                  //             price: double.tryParse(
                                                  //                     ingredient
                                                  //                         .price
                                                  //                         .toString()) ??
                                                  //                 0.0,
                                                  //           ))
                                                  //       .toList(),
                                                  // ));
                                        if(widget.forProduct) widget.ingredients!.add(Ingredients(id: ingredient.id!,createdAt: ingredient.createdAt, description: ingredient.description, imageUrl: ingredient.imageUrl, name: ingredient.name, price: double.tryParse(ingredient.price.toString()) ?? 0.0,basePrice: double.tryParse(ingredient.price.toString()) ?? 0.0, quantity: 1));
                                        else cartController.addIngredientToCart(ingredient );
                                        // ingredientList.map((e) {
                                        //   Ingredients(id: DateTime.now().millisecondsSinceEpoch,
                                        //   price: e.price,
                                        //   description: e.description,
                                        //   name: e.name,
                                        //   );
                                        // });
                                        // cartController.addToCart(CartItem(id: 110, name: 'Ingredients',originalPrice: 0.0, description: 'ingredient shoping', price: 0.0, ingredients: ingredientShoping.map((e){
                                        //   return Ingredients(
                                        //     id: e.id,
                                        //     //createdAt: e.createdAt,
                                        //     description: e.description,
                                        //     //imageUrl: e.imageUrl,
                                        //     name: e.name,
                                        //     price: e.price,
                                        //    // quantity: e.quantity,
                                        //    // unit: e.unit,
                                        //   );
                                        // }).toList())); //add(ingredient)));
                                        // cartController.addToCart(CartItem(
                                        //                                               id: category[index].id!,
                                        //                                               name: category[index].name!,
                                        //                                               description: category[index].description ?? 'N/A',
                                        //                                               price: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                        //                                               originalPrice: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                        //                                               ingredients: category[index]
                                        //                                                   .ingredients!
                                        //                                                   .map((ingredient) => Ingredients(
                                        //                                                         id: ingredient.id!,
                                        //                                                         name: ingredient.name,
                                        //                                                         description: ingredient.description,
                                        //                                                         price: double.tryParse(ingredient.price.toString()) ?? 0.0,
                                        //                                                       ))
                                        //                                                   .toList(),
                                        //                                             ));
                                      //  myLog.log('added to cart ${widget.ingredients!.toList()}');
                                        Get.snackbar('Success', 'Item added to cart',colorText: Colors.white,backgroundColor: Colors.green);
                                        Navigator.pop(context);
                                              
                                        
                                                 
                                                },
                                                child: Row(
                                                  spacing: 4,
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .shopping_cart_outlined,
                                                      color: Colors.blueGrey,
                                                      size: 16,
                                                    ),
                                                    Text(
                                                      'Add To Cart',
                                                      style: TextStyle(
                                                          color: Colors.blueGrey,
                                                          fontSize: 12),
                                                    )
                                                  ],
                                                ))),
                                      ),
                                   widget.forProduct ? SizedBox.shrink() : Expanded(
                                        child: SizedBox(
                                            height: 40,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 8, vertical: 6),
                                                backgroundColor:
                                                    Color(0xffCC6522),
                                                foregroundColor:
                                                    Color(0xffffffff),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                ),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                Navigator.of(context).push(
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            GrainsDetailedScreen(
                                                                // item: category[index],
                                                                )));
                                              },
                                              child: Text('GET INGREDIENT',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            )),
                                      )
                                    ],
                                  )
                                ],
                              );
                            },
                          );
                        },
                      );
                      // Handle category tap
                      print('Tapped on category: ${ingredient}');
                      myLog.log('product image ${ingredient.imageUrl}');
                    },
                    child: Column(
                      children: [
                        Container(
                          //  margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(
                              ingredient.imageUrl != null ? 0 : 5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            // borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: ingredient.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: ingredient.imageUrl.toString(),
                                      placeholder: (context, url) =>
                                          const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: const SpinKitPulse(
                                            color: Colors
                                                .amber, // You can use any color
                                            size: 24.0, // Customize size
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                    ))
                                : SvgPicture.asset(
                                    'assets/images/product_image.svg'),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          ingredient.name.toString().length > 10
                              ? '${ingredient.name!.substring(0, 7)}...'
                              :
                              // softWrap: true,
                              // maxLines:
                              //     2, // Set to any number of lines you want
                              // overflow: TextOverflow
                              //     .ellipsis, // Optional: adds "..." at the end
                              ingredient.name.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Roboto'),
                        )
                      ],
                    ),
                  );
                },
              );
                  })
            ),
          ],
        ),
      ),
    );
  }
}
