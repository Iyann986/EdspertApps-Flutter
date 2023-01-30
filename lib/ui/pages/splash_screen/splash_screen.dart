import 'dart:async';

import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = "splash_screen";

  @override
  Widget build(BuildContext context) {
    Timer(
      Duration(seconds: 5),
      () {
        // Navigator.of(context).push(
        //   MaterialPageRoute(builder: (context) => LoginPage()),
        // );
        Navigator.of(context).pushReplacementNamed(LoginPage.route);
      },
    );

    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          width: 300,
        ),
      ),
    );
  }
}
