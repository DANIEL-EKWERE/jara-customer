import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/forget_password_screen/controller/forget_password_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../otp_verification/otp_verification.dart';
import '../../widgets/customized_text_field.dart';
import 'package:jara_market/services/api_service.dart'; // Import ApiService

ForgetPasswordController controller = Get.put(ForgetPasswordController());

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5)); // Add ApiService
  bool _isEmailValid = false;
  bool _isLoading = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _emailController.text = '';
    _validateEmail();
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(_emailController.text);
    });
  }

  Future<void> _requestPasswordReset() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final resetData = {
        'email': _emailController.text,
        'reset_password': true, // Flag to indicate password reset request
      };

      // Use login endpoint to trigger password reset flow
      final response = await _apiService.login(resetData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(email: _emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset request failed: ${response.body}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Forget Password',
        titleColor: Colors.orange,
        onBackPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter your registered email below',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            CustomTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter your email',
              onChanged: (value) {
                _validateEmail();
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isEmailValid && !_isLoading ? _requestPasswordReset : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isEmailValid ? Colors.orange : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Processing...' : 'Verify',
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