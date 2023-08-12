import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/exercise_list_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/Latihan_soal_api.dart';
import 'package:finalproject_edspertapp/ui/pages/course/kerjakan_latihan_soal.dart';
import 'package:flutter/material.dart';

class ListPaketSoalPage extends StatefulWidget {
  const ListPaketSoalPage({super.key, required this.id});
  static String route = "paket_soal_page";
  final String id;

  @override
  State<ListPaketSoalPage> createState() => _ListPaketSoalPageState();
}

class _ListPaketSoalPageState extends State<ListPaketSoalPage> {
  ExerciseListResponse? exerciseListResponse;
  getExerciseListRespone() async {
    final courseResult = await LatihanSoalApi().getExerciseList(widget.id);
    if (courseResult.status == Status.success) {
      exerciseListResponse = ExerciseListResponse.fromJson(courseResult.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getExerciseListRespone();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.whiteTexts,
      appBar: AppBar(
        title: const Text("Paket Soal"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Paket Soal",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Expanded(
              child: exerciseListResponse == null
                  ? const Center(child: CircularProgressIndicator())
                  :
                  // : SingleChildScrollView(
                  //     child: Wrap(
                  //         children: List.generate(
                  //             exerciseListResponse!.data!.length, (index) {
                  //       final currentPaketSoal =
                  //           exerciseListResponse!.data![index];
                  //       return Container(
                  //           padding: EdgeInsets.all(3),
                  //           width: MediaQuery.of(context).size.width * 0.4,
                  //           child: PaketSoalWidget(data: currentPaketSoal));
                  //     }).toList()),
                  //   ),

                  GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 4, // bisa pake 3/2
                      children: List.generate(
                          exerciseListResponse!.data!.length, (index) {
                        final currentPaketSoal =
                            exerciseListResponse!.data![index];
                        return PaketSoalWidget(data: currentPaketSoal);
                      }).toList()
                      // [
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      //   PaketSoalWidget(),
                      // ],
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

class PaketSoalWidget extends StatelessWidget {
  const PaketSoalWidget({
    super.key,
    required this.data,
  });

  final ExerciseListData data;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => KerjakanLatihanSoalpage(id: data.exerciseId!),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(13.0),
        // margin: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withOpacity(0.2),
              ),
              child: Image.asset(
                R.assets.icNote,
                width: 14,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              data.exerciseTitle!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            Text(
              "${data.jumlahDone}/${data.jumlahSoal} Soal",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
                color: R.colors.greySubtitle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
