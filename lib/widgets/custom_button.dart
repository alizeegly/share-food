import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {

  final void Function()? onPressed;
  final Color? color;
  final String text;

  CustomButton({
    this.onPressed,
    this.color,
    this.text = "",
  });


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 65, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
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