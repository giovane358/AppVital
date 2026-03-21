import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vital_application/core/utils/colors.dart';

Widget textFieldFormatterCustom({
  required String hint,
  required bool obscureText,
  required TextEditingController controller,
  required TextInputFormatter formatter,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly, formatter],
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontStyle: FontStyle.italic),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget textFieldCustom({
  required String hint,
  required bool obscureText,
  required TextEditingController controller,
  required keyboardType,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontStyle: FontStyle.italic),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget textFieldPasswordCustom({
  required String hint,
  required bool obscureText,
  required TextEditingController controller,
  required Widget icon,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
    padding: EdgeInsets.symmetric(horizontal: 15),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(30),
    ),
    child: TextField(
      controller: controller,
      obscureText: obscureText,

      decoration: InputDecoration(
        labelText: hint,
        labelStyle: TextStyle(fontStyle: FontStyle.italic),
        border: InputBorder.none,
        suffixIcon: icon,
      ),
    ),
  );
}

Widget buttonCustom({required Widget child}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 45, vertical: 5),
    padding: EdgeInsets.symmetric(horizontal: 0),
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.black),
      color: AppColos.colorButtonRed,
    ),
    child: child,
  );
}

Widget toggleCustom({required Widget child}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 0),
    margin: EdgeInsets.symmetric(horizontal: 45),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black, width: 2),
      borderRadius: BorderRadius.circular(30),
      color: AppColos.colorBackground,
    ),
    child: child,
  );
}
