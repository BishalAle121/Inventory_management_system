import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 110, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 5,
      ),
      child: isLoading
          ? const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
      )
          : Text(
        label,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
