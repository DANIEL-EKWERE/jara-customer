import 'dart:developer' as myLog;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/egusi_soup_detail_screen/egusi_soup_detail_screen.dart';
import 'package:jara_market/screens/home_screen/controller/home_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import '../soup_list_screen/soup_list_screen.dart';

HomeController controller = Get.put(HomeController());
var cartController = Get.put(CartController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  // List<dynamic> _foodCategories = [];
  // List<dynamic> _ingredients = [];
  // List<dynamic> _foods = [];
  // bool _isLoading = true;
  late Map<String, dynamic> userData;
  bool isSet = false;
  int _currentIndex = 0;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() {
    controller.fetchFoodCategories();
  }

  // Controller for the carousel
  late CarouselSliderController carouselController;
  // Timer? _autoSlideTimer;
  // int _currentPage = 0;
  // final int _totalItems = 5; // Update this with your actual number of items

  String? name;

  // Add search controller and filtered lists
  final TextEditingController _searchController = TextEditingController();
  // List<dynamic> _filteredFoodCategories = [];
  // List<dynamic> _filteredIngredients = [];
  // List<dynamic> _filteredFoods = [];

  void getUserName() async {
    var name1 = await dataBase.getFirstName() ?? 'N/A';
    if (mounted) {
      // Added mounted check
      setState(() {
        name = name1;
      });
    }
  }

  Widget dotIndicator(int index, int lenght) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: ListView.builder(
              itemCount: lenght,
              itemBuilder: (BuildContext, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  width: _currentIndex == index ? 18.0 : 10.0,
                  height: _currentIndex == index ? 10.0 : 10.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: _currentIndex == index
                        ? Colors.blue
                        : Colors.grey.withValues(alpha: 0.5),
                  ),
                );
              }),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getUserName();
    controller.fetchFoodCategoriesByCondition();
    // Uncomment this when you implement filtering
    // _searchController.addListener(_filterItems);
    carouselController = CarouselSliderController();
    //_startAutoSlide();
  }

  // void _startAutoSlide() {
  //   // Create a timer that updates the carousel every 3 seconds
  //   _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
  //     // Move to next slide (with wrap-around)
  //     _currentPage = (_currentPage + 1) % _totalItems;
  //     // Update carousel position
  //     carouselController.animateTo(_currentPage,
  //         duration: const Duration(seconds: 3), curve: Curves.decelerate);
  //     // Rebuild the widget to reflect current state
  //     setState(() {});
  //   });
  // }

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
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFFFBBC05),
                  ))
                : Column(
                    children: [
                      // ElevatedButton(onPressed: (){dataBase.logOut();}, child: Text('clear local db')),
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
                      //  CustomButton(text: 'Shop Ingredient', onPressed: () {}),
                      // Category sections inside ListView
                      Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: _onRefresh,
                          child: ListView.separated(
                            physics: BouncingScrollPhysics(),
                            itemCount: controller.category.length + 1, // Only one section for now, you can add more sections as needed
                            separatorBuilder: (context, index) {
                               if(index == 0) return SizedBox(
                                      height: 24,
                                    );
                              // ? CustomButton(text: 'text', onPressed: (){}) : index == 2
                                  
                                  return Divider(
                                      height: 24,
                                      thickness: 0.5,
                                      color: Colors.grey[400],
                                    );
                            },

                            itemBuilder: (context, sectionIndex) {
                              if(sectionIndex == 0){
                                return CustomButton(text: 'text', onPressed: (){});
                              }
                             return sectionIndex == 2
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 154,
                                          child: CarouselSlider(
                                            carouselController:
                                                carouselController,
                                            options: CarouselOptions(
                                              height: 200.0,
                                              viewportFraction: 0.8,
                                              initialPage: 0,
                                              enableInfiniteScroll: true,
                                              reverse: false,
                                              autoPlay: true,
                                              autoPlayInterval:
                                                  const Duration(seconds: 3),
                                              autoPlayAnimationDuration:
                                                  const Duration(
                                                      milliseconds: 800),
                                              autoPlayCurve:
                                                  Curves.fastOutSlowIn,
                                              enlargeCenterPage: true,
                                              scrollDirection: Axis.horizontal,
                                              onPageChanged: (index, reason) {
                                                setState(() {
                                                  _currentIndex = index;
                                                });
                                              },
                                            ),
                                            items: [
                                              Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    154,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Color(0xFFFBBC05)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'MIN 14%\nOFF',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            color: Color(
                                                                0xff3F1405)),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffCC6522),
                                                              foregroundColor:
                                                                  Color(
                                                                      0xffffffff),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                'SHOP NOW',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                //  height:154,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'MIN 15%\nOFF',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            color: Color(
                                                                0xff3F1405)),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffCC6522),
                                                              foregroundColor:
                                                                  Color(
                                                                      0xffffffff),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                'SHOP NOW',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    154,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Color(0xFFFBBC05)),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    154,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Color(0xFFFBBC05)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'MIN 16%\nOFF',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            color: Color(
                                                                0xff3F1405)),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffCC6522),
                                                              foregroundColor:
                                                                  Color(
                                                                      0xffffffff),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                'SHOP NOW',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    154,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Color(0xFFFBBC05)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'MIN 17%\nOFF',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            color: Color(
                                                                0xff3F1405)),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffCC6522),
                                                              foregroundColor:
                                                                  Color(
                                                                      0xffffffff),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                'SHOP NOW',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    154,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    color: Color(0xFFFBBC05)),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 25),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'MIN 18%\nOFF',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 24,
                                                            color: Color(
                                                                0xff3F1405)),
                                                      ),
                                                      SizedBox(
                                                        height: 8,
                                                      ),
                                                      SizedBox(
                                                          height: 28,
                                                          width: 90,
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          8,
                                                                      vertical:
                                                                          6),
                                                              backgroundColor:
                                                                  Color(
                                                                      0xffCC6522),
                                                              foregroundColor:
                                                                  Color(
                                                                      0xffffffff),
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                            ),
                                                            onPressed: () {},
                                                            child: Text(
                                                                'SHOP NOW',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        8)),
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // dotIndicator(_currentIndex,5)
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: List.generate(
                                            5,
                                            (index) => GestureDetector(
                                              onTap: () {
                                                carouselController
                                                    .animateToPage(index);
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                    milliseconds: 300),
                                                curve: Curves.easeInOut,
                                                width: _currentIndex == index
                                                    ? 12.0
                                                    : 7.0,
                                                height: 7.0,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                  color: _currentIndex == index
                                                      ? Colors.blue
                                                      : Colors.grey.withValues(
                                                          alpha: 0.5),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  :  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //CustomButton(text: 'Shop Ingredient', onPressed: (){}),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: Row(
                                              children: [
                                                Text(
                                                  controller
                                                      .category[sectionIndex -1]
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Roboto',
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Spacer(),
                                                controller
                                                            .category[
                                                                sectionIndex -1]
                                                            .products!
                                                            .length <=
                                                        3
                                                    ? SizedBox.shrink()
                                                    : InkWell(
                                                        onTap: () {
                                                          // Handle "See All" tap
                                                          print(
                                                              'Tapped on See All for category: ${controller.category[sectionIndex].name}');
                                                          // Navigate to the next screen or perform any action
                                                          Get.to(() => SoupListScreen(
                                                              item: controller
                                                                      .category[
                                                                  sectionIndex]));
                                                        },
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              'See All',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontFamily:
                                                                    'Roboto',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Color(
                                                                    0xffCC6522),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .arrow_forward_ios,
                                                              size: 10,
                                                              color: Color(
                                                                  0xffCC6522),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          // Fixed height container for the grid
                                          controller.category[sectionIndex]
                                                  .products!.isEmpty
                                              ? Center(
                                                  child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(
                                                    'Food Not Availabe for this Category!!!',
                                                    style: TextStyle(
                                                        color: Colors.grey[400],
                                                        fontFamily: 'Roboto',
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ))
                                              : SizedBox(
                                                  // Calculate height based on number of rows needed
                                                  height: (controller
                                                                  .category[
                                                                      sectionIndex]
                                                                  .products!
                                                                  .length /
                                                              4)
                                                          .ceil() *
                                                      70.0,
                                                  child: GridView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(), // Disable grid scrolling
                                                    itemCount: controller
                                                                    .category[
                                                                        sectionIndex]
                                                                    .products!
                                                                    .length -
                                                                1 >
                                                            8
                                                        ? 8
                                                        : controller
                                                            .category[
                                                                sectionIndex]
                                                            .products!
                                                            .length,
                                                    gridDelegate:
                                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 4,
                                                      crossAxisSpacing: 4.0,
                                                      mainAxisSpacing: 7.0,
                                                      childAspectRatio: 1.2,
                                                    ),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final category =
                                                          controller
                                                              .category[
                                                                  sectionIndex]
                                                              .products;
                                                      return GestureDetector(
                                                        onTap: () {
                                                          showDialog(
                                                            barrierDismissible:
                                                                false,
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                                  return AlertDialog(
                                                                    insetPadding:
                                                                        EdgeInsets
                                                                            .zero,
                                                                    contentPadding: EdgeInsets.only(
                                                                        right:
                                                                            16,
                                                                        left:
                                                                            24,
                                                                        top: 0,
                                                                        bottom:
                                                                            16),
                                                                    backgroundColor:
                                                                        Colors.grey[
                                                                            100],
                                                                    title: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.topLeft,
                                                                          child:
                                                                              Text(
                                                                            category[index].name.toString(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontSize: 14,
                                                                              fontFamily: 'Roboto',
                                                                              fontWeight: FontWeight.w600,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.of(context).pop();
                                                                                },
                                                                                child: Icon(Icons.cancel_presentation_rounded))),
                                                                      ],
                                                                    ),
                                                                    content:
                                                                        // Text(
                                                                        //     "This is a popup modal!"),
                                                                        Container(
                                                                      height:
                                                                          273,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                              //  color: Colors.grey[400]
                                                                              ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
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
                                                                                  "\u20A6${category[index].price}",
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    fontFamily: 'Roboto',
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                ' Per Portion',
                                                                                style: TextStyle(color: Colors.grey[400], fontSize: 10),
                                                                              ),
                                                                              Spacer(),
                                                                              Align(
                                                                                alignment: Alignment.topRight,
                                                                                child: IconButton(
                                                                                    onPressed: () async {
                                                                                      if (category[index].isFavorite) {
                                                                                        // Remove from favorites
                                                                                        controller.removeFavorite(category[index].id!);
                                                                                        print('Removing from favorites');
                                                                                      }
                                                                                      var result = await controller.addFavorite(category[index].id!);
                                                                                      setState(() {
                                                                                        //isSet = !isSet;
                                                                                        category[index].isFavorite = !category[index].isFavorite;
                                              
                                                                                        if (!result) {
                                                                                          category[index].isFavorite = !category[index].isFavorite;
                                                                                        }
                                                                                      });
                                                                                    },
                                                                                    icon: category[index].isFavorite ? Icon(Icons.favorite_rounded) : Icon(Icons.favorite_border_rounded)),
                                                                              )
                                                                            ],
                                                                          ),
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.topLeft,
                                                                            child:
                                                                                Text(
                                                                              //"${category[index].stock} Portion Available",
                                                                              "${category[index].ingredients!.length} Ingredients in food",
                                              
                                                                              style: TextStyle(
                                                                                color: Colors.grey[600],
                                                                                fontSize: 14,
                                                                                fontFamily: 'Roboto',
                                                                                fontWeight: FontWeight.w400,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            height:
                                                                                150,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)), border: Border.all(width: 10, color: Colors.white)),
                                                                            child:
                                                                                Container(
                                                                              // widthFactor: 10.5,
                                                                              // heightFactor: 10.5,
                                                                              child: category[index].imageUrl != null
                                                                                  ?
                                                                                  //  Image.network(
                                                                                  //     category[index].imageUrl.toString(),
                                                                                  //     fit: BoxFit.cover,
                                                                                  //   )
                                                                                  ClipRRect(
                                                                                      borderRadius: BorderRadius.circular(20),
                                                                                      child: CachedNetworkImage(
                                                                                        imageUrl: category[index].imageUrl.toString(),
                                                                                        placeholder: (context, url) => const Padding(
                                                                                          padding: EdgeInsets.all(8.0),
                                                                                          child: Center(
                                                                                            child: const SpinKitPulse(
                                                                                              color: Colors.amber, // You can use any color
                                                                                              size: 24.0, // Customize size
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                                                                        width: context.width * 0.6,
                                                                                        height: 40,
                                                                                        fit: BoxFit.cover,
                                                                                      ))
                                                                                  : SvgPicture.asset('assets/images/product_image.svg'),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          Container(
                                                                            padding:
                                                                                EdgeInsets.all(8),
                                                                            height:
                                                                                53,
                                                                            decoration:
                                                                                BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(12)), color: Colors.amber[50]),
                                                                            child:
                                                                                Text('*${category[index].description}\n We also Offer meal prep as well!!!'),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    actions: [
                                                                      Row(
                                                                        spacing:
                                                                            context.width *
                                                                                0.02,
                                                                        children: [
                                                                          SizedBox(
                                                                              height: 40,
                                                                              width: 110,
                                                                              child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    elevation: 0,
                                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                                    backgroundColor: Colors.white,
                                                                                    foregroundColor: Color(0xffffffff),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                      side: BorderSide(color: Colors.blueGrey),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    // Navigator.of(context).pop();
                                                                                    // Navigator.of(context).push(CupertinoPageRoute(
                                                                                    //     builder: (context) => FoodDetailScreen(
                                                                                    //           item: category[index],
                                                                                    //         )));
                                                                                    print('Add to cart pressed ${category[index].id}');
                                              
                                                                                    cartController.addToCart(CartItem(
                                                                                      id: category[index].id!,
                                                                                      name: category[index].name!,
                                                                                      description: category[index].description ?? 'N/A',
                                                                                      price: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                                                                      originalPrice: double.tryParse(category[index].price!.toString()) ?? 0.0,
                                                                                      ingredients: category[index]
                                                                                          .ingredients!
                                                                                          .map((ingredient) => Ingredients(
                                                                                                basePrice: double.tryParse(ingredient.price.toString()) ?? 0.0,
                                                                                                id: ingredient.id!,
                                                                                                name: ingredient.name,
                                                                                                description: ingredient.description,
                                                                                                price: double.tryParse(ingredient.price.toString()) ?? 0.0,
                                                                                              ))
                                                                                          .toList(),
                                                                                    ));
                                                                                    // print(category[index].id!);
                                                                                    // print(category[index].name!);
                                                                                    // print(category[index].description!);
                                                                                    // print(category[index].price!);
                                                                                    // Add your add to cart logic here
                                                                                  },
                                                                                  child: Row(
                                                                                    spacing: 4,
                                                                                    children: [
                                                                                      Icon(
                                                                                        Icons.shopping_cart_outlined,
                                                                                        color: Colors.blueGrey,
                                                                                        size: 16,
                                                                                      ),
                                                                                      Text(
                                                                                        'Add To Cart',
                                                                                        style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                                                                                      )
                                                                                    ],
                                                                                  ))),
                                                                          Expanded(
                                                                            child: SizedBox(
                                                                                height: 40,
                                                                                child: ElevatedButton(
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                                                                    backgroundColor: Color(0xffCC6522),
                                                                                    foregroundColor: Color(0xffffffff),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(4),
                                                                                    ),
                                                                                  ),
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                    Navigator.of(context).push(CupertinoPageRoute(
                                                                                        builder: (context) => FoodDetailScreen(
                                                                                              item: category[index],
                                                                                            )));
                                                                                  },
                                                                                  child: Text('GET INGREDIENT', style: TextStyle(color: Colors.white, fontSize: 12)),
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
                                                          print(
                                                              'Tapped on category: $category');
                                                          myLog.log(
                                                              'product image ${category[sectionIndex].imageUrl}');
                                                        },
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                              //  margin: EdgeInsets.all(5),
                                                              padding: EdgeInsets.all(
                                                                  category![index]
                                                                              .imageUrl !=
                                                                          null
                                                                      ? 0
                                                                      : 5),
                                                              decoration:
                                                                  BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .grey[200],
                                                                // borderRadius: BorderRadius.circular(12),
                                                              ),
                                                              child: Center(
                                                                child: category[index]
                                                                            .imageUrl !=
                                                                        null
                                                                    ? ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(
                                                                                20),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: category[index]
                                                                              .imageUrl
                                                                              .toString(),
                                                                          placeholder: (context, url) =>
                                                                              const Padding(
                                                                            padding:
                                                                                EdgeInsets.all(8.0),
                                                                            child:
                                                                                Center(
                                                                              child: const SpinKitPulse(
                                                                                color: Colors.amber, // You can use any color
                                                                                size: 24.0, // Customize size
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          errorWidget: (context, url, error) =>
                                                                              const Icon(Icons.error),
                                                                          width:
                                                                              40,
                                                                          height:
                                                                              40,
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ))
                                                                    : SvgPicture
                                                                        .asset(
                                                                            'assets/images/product_image.svg'),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              height: 5,
                                                            ),
                                                            Text(
                                                              category[index]
                                                                          .name
                                                                          .toString()
                                                                          .length >
                                                                      10
                                                                  ? '${category[index].name!.substring(0, 7)}...'
                                                                  :
                                                                  // softWrap: true,
                                                                  // maxLines:
                                                                  //     2, // Set to any number of lines you want
                                                                  // overflow: TextOverflow
                                                                  //     .ellipsis, // Optional: adds "..." at the end
                                                                  category[
                                                                          index]
                                                                      .name
                                                                      .toString(),
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  fontFamily:
                                                                      'Roboto'),
                                                            )
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                        ],
                                      ),
                                    );
                            },
                          ),
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
