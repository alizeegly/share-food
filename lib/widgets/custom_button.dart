import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final VoidCallback onPressed;
  final Color? color;
  final String text;

  const CustomButton({
    required this.onPressed,
    this.color,
    this.text = "",
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        minimumSize: const Size.fromHeight(50)
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16
        ),
      )
    );
  }
}