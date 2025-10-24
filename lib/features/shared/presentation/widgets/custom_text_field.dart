import 'package:flutter/material.dart';

import '../../../../core/utils/responsive/screen_size.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  /*final IconData? suffixIcon;
  final IconData? prefixIcon;*/
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final double fontSize = getResponsiveFontSize(20); // or manually use 20 for tablets
    final double verticalPadding = getProportionateScreenHeight(14); // increase height
    final double horizontalPadding = getProportionateScreenWidth(16); // increase width

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: getProportionateScreenHeight(8),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        style: TextStyle(fontSize: fontSize), // 👈 increases input text size
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          isDense: false, // 👈 important for taller input
          contentPadding: EdgeInsets.symmetric(
            vertical: verticalPadding,
            horizontal: horizontalPadding,
          ), // 👈 increases box size
          labelStyle: TextStyle(fontSize: fontSize),
          hintStyle: TextStyle(fontSize: fontSize * 0.9),
        ),
      ),
    );
  }

}