import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController customController;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomTextFormField({
    Key? key,
    required this.label,
    required this.hintText,
    required this.customController,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
  }) : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6.0),
            child: Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        TextFormField(
          controller: widget.customController,
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscureText : false,
          validator: widget.validator, // ✅ No error here
          decoration: InputDecoration(
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon)
                : null,
            suffixIcon: widget.isPassword
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : widget.suffixIcon != null
                ? IconButton(
              icon: Icon(widget.suffixIcon),
              onPressed: widget.onSuffixTap,
            )
                : null,
            hintText: widget.hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
