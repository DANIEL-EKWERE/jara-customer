import 'dart:developer' as myLog;
import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:jara_market/screens/grains_screen/grains_screen.dart';
import 'package:jara_market/widgets/custom_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';
import 'package:jara_market/widgets/cart_widgets/cart_ingredient.dart';
import 'package:jara_market/widgets/message_box.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../widgets/cart_widgets/checkout_button.dart';
import '../../widgets/cart_widgets/payment_methods.dart';
import '../../widgets/cart_widgets/cart_summary.dart';

var controller = Get.find<CartController>();

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //  // _fetchCart();
  // }

  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  bool _isRecorderInitialized = false;
  bool isPlayed = false;
  bool isResumed = false;
  bool isStoped = false;
  String? recordingPath;
  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    // getName();
  }

  Timer? _timer;
  Duration _recordingDuration = Duration.zero;
  DateTime? _pauseStartTime;
// bool _isPaused = false;

  String get _durationText {
    final minutes =
        _recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        _recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _startTimer() {
    _recordingDuration = Duration.zero;
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _recordingDuration += Duration(seconds: 1);
      });
    });
  }

  void _pauseTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _isPaused = true;
      _pauseStartTime = DateTime.now();
    }
  }

  void _resumeTimer() {
    if (_isPaused) {
      _timer = Timer.periodic(Duration(seconds: 1), (_) {
        setState(() {
          _recordingDuration += Duration(seconds: 1);
        });
      });
      _isPaused = false;
    }
  }

  void _stopTimer() {
    _timer?.cancel();
    _recordingDuration = Duration.zero;
    _isPaused = false;
  }

  Future<void> _initializeRecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is required for voice notes'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await _recorder.openRecorder();
      _isRecorderInitialized = true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to initialize recorder: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized) {
      await _initializeRecorder();
      if (!_isRecorderInitialized) return;
    }

