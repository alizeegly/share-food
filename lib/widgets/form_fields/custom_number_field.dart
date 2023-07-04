import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'dart:math' as math;

class CustomNumberField extends StatelessWidget {

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecre = true;
  bool? enabled = true;
  final intitialValue;

  CustomNumberField({
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
        obscureText: isObsecre!,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [DecimalTextInputFormatter(decimalRange: 2)],

        cursorColor: Theme.of(context).colorScheme.primary,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
          focusColor: Colors.grey,
          labelStyle: const TextStyle(
            fontSize: 15
          ),
          labelText: hintText,
        ),
      ),
    );
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;
  DecimalTextInputFormatter({required this.decimalRange});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue, // unused.
    TextEditingValue newValue,
  ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
  }
}