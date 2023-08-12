import 'package:finalproject_edspertapp/ui/data/models/course_response.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/home_page.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/home/list_paket_soal_page.dart';
import 'package:flutter/material.dart';

class HomeMapelWidget extends StatelessWidget {
  const HomeMapelWidget({super.key, required this.mapel});
  static String route = "mapel_page";

  final CourseResponse mapel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Pelajaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 22),
        child: ListView.builder(
          itemCount: mapel.data!.length,
          itemBuilder: (context, index) {
            final currentMapel = mapel.data![index];
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
        ),
      ),
    );
  }
}
