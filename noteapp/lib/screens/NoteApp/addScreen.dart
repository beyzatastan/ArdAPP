import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';
import 'package:noteapp/widgets/widgets.dart';

class Addscreen extends StatefulWidget {
  const Addscreen({super.key});

  @override
  State<Addscreen> createState() => _AddscreenState();
}

class _AddscreenState extends State<Addscreen> {
  final TextEditingController titleCont = TextEditingController();
  final TextEditingController descCont = TextEditingController();
  final Timestamp timestamp = Timestamp.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      backgroundColor: HexColor(backgroundColor),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
            child: Column(
              children: [
                textField(titleCont, "Note Title..."),
                const SizedBox(
                  height: 40,
                ),
                textField(descCont, "Note Description..."),
                const SizedBox(
                  height: 60,
                ),
                ElevatedButton(
                    onPressed: () {
                      _addNote();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: HexColor(buttonBackground),
                        foregroundColor: HexColor(buttoncolor),
                        minimumSize: const Size(327, 63),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Text(
                      "Save Note",
                      style: TextStyle(fontFamily: "Inter", fontSize: 20),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addNote() async {
    if (titleCont.text.isNotEmpty && descCont.text.isNotEmpty) {
      try {
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUserId)
            .get();
        String userName = userDoc['name'] ?? 'Unknown';

        await FirebaseFirestore.instance.collection('Notes').doc(currentUserId).collection("Notes").add({
          "userId": currentUserId,
          "userName": userName,
          "noteTitle": titleCont.text,
          "noteDescription": descCont.text,
          "timestamp": timestamp,
        });

        titleCont.clear();
        descCont.clear();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Notesscreen()),
          (Route<dynamic> route) => false,
        );
      } catch (e) {
        print("Error sending message: $e");
      }
    }
  }
}
