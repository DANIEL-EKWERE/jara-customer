import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final bool showSearch;

  const AppHeader({
    Key? key,
    required this.title,
    this.onBackPressed,
    this.showSearch = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          if (onBackPressed != null)
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: onBackPressed,
            ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (showSearch)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Implement search
              },
            ),
        ],
      ),
    );
  }
}

