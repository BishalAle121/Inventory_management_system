import 'package:flutter/material.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText; // <-- stays above the field
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final double? iconSize;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;

  const CustomTextFormFieldWidget({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // align label to left
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 0), // space between label & field
        ],
        Container(
          height: 50,
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            onChanged: onChanged,
            onFieldSubmitted: onFieldSubmitted,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: prefixIcon != null
                  ? Icon(prefixIcon, size: iconSize ?? 24)
                  : null,
              suffixIcon: suffixIcon != null
                  ? Icon(suffixIcon, size: iconSize ?? 24)
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            ),
          ),
        ),
      ],
    );
  }
}
