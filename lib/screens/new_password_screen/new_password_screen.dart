import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/new_password_screen/controller/new_password_controller.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/password_input.dart';
import '../login_screen/login_screen.dart';
import 'package:jara_market/services/api_service.dart'; // Import ApiService

NewPasswordController controller = Get.put(NewPasswordController());

class NewPasswordScreen extends StatefulWidget {
  final String? email; // Make email optional but needed for password reset
  final String? token; // Token from OTP verification

  const NewPasswordScreen({Key? key, this.email, this.token}) : super(key: key);

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5)); // Add ApiService
  bool _isPasswordValid = false;
  bool _isLoading = false; // Add loading state

  void _validatePasswords() {
    setState(() {
      _isPasswordValid = _newPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmPasswordController.text &&
          _newPasswordController.text.length >= 8; // Ensure password is at least 8 characters
    });
  }

  Future<void> _resetPassword() async {
    if (widget.email == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is required for password reset')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final resetData = {
        'email': widget.email,
        'token': widget.token,
        'new_password': _newPasswordController.text,
      };

      // You might need to implement a reset password endpoint in your API service
      // For now, we'll use the login endpoint
      final response = await _apiService.login(resetData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password reset successful')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset failed: ${response.body}')),
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
        title: 'New Password',
        titleColor: Colors.orange,
        onBackPressed: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Enter a New Password Below',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            PasswordInput(
              label: 'New Password',
              controller: _newPasswordController,
              onChanged: (_) => _validatePasswords(),
            ),
            const SizedBox(height: 16),
            PasswordInput(
              label: 'Confirm Password',
              controller: _confirmPasswordController,
              onChanged: (_) => _validatePasswords(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPasswordValid && !_isLoading ? _resetPassword : null,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: _isPasswordValid ? Colors.orange : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  _isLoading ? 'Processing...' : 'Submit',
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