// _recordDuration = 0;
//   _timer?.cancel();
//   _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//     setState(() {
//       _recordDuration++;
//     });
//   });

    try {
      final directory = await getApplicationDocumentsDirectory();
      _recordingPath =
          '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(toFile: _recordingPath);
      setState(() {
        _isRecording = true;
        _isPaused = false;
        isResumed = false;
        isStoped = false;
        recordingPath = _recordingPath;
      });

      // Show recording indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording started...'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pauseRecording() async {
    if (!_isRecording) return;

    try {
      await _recorder.pauseRecorder();
      setState(() {
        _isPaused = true;
        isResumed = true;
        isStoped = false;
        isPlayed = false;
      });

      // Show paused indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording paused'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to pause recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _resumeRecording() async {
    if (!_isRecording || !_isPaused) return;

    try {
      await _recorder.resumeRecorder();
      setState(() {
        _isPaused = false;
      });

      // Show resumed indicator
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recording resumed'),
          duration: Duration(seconds: 1),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to resume recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
//_timer?.cancel();
    try {
      final recordingResult = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _isPaused = false;
        isResumed = false;
        isStoped = true;
        isPlayed = true;
      });

      // Show success message with recording path
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Voice note recorded successfully'),
          action: SnackBarAction(
            label: 'PLAY',
            onPressed: () {
              // Implement playback functionality
              _playRecording(recordingResult);
            },
          ),
        ),
      );

      // Here you would typically upload the voice note to your server
      // _uploadVoiceNote(recordingResult);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to stop recording: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _playRecording(String? path) async {
    if (path == null) return;

    // Implement playback functionality
    // This would typically use FlutterSoundPlayer

    await _player.openPlayer();
    await _player.startPlayer(fromURI: path);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing voice note...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isCartEmpty = controller.cartItems.isEmpty;
    bool isCheckoutEnabled = !isCartEmpty && controller.total > 0;

    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Cart',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Expanded(
                child: controller.cartItems.length == 0
                    ? const Center(
                        child: Text(
                          'Your cart is empty',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    : Obx(() {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: controller.cartItems.length + 3,
                          separatorBuilder: (context, index) => const Divider(
                            height: 0.5,
                            color: Color.fromARGB(57, 228, 228, 228),
                          ),
                          itemBuilder: (context, index) {
                            if (index == controller.cartItems.length) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      side: const BorderSide(
                                        color: Color(
                                            0xff868D94), // Change this to your desired stroke color
                                        width: 2, // Optional: stroke thickness
                                      ),
                                      value: controller.mealPrep.value,
                                      onChanged: (bool? value) {
                                        //controller.toggleSelectAll(value!);
                                        setState(() {
                                          controller.mealPrep.value = value!;
                                          print(value);
                                          print(controller.mealPrep.value);
                                        });
                                      },
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Meal Preparation',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey[400],
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                        Text(
                                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit\ntempor incididunt ut labore et dolore magna aliqua.',
                                          style: TextStyle(
                                            fontSize: 9,
                                            color: Colors.grey[400],
                                            fontWeight: FontWeight.w400,
                                            fontFamily: 'Roboto',
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else if (index ==
                                controller.cartItems.length + 1) {
                              return Column(
                                children: [
                                  Divider(
                                    height: 0.5,
                                    color: Color.fromARGB(57, 228, 228, 228),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Shop By Ingredient?',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey,
                                          fontFamily: 'Roboto',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      )),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AnimatedTextKit(
                              repeatForever: true,
                              animatedTexts: [
                                TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  'Aside your normal product ordering',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                                TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  'You can decide to shop for ingredient separately on a different list.',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                                 TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  'This order or will be processed together with your food ',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                                TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  'Order can be placed on ingredient only within your cart',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                                    TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  
                                  'click the "shop by ingredient" button to see list our ingredients.',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                                TyperAnimatedText(
                                  speed: Duration(milliseconds: 40),
                                  'Thank you, Happy shopping in advance.',
                                  textStyle: TextStyle(color: Colors.grey.shade400),
                                ),
                              ],
                            ),
                            SizedBox(height: 20,),
                                  SizedBox(
                                    height: 60,
                                    child: CustomButton(
                                        text: 'Shop Ingredients',
                                        onPressed: () {
                                          myLog.log('Shoping for ingredients');
                                          Get.to(()=> GrainsScreen(forProduct: false));
                                        }),
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Divider(
                                    height: 0.5,
                                    color: Color.fromARGB(57, 228, 228, 228),
                                  ),
                                ],
                              );
                            } else if (index ==
                                controller.cartItems.length + 2) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: MessageBox(
                                  controller: _messageController,
                                  hintText: 'Add a message...',
                                  isPaused: _isPaused,
                                  isPlayed: isPlayed,
                                  isResumed: isResumed,
                                  isStoped: isStoped,
                                  isRecording: _isRecording,
                                  filePath: recordingPath,
                                  recordingDuration: _durationText,
                                  onVoicePressedDelete: () {
                                    setState(() {
                                      recordingPath = '';
                                      _stopTimer();
                                      _stopRecording(); // Optional depending on your logic
                                    });
                                  },
                                  onVoicePressedPlay: () {
                                    _playRecording(recordingPath);
                                  },
                                  onVoicePressedStop: () {
                                    _stopRecording();
                                  },
                                  onVoicePressed: () {
                                    print('starting');
                                    if (_isRecording) {
                                      myLog.log('is Recording');
                                      if (_isPaused) {
                                        myLog.log('is paused new resuming');
                                        _resumeRecording();
                                        _resumeTimer();
                                      } else {
                                        myLog
                                            .log('it was playing now resuming');
                                        _pauseRecording();
                                        _pauseTimer();
                                      }
                                    } else {
                                      myLog.log('stoping rcorder');
                                      _startRecording();
                                      _startTimer();
                                    }
                                  },
                                ),
                              );
                              //const SizedBox(height: 24),
                            }
                            final item = controller.cartItems[index];
                            final RxList<Ingredients> ingredients =
                                controller.cartItems[index].ingredients;
                            // return CartItemCard(
                            //   name: item.name,
                            //   unit: item.description,
                            //   basePrice: item.price,
                            //   quantity: item.quantity,
                            //   // onQuantityChanged: (newQuantity) =>
                            //   //     _updateQuantity(item.id.toString(), newQuantity),
                            //   addQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value + 1),
                            //   removeQuantity: () => controller.updateItemQuantity(item.id, item.quantity.value - 1),
                            //   onDeleteConfirmed: () => controller.removeFromCart(item.id),
                            //   textController: TextEditingController(
                            //       text: item.quantity.toString()),
                            //   isSelected: false,
                            //   onCheckboxChanged: (bool? value) {},
                            // );
                            return CartItemCard1(
                              id: item.id,
                              ingredients: ingredients,
                              name: item.name,
                              unit: item.description,
                              basePrice: item.price.obs,
                              quantity: item.quantity,
                              addQuantity: () {
                                controller.updateItemQuantity(
                                    item.id, item.quantity.value + 1);
                              },
                              removeQuantity: () {
                                controller.updateItemQuantity(
                                    item.id, item.quantity.value - 1);
                              },
                              onDeleteConfirmed: () {
                                controller.removeFromCart(item.id);
                              },
                              textController: TextEditingController(
                                  text: item.quantity.toString()),
                              isSelected: false,
                              onCheckboxChanged: (bool? value) {},
                            );
                          },
                        );
                      })),
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  CartSummary(
                    itemsCost: controller.totalIngredientPrice,
                    mealCost: controller.mealPrepPrice,
                    serviceCharge: controller.calculatedServiceCharge,
                    shippingCost: controller.shippingCost.value,
                    totalAmount: controller.total.obs,
                  ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return CheckoutButton(
                      isEnabled: isCheckoutEnabled,
                      totalAmount: controller.total,
                      cartItems: controller.cartItems,
                      loading: controller.isLoading.value,
                      // onPressed: () {
                      //   // Handle checkout button press
                      //   controller.getCheckoutAddress();
                      // },
                    );
                  }),
                  const SizedBox(height: 16),
                  const PaymentMethods(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
