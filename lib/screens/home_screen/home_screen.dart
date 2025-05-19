import 'dart:async';
import 'dart:developer' as myLog;
// lib/screens/home_screen.dart
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
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
  // ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  // List<dynamic> _foodCategories = [];
  // List<dynamic> _ingredients = [];
  // List<dynamic> _foods = [];
  // bool _isLoading = true;
  late Map<String, dynamic> userData;
  int _currentIndex = 0;

  // Controller for the carousel
  late CarouselSliderController carouselController;
  Timer? _autoSlideTimer;
  int _currentPage = 0;
  final int _totalItems = 5; // Update this with your actual number of items

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

  Widget dotIndicator(int index,int lenght){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 20,
          child: ListView.builder(
            itemCount: lenght,
            itemBuilder: (BuildContext,index){
            return  AnimatedContainer(
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
    controller.fetchFoodCategories();
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
                          itemCount: controller.categories
                              .length, // Only one section for now, you can add more sections as needed
                          separatorBuilder: (context, index) {
                            return index == 2
                                ? SizedBox(
                                    height: 24,
                                  )
                                : Divider(height: 24,thickness: 0.5,color: Colors.grey[400],);
                          },

                          itemBuilder: (context, sectionIndex) {
                            return sectionIndex == 2
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 154,
                                        child: CarouselSlider(
                                          carouselController: carouselController,
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
                                            autoPlayCurve: Curves.fastOutSlowIn,
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
                                                borderRadius: BorderRadius.circular(15),
                                                  color: Color(0xFFFBBC05)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
                                                    child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('MIN 14%\nOFF',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Color(0xff3F1405)),),
                                                      SizedBox(height: 8,),
                                                      SizedBox(
                                                        height: 28,
                                                        width: 90,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),backgroundColor: Color(0xffCC6522),foregroundColor: Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),),
                                                          onPressed: (){
                                                        
                                                        }, child: Text('SHOP NOW',style: TextStyle(color: Colors.white,fontSize: 8)),)
                                                      )
                                                    ],
                                                                                                    ),
                                                  ),
                                            ),
                                            Container(
                                            //  height:154,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text('MIN 15%\nOFF',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Color(0xff3F1405)),),
                                                    SizedBox(height: 8,),
                                                    SizedBox(
                                                      height: 28,
                                                      width: 90,
                                                      child: ElevatedButton(
                                                        style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),backgroundColor: Color(0xffCC6522),foregroundColor: Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),),
                                                        onPressed: (){
                                                      
                                                      }, child: Text('SHOP NOW',style: TextStyle(color: Colors.white,fontSize: 8)),)
                                                    )
                                                  ],
                                                ),
                                              ),
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  154,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                  color: Color(0xFFFBBC05)),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  154,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                  color: Color(0xFFFBBC05)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
                                                    child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('MIN 16%\nOFF',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Color(0xff3F1405)),),
                                                      SizedBox(height: 8,),
                                                      SizedBox(
                                                        height: 28,
                                                        width: 90,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),backgroundColor: Color(0xffCC6522),foregroundColor: Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),),
                                                          onPressed: (){
                                                        
                                                        }, child: Text('SHOP NOW',style: TextStyle(color: Colors.white,fontSize: 8)),)
                                                      )
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
                                                borderRadius: BorderRadius.circular(15),
                                                  color: Color(0xFFFBBC05)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
                                                    child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('MIN 17%\nOFF',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Color(0xff3F1405)),),
                                                      SizedBox(height: 8,),
                                                      SizedBox(
                                                        height: 28,
                                                        width: 90,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),backgroundColor: Color(0xffCC6522),foregroundColor: Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),),
                                                          onPressed: (){
                                                        
                                                        }, child: Text('SHOP NOW',style: TextStyle(color: Colors.white,fontSize: 8)),)
                                                      )
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
                                                borderRadius: BorderRadius.circular(15),
                                                  color: Color(0xFFFBBC05)),
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 25),
                                                    child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text('MIN 18%\nOFF',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 24,color: Color(0xff3F1405)),),
                                                      SizedBox(height: 8,),
                                                      SizedBox(
                                                        height: 28,
                                                        width: 90,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(horizontal: 8,vertical: 6),backgroundColor: Color(0xffCC6522),foregroundColor: Color(0xffffffff),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4),),),
                                                          onPressed: (){
                                                        
                                                        }, child: Text('SHOP NOW',style: TextStyle(color: Colors.white,fontSize: 8)),)
                                                      )
                                                    ],
                                                                                                    ),
                                                  ),
                                            )
                                          ],
                                        ),

                                     
                                      ),
                                      SizedBox(height: 10,),
                                     // dotIndicator(_currentIndex,5)
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.center,
                                       children: List.generate(
                                         5,
                                         (index) => GestureDetector(
                                          onTap: () {
                                           carouselController.animateToPage(index);
                                          },
                                           child: AnimatedContainer(
                                             duration: const Duration(milliseconds: 300),
                                             curve: Curves.easeInOut,
                                             width: _currentIndex == index ? 18.0 : 10.0,
                                             height: 10.0,
                                             margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                             decoration: BoxDecoration(
                                               borderRadius: BorderRadius.circular(5.0),
                                               color: _currentIndex == index
                                                   ? Colors.blue
                                                   : Colors.grey.withValues(alpha:0.5),
                                             ),
                                           ),
                                         ),
                                       ),
                                     )
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8.0),
                                        child: Text(
                                          controller
                                              .categories[sectionIndex].name
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      // Fixed height container for the grid
                                      SizedBox(
                                        // Calculate height based on number of rows needed
                                        height:
                                            (controller.categories[sectionIndex]
                                                            .products!.length /
                                                        4)
                                                    .ceil() *
                                                100.0,
                                        child: GridView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(), // Disable grid scrolling
                                          itemCount: controller
                                              .categories[sectionIndex]
                                              .products!
                                              .length,
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 4,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            childAspectRatio: 1.5,
                                          ),
                                          itemBuilder: (context, index) {
                                            final category = controller
                                                .categories[sectionIndex]
                                                .products;
                                            return GestureDetector(
                                              onTap: () {
                                                // Handle category tap
                                                print(
                                                    'Tapped on category: $category');
                                                myLog.log(
                                                    'product image ${category[sectionIndex].imageUrl}');
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
                                                    child: Center(
                                                      child: category![index]
                                                                  .imageUrl !=
                                                              null
                                                          ? Image.network(
                                                              category[index]
                                                                  .imageUrl,
                                                              fit: BoxFit
                                                                  .contain,
                                                            )
                                                          : SvgPicture.asset(
                                                              'assets/images/product_image.svg'),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    category[index]
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        fontFamily: 'Poppins'),
                                                  )
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
