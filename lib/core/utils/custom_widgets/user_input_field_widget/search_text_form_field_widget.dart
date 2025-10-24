import 'package:flutter/material.dart';

import '../../responsive/screen_size.dart';

class CustomSearchTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? iconSize;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const CustomSearchTextFormFieldWidget({
    required this.controller,
    required this.hintText,
    this.labelText,
    this.prefixIcon,
    this.iconSize,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Background color
        borderRadius: BorderRadius.circular(20), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2), // Shadow color
            blurRadius: 6,                        // Spread of shadow
            offset: const Offset(0, 3),           // Shadow direction: down
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: getProportionateScreenWidth(iconSize ?? 24)) : null,
          suffixIcon: suffixIcon != null ? Icon(suffixIcon, size: getProportionateScreenWidth(iconSize ?? 24)) : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: getProportionateScreenHeight(12), horizontal: getProportionateScreenWidth(12)),
      
        ),
        style: TextStyle(fontSize: getResponsiveFontSize(24), height: 1.4),
        cursorHeight: getProportionateScreenHeight(22),
        cursorColor: Colors.black,
      ),
    );
  }
}
