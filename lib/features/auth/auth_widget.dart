import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';

Widget toggleCustom({required Widget child}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
    margin: EdgeInsets.symmetric(horizontal: 45),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(30),
      color: AppColors.colorBackground,
    ),
    child: child,
  );
}
