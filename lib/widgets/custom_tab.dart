import 'package:flutter/material.dart';

class CustomTabItem extends StatelessWidget {

  final bool isSelected;
  final IconData iconData;
  final Function onTap;

  const CustomTabItem({
    required this.isSelected,
    required this.iconData,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).colorScheme.secondary : null
        ),
        padding: const EdgeInsets.all(0),
        child: IconButton(
          enableFeedback: false,
          onPressed: onTap as void Function()?,
          icon: isSelected
            ? Icon(
              iconData,
              color: Colors.white,
              size: 30,
            )
            : Icon(
              iconData,
              color: Colors.black,
              size: 30,
              weight: 0.2,
            ),
        ),
      ),
    );
  }
}