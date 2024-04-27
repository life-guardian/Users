import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.onChanged,
    this.hintText,
    this.suffixIcon,
  });
  final void Function(String value) onChanged;
  final String? hintText;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return TextField(
      onChanged: (value) {
        onChanged(value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: (themeData.brightness == Brightness.light)
            ? const Color.fromARGB(161, 255, 255, 255)
            : Theme.of(context).colorScheme.primary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color.fromARGB(156, 158, 158, 158)),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        labelText: hintText,
        labelStyle:
            TextStyle(color: Theme.of(context).colorScheme.onBackground),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
