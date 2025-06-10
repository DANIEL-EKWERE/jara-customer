import 'dart:developer' as myLog;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/grains_screen/controller/grains_controller.dart';
import 'package:jara_market/screens/grains_screen/models/models.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../../widgets/custom_app_bar.dart';
import '../grains_detailed_screen/grains_detailed_screen.dart'; // Import GrainsDetailedScreen
import 'package:jara_market/screens/cart_screen/models/models.dart';
// import 'package:jara_market/screens/cart_screen/models/models.dart';

GrainsController controller = Get.put(GrainsController());
CartController cartController = Get.find<CartController>();

class GrainsScreen extends StatefulWidget {
  const GrainsScreen({Key? key, required this.forProduct, this.ingredients})
      : super(key: key);
  final bool forProduct;
  final List<Ingredients>? ingredients;
  @override
  State<GrainsScreen> createState() => _GrainsScreenState();
}

class _GrainsScreenState extends State<GrainsScreen> {
// List<Ingredients> ingredients = [];
  List<Ingredients> ingredientShoping = [];
  String _selectedMeasurement = 'Half Bag';
  final List<String> _measurementsRow1 = ['Cup', 'Quarter Bag'];
  final List<String> _measurementsRow2 = ['Half Bag', 'One Bag'];
  int _quantity = 1;
  bool _shopWithYourPrice = false;
  String errorText = '';
  final TextEditingController _priceController = TextEditingController();
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
          if (Navigator.canPop(context)) {
            myLog.log('i can pop');
            // Navigator.pop(context, {
            //   "result":ingredients
            // });
          } else {
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
            Expanded(child: Obx(() {
              return controller.isLoading.value
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber,
                      ),
                    )
                  : GridView.builder(
                      physics:
                          NeverScrollableScrollPhysics(), // Disable grid scrolling
                      itemCount:
                          // controller.category[sectionIndex].products!.length - 1 > 8
                          //     ? 8
                          //     :
                          controller.dataList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                              // barrierDismissible: false,
                              context: context,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Container(
                                        width: double.infinity,
                                        height: 420,
                                        decoration: BoxDecoration(
                                            //  color: Colors.grey[400]
                                            ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent),
                                              width: double.infinity,
                                              height: 150,
                                              child: Container(
                                                child: ingredient.imageUrl !=
                                                        null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        20),
                                                                topRight: Radius
                                                                    .circular(
                                                                        20)),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: ingredient
                                                              .imageUrl
                                                              .toString(),
                                                          placeholder:
                                                              (context, url) =>
                                                                  const Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    8.0),
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
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                                  Icons.error),
                                                          width: context.width *
                                                              0.9,
                                                          height: 40,
                                                          fit: BoxFit.cover,
                                                        ))
                                                    : SvgPicture.asset(
                                                        'assets/images/product_image.svg'),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              height: 270,
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20)),
                                                  color: Colors.white),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${ingredient.name}',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff1F2937),
                                                            fontFamily: 'Inter',
                                                            fontSize: 24,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                      ),
                                                      Spacer(),
                                                      Text('2.5k orders'),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Align(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                'Measurement',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff1F2937),
                                                                    fontFamily:
                                                                        'Inter',
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              )),
                                                          const SizedBox(
                                                              height: 8),
                                                          Row(
                                                            // crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:
                                                                _measurementsRow1
                                                                    .map(
                                                                        (measurement) {
                                                              final isSelected =
                                                                  measurement ==
                                                                      _selectedMeasurement;
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8),
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 25,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        _shopWithYourPrice
                                                                            ? null
                                                                            : () {
                                                                                setState(() {
                                                                                  _selectedMeasurement = measurement;
                                                                                });
                                                                              },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      foregroundColor: isSelected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      textStyle:
                                                                          TextStyle(
                                                                              fontSize: 8),
                                                                      backgroundColor: isSelected
                                                                          ? Colors
                                                                              .orange
                                                                          : Colors
                                                                              .grey[200],
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                        measurement),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                          SizedBox(
                                                            height: 10,
                                                          ),
                                                          Row(
                                                            //  crossAxisAlignment: CrossAxisAlignment.start,
                                                            children:
                                                                _measurementsRow2
                                                                    .map(
                                                                        (measurement) {
                                                              final isSelected =
                                                                  measurement ==
                                                                      _selectedMeasurement;
                                                              return Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        right:
                                                                            8),
                                                                child: SizedBox(
                                                                  width: 50,
                                                                  height: 25,
                                                                  child:
                                                                      ElevatedButton(
                                                                    onPressed:
                                                                        _shopWithYourPrice
                                                                            ? null
                                                                            : () {
                                                                                setState(() {
                                                                                  _selectedMeasurement = measurement;
                                                                                });
                                                                              },
                                                                    style: ElevatedButton
                                                                        .styleFrom(
                                                                      textStyle:
                                                                          TextStyle(
                                                                              fontSize: 8),
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      foregroundColor: isSelected
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .black,
                                                                      backgroundColor: isSelected
                                                                          ? Colors
                                                                              .orange
                                                                          : Colors
                                                                              .grey[200],
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(8),
                                                                      ),
                                                                    ),
                                                                    child: Text(
                                                                        measurement),
                                                                  ),
                                                                ),
                                                              );
                                                            }).toList(),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.end,
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Text(
                                                                'Quantity',
                                                                style: TextStyle(
                                                                    color: Color(
                                                                        0xff1F2937),
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontFamily:
                                                                        'Inter'),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  IconButton(
                                                                    icon: SvgPicture
                                                                        .asset(
                                                                            'assets/images/removepreview.svg'),
                                                                    //  const Icon(
                                                                    //     Icons
                                                                    //         .remove_circle_outline),
                                                                    onPressed:
                                                                        _shopWithYourPrice
                                                                            ? null
                                                                            : () {
                                                                                setState(() {
                                                                                  _quantity = (_quantity - 1).clamp(1, 99);
                                                                                });
                                                                              },
                                                                    color: _shopWithYourPrice
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                  Container(
                                                                    padding: EdgeInsets.symmetric(
                                                                        vertical:
                                                                            5,
                                                                        horizontal:
                                                                            18),
                                                                    decoration: BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                10),
                                                                        border: Border.all(
                                                                            width:
                                                                                0.5,
                                                                            color:
                                                                                Color(0xffF9F9F9))),
                                                                    child: Text(
                                                                      _quantity
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          color: Color(
                                                                              0xff262626),
                                                                          fontSize:
                                                                              12,
                                                                          fontFamily:
                                                                              'Inter',
                                                                          fontWeight:
                                                                              FontWeight.w400),
                                                                    ),
                                                                  ),
                                                                  IconButton(
                                                                    icon: SvgPicture
                                                                        .asset(
                                                                            'assets/images/addpreview.svg'),
                                                                    // const Icon(
                                                                    //     Icons
                                                                    //         .add_circle_outline),
                                                                    onPressed:
                                                                        _shopWithYourPrice
                                                                            ? null
                                                                            : () {
                                                                                setState(() {
                                                                                  _quantity = (_quantity + 1).clamp(1, 99);
                                                                                });
                                                                              },
                                                                    color: _shopWithYourPrice
                                                                        ? Colors
                                                                            .grey
                                                                        : Colors
                                                                            .black,
                                                                  ),
                                                                ],
                                                              ),
                                                              SizedBox(
                                                                height: 15,
                                                              )
                                                            ],
                                                          ),
                                                          Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Text('\u20A6${ingredient.price}'))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  Spacer(),

                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Checkbox(
                                                        side: BorderSide(
                                                            width: 1.5),
                                                        value:
                                                            _shopWithYourPrice,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            _shopWithYourPrice =
                                                                value ?? false;
                                                          });
                                                        },
                                                        activeColor:
                                                            Colors.orange,
                                                      ),
                                                      const Text(
                                                        'Shop with your price',
                                                        style: TextStyle(
                                                            fontSize: 10),
                                                      ),
                                                      SizedBox(
                                                        width: 7,
                                                      )
                                                    ],
                                                  ),
                                                  //  const SizedBox(height: 8),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      // const SizedBox(height: 16),

                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            if (widget
                                                                .forProduct)
                                                              widget.ingredients!.add(Ingredients(
                                                                  id: ingredient
                                                                      .id!,
                                                                  createdAt:
                                                                      ingredient
                                                                          .createdAt,
                                                                  description:
                                                                      ingredient
                                                                          .description,
                                                                  imageUrl: ingredient
                                                                      .imageUrl,
                                                                  name: ingredient
                                                                      .name,
                                                                  price: double.tryParse(ingredient
                                                                          .price
                                                                          .toString()) ??
                                                                      0.0,
                                                                  basePrice: double.tryParse(ingredient
                                                                          .price
                                                                          .toString()) ??
                                                                      0.0,
                                                                  quantity:
                                                                      _quantity));
                                                            else
                                                              cartController.addIngredientToCart(Data(
                                                                  id: ingredient
                                                                      .id,
                                                                  createdAt: ingredient
                                                                      .createdAt,
                                                                  description:
                                                                      ingredient
                                                                          .description,
                                                                  imageUrl:
                                                                      ingredient
                                                                          .imageUrl,
                                                                  name:
                                                                      ingredient
                                                                          .name,
                                                                  price: _shopWithYourPrice && ingredient.controller.text.isNotEmpty && double.tryParse(ingredient.controller.text) !> (double.tryParse(ingredient.price.toString()) ?? 0.0)  ? double.tryParse(ingredient.controller.text) :
                                                                      ingredient
                                                                          .price,
                                                                  quantity:
                                                                      _quantity,
                                                                  stock:
                                                                      ingredient
                                                                          .stock,
                                                                  unit: ingredient
                                                                      .unit));

                                                            Get.snackbar(
                                                                'Success',
                                                                'Item added to cart',
                                                                colorText:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors
                                                                        .green);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.orange,
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical:
                                                                        16),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: const Text(
                                                            'Add to Cart',
                                                            style: TextStyle(
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  'Inter',
                                                              color: Color(
                                                                  0xff090909),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      
                                                      Expanded(
                                                        child: SizedBox(
                                                          height: 35,
                                                          child: TextField(
                                                            onChanged: (value) {
                                                             double inPrice = double.parse(value);
                                                              if(inPrice < ingredient.price!){
                                                                setState((){
                                                                  errorText = 'custom price must be greater than default.';
                                                                });
                                                              }else {
                                                                setState((){
                                                                  errorText = '';
                                                                });
                                                              }
                                                            },
                                                            
                                                            controller: ingredient.controller,
                                                                        //  _priceController,
                                                            enabled:
                                                                _shopWithYourPrice,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            decoration:
                                                                InputDecoration(
                                                                 // errorText: errorText,
                                                              hintText:
                                                                  'Enter your price',
                                                              filled: true,
                                                              hintStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          12),
                                                              fillColor:
                                                                  _shopWithYourPrice
                                                                      ? Colors
                                                                          .white
                                                                      : Colors.grey[
                                                                          200],
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            8),
                                                                borderSide:
                                                                    BorderSide
                                                                        .none,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 40),
                                                ],
                                              ),
                                            ),
                                            // SizedBox(height: 20),
                                          ],
                                        ),
                                      ),
                                      // actions: [
                                      //   Row(
                                      //     spacing: context.width * 0.02,
                                      //     children: [
                                      //       Expanded(
                                      //         child: SizedBox(
                                      //             height: 40,
                                      //             //   width: 110,
                                      //             child: ElevatedButton(
                                      //                 style: ElevatedButton
                                      //                     .styleFrom(
                                      //                   elevation: 0,
                                      //                   padding: EdgeInsets
                                      //                       .symmetric(
                                      //                           horizontal: 8,
                                      //                           vertical: 6),
                                      //                   backgroundColor:
                                      //                       Colors.white,
                                      //                   foregroundColor:
                                      //                       Color(0xffffffff),
                                      //                   shape:
                                      //                       RoundedRectangleBorder(
                                      //                     borderRadius:
                                      //                         BorderRadius
                                      //                             .circular(4),
                                      //                     side: BorderSide(
                                      //                         color: Colors
                                      //                             .blueGrey),
                                      //                   ),
                                      //                 ),
                                      //                 onPressed: () {
                                      //                   // Navigator.of(context).pop();
                                      //                   // Navigator.of(context).push(CupertinoPageRoute(
                                      //                   //     builder: (context) => FoodDetailScreen(
                                      //                   //           item: category[index],
                                      //                   //         )));
                                      //                   print(
                                      //                       'Add to cart pressed ${ingredient.name}');
                                      //                   //TODO: implemet popping back to ingredient in food or just ingredient
                                      //                   // cartController.addToCart(CartItem(
                                      //                   //   id: category[index].id!,
                                      //                   //   name: category[index].name!,
                                      //                   //   description: category[index]
                                      //                   //           .description ??
                                      //                   //       'N/A',
                                      //                   //   price: double.tryParse(
                                      //                   //           category[index]
                                      //                   //               .price!
                                      //                   //               .toString()) ??
                                      //                   //       0.0,
                                      //                   //   originalPrice: double.tryParse(
                                      //                   //           category[index]
                                      //                   //               .price!
                                      //                   //               .toString()) ??
                                      //                   //       0.0,
                                      //                   //   ingredients: category[index]
                                      //                   //       .ingredients!
                                      //                   //       .map((ingredient) =>
                                      //                   //           Ingredients(
                                      //                   //             id: ingredient.id!,
                                      //                   //             name: ingredient.name,
                                      //                   //             description:
                                      //                   //                 ingredient
                                      //                   //                     .description,
                                      //                   //             price: double.tryParse(
                                      //                   //                     ingredient
                                      //                   //                         .price
                                      //                   //                         .toString()) ??
                                      //                   //                 0.0,
                                      //                   //           ))
                                      //                   //       .toList(),
                                      //                   // ));
                                      //                   if (widget.forProduct)
                                      //                     widget.ingredients!.add(Ingredients(
                                      //                         id: ingredient
                                      //                             .id!,
                                      //                         createdAt: ingredient
                                      //                             .createdAt,
                                      //                         description:
                                      //                             ingredient
                                      //                                 .description,
                                      //                         imageUrl:
                                      //                             ingredient
                                      //                                 .imageUrl,
                                      //                         name: ingredient
                                      //                             .name,
                                      //                         price: double.tryParse(
                                      //                                 ingredient
                                      //                                     .price
                                      //                                     .toString()) ??
                                      //                             0.0,
                                      //                         basePrice: double.tryParse(
                                      //                                 ingredient
                                      //                                     .price
                                      //                                     .toString()) ??
                                      //                             0.0,
                                      //                         quantity: 1));
                                      //                   else
                                      //                     cartController
                                      //                         .addIngredientToCart(
                                      //                             ingredient);
                                      //                   // ingredientList.map((e) {
                                      //                   //   Ingredients(id: DateTime.now().millisecondsSinceEpoch,
                                      //                   //   price: e.price,
                                      //                   //   description: e.description,
                                      //                   //   name: e.name,
                                      //                   //   );
                                      //                   // });
                                      //                   // cartController.addToCart(CartItem(id: 110, name: 'Ingredients',originalPrice: 0.0, description: 'ingredient shoping', price: 0.0, ingredients: ingredientShoping.map((e){
                                      //                   //   return Ingredients(
                                      //                   //     id: e.id,
                                      //                   //     //createdAt: e.createdAt,
                                      //                   //     description: e.description,
                                      //                   //     //imageUrl: e.imageUrl,
                                      //                   //     name: e.name,
                                      //                   //     price: e.price,
                                      //                   //    // quantity: e.quantity,
                                      //                   //    // unit: e.unit,
                                      //                   //   );
                                      //                   // }).toList())); //add(ingredient)));
                                      //                   // cartController.addToCart(CartItem(
                                      //                   //                                               id: category[index].id!,
                                      //                   //                                               name: category[index].name!,
                                      //                   //                                               description: category[index].description ?? 'N/A',
                                      //                   //                                               price: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                      //                   //                                               originalPrice: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                      //                   //                                               ingredients: category[index]
                                      //                   //                                                   .ingredients!
                                      //                   //                                                   .map((ingredient) => Ingredients(
                                      //                   //                                                         id: ingredient.id!,
                                      //                   //                                                         name: ingredient.name,
                                      //                   //                                                         description: ingredient.description,
                                      //                   //                                                         price: double.tryParse(ingredient.price.toString()) ?? 0.0,
                                      //                   //                                                       ))
                                      //                   //                                                   .toList(),
                                      //                   //                                             ));
                                      //                   //  myLog.log('added to cart ${widget.ingredients!.toList()}');
                                      //                   Get.snackbar('Success',
                                      //                       'Item added to cart',
                                      //                       colorText:
                                      //                           Colors.white,
                                      //                       backgroundColor:
                                      //                           Colors.green);
                                      //                   Navigator.pop(context);
                                      //                 },
                                      //                 child: Row(
                                      //                   spacing: 4,
                                      //                   children: [
                                      //                     Icon(
                                      //                       Icons
                                      //                           .shopping_cart_outlined,
                                      //                       color:
                                      //                           Colors.blueGrey,
                                      //                       size: 16,
                                      //                     ),
                                      //                     Text(
                                      //                       'Add To Cart',
                                      //                       style: TextStyle(
                                      //                           color: Colors
                                      //                               .blueGrey,
                                      //                           fontSize: 12),
                                      //                     )
                                      //                   ],
                                      //                 ))),
                                      //       ),
                                      //       widget.forProduct
                                      //           ? SizedBox.shrink()
                                      //           : Expanded(
                                      //               child: SizedBox(
                                      //                   height: 40,
                                      //                   child: ElevatedButton(
                                      //                     style: ElevatedButton
                                      //                         .styleFrom(
                                      //                       padding: EdgeInsets
                                      //                           .symmetric(
                                      //                               horizontal:
                                      //                                   8,
                                      //                               vertical:
                                      //                                   6),
                                      //                       backgroundColor:
                                      //                           Color(
                                      //                               0xffCC6522),
                                      //                       foregroundColor:
                                      //                           Color(
                                      //                               0xffffffff),
                                      //                       shape:
                                      //                           RoundedRectangleBorder(
                                      //                         borderRadius:
                                      //                             BorderRadius
                                      //                                 .circular(
                                      //                                     4),
                                      //                       ),
                                      //                     ),
                                      //                     onPressed: () {
                                      //                       Navigator.of(
                                      //                               context)
                                      //                           .pop();
                                      //                       Navigator.of(context).push(
                                      //                           CupertinoPageRoute(
                                      //                               builder: (context) =>
                                      //                                   GrainsDetailedScreen(
                                      //                                       // item: category[index],
                                      //                                       )));
                                      //                     },
                                      //                     child: Text(
                                      //                         'GET INGREDIENT',
                                      //                         style: TextStyle(
                                      //                             color: Colors
                                      //                                 .white,
                                      //                             fontSize:
                                      //                                 12)),
                                      //                   )),
                                      //             )
                                      //     ],
                                      //   )
                                      // ],
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
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                ingredient.imageUrl.toString(),
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
                                            errorWidget:
                                                (context, url, error) =>
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
            })),
          ],
        ),
      ),
    );
  }
}
