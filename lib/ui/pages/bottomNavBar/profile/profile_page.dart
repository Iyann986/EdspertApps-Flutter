import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/user_response.dart';
import 'package:finalproject_edspertapp/ui/helpers/preference_helper.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/profile/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? user;
  getUserData() async {
    final data = await PreferenceHelper().getUserData();
    user = data;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Akun Saya",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return EditProfilePage();
                    },
                  ),
                );
                if (result == true) {
                  getUserData();
                }
              },
              child: Text(
                "Edit",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              )),
        ],
      ),
      body: user == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.only(
                    top: 28,
                    bottom: 60,
                    right: 15,
                    left: 15,
                  ),
                  decoration: BoxDecoration(
                    color: R.colors.primary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(9),
                      bottomRight: Radius.circular(9),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user!.userName!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              user!.userAsalSekolah!,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        R.assets.icAvatar,
                        width: 50,
                        height: 50,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 7,
                        color: Colors.black.withOpacity(0.25),
                      )
                    ],
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 13, vertical: 18),
                  margin: EdgeInsets.symmetric(horizontal: 13, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Identitas Diri",
                        //style: ,
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Nama Lengkap",
                        style: TextStyle(
                          color: R.colors.greySubtitle,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user!.userName!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Email",
                        style: TextStyle(
                          color: R.colors.greySubtitle,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user!.userEmail!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Jenis Kelamin",
                        style: TextStyle(
                          color: R.colors.greySubtitle,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user!.userGender!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Kelas",
                        style: TextStyle(
                          color: R.colors.greySubtitle,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user!.kelas!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Sekolah",
                        style: TextStyle(
                          color: R.colors.greySubtitle,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        user!.userAsalSekolah!,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await GoogleSignIn().signOut();
                    await FirebaseAuth.instance.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginPage.route, (route) => false);
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 13),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 7,
                          color: Colors.black.withOpacity(0.25),
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          R.assets.icLogout,
                          width: 20,
                          height: 20,
                        ),
                        SizedBox(width: 7),
                        Text(
                          "Keluar",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
