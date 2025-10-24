import 'package:flutter/material.dart';
import 'package:inventorymanagement/core/constants/colors_manager.dart';

class ScanButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double elevation;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Widget? prefixIcon;
  final Widget? suffixIcon;// optional icon

  const ScanButtonWidget({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = kPrimary,
    this.textColor = Colors.white,
    this.borderRadius = 12,
    this.elevation = 2,
    this.fontSize = 16,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    this.prefixIcon,
    this.suffixIcon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: padding,
          elevation: elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${text}  "),
            if(prefixIcon !=null)
              prefixIcon!,
            if(suffixIcon != null && prefixIcon !=null)
            Text("  OR  "),
            if(suffixIcon != null)
              suffixIcon!
        ],)
      ),
    );
  }
}
