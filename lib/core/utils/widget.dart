import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_application/core/utils/colors.dart';

class TextFieldCustom extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;

  const TextFieldCustom({
    super.key,
    required this.hint,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          labelText: hint,
          labelStyle: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 14,
          ),
          border: InputBorder.none,
          isDense: true,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}

Widget buttonCustom({required Widget child, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black),
        color: AppColors.colorButtonRed,
      ),
      child: Center(child: child),
    ),
  );
}
