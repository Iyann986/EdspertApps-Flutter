import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/banner_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/course_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/user_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/Latihan_soal_api.dart';
import 'package:finalproject_edspertapp/ui/helpers/preference_helper.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/home_mapel_widget.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/list_paket_soal_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CourseResponse? courseResponse;
  getCourse() async {
    final courseResult = await LatihanSoalApi().getCourse();
    if (courseResult.status == Status.success) {
      courseResponse = CourseResponse.fromJson(courseResult.data!);
      setState(() {});
    }
  }

  BannerResponse? bannerResponse;
  getBanner() async {
    final banner = await LatihanSoalApi().getBanner();
    if (banner.status == Status.success) {
      bannerResponse = BannerResponse.fromJson(banner.data!);
      setState(() {});
    }
  }

  setupFcm() async {
    // Get any messages which caused the application to open from
    // a terminated state.
    final tokenFcm = await FirebaseMessaging.instance.getToken();
    print("tokenfcm: $tokenFcm");
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    // if (initialMessage != null) {
    //   _handleMessage(initialMessage);
    // }

    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((event) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }

  UserData? dataUser;
  Future getUserData() async {
    dataUser = await PreferenceHelper().getUserData();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCourse();
    getBanner();
    setupFcm();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.whiteTexts,
      body: SafeArea(
        child: ListView(
          children: [
            _buildUserHomeProfile(),
            _buildTopBannerHome(context),
            _buildHomeListMapel(courseResponse),
            Container(
              // margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Terbaru",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 11,
                  ),
                  bannerResponse == null
                      ? Container(
                          height: 70,
                          width: double.infinity,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : Container(
                          height: 150,
                          child: ListView.builder(
                            itemCount: bannerResponse!.data!.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final currentBanner =
                                  bannerResponse!.data![index];
                              return Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child:
                                      Image.network(currentBanner.eventImage!),
                                ),
                              );
                            },
                          ),
                        ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHomeListMapel(CourseResponse? list) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 21),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Pilih Pelajaran",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return HomeMapelWidget(mapel: courseResponse!);
                    },
                  ));
                },
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: R.colors.primary,
                  ),
                ),
              ),
            ],
          ),
          list == null
              ? Container(
                  height: 70,
                  width: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: list.data!.length > 3 ? 3 : list.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    final currentMapel = list.data![index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ListPaketSoalPage(id: currentMapel.courseId!),
                          ),
                        );
                      },
                      child: MapelWidget(
                        title: currentMapel.courseName!,
                        totalPaket: currentMapel.jumlahMateri!,
                        totalDone: currentMapel.jumlahDone!,
                      ),
                    );
                  },
                )
        ],
      ),
    );
  }

  Container _buildTopBannerHome(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      decoration: BoxDecoration(
        color: R.colors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      height: 147,
      width: double.infinity,
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15,
              ),
              child: Text(
                "Mau kerjain latihan soal apa hari ini?",
                style: GoogleFonts.poppins().copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Image.asset(
              R.assets.imgHome,
              width: MediaQuery.of(context).size.width * 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Padding _buildUserHomeProfile() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 15,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hi, " + (dataUser?.userName ?? "Nama User"),
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  "Selamat Datang",
                  style: GoogleFonts.poppins().copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Image.asset(
            R.assets.icAvatar,
            width: 35,
            height: 35,
          ),
        ],
      ),
    );
  }
}

class MapelWidget extends StatelessWidget {
  const MapelWidget({
    super.key,
    required this.title,
    required this.totalDone,
    required this.totalPaket,
  });

  final String title;
  final int? totalDone;
  final int? totalPaket;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(bottom: 11),
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 21),
      child: Row(
        children: [
          Container(
            height: 53,
            width: 53,
            padding: EdgeInsets.all(13),
            decoration: BoxDecoration(
              color: R.colors.whiteTexts,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(R.assets.icMtk),
          ),
          SizedBox(
            width: 9,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  "$totalDone/$totalPaket Paket latihan soal",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: R.colors.greyText,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: R.colors.whiteTexts,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: totalDone!,
                          child: Container(
                            height: 5,
                            //width: MediaQuery.of(context).size.width * 0.4,
                            decoration: BoxDecoration(
                              color: R.colors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: totalPaket! - totalDone!,
                          child: Container(
                              // height: 5,
                              // width: MediaQuery.of(context).size.width * 0.4,
                              // decoration: BoxDecoration(
                              //   color: R.colors.primary,
                              //   borderRadius: BorderRadius.circular(10),
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
