import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jara_market/screens/referral_screen/controller/referral_controller.dart';

ReferralController controller = Get.put(ReferralController());

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Earn Money\nBy Refer',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.shopping_bag_outlined),
                        onPressed: () {
                          // TODO: Implement cart navigation
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Text(
                          'mir20220320',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            // TODO: Implement copy functionality
                          },
                          child: const Text('Copy'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // TODO: Implement share functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                          ),
                          child: const Text('SHARE'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Invite a friend',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildFriendItem(
                    name: 'Jessica Prince',
                    isInvited: index > 1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendItem({
    required String name,
    required bool isInvited,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey[300],
        child: const Icon(Icons.person, color: Colors.grey),
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: ElevatedButton(
        onPressed: isInvited ? null : () {},
        style: ElevatedButton.styleFrom(
          foregroundColor: isInvited ? Colors.grey : Colors.orange, backgroundColor: isInvited ? Colors.grey[200] : Colors.orange[100],
        ),
        child: Text(isInvited ? 'Invited' : 'Invite'),
      ),
    );
  }
}