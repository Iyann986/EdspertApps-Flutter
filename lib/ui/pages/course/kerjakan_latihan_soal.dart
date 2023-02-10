import 'package:finalproject_edspertapp/ui/constants/r.dart';
import 'package:finalproject_edspertapp/ui/data/models/exercise_result.dart';
import 'package:finalproject_edspertapp/ui/data/models/network_response.dart';
import 'package:finalproject_edspertapp/ui/data/models/question_list_response.dart';
import 'package:finalproject_edspertapp/ui/data/repository/Latihan_soal_api.dart';
import 'package:finalproject_edspertapp/ui/helpers/user_email.dart';
import 'package:finalproject_edspertapp/ui/pages/bottomNavBar/discussion/result_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class KerjakanLatihanSoalpage extends StatefulWidget {
  const KerjakanLatihanSoalpage({super.key, required this.id});
  static String route = "paket_soal_page";
  final String id;

  @override
  State<KerjakanLatihanSoalpage> createState() =>
      _KerjakanLatihanSoalpageState();
}

class _KerjakanLatihanSoalpageState extends State<KerjakanLatihanSoalpage>
    with SingleTickerProviderStateMixin {
  QuestionListResponse? questionList;
  getQuestionList() async {
    final result = await LatihanSoalApi().postQuestionList(widget.id);
    if (result.status == Status.success) {
      questionList = QuestionListResponse.fromJson(result.data!);
      _controller =
          TabController(length: questionList!.data!.length, vsync: this);
      _controller!.addListener(
        () {
          setState(() {});
        },
      );
      setState(() {});
    }
  }

  TabController? _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getQuestionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Soal"),
      ),

      /// Button Submit
      bottomNavigationBar: _controller == null
          ? SizedBox(height: 0)
          : Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: R.colors.primary,
                        fixedSize: Size(153, 33),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                    onPressed: () async {
                      if (_controller!.index ==
                          questionList!.data!.length - 1) {
                        final result = await showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) {
                            return ButtomshetConfirmation();
                          },
                        );
                        print(result);
                        if (result == true) {
                          //print("Kirim ke bc");
                          List<String> answer = [];
                          List<String> questionID = [];

                          questionList!.data!.forEach((element) {
                            questionID.add(element.bankQuestionId!);
                            answer.add(element.studentAnswer!);
                          });

                          final payload = {
                            "user_email": UserEmail.getUserEmail(),
                            "exercise_id": widget.id,
                            "bank_question_id": questionID,
                            "student_answer": answer,
                          };
                          print(payload);

                          final result =
                              await LatihanSoalApi().postStudentAnswer(payload);
                          if (result.status == Status.success) {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) {
                                return ResultPage(
                                  exerciseId: widget.id,
                                );
                              },
                            ));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Submit gagal silahkan ulangi"),
                              ),
                            );
                          }
                        }
                      } else {
                        _controller!.animateTo(_controller!.index + 1);
                      }
                    },
                    child: Text(
                      _controller?.index == questionList!.data!.length - 1
                          ? "Kumpulin"
                          : "Selanjutnya",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  )
                ],
              ),
            ),
      body: questionList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                /// Tabbar nomor soal
                Container(
                  child: TabBar(
                    controller: _controller,
                    tabs: List.generate(
                      questionList!.data!.length,
                      (index) => Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

                /// TabbarView soal dan pilihan jawaban
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: TabBarView(
                        controller: _controller,
                        children: List.generate(
                          questionList!.data!.length,
                          (index) => SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Soal no ${index + 1}",
                                  style: TextStyle(
                                    color: R.colors.greySubtitle,
                                    fontSize: 12,
                                  ),
                                ),
                                if (questionList!.data![index].questionTitle !=
                                    null)
                                  Html(
                                    data: questionList!
                                        .data![index].questionTitle!,
                                    style: {
                                      "body": Style(
                                        padding: EdgeInsets.zero,
                                      ),
                                      "p": Style(
                                        fontSize: FontSize(14),
                                      )
                                    },
                                  ),
                                if (questionList!
                                        .data![index].questionTitleImg !=
                                    null)
                                  Image.network(questionList!
                                      .data![index].questionTitleImg!),
                                _buildOptions(
                                  "A",
                                  questionList!.data![index].optionA,
                                  questionList!.data![index].optionAImg,
                                  index,
                                ),
                                _buildOptions(
                                  "B",
                                  questionList!.data![index].optionB,
                                  questionList!.data![index].optionBImg,
                                  index,
                                ),
                                _buildOptions(
                                  "C",
                                  questionList!.data![index].optionC,
                                  questionList!.data![index].optionCImg,
                                  index,
                                ),
                                _buildOptions(
                                  "D",
                                  questionList!.data![index].optionD,
                                  questionList!.data![index].optionDImg,
                                  index,
                                ),
                                _buildOptions(
                                  "E",
                                  questionList!.data![index].optionE,
                                  questionList!.data![index].optionEImg,
                                  index,
                                ),
                              ],
                            ),
                          ),
                        ).toList()),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildOptions(
      String option, String? answer, String? answerImg, int index) {
    final answerCheck = questionList!.data![index].studentAnswer == option;
    return GestureDetector(
      onTap: () {
        questionList!.data![index].studentAnswer = option;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        margin: EdgeInsets.symmetric(vertical: 2),
        decoration: BoxDecoration(
          color: answerCheck ? Colors.blue.withOpacity(0.4) : Colors.white,
          border: Border.all(
            width: 1,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Text(
              option + ".",
              style: TextStyle(
                color: answerCheck ? Colors.white : Colors.black,
              ),
            ),
            if (answer != null)
              Expanded(
                  child: Html(
                data: answer,
                style: {
                  "p": Style(
                    color: answerCheck ? Colors.white : Colors.black,
                  )
                },
              )),
            if (answerImg != null) Expanded(child: Image.network(answerImg)),
          ],
        ),
      ),
    );
  }
}

class ButtomshetConfirmation extends StatefulWidget {
  const ButtomshetConfirmation({
    super.key,
  });

  @override
  State<ButtomshetConfirmation> createState() => _ButtomshetConfirmationState();
}

class _ButtomshetConfirmationState extends State<ButtomshetConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 100,
              height: 5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: R.colors.greySubtitle,
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Image.asset(R.assets.imgSucces),
            SizedBox(
              height: 15,
            ),
            Text("Kumpulkan latihan soal sekarang?"),
            Text("Boleh langsung kumpulin dong"),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text("Nanti Dulu"),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text("Ya"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
