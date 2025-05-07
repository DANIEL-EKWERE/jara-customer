import 'package:flutter/material.dart';

class AvatarWithEdit extends StatelessWidget {
  final double avatarRadius;
  final double editIconSize;
  final String? imageUrl;
  final VoidCallback? onEditPressed;

  const AvatarWithEdit({
    Key? key,
    required this.avatarRadius,
    required this.editIconSize,
    this.imageUrl,
    this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: avatarRadius,
          backgroundImage: imageUrl != null && imageUrl!.isNotEmpty
              ? NetworkImage(imageUrl!)
              : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: onEditPressed,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.edit,
                color: Colors.white,
                size: editIconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}