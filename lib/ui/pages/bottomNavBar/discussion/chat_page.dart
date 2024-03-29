import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, this.id}) : super(key: key);
  final String? id;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final textController = TextEditingController();
  late CollectionReference chat;
  late QuerySnapshot chatData;
  //List<QueryDocumentSnapshot>? listChat;
  // getDataFromFirebase() async {
  //   chatData = await FirebaseFirestore.instance
  //       .collection("room")
  //       .doc("kimia")
  //       .collection("chat")
  //       .get();
  //   //listChat = chatData.docs;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    //getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    chat = FirebaseFirestore.instance
        .collection("room")
        .doc("kimia")
        .collection("chat");
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diskusi Soal"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: chat.orderBy("time").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.reversed.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final currentChat =
                          snapshot.data!.docs.reversed.toList()[index];
                      final currentDate =
                          (currentChat["time"] as Timestamp?)?.toDate();

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: user.uid == currentChat["uid"]
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentChat["nama"],
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xff5200FF),
                              ),
                            ),
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Container(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                title: const Text("Salin"),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  FlutterClipboard.copy(
                                                          currentChat[
                                                              "content"])
                                                      .then(
                                                    (value) =>
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            "Obrolan telah disalin"),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                              if (user.uid ==
                                                  currentChat["uid"])
                                                ListTile(
                                                  title: const Text("Hapus"),
                                                  onTap: () {
                                                    String id = currentChat.id;
                                                    chat.doc(id).update({
                                                      "is_deleted": true
                                                    }).then(
                                                      (value) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                            content: Text(
                                                                "Obrolan telah dihapus"),
                                                          ),
                                                        );
                                                        Navigator.pop(context);
                                                      },
                                                    );
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                    color: user.uid == currentChat["uid"]
                                        ? Colors.green.withOpacity(0.5)
                                        : const Color(0xffFFDCDC),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: const Radius.circular(10),
                                      bottomRight:
                                          user.uid == currentChat["uid"]
                                              ? const Radius.circular(0)
                                              : const Radius.circular(10),
                                      topRight: const Radius.circular(10),
                                      topLeft: user.uid != currentChat["uid"]
                                          ? const Radius.circular(0)
                                          : const Radius.circular(10),
                                    )),
                                child: baloonChat(currentChat),
                              ),
                            ),
                            Text(
                              currentDate == null
                                  ? ""
                                  : DateFormat("dd-MM-yyy HH:mm")
                                      .format(currentDate),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xff979797),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          SafeArea(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.25),
                  )
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.add,
                      color: Colors.blue,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: TextField(
                                controller: textController,
                                decoration: InputDecoration(
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () async {
                                      final imgResult =
                                          await ImagePicker().pickImage(
                                        source: ImageSource.camera,
                                        maxHeight: 300,
                                        maxWidth: 300,
                                      );
                                      if (imgResult != null) {
                                        File file = File(imgResult.path);
                                        // ignore: unused_local_variable
                                        final name = imgResult.path.split("/");
                                        String room = widget.id ?? "kimia";
                                        String ref =
                                            "chat/$room/${user.uid}/${imgResult.name}";

                                        final imgResUpload =
                                            await FirebaseStorage.instance
                                                .ref()
                                                .child(ref)
                                                .putFile(file);

                                        final url = await imgResUpload.ref
                                            .getDownloadURL();

                                        final chatContent = {
                                          "nama": user.displayName,
                                          "uid": user.uid,
                                          "content": textController.text,
                                          "email": user.email,
                                          "photo": user.photoURL,
                                          "ref": ref,
                                          "type": "file",
                                          "file_url": url,
                                          "time": FieldValue.serverTimestamp(),
                                          "is_deleted": false,
                                        };
                                        chat.add(chatContent).whenComplete(() {
                                          textController.clear();
                                          //getDataFromFirebase();
                                        });
                                      }
                                    },
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  hintText: " Ketik pesan",
                                  hintStyle: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (textController.text.isEmpty) {
                        return;
                      }
                      // ignore: avoid_print
                      print(textController.text);
                      //final user = FirebaseAuth.instance.currentUser!;
                      final chatContent = {
                        "nama": user.displayName,
                        "uid": user.uid,
                        "content": textController.text,
                        "email": user.email,
                        "photo": user.photoURL,
                        "ref": null,
                        "type": "text",
                        "file_url": null,
                        "time": FieldValue.serverTimestamp(),
                        "is_deleted": false,
                      };
                      chat.add(chatContent).whenComplete(() {
                        textController.clear();
                        //getDataFromFirebase();
                      });
                    },
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget baloonChat(QueryDocumentSnapshot currentChat) {
    if (currentChat["is_deleted"] == true) {
      return const Text(
        "Pesan telah dihapus",
        style: TextStyle(
          color: Colors.grey,
          fontStyle: FontStyle.italic,
        ),
      );
    }
    return currentChat["type"] == "file"
        ? Image.network(
            currentChat["file_url"],
            errorBuilder: (context, error, stackTrace) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.warning),
              );
            },
          )
        : Text(
            currentChat["content"],
          );
  }
}
