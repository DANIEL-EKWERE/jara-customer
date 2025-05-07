import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/profile_screen/controller/profile_controller.dart';
import 'package:jara_market/services/api_service.dart';
// import 'package:jara_market/widgets/custom_bottom_nav.dart';
import '../../widgets/avatar_with_edit.dart';
import '../../widgets/contact_info_card.dart';
import '../../widgets/settings_card.dart';
import '../../widgets/additional_options_card.dart';

ProfileController controller = Get.put(ProfileController());

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  Map<String, dynamic> _userProfile = {};
  late String _userEmail; // This should be retrieved from user session/storage

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      // Replace fetchUserProfile with getUser
      final response = await _apiService.getUser();

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _userProfile = jsonDecode(response.body);
          _userEmail = _userProfile['email'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load profile: ${response.body}')),
        );
      }
    } catch (e, stackTrace) {
      print('Error: $e');
      print('Stack Trace: $stackTrace');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateUserProfile(Map<String, dynamic> updatedData) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final response =
          await _apiService.editUserProfile(_userEmail, updatedData);

      setState(() {
        _isLoading = false;
      });

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Refresh profile data
        _fetchUserProfile();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    AvatarWithEdit(
                      avatarRadius: 50,
                      editIconSize: 24,
                      imageUrl: _userProfile['profile_image'],
                      onEditPressed: () {
                        // Show dialog to update profile image
                        _showEditProfileImageDialog();
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '${_userProfile['first_name'] ?? ''} ${_userProfile['last_name'] ?? ''}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ContactInfoCard(
                      email: _userProfile['email'] ?? '',
                      phone: _userProfile['phone'] ?? '',
                      onEditPressed: () {
                        // Show dialog to edit contact info
                        _showEditContactInfoDialog();
                      },
                    ),
                    const SizedBox(height: 16),
                    const SettingsCard(),
                    const SizedBox(height: 16),
                    const AdditionalOptionsCard(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
      ),
    );
  }

  void _showEditProfileImageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Profile Picture'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Implement image picker from gallery
                Navigator.pop(context);
                // After picking image, update profile
                // _updateUserProfile({'profile_image': imageUrl});
              },
              child: const Text('Choose from Gallery'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Implement camera capture
                Navigator.pop(context);
                // After capturing image, update profile
                // _updateUserProfile({'profile_image': imageUrl});
              },
              child: const Text('Take a Photo'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showEditContactInfoDialog() {
    final TextEditingController phoneController =
        TextEditingController(text: _userProfile['phone']);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Contact Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _updateUserProfile({
                'phone': phoneController.text,
              });
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
