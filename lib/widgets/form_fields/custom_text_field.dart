import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;
  final intitialValue;

  CustomTextField({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled,
    this.intitialValue
  });


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // color: Colors.white,
        // borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border(bottom: BorderSide(color: Colors.black, style: BorderStyle.solid)),
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        initialValue: intitialValue,
        obscureText: isObsecre!,
        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          // prefixIcon: Icon(
          //   data,
          //   color: Colors.cyan
          // ),
          focusColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 15
          ),
          // hintText: hintText,
          labelText: hintText
        ),
      ),
    );
  }
}