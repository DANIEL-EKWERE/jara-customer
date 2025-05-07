import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/checkout_screen/controller/checkout_controller.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:jara_market/services/api_service.dart';
// import 'package:jara_market/widgets/custom_bottom_nav.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/cart_widgets/cart_item_card.dart';
import '../../widgets/payment_method_card.dart';
import '../../widgets/address_card.dart';
import '../../widgets/summary_breakdown_card.dart';
import '../../widgets/message_box.dart';
import '../wallet_screen/wallet_screen.dart';
import '../../models/cart_item.dart';

CheckoutController controller = Get.put(CheckoutController()) ;

class CheckoutScreen extends StatefulWidget {
  final double totalAmount;
  final List<CartItem> cartItems;

  const CheckoutScreen({
    Key? key,
    required this.totalAmount,
    required this.cartItems,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = '';
  final TextEditingController _messageController = TextEditingController();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
  bool _isRecording = false;
  bool _isPaused = false;
  String? _recordingPath;
  bool _isRecorderInitialized = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
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

    try {
      final directory = await getApplicationDocumentsDirectory();
      _recordingPath =
          '${directory.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.aac';

      await _recorder.startRecorder(toFile: _recordingPath);
      setState(() {
        _isRecording = true;
        _isPaused = false;
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

    try {
      final recordingResult = await _recorder.stopRecorder();
      setState(() {
        _isRecording = false;
        _isPaused = false;
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Playing voice note...'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  double get deliveryFee => 0;

  Future<void> _createOrder() async {
    final orderData = {
      'user_id': 'userId', // Replace with actual user ID
      'total': widget.totalAmount,
      'shipping_fee': deliveryFee,
      'status': 'pending',
      'items': widget.cartItems.map((item) {
        return {
          'product_id': item.id ?? 'unknown',
          'quantity': item.quantity ?? 1,
        };
      }).toList(),
    };

    final response = await _apiService.postOrder(orderData);
    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const WalletScreen()),
      );
    } else {
      print('Failed to create order: ${response.body}');
    }
  }

  void _selectPaymentMethod(String method) {
    setState(() {
      _selectedPaymentMethod = method;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Summary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
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
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: widget.cartItems.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = widget.cartItems[index];
                      return CartItemCard(
                        name: item.name ?? 'Unknown',
                        unit: item.description ?? 'No description',
                        basePrice: item.price ?? 0.0,
                        quantity: item.quantity ?? 1,
                        onQuantityChanged: (qty) {
                          // Handle quantity change if needed
                        },
                        onDeleteConfirmed: () {},
                        textController: TextEditingController(
                          text: (item.quantity ?? 1).toString(),
                        ),
                        isSelected: false,
                        onCheckboxChanged: (value) {},
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  MessageBox(
                    controller: _messageController,
                    hintText: 'Add a message...',
                    onVoicePressed: () {
                      if (_isRecording) {
                        if (_isPaused) {
                          _resumeRecording();
                        } else {
                          _pauseRecording();
                        }
                      } else {
                        _startRecording();
                      }
                    },
                  ),
                  const SizedBox(height: 24),
                  SummaryBreakdown(
                    itemsTotal: widget.totalAmount,
                    serviceChargePercentage: 0,
                    deliveryFee: deliveryFee,
                    total: widget.totalAmount,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Payment Methods',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 16),
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
                  AddressCard(
                    name: 'Jacob Peter',
                    address: '2972 Westheimer Rd. Santa Ana, Illinois 85486',
                    onChangePressed: () {},
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
