import 'package:flutter/material.dart';

class CustomDateTimeField extends StatelessWidget {

  final TextEditingController? controller;
  String? setState;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;

  CustomDateTimeField({
    this.controller,
    this.setState,
    this.data,
    this.hintText,
    this.isObsecre,
    this.enabled
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
        enabled: false,
        controller: controller,
        obscureText: isObsecre!,
        onSaved: (String? val) {
          setState = val;
        },
        keyboardType: TextInputType.text,

        cursorColor: Theme.of(context).colorScheme.primary,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          // prefixIcon: Icon(
          //   data,
          //   color: Colors.cyan
          // ),
          focusColor: Colors.grey,
          labelStyle: TextStyle(
            fontSize: 15,
            color: Colors.grey.shade800
          ),
          // hintText: hintText,
          labelText: hintText
        ),
      ),
    );
  }
}