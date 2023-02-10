// ignore_for_file: unrelated_type_equality_checks, deprecated_member_use

import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/user_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/auth_repository.dart';
import 'package:finalproject_edspertapp/ui/helpers/preference_helper.dart';
import 'package:finalproject_edspertapp/ui/helpers/user_email.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/bottom_nav.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);
  static String route = "register_page";

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

enum Gender { lakilaki, perempuan }

class _EditProfilePageState extends State<EditProfilePage> {
  List<String> classSma = ["10", "11", "12"];

  String gender = "Laki-laki";
  String selectedClass = "10";
  // String schoolLevel = "jenjang";
  final emailController = TextEditingController();
  final sekolahNameController = TextEditingController();
  final fullNameController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (genderInput == Gender.lakilaki) {
      gender = "Laki-laki";
    } else {
      gender = "Perempuan";
    }
    setState(() {});
  }

  initDataUser() async {
    emailController.text = UserEmail.getUserEmail()!;
    //fullNameController.text = UserEmail.getUserDisplayName()!;
    final dataUser = await PreferenceHelper().getUserData();
    fullNameController.text = dataUser!.userName!;
    sekolahNameController.text = dataUser.userAsalSekolah!;
    gender = dataUser.userGender!;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffF0F3F5),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: R.colors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Edit Akun",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.only(
        //     bottomLeft: Radius.circular(25.0),
        //     bottomRight: Radius.circular(25.0),
        //   ),
        // ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ButtonLogin(
            radius: 8,
            onTap: () async {
              final json = {
                "email": emailController.text,
                "nama_lengkap": fullNameController.text,
                "nama_sekolah": sekolahNameController.text,
                "kelas": selectedClass,
                "gender": gender,
                "foto": UserEmail.getUserPhotoUrl(),
                // "jenjang": schoolLevel,
              };
              print(json);
              final result = await AuthRepository().postUpdateUser(json);
              if (result.status == Status.success) {
                final registerResult = UserResponse.fromJson(result.data!);
                if (registerResult.status == 1) {
                  await PreferenceHelper().setUserData(registerResult.data!);
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(registerResult.message!),
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Terjadi Error, Silahkan Ulang Kembali"),
                  ),
                );
              }
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.toscaBorderSide,
            child: Text(
              R.strings.perbarui,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: R.colors.whiteTexts,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EditProfileTextField(
                controller: emailController,
                hintText: "Masukan Email Anda",
                title: "Email",
                enabled: false,
              ),
              SizedBox(height: 15),
              EditProfileTextField(
                hintText: "Masukan Nama Lengkap Anda",
                title: "Nama Lengkap",
                controller: fullNameController,
              ),
              SizedBox(height: 15),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 14,
                  color: R.colors.greySubtitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary:
                              gender.toLowerCase() == "Laki-laki".toLowerCase()
                                  ? R.colors.primary
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorderEmail,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.lakilaki);
                        },
                        child: Text(
                          "Laki-Laki",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: gender.toLowerCase() ==
                                    "Laki-laki".toLowerCase()
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: gender == "Perempuan"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorderEmail,
                            ),
                          ),
                        ),
                        onPressed: () {
                          onTapGender(Gender.perempuan);
                        },
                        child: Text(
                          "Perempuan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            color: gender == "Perempuan"
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Text(
                "Kelas",
                style: TextStyle(
                  fontSize: 14,
                  color: R.colors.greySubtitle,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(
                    color: R.colors.greyBorderEmail,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedClass,
                    items: classSma
                        .map(
                          (e) => DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          ),
                        )
                        .toList(),
                    onChanged: (String? value) {
                      selectedClass = value!;
                      setState(() {});
                    },
                  ),
                ),
              ),
              SizedBox(height: 15),
              EditProfileTextField(
                hintText: "Masukan Nama Sekolah Anda",
                title: "Nama Sekolah",
                controller: sekolahNameController,
              ),
              // SizedBox(height: 30),
              //Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditProfileTextField extends StatelessWidget {
  const EditProfileTextField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
    this.enabled = true,
  }) : super(key: key);

  final String title;
  final String hintText;
  final bool enabled;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: R.colors.greySubtitle,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 5),
          TextField(
            enabled: enabled,
            controller: controller,
            decoration: InputDecoration(
              //border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: R.colors.greyHintText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
