import 'package:flutter/material.dart';
import 'package:vital_application/core/utils/colors.dart';
import 'package:vital_application/core/utils/img.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Luiz", style: TextStyle(fontSize: 20, color: Colors.red)),
            Image.asset(Img.logoName),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(color: Colors.amber),
              child: Icon(Icons.abc_outlined),
            ),
          ],
        ),
      ),
    );
  }
}
