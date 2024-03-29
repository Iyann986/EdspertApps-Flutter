import 'dart:async';

import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/helpers/user_email.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/bottom_nav.dart';
import 'package:flutter/material.dart';

import '../../data/models/network_response.dart';
import '../../data/models/user_response.dart';
import '../../data/repository/auth_repository.dart';
import '../auth/register_page/register_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String route = "splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 5),
      () async {
        final user = UserEmail.getUserEmail();

        if (user != null) {
          final dataUser = await AuthRepository().getUserResponse();
          if (dataUser.status == Status.success) {
            final data = UserResponse.fromJson(dataUser.data!);
            if (data.status == 1) {
              Navigator.of(context).pushReplacementNamed(BottomNavBar.route);
            } else {
              Navigator.of(context).pushReplacementNamed(RegisterPage.route);
            }
          }
        } else {
          Navigator.of(context).pushReplacementNamed(LoginPage.route);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: Center(
        child: Image.asset(
          R.assets.icSplash,
          width: 250,
          height: 250,
        ),
      ),
    );
  }
}
