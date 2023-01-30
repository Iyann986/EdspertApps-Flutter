import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/pages/auth/login_page/login_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/bottom_nav.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  static String route = "register_page";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

enum Gender { lakilaki, perempuan }

class _RegisterPageState extends State<RegisterPage> {
  String gender = "Laki-laki";
  List<String> classSma = ["10", "11", "12"];
  String selectedClass = "10";

  final emaiController = TextEditingController();

  onTapGender(Gender genderInput) {
    if (gender == Gender.lakilaki) {
      gender = "Laki-laki";
    } else {
      gender = "Perempuan";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Yuk isi data diri",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: ButtonLogin(
            onTap: () {
              print(emaiController.text);
              Navigator.of(context).pushNamedAndRemoveUntil(
                  BottomNavBar.route, (context) => false);
            },
            backgroundColor: R.colors.primary,
            borderColor: R.colors.toscaBorderSide,
            child: Text(
              R.strings.daftar,
              style: TextStyle(
                fontSize: 17,
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
              RegisterTextField(
                controller: emaiController,
                hintText: "Masukan Email Anda",
                title: "Email",
              ),
              SizedBox(height: 20),
              RegisterTextField(
                hintText: "Masukan Nama Lengkap Anda",
                title: "Nama Lengkap",
              ),
              SizedBox(height: 20),
              Text(
                "Jenis Kelamin",
                style: TextStyle(
                  fontSize: 16,
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
                          primary: gender == "Laki-laki"
                              ? R.colors.primary
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorderEmail,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
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
                            color: gender == "Laki-laki"
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
                            side: BorderSide(
                              width: 1,
                              color: R.colors.greyBorderEmail,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
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
              SizedBox(height: 20),
              Text(
                "Kelas",
                style: TextStyle(
                  fontSize: 16,
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
              SizedBox(height: 20),
              RegisterTextField(
                hintText: "Masukan Nama Sekolah Anda",
                title: "Nama Sekolah",
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

class RegisterTextField extends StatelessWidget {
  const RegisterTextField({
    Key? key,
    required this.title,
    required this.hintText,
    this.controller,
  }) : super(key: key);

  final String title;
  final String hintText;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 5),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(
              color: R.colors.greyBorderEmail,
            ),
          ),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hintText,
              hintStyle: TextStyle(
                color: R.colors.greyHintText,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
