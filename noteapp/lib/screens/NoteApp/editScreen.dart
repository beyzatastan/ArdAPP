import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:noteapp/extensions/colors.dart';
import 'package:noteapp/screens/NoteApp/notesScreen.dart';

class Editscreen extends StatefulWidget {
  const Editscreen({super.key, required this.notetitle, required this.notedesc,required this.noteId});
  final String notetitle;
  final String notedesc;
  final String noteId;

  @override
  State<Editscreen> createState() => _EditscreenState();
}

class _EditscreenState extends State<Editscreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.notetitle);
    _descController = TextEditingController(text: widget.notedesc);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor(backgroundColor),
      appBar: AppBar(
        backgroundColor: HexColor(backgroundColor),
        leading: IconButton(onPressed: (){
         //yığını da temizleyip gönderiyorum
          Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Notesscreen()),
           (Route<dynamic> route) => false,
             );
        }, icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 40),
            child: Column(
              children: [
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8), 
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor(buttonBackground),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(noteColor)),
                      ),
                    ),
                    style: const TextStyle(
                      fontFamily: "Inter",
                      fontSize: 22,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8), // Adjust width as needed
                  child: TextField(
                    controller: _descController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: HexColor(buttonBackground),
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: HexColor(noteColor)),
                      ),
                    ),
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      color: HexColor(noteColor),
                    ),
                  ),
                ),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                          onPressed: () {
                          updateNotes(widget.noteId);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: HexColor(buttonBackground),
                              foregroundColor: HexColor(buttoncolor),
                              minimumSize: const Size(327, 63),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5))),
                          child: const Text(
                            "Update Note",
                            style: TextStyle(fontFamily: "Inter", fontSize: 20),
                          )
                          ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
 
  Future<void> updateNotes(String noteId) async{
    try{
      if(_titleController.text.isNotEmpty && _descController.text.isNotEmpty){
      await FirebaseFirestore.instance.collection("Notes").doc(FirebaseAuth.instance.currentUser!.uid).collection("Notes").doc(widget.noteId).update({
        "noteTitle":_titleController.text,
        "noteDescription": _descController.text
      });
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Notesscreen()),
          (Route<dynamic> route) => false,
        );
      } 
      }catch (e) {
        print("Error updating note: $e");
      }
    }

    }

