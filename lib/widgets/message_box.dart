// lib/widgets/message_box.dart
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final VoidCallback? onVoicePressed;
  final VoidCallback? onVoicePressedStop;
  final VoidCallback? onVoicePressedPlay;
  final VoidCallback? onVoicePressedDelete;
  final bool isPaused;
  final bool isResumed;
  final bool isStoped;
  final bool isPlayed;
  final bool isRecording;
  final String? filePath;
  final String? recordingDuration;

  const MessageBox({
    Key? key,
    required this.controller,
    this.hintText,
    this.onVoicePressed,
    this.onVoicePressedStop,
    this.onVoicePressedPlay,
    this.onVoicePressedDelete,
    required this.isPaused,
    required this.isResumed,
    required this.isPlayed,
    required this.isStoped,
    required this.isRecording,
    required this.filePath,
    this.recordingDuration,
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
           filePath != null ?   Positioned(
                  bottom: 8,
                  left: 8,
                  child: Row(
                    children: [
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
                        onPressed: onVoicePressedPlay,
                      ),
                      IconButton(
                        icon: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                          ),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                            size: 20,
                          ),
                        ),
                        onPressed: onVoicePressedDelete,
                      ),


isRecording?
 Row(children: [
  AnimatedOpacity(
  duration: const Duration(milliseconds: 500),
  opacity: isRecording ? 1.0 : 0.0,
  child: Container(
    width: 8,
    height: 8,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: Colors.red,
    ),
  ),
),
        Text(
          recordingDuration ?? '00:00', // <- Replace with actual timer text from parent widget
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        )
 ],) : SizedBox.shrink()

                    ],
                  )): SizedBox.shrink(),
              Positioned(
                right: 8,
                bottom: 8,
                child: Row(
                  children: [
                    isRecording
                        ? IconButton(
                            icon: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey.shade200,
                              ),
                              child: const Icon(
                                Icons.stop,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),
                            onPressed: onVoicePressedStop,
                          )
                        : SizedBox.shrink(),
                  isRecording ? IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey.shade200,
                        ),
                        child:  Icon(
                        isPaused ? Icons.play_circle : Icons.pause,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                      onPressed: onVoicePressed,
                    )  : IconButton(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
