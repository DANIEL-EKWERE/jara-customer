import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  ApiService _apiService = ApiService(Duration(seconds: 60 * 5));
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
                      avatarRadius: 60,
                      editIconSize: 24,
                      imageUrl: _userProfile['profile_image'],
                      onEditPressed: () {
                        // Show dialog to update profile image
                        _showEditProfileImageDialog();
                      },
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Daniel Ekwere',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text(
                        'Contact Information',
                        style: TextStyle(
                          fontSize: 13,
                          //(MediaQuery.of(context).size.width / 100 ) * 10,
                          fontFamily: 'Mont',
                         fontWeight: FontWeight.w300,
                        ),),
                        // ElevatedButton.icon(
                        //   icon: const Icon(Icons.chevron_right_rounded),
                        //   label: const Text('Edit'),
                        //   onPressed: () {
                        //     // Show dialog to edit contact info
                        //     _showEditContactInfoDialog();
                        //   },
                        // ),
                        GestureDetector(
                          onTap: (){
                            _showEditContactInfoDialog();
                          },
                          child: Row(children: [Text('Edit',style: TextStyle(color: Colors.amber,fontFamily: 'Mont'),),Icon(Icons.chevron_right_outlined,color: Colors.amber,)],))
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ContactInfoCard(
                    //   email: _userProfile['email'] ?? '',
                    //   phone: _userProfile['phone'] ?? '',
                    //   onEditPressed: () {
                    //     // Show dialog to edit contact info
                    //     _showEditContactInfoDialog();
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20),
                          
                          ),
                          color: Color.fromARGB(14, 45, 45, 1),
                          border: Border.all(width: 1,color: const Color.fromARGB(88, 128, 128, 128))
                        ),
                        child: Column(
                          
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('Phone Number',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.normal),),
                              Text('+2347043194111',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                           
                           SvgPicture.asset('assets/images/Vector(5).svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('Email Address',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.normal),),
                              Text('ekweredaniel8@gmail.com',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                           SvgPicture.asset('assets/images/Group 35689.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                           //Icon(Icons.email,color: Colors.amber,size: 20,),
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              Text('Address',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.normal),),
                              Text('Obot Idim. ibesikpo',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                            SvgPicture.asset('assets/images/location.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                          // Icon(Icons.location_on,color: Colors.amber,size: 20,),
                          ],)
                        ],),
                      ),
                    ),
                    const SizedBox(height: 16),
                   // const SettingsCard(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20),
                          
                          ),
                          color: Color.fromARGB(14, 45, 45, 1),
                          border: Border.all(width: 1,color: const Color.fromARGB(88, 128, 128, 128))
                        ),
                        child: Column(
                          
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/alarm.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Notifications',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600),),
                            ],),
                           
                          // SvgPicture.asset('assets/images/Vector(5).svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                          TextButton(onPressed: (){}, child: Text('on',style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 18),))
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/wallet.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('wallet',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                         
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/referral.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Referral',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                           //
                          ],)
                        ],),
                      ),
                    ),

                    const SizedBox(height: 16),
                 //   const AdditionalOptionsCard(),

                   Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20),
                          
                          ),
                          color: Color.fromARGB(14, 45, 45, 1),
                          border: Border.all(width: 1,color: const Color.fromARGB(88, 128, 128, 128))
                        ),
                        child: Column(
                          
                          children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/security.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Security',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600),),
                            ],),
                           
                          // SvgPicture.asset('assets/images/Vector(5).svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),
                       //   TextButton(onPressed: (){}, child: Text('on',style: TextStyle(color: Colors.amber, fontWeight: FontWeight.w600, fontSize: 18),))
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/help_and_support.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Help and Support',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                         
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/contact_us.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Contact Us',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                           //
                          ],),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                              SvgPicture.asset('assets/images/privacy_policy.svg',semanticsLabel: 'Dart Logo',height: 20,width: 20,),SizedBox(width: 5,),
                              Text('Privacy Policy',style: TextStyle(fontSize: 13,fontFamily: 'Mont', fontWeight: FontWeight.w600)),
                            ],),
                           //
                          ],)
                        ],),
                      ),
                    ),
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
