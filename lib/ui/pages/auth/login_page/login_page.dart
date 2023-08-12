import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/user_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/auth_repository.dart';
import 'package:finalproject_edspertapp/ui/helpers/preference_helper.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/register_page/register_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = "login_screen";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F7F8),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  R.strings.login,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Image.asset(R.assets.imgLogin),
            const SizedBox(
              height: 35,
            ),
            Text(
              R.strings.welcome,
              style: GoogleFonts.poppins().copyWith(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            Text(
              R.strings.loginDesc,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xff6A7483)),
            ),
            const Spacer(),
            ButtonLogin(
              onTap: () async {
                await signInWithGoogle();

                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  final dataUser = await AuthRepository().getUserResponse();
                  if (dataUser.status == Status.success) {
                    final data = UserResponse.fromJson(dataUser.data!);
                    if (data.status == 1) {
                      await PreferenceHelper().setUserData(data.data!);
                      Navigator.of(context).pushNamed(BottomNavBar.route);
                    } else {
                      Navigator.of(context).pushNamed(RegisterPage.route);
                    }
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Gagal Masuk"),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              backgroundColor: Colors.white,
              borderColor: R.colors.toscaBorderSide,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icGoogle),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    R.strings.loginWithGoogle,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff1A1F26),
                    ),
                  ),
                ],
              ),
            ),
            ButtonLogin(
              onTap: () {},
              backgroundColor: Colors.black,
              borderColor: R.colors.blackBorderSide,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(R.assets.icApple),
                  const SizedBox(
                    width: 15,
                  ),
                  Text(
                    R.strings.loginWithApple,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({
    Key? key,
    required this.backgroundColor,
    required this.child,
    required this.borderColor,
    required this.onTap,
    this.radius,
  }) : super(key: key);

  final double? radius;
  final Color backgroundColor;
  final Widget child;
  final Color borderColor;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 25),
            side: BorderSide(color: borderColor),
          ),
          fixedSize: Size(MediaQuery.of(context).size.width * 0.8, 50),
        ),
        onPressed: onTap,
        child: child,
      ),
    );
  }
}
