import 'package:flutter/material.dart';

class TextFieldCustom extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Widget? suffixIcons;
  final Widget? prefixIcons;
  final String? Function(String value) validator;
  final bool? obstructIcons;

  const TextFieldCustom({
    super.key,
    required this.label,
    required this.controller,
    this.suffixIcons,
    this.prefixIcons,
    required this.validator,
    this.obstructIcons,
  });

  @override
  TextFieldCustomState createState() => TextFieldCustomState();
}

class TextFieldCustomState extends State<TextFieldCustom> {
  String? errorText;

  /// ✅ Call this to externally trigger validation
  bool validator() {
    final error = widget.validator(widget.controller.text);
    setState(() {
      errorText = error;
    });
    return error == null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.obstructIcons ?? false,
          onChanged: (value) {
            final error = widget.validator(value);
            setState(() {
              errorText = error;
            });
          },
          decoration: InputDecoration(
            labelText: widget.label,
            suffixIcon: widget.suffixIcons,
            prefixIcon: widget.prefixIcons,
            errorText: errorText,
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
