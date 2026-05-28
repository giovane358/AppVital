import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';

class ButtonCustom extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final double height;

  const ButtonCustom({
    super.key,
    required this.child,
    required this.onTap,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 45, vertical: 5),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.black),
          color: AppColors.colorButtonRed,
        ),
        child: Center(child: child),
      ),
    );
  }
}