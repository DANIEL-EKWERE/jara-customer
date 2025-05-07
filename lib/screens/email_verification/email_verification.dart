import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/email_verification/controller/email_verification_controller.dart';
import 'package:jara_market/widgets/customized_app_bar.dart';
import '../../widgets/otp_input.dart';
import '../../widgets/countdown_timer.dart';
import '../login_screen/login_screen.dart';
import 'package:jara_market/services/api_service.dart'; // Import ApiService

EmailVerificationController controller = Get.put(EmailVerificationController());

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final ApiService _apiService = ApiService(); // Add ApiService
  bool _isVerifying = false;
  bool _showCountdown = false;
  bool _isLoading = false; // Add loading state

  void _startCountdown() {
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _showCountdown = true;
      });
    });
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final otpData = {
        'email': widget.email,
        'otp': _otpController.text,
      };

      final response = await _apiService.validateUserSignupOtp(otpData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else {
        var  responseBody = jsonDecode(response.body);
        var message = responseBody['message'] ?? 'something went wrong';
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP verification failed: ${message}')),
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
      // For now, we'll reuse the registration endpoint
      final response = await _apiService.registerCustomer(resendData);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A new code has been sent to your email')),
        );
        _startCountdown();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to resend code: ${response.body}["message"]')),
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
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Email Verification',
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
              _showCountdown ?  AbsorbPointer(
                  child: TextButton(
                    onPressed: _resendOtp, // Use the resendOtp method
                    child: const Text(
                      'Send A New Code',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ) : AbsorbPointer(
                  child: TextButton(
                    onPressed: _resendOtp, // Use the resendOtp method
                    child: const Text(
                      'Send A New Code',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
            if (_showCountdown) const CountdownTimer(duration: Duration(minutes: 4)),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isVerifying && !_isLoading ? _verifyOtp : null, // Use verifyOtp method
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