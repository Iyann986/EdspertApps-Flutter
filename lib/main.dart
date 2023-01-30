import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/register_page/register_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/bottom_nav.dart';
import 'package:finalproject_edspertapp/ui/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: const SplashScreen(),
      initialRoute: "/",
      routes: {
        "/": (context) => const SplashScreen(),
        LoginPage.route: (context) => const LoginPage(),
        RegisterPage.route: (context) => const RegisterPage(),
        BottomNavBar.route: (context) => const BottomNavBar(),
      },
    );
  }
}
