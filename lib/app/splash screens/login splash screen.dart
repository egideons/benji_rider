// ignore_for_file: camel_case_types, file_names

import 'package:flutter/material.dart';

import '../dashboard/dashboard.dart';

class LoginSplashScreen extends StatelessWidget {
  const LoginSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const Dashboard()),
        (route) => false,
      );
    });

    return SafeArea(
      maintainBottomViewPadding: true,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Center(
              child: Container(
                width: 400,
                height: 500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/animations/splash screen/successful.gif",
                    ),
                  ),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
