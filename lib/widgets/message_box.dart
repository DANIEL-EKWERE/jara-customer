// lib/widgets/message_box.dart
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback? onVoicePressed;

  const MessageBox({
    Key? key,
    required this.controller,
    this.hintText,
    this.onVoicePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Message',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontFamily: 'Roboto',
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Lorem ipsum dolor sit amet consectetur. Fringilla',
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'Roboto',
            color: Color(0xff2D2D2D),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Stack(
            children: [
              TextField(
                controller: controller,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey.shade200,
                    ),
                    child: const Icon(
                      Icons.mic,
                      color: Colors.grey,
                      size: 20,
                    ),
                  ),
                  onPressed: onVoicePressed,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}