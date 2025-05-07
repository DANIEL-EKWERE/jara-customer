// lib/screens/auth/otp_verification.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/otp_verification/controller/otp_verification_controller.dart';
import '../../widgets/customized_app_bar.dart';
import '../../widgets/otp_input.dart';
import '../../widgets/countdown_timer.dart';
import '../new_password_screen/new_password_screen.dart';
import 'package:jara_market/services/api_service.dart';

OtpVerificationController controller = Get.put(OtpVerificationController());

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isVerifying = false;
  bool _showCountdown = false;
  bool _isLoading = false;

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showCountdown = true;
      });
    });
  }

  Future<void> _validateOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final otpData = {
        'email': widget.email,
        'otp': _otpController.text,
      };

      final response = await _apiService.validateUserLoginOtp(otpData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NewPasswordScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP validation failed: ${response.body}')),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _resendOtp() async {
    try {
      final resendData = {
        'email': widget.email,
      };

      // You might need to implement a resend OTP endpoint in your API service
      // For now, we'll use the login endpoint to trigger a new OTP
      final response = await _apiService.login(resendData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new code has been sent to your email.')),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend code: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _otpController.addListener(() {
      setState(() {
        _isVerifying = _otpController.text.length == 4;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'OTP Verification',
        titleColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We have sent a confirmation code to your mail at ${widget.email}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            OtpInput(
              controller: _otpController,
              onCompleted: (String value) {
                setState(() {
                  _isVerifying = value.length == 4;
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  "Didn't Receive Code,",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
                  onPressed: _resendOtp,
                  child: const Text(
                    'Send A New Code',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            if (_showCountdown) const CountdownTimer(duration: Duration(minutes: 4)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying && !_isLoading ? _validateOtp : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isVerifying ? Colors.orange : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isLoading ? 'Verifying...' : 'Verify',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}