import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/home_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/list_paket_soal_page.dart';
import 'package:flutter/material.dart';

class HomeMapelWidget extends StatelessWidget {
  const HomeMapelWidget({super.key});
  static String route = "mapel_page";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pilih Pelajaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        child: ListView.builder(
          itemCount: 6,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ListPaketSoalPage.route);
              },
              child: MapelWidget(),
            );
          },
        ),
      ),
    );
  }
}
