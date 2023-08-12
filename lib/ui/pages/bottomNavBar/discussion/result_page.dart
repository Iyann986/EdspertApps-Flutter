import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/exercise_result.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/Latihan_soal_api.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.exerciseId});
  final String exerciseId;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  ExerciseResultResponse? resultResponse;
  getResult() async {
    final result = await LatihanSoalApi().getResult(widget.exerciseId);
    if (result.status == Status.success) {
      resultResponse = ExerciseResultResponse.fromJson(result.data!);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getResult();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: R.colors.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: resultResponse == null
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "Tutup",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      "Selamat",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Kamu telah menyelesaikan Kuiz ini",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Image.asset(
                      R.assets.imgResult,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Nilai kamu : ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      resultResponse!.data!.result!.jumlahScore!,
                      style: const TextStyle(
                        fontSize: 90,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
