import 'dart:async';
import 'dart:developer' as myLog;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:jara_market/config/routes.dart';
import 'package:jara_market/screens/cart_screen/controller/cart_controller.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
import 'package:jara_market/screens/main_screen/main_screen.dart';
import 'package:jara_market/widgets/cart_widgets/cart_summary_card.dart';
import 'package:jara_market/widgets/cart_widgets/checkout_button_paystack.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import '../../widgets/payment_method_card.dart';
import '../../widgets/address_card.dart';
import '../../widgets/summary_breakdown_card.dart';
import '../../widgets/message_box.dart';
import 'package:jara_market/screens/cart_screen/models/models.dart';

CheckoutController controller = Get.put(CheckoutController());
var cartController = Get.find<CartController>();

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;
  final Map<String, dynamic> orderAddress;
  final double balance;
  final String path;

  const CheckoutScreen({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
    required this.orderAddress,
    required this.balance, required this.path,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = '';

  String fullName = 'Jacob Peter';
  Map<String, dynamic> result = {};

  getName() async {
    var name = await dataBase.getFullName();
    setState(() {
      fullName = name;
    });
  }

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
    getName();
  }


Timer? _timer;
Duration _recordingDuration = Duration.zero;
DateTime? _pauseStartTime;
// bool _isPaused = false;



String get _durationText {
  final minutes = _recordingDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = _recordingDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
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

  double get deliveryFee => 0;

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Icon(
              Icons.chevron_left,
              size: 26,
            )),
        centerTitle: true,
        title: const Text(
          'Cart Summary',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    // padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = cartController.cartItems[index];
                      final ingredients = item.ingredients;
                      return CartItemCard2(
                        id: item.id,
                        ingredients: ingredients,
                        name: item.name,
                        unit: item.description,
                        basePrice: item.price,
                        quantity: item.quantity,
                        textController: TextEditingController(
                          text: (item.quantity).toString(),
                        ),
                        isSelected: false,
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  widget.path.isEmpty || widget.path == '' ?  SizedBox.shrink() :
                  IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.play_arrow,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: (){
                              _playRecording(widget.path);
                            },
                          ) ,
                //  ElevatedButton(onPressed: (){print('starting');_startRecording();}, child: Text('start recode')),
                  // MessageBox(
                  //   controller: _messageController,
                  //   hintText: 'Add a message...',
                  //   isPaused: _isPaused,
                  //   isPlayed: isPlayed,
                  //   isResumed: isResumed,
                  //   isStoped: isStoped,
                  //   isRecording: _isRecording,
                  //   filePath: recordingPath,
                  //   recordingDuration: _durationText,
                  //   onVoicePressedDelete: (){
                  //     setState(() {
                  //       recordingPath = '';
                  //        _stopTimer();
                  //        _stopRecording(); // Optional depending on your logic
                  //     });
                  //   },
                  //   onVoicePressedPlay: () {
                  //     _playRecording(recordingPath);
                  //   },
                  //   onVoicePressedStop: () {
                  //     _stopRecording();
                  //   },
                  //   onVoicePressed: () {
                  //     print('starting');
                  //     if (_isRecording) {
                  //       myLog.log('is Recording');
                  //       if (_isPaused) {
                  //         myLog.log('is paused new resuming');
                  //         _resumeRecording();
                  //          _resumeTimer();
                  //       } else {
                  //         myLog.log('it was playing now resuming');
                  //         _pauseRecording();
                  //           _pauseTimer();
                  //       }
                  //     } else {
                  //       myLog.log('stoping rcorder');
                  //       _startRecording();
                  //        _startTimer();
                  //     }
                  //   },
                  // ),
                  const SizedBox(height: 24),
                  SummaryBreakdown(
                    mealPrep: cartController.mealPrepPrice,
                    itemsTotal: widget.totalAmount,
                    serviceChargePercentage:
                        cartController.calculatedServiceCharge,
                    deliveryFee: cartController.shippingCost.value,
                    total: widget.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  (widget.balance < widget.totalAmount)
                      ? AbsorbPointer(
                          child: CheckoutButtonPaystack(
                            color: Colors.grey[400],
                            title: 'Insufficient Balance ${widget.balance}',
                            amount: widget.totalAmount,
                          ),
                        )
                      : Obx(() {
                          return CheckoutButtonPaystack(
                            title: controller.isLoading.value
                                ? 'Initializing Payment...'
                                : 'Check Out',
                            amount: widget.totalAmount,
                          );
                        }),
                  const SizedBox(height: 24),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        PaymentMethodCard(
                          imagePath: 'assets/images/Paypal.png',
                          name: 'Bank Transfer',
                          isSelected: _selectedPaymentMethod == 'bank',
                          onTap: () => _selectPaymentMethod('bank'),
                        ),
                        const SizedBox(width: 8),
                        PaymentMethodCard(
                          imagePath: 'assets/images/Visa.png',
                          name: 'Visa',
                          isSelected: _selectedPaymentMethod == 'visa',
                          onTap: () => _selectPaymentMethod('visa'),
                        ),
                        const SizedBox(width: 8),
                        PaymentMethodCard(
                          imagePath: 'assets/images/Mastercard.png',
                          name: 'Mastercard',
                          isSelected: _selectedPaymentMethod == 'mastercard',
                          onTap: () => _selectPaymentMethod('mastercard'),
                        ),
                        const SizedBox(width: 8),
                        PaymentMethodCard(
                          imagePath: 'assets/images/Amex.png',
                          name: 'USSD',
                          isSelected: _selectedPaymentMethod == 'ussd',
                          onTap: () => _selectPaymentMethod('ussd'),
                        ),
                        const SizedBox(width: 8),
                        PaymentMethodCard(
                          imagePath: 'assets/images/ApplePay.png',
                          name: 'Apple Pay',
                          isSelected: _selectedPaymentMethod == 'apple',
                          onTap: () => _selectPaymentMethod('apple'),
                        ),
                        const SizedBox(width: 8),
                        PaymentMethodCard(
                          imagePath: 'assets/images/GPay.png',
                          name: 'Google Pay',
                          isSelected: _selectedPaymentMethod == 'google',
                          onTap: () => _selectPaymentMethod('google'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  result.isNotEmpty
                      ? Obx(() {
                          return AddressCard(
                            name: fullName,
                            action: 'Change',
                            address:
                                '${controller.selectedAddress},${controller.selectedState},${controller.selectedCountry} ',
                            onChangePressed: () async {
                              print('change address pressed');
                              //Get.toNamed(AppRoutes.checkoutAddressChange);
                              // Navigator.of(context).push(
                              //   CupertinoPageRoute(
                              //     builder: (context) => CheckoutAddressChangeScreen(),
                              //   ),
                              // );
                              result = await Get.toNamed(
                                  AppRoutes.checkoutAddressChange,
                                  arguments: {
                                    'isFromProfile': widget.orderAddress.isEmpty
                                        ? true
                                        : false,
                                  });
                              if (result.isNotEmpty) {
                                setState(() {
                                  controller.selectedAddress.value =
                                      result['contact_address'];
                                  controller.selectedCountry.value =
                                      result['country'];
                                  controller.selectedState.value =
                                      result['state'];
                                  controller.selectedLga.value = result['lga'];
                                  controller.number.value =
                                      result['phone_number'];
                                });
                              }
                            },
                          );
                        })
                      : AddressCard(
                          name: fullName,
                          action:
                              widget.orderAddress.isNotEmpty ? 'Change' : 'Add',
                          address: widget.orderAddress.isNotEmpty
                              ? '${widget.orderAddress['contact_address']},${widget.orderAddress['lga']},${widget.orderAddress['state']},${widget.orderAddress['country']}.'
                              : 'Set Address to recieve your order.',
                          onChangePressed: () async {
                            print('change address pressed');
                            //Get.toNamed(AppRoutes.checkoutAddressChange);
                            // Navigator.of(context).push(
                            //   CupertinoPageRoute(
                            //     builder: (context) => CheckoutAddressChangeScreen(),
                            //   ),
                            // );
                            result = await Get.toNamed(
                                AppRoutes.checkoutAddressChange,
                                arguments: {
                                  'isFromProfile': widget.orderAddress.isEmpty
                                      ? true
                                      : false,
                                });
                          },
                        ),
                ],
              ),
            ),
            //ElevatedButton(onPressed: (){print(result);}, child: Text('Print Result'))
          ],
        ),
      ),
    );
  }
}
