import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCart;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.showCart = true, required void Function() onBackPressed, required MaterialColor titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.close, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        if (showCart)
          // IconButton(
          //   icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
          //   onPressed: () {
          //     // TODO: Implement cart navigation
          //   },
          // ),
          SvgPicture.asset('assets/images/bag.svg'),
          SizedBox(width: 16,)
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